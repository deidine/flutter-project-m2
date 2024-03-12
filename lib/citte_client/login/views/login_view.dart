import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapgoog/app/core/themes/font_themes.dart';
import 'package:mapgoog/app/core/values/assets.dart';
import 'package:mapgoog/app/core/values/colors.dart';
import 'package:mapgoog/app/global_widgets/loading_spinkit.dart';
import 'package:mapgoog/app/routes/app_pages.dart';

import '../../../app/global_widgets/custom_medium_button.dart';
import '../../../app/global_widgets/footer_text.dart';
import '../controllers/login_controller.dart';
import '../../../app/global_widgets/custom_textfield.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          // color: Colors.white,
          child: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.15,
                      ),
                      Image.asset(heroLoginImage),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: headline4,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        textStyle: headline6,
                        isObscure: false,
                        controller: controller.usernameController,
                        label: 'Username',
                        icon: Icons.person,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        textStyle: headline6,
                        isObscure: true,
                        controller: controller.passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomMediumButton(
                        color: blue,
                        label: 'Login',
                        onTap: controller.handleLogin,
                      ),
                      SizedBox(
                        height: 50,
                        child: controller.obx(
                          (state) => const SizedBox.shrink(),
                          onLoading: const LoadingSpinkit(),
                        ),
                      ),
                      FooterText(
                        label: 'Don\'t have an account? ',
                        labelWithFunction: 'Join Us',
                        ontap: () => Get.toNamed(Routes.REGISTER),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]))
    ]));
  }
}
