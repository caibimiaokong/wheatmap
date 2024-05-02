import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheatmap/bloc_observe.dart';
import 'package:wheatmap/config/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:wheatmap/feature/login_feature/controller/login_logic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  Bloc.observer = AppBlocObserve();
  await Supabase.initialize(
    url: 'https://toayvqrlxcejyjnmqwhu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRvYXl2cXJseGNlanlqbm1xd2h1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQwMDU4NTUsImV4cCI6MjAwOTU4MTg1NX0.Ns8CPoTsCwRXAOf30BHgd_FxEc_r6CmQmnT32leDVFk',
  );
  runApp(ChangeNotifierProvider(
      create: (context) => SignInProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
