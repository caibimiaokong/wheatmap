//flutter library
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//pubdev library
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

//local library

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  ScreenSplashState createState() => ScreenSplashState();
}

class ScreenSplashState extends State<SplashScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildLottie(String assetName, [double width = 350]) {
    return Lottie.asset('lib/asset/photo/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, fontFamily: 'Playfair');

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, fontFamily: 'Platypi'),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 15000,
      infiniteAutoScroll: true,
      globalFooter: const SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Powered by Google&Supabase",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "created by @caibimiaokong",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          )),
      pages: [
        PageViewModel(
          title: "RS & GIS ",
          body: "using RS & GIS tech monitoring wheat Maturity status",
          image: _buildLottie('chipfarm.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Wheat Map",
          body: "using mobile app help farmer Managing agriculture",
          image: _buildLottie('farmer.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Climate Change",
          body: "helping farmer copying with climate change",
          image: _buildLottie('climateChange.json'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        debugPrint("go to login home page");
        context.go('/login');
      },
      onSkip: () async {
        await introKey.currentState?.skipToEnd();
      }, // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: Colors.orangeAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
