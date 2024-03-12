import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tfnd_app/adminSide/businessRequests.dart';
import 'package:tfnd_app/adminSide/buttom_navigation.dart';
import 'package:tfnd_app/firebase_options.dart';
import 'package:tfnd_app/screens/auth/signin.dart';
import 'package:tfnd_app/screens/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tfnd_app/screens/businessSide/qr_code.dart';
import 'package:tfnd_app/screens/userSide/bottomnavbar.dart';
import 'package:tfnd_app/screens/userSide/business_request/user_request.dart';
import 'package:tfnd_app/screens/userSide/scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      "pk_test_51MRaTJF6Z1rhh5U4MNaqxGCB6W0q9jpChr38P0XGxBWxwxHCq0Zcoj51ocXiDz3vv07ngUxak47ndtbaNk9Hyojq00ANDUYmf5";

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle the message when the app is in the foreground
    print("Message data: ${message.data}");
    print("Notification title: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the message when the app is in the background or terminated
    print("Message data: ${message.data}");
  });
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Request notification permissions
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications');
  } else {
    print('User declined permission for notifications');
  }

  // Get the APNs token
  String? apnsToken = await _firebaseMessaging.getAPNSToken();
  print('APNs Token: $apnsToken');

  String? fcmToken;

  _firebaseMessaging.getToken().then((token) {
    fcmToken = token;
    print('FCM Token: $fcmToken');
    // You can use the 'fcmToken' as needed (e.g., send it to your server)
  });
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('Broadcast');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //Load our .env file that contains our Stripe Secret key
  // await dotenv.load(fileName: "assets/stripe/.env");

  //  await Stripe.publishableKey;

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MyApp());
}

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? curentmail;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFND',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home:
          //  businessRequests()

          //Requestform());
          //BottomNavBar();)
          // Buttomnavigation());
          FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              print("curent emal is ${curentmail}");
              return BottomNavBar(
                userEmail: curentmail.toString(),
                status: '',
              );
            } else {
              // User is not logged in, navigate to signup screen
              return signin();
            }
          } else {
            // Loading state, you can show a loader or splash screen here
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    // Check the user login status using SharedPreferences or any other method
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    curentmail = prefs.getString('email');

    return isLoggedIn;
  }
}
