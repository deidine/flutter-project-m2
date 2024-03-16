import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mapgoog/app/core/values/assets.dart';
import 'package:mapgoog/app/routes/app_pages.dart'; 
import 'package:mapgoog/citte_client/onboarding/controllers/onboarding_controller.dart';

class OnBoardingPage  extends GetView<OnboardingController> {
    final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
  Get.offAndToNamed(Routes.LOGIN, arguments: false);
  }

  Widget _buildImage(String assetName, [double width = 400]) {
    return Image.asset( 'assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        imageFlex: 2,
        imagePadding: EdgeInsets.zero //(top: 100),
        );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('logo.jpeg', 60),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          child: const Text(
            'Commencer dès maintenant !',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Bienvenue dans un monde de nouvelles possibilités !",
          body: "",
          image: _buildImage('hero_onboarding.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(      
              title: "Débloquez des opportunités infinies",
          body: "Restez à jour avec les dernières matches",
          image: _buildImage('2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "CITEK réalisez votre travail !",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:   [
                      Text("Cliquez sur ", style: bodyStyle),
              Icon(Icons.post_add_outlined),
              Text(" pour reserver une citte", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 3,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('OIP.jpeg'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Colors.orange,
      ),
      skip: const Text('Passer',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
      next: const Icon(Icons.arrow_forward, color: Colors.orange),
      done: const Text('Terminé',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
      curve: Curves.bounceIn, //Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: Colors.orange,
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color.fromARGB(221, 58, 56, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
