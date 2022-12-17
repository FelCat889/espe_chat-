import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:espe_chat/common/utils/colors.dart';
import 'package:espe_chat/common/widgets/error.dart';
import 'package:espe_chat/common/widgets/loader.dart';
import 'package:espe_chat/features/auth/controller/auth_controller.dart';
import 'package:espe_chat/features/landing/screens/landing_screen.dart';
import 'package:espe_chat/firebase_options.dart';
import 'package:espe_chat/router.dart';
import 'package:espe_chat/mobile_layout_screen.dart';


void main() async {

//   const firebaseConfig = {

//     apiKey: "AIzaSyCl7mn6fV1pqSo23mAZ2XiAaZznrE4lgfk",

//   authDomain: "bduniversidad-5d746.firebaseapp.com",

//   databaseURL: "https://bduniversidad-5d746-default-rtdb.firebaseio.com",

//   projectId: "bduniversidad-5d746",

//   storageBucket: "bduniversidad-5d746.appspot.com",

//   messagingSenderId: "222835281688",

//   appId: "1:222835281688:web:ffdda5b4cbe68dab17186d",

//   measurementId: "G-EGMLHHS4LD"

// };


//   WidgetsFlutterBinding.ensureInitialized();
//   //NAVEGADOR
//  await Firebase.initializeApp(
//       options: FirebaseOptions(      
//       apiKey: "AIzaSyCl7mn6fV1pqSo23mAZ2XiAaZznrE4lgfk",
//       authDomain: "bduniversidad-5d746.firebaseapp.com",
//       projectId: "bduniversidad-5d746",
//       storageBucket: "bduniversidad-5d746.appspot.com",
//       messagingSenderId: "222835281688",
//       appId: "1:222835281688:web:ffdda5b4cbe68dab17186d",
//       measurementId: "G-EGMLHHS4LD"
//    ));
// Initialize Firebase

// const app = initializeApp(firebaseConfig);

// const analytics = getAnalytics(app);

  //ACTIVATE THIS FOR ANDROID
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
