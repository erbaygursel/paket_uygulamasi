import 'package:bootcamp_app/pages/open_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/database.dart';

void main() async {
  // Firebase auth initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OUA Bootcamp Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: FirebaseAuth.instance.currentUser != null ? const HomePage() : const OpenPage(), // Eğer kullanıcı login ise anasayfaya değilse login sayfasına yönlendiriyor.
    );
  }
}
