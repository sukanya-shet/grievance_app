import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grievance_app/providers/user_provider.dart';
import 'package:grievance_app/screens/home/home.dart';
import 'package:grievance_app/screens/authenticate/login_screen.dart';
import 'package:grievance_app/screens/wrapper.dart';
import 'package:grievance_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (Wrapper());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error occured"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return LoginScreen();
            }),
      ),
    );
  }
}
