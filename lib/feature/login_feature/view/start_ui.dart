// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wheatmap/feature/login_feature/controller/login_logic.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 6),
      () async {
        final sp = context.read<SignInProvider>();
        if (await sp.checkSignInUser() == true) {
          context.go('/home');
        } else {
          context.go('/splash');
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.string(
              width: 150,
              height: 150,
              '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 64 64"><path fill="#75a843" d="M10.7 27.5c-.6 3-.9 6.1-.8 9.1c.1 3 .7 6 1.6 8.8c1 2.8 2.3 5.5 4 8.1c.8 1.3 1.7 2.5 2.7 3.7c1 1.2 2 2.3 3.1 3.4c-1.3-.8-2.5-1.8-3.6-2.9c-1.1-1.1-2.2-2.3-3.1-3.5c-1.9-2.5-3.4-5.3-4.4-8.3c-1-3-1.5-6.2-1.4-9.3c.1-3.2.7-6.3 1.9-9.1m40.6.5c-3.2 1.8-6.3 3.8-9.2 6c-2.9 2.2-5.6 4.7-8 7.4c-2.4 2.7-4.6 5.6-6.4 8.7c-.9 1.6-1.8 3.2-2.5 4.8c-.8 1.7-1.4 3.4-2 5.1c.2-1.8.7-3.6 1.3-5.4c.6-1.8 1.3-3.5 2.2-5.1c1.7-3.3 3.9-6.4 6.4-9.2c2.5-2.8 5.3-5.2 8.4-7.3c3.1-2 6.4-3.8 9.8-5"/><g fill="#f4bc58"><path d="M28.5 14.7c-1.5 1.8-4.1 1.2-4.1 1.2s-1-2.5.4-4.3c1.5-1.8 5-2.3 5-2.3s.1 3.7-1.3 5.4m-5.3.4c.4 1.8-1.2 3.2-1.2 3.2s-2.1-.6-2.6-2.4c-.4-1.8 1-4.4 1-4.4s2.3 1.8 2.8 3.6"/><path d="M26 20.1c-1.8.4-3.2-1.2-3.2-1.2s.6-2.1 2.4-2.6s4.4 1 4.4 1s-1.8 2.3-3.6 2.8m-5.8-.5c.6 1.7-.8 3.4-.8 3.4s-2.2-.3-2.8-2c-.6-1.7.4-4.5.4-4.5s2.6 1.4 3.2 3.1m3.4 4.6c-1.7.6-3.4-.8-3.4-.8s.3-2.2 2-2.8c1.7-.6 4.5.4 4.5.4s-1.4 2.6-3.1 3.2m-5.4.2c.9 1.7-.5 3.6-.5 3.6s-2.3-.1-3.2-1.8c-.9-1.7 0-4.7 0-4.7s2.9 1.1 3.7 2.9m4 4.4c-1.7.9-3.6-.5-3.6-.5s.1-2.3 1.8-3.2c1.7-.9 4.7 0 4.7 0s-1.1 2.8-2.9 3.7M16.4 30c1.2 1.7.1 4 .1 4s-2.5.4-3.7-1.4c-1.2-1.7-.9-5.1-.9-5.1s3.3.8 4.5 2.5m5.2 4.1c-1.7 1.2-4 .1-4 .1s-.4-2.5 1.4-3.7s5.1-.9 5.1-.9s-.8 3.2-2.5 4.5m-6.3 2.6c1.5 1.6.6 4.2.6 4.2s-2.6.7-4.1-.9s-1.6-5.2-1.6-5.2s3.6.2 5.1 1.9m5.9 3.5c-1.6 1.5-4.2.6-4.2.6s-.7-2.6.9-4.1s5.2-1.6 5.2-1.6s-.2 3.6-1.9 5.1"/><path d="M24.5 15.8c-2.5 3.1-4.3 6.7-5.4 10.4c-.5 1.9-1 3.8-1.3 5.7c-.3 1.9-.5 3.9-.6 5.9c-.1 2-.1 3.9-.1 5.9c0 2 .2 3.9.3 5.9c.2 2 .4 3.9.7 5.9c.3 2 .6 3.9 1 5.9c-.6-1.9-1.1-3.8-1.5-5.8c-.4-1.9-.8-3.9-1-5.9c-.3-2-.4-4-.5-6c-.1-2-.1-4 0-6s.3-4 .7-6c.4-2 .8-3.9 1.5-5.8c.6-1.9 1.5-3.7 2.5-5.5c1-1.6 2.2-3.2 3.7-4.6"/></g><g fill="#fc6"><path d="M51.7 8.7c-2.4 1.7-5.6.1-5.6.1s-.4-3.5 2-5.2c2.4-1.7 7.1-1.2 7.1-1.2S54.1 7 51.7 8.7M45 7.4c-.1 2.4-2.7 3.6-2.7 3.6s-2.5-1.4-2.4-3.8C40 4.8 42.6 2 42.6 2s2.5 3 2.4 5.4"/><path d="M46.8 14.5c-2.4-.1-3.6-2.7-3.6-2.7s1.4-2.5 3.8-2.4c2.4.1 5.2 2.7 5.2 2.7s-3 2.5-5.4 2.4M39.7 12c.2 2.4-2.2 3.9-2.2 3.9s-2.6-1.1-2.9-3.5c-.2-2.4 2-5.5 2-5.5s2.9 2.7 3.1 5.1m2.7 6.9c-2.4.2-3.9-2.2-3.9-2.2s1.1-2.6 3.5-2.9c2.4-.2 5.5 2 5.5 2s-2.7 2.9-5.1 3.1m-6.8-1.6c.5 2.5-1.9 4.3-1.9 4.3s-2.9-.9-3.3-3.3c-.5-2.5 1.5-5.9 1.5-5.9s3.2 2.4 3.7 4.9m3.5 6.9c-2.5.5-4.3-1.9-4.3-1.9s.9-2.9 3.3-3.3c2.5-.5 5.9 1.5 5.9 1.5s-2.4 3.2-4.9 3.7m-7.7-.4c1 2.6-1.2 5-1.2 5s-3.2-.4-4.2-3s.6-6.7.6-6.7s3.9 2.1 4.8 4.7m5.1 6.8c-2.6 1-5-1.2-5-1.2s.4-3.2 3-4.2s6.7.6 6.7.6s-2.1 3.8-4.7 4.8m-8.7 1.1c1.4 2.6-.6 5.4-.6 5.4s-3.5 0-4.8-2.6s-.2-7.1-.2-7.1s4.2 1.7 5.6 4.3m6.2 6.5c-2.6 1.4-5.4-.6-5.4-.6s0-3.5 2.6-4.8c2.6-1.4 7.1-.2 7.1-.2s-1.7 4.2-4.3 5.6"/><path d="M46.4 8.8c-4.2 3-7.6 6.9-10.3 11.2c-1.3 2.2-2.5 4.4-3.5 6.8c-1 2.3-1.9 4.7-2.7 7.1c-.8 2.4-1.5 4.9-2.1 7.4c-.6 2.5-1.1 5-1.6 7.5c-.4 2.5-.8 5.1-1.2 7.6c-.3 2.5-.6 5.1-.8 7.7c-.1-2.6-.1-5.2.1-7.7c.2-2.6.4-5.2.7-7.7c.3-2.6.8-5.1 1.4-7.6c.6-2.5 1.2-5 2-7.5s1.8-4.9 2.9-7.3c1.1-2.4 2.4-4.6 3.8-6.8c1.5-2.2 3.1-4.2 5-6c1.9-1.9 4-3.5 6.3-4.7"/></g><path fill="#83bf4f" d="M39.4 39.5c-2.5.5-4.9 1.2-7.1 2.2c-2.2 1-4.2 2.4-6 4.1c-1.7 1.7-3.1 3.7-4.3 5.9c-.6 1.1-1.1 2.2-1.5 3.4c-.4 1.2-.8 2.4-1.1 3.6c0-1.3.1-2.5.4-3.8c.3-1.2.6-2.5 1.1-3.7c1-2.4 2.4-4.6 4.3-6.4c1.9-1.8 4.1-3.2 6.6-4.1c2.5-.9 5.1-1.3 7.6-1.2"/></svg>',
            ),
          ),
        ),
      ),
    );
  }
}
