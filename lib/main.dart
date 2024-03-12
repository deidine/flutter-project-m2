import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapgoog/citte_client/onboarding/views/introduction_screen.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
 
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Venue Booking App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: OnBoardingPage(),
//     );
//   }
// }

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

     
    //  MultiProvider(
    //   providers: [
        
    //     ChangeNotifierProvider(
    //       create: (context) => OwnerDetailsProvider(),
    //     )
    //   ],
    //   child: MaterialApp(
    //     routes: {'doctorHomePage': (context) => OwnerHomePage()},
    //     theme: ThemeData(useMaterial3: true),
    //     debugShowCheckedModeBanner: false,
    //     home: OwnerHomePage(),
    //   ))
  