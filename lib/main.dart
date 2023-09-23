import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_app/router/go_router.dart';
import 'business/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sandbox App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routerConfig: router,
    );
  }
}
