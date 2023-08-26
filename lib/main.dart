import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//  https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa3M5Z0o1bkY1WGc1Y3U2YXhEd2lRc0I4Q1A2QXxBQ3Jtc0tsc21wYk95UXJvQ1RLRDhxWWQ4S2ZiS2VUUGV4X0V4TU53ZE1mYWRLMUZTMmZsbXhvb2NHeVd4M3RUa1ppWFgzRVJBQU1iRlh6amFYYVdWbHlOblptdVVMaXBsMlpOd0E0dGhFMFJtVzZaWGZJN2xLaw&q=https%3A%2F%2Fgithub.com%2Fvijayinyoutube%2Fprint_flutterapp&v=7Aqg1fzfxi0
//  https://github.com/vijayinyoutube/print_flutterapp/tree/master/lib/Presentation/Screens

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
      title: 'Coffeina',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
