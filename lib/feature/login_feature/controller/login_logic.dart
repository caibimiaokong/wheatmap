import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class SignInProvider extends ChangeNotifier {
  // instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final twitterLogin = TwitterLogin(
      apiKey: dotenv.env['twitterApiKey']!,
      apiSecretKey: dotenv.env['twitterApiKeySecrety']!,
      redirectURI: "socialauth://");

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  //hasError, errorCode, provider,uid, email, name, imageUrl
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  //check user wether sign in or not
  SignInProvider() {
    checkSignInUser();
  }

  //get user sign in data from shared preferences
  Future<bool> checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    debugPrint("SIGN IN STATUS: $_isSignedIn");
    notifyListeners();
    return _isSignedIn;
  }

  //set user sign in data to shared preferences
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await getUserDataFromFirestore(value.user!.uid);
        await setSignIn();
        await saveDataToFirestore();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _hasError = true;
        _errorCode = "No user found for that email.";
        notifyListeners();
      } else if (e.code == 'wrong-password') {
        _hasError = true;
        _errorCode = "Wrong password provided for that user.";
        notifyListeners();
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        _name = name;
        _email = email;
        _uid = value.user!.uid;
        _imageUrl =
            "https://winaero.com/blog/wp-content/uploads/2017/12/User-icon-256-blue.png";
        _provider = "EMAIL";
        notifyListeners();
        await saveDataToFirestore();
        await setSignIn();
        await saveDataToSharedPreferences();
      });
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  // sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // sign in with twitter
  Future signInWithTwitter() async {
    final authResult = await twitterLogin.loginV2();
    if (authResult.status == TwitterLoginStatus.loggedIn) {
      try {
        final credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!);
        await firebaseAuth.signInWithCredential(credential);

        final userDetails = authResult.user;
        // save all the data
        _name = userDetails!.name;
        _email = firebaseAuth.currentUser!.email;
        _imageUrl = userDetails.thumbnailImage;
        _uid = userDetails.id.toString();
        _provider = "TWITTER";
        _hasError = false;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // sign in with phone
  Future<void> signInWithPhone(
      BuildContext context, String mobile, String name, String email) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
        phoneNumberUser(firebaseAuth.currentUser!, email, name);
        await setSignIn();
        await saveDataToFirestore();
        await saveDataToSharedPreferences();
        // ignore: use_build_context_synchronously
        context.go('/home');
      },
      verificationFailed: (FirebaseAuthException e) {
        _hasError = true;
        _errorCode = e.message;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(children: [
                  Lottie.asset('lib/asset/photo/message.json',
                      width: 200, height: 200),
                  Pinput(
                    length: 6,
                    onCompleted: (String pin) async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: pin);
                        await firebaseAuth
                            .signInWithCredential(credential)
                            .then((value) async {
                          phoneNumberUser(
                              firebaseAuth.currentUser!, email, name);
                          await setSignIn();
                          await saveDataToFirestore();
                          await saveDataToSharedPreferences();
                          // ignore: use_build_context_synchronously
                          context.go('/home');
                        });
                      } catch (e) {
                        _hasError = true;
                        _errorCode = e.toString();
                        notifyListeners();
                      }
                    },
                  )
                ]),
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // get user data from firestore
  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
            });
  }

  //save user data to firestore
  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
    });
    notifyListeners();
  }

  // save user data to shared preferences
  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    notifyListeners();
  }

  // get user data from shared preferences
  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    notifyListeners();
  }

  // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      debugPrint("EXISTING USER");
      return true;
    } else {
      debugPrint("NEW USER");
      return false;
    }
  }

  // signout
  Future userSignOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();

    _isSignedIn = false;
    notifyListeners();
    // clear all storage information
    clearStoredData();
  }

  // clear all local stored data
  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  // set user data from phone number
  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageUrl =
        "https://winaero.com/blog/wp-content/uploads/2017/12/User-icon-256-blue.png";
    _uid = user.phoneNumber;
    _provider = "PHONE";
    notifyListeners();
  }
}
