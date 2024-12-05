import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walletar/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('WalletAR')),
        body: Center(child: Text('Firebase Configurado Correctamente')),
      ),
    );
  }
}
