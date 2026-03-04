import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forum/screens/home_screen.dart';
import 'package:forum/screens/login.dart';
import 'package:forum/screens/register.dart';
Future<void> main() async {
await dotenv.load(fileName: "assets/.env.local");
runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
      '/': (context) => const HomeScreen(),
      '/register':(context) => const Register(),
      '/login': (context) => const Login(),
      },
    );
  }
}



