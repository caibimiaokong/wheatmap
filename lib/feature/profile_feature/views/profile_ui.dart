import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheatmap/feature/login_feature/controller/login_logic.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI>
    with AutomaticKeepAliveClientMixin {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String image = '';
  String provider = '';

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name')!;
    email = prefs.getString('email')!;
    phone = prefs.getString('phone')!;
    address = prefs.getString('address')!;
    image = prefs.getString('image')!;
    provider = prefs.getString('provider')!;
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  color: Colors.blueAccent.withOpacity(0.1),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        'lib/asset/photo/polar_bear_transformed.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Caveat',
                    color: Colors.black),
              ),
              Text(
                email,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Caveat',
                    color: Colors.black),
              ),
              const SizedBox(
                height: 50,
              ),
              const Divider(),
              const ProfileMenuWidget(
                icon: Icons.settings,
                title: 'Settings',
              ),
              ProfileMenuWidget(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  final sp = context.read<SignInProvider>();
                                  sp.userSignOut();
                                  context.go('/splash');
                                },
                                child: const Text('Logout'))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileMenuWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? isLastShow;
  final Function()? onTap;

  const ProfileMenuWidget(
      {super.key,
      required this.icon,
      required this.title,
      this.isLastShow = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blueAccent.withOpacity(0.1)),
          child: Icon(icon)),
      title: Text(title),
      trailing: isLastShow!
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.1)),
              child: const Icon(Icons.arrow_forward_ios),
            )
          : null,
    );
  }
}
