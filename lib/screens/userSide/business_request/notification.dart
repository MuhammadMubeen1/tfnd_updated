import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        await saveUserData(user.uid, _usernameController.text);
        await subscribeToNotificationTopic(user.uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      }
    } catch (e) {
      print('Error logging in: $e');
      // Handle login error
      // You may want to display an error message to the user
    }
  }

  Future<void> saveUserData(String uid, String username) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
    });
  }

  Future<void> subscribeToNotificationTopic(String uid) async {
    await FirebaseMessaging.instance.subscribeToTopic(uid);
  }

  @override
  Widget build(BuildContext context) {
    configureFCM(context); // Add this line to set up FCM listeners

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.displayName}!'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

void configureFCM(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received notification: ${message.notification?.body}");
    _showNotification(
        message.notification?.title, message.notification?.body, context);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(
        "Notification opened when app is in the foreground: ${message.notification?.body}");
    _handleNotificationTap(message.data, context);
  });
}

void _showNotification(String? title, String? body, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title ?? ''),
      content: Text(body ?? ''),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

void _handleNotificationTap(Map<String, dynamic> data, BuildContext context) {
  // Handle notification tap, e.g., navigate to a specific screen
  // You can extract additional data from the notification payload (data)
}
