import 'package:mapgoog/app/data/model/user/user_response.dart';
import 'package:mapgoog/app/data/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapgoog/app/core/themes/custom_snackbar_theme.dart';
import 'package:mapgoog/app/data/service/login_service.dart';
import 'package:mapgoog/app/routes/app_pages.dart';

class LoginController extends GetxController with StateMixin {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  // late UserResponse? userProfile;

  @override
  void onInit() {
    intializeController();
    change(true, status: RxStatus.success());

    super.onInit();
  }

  void intializeController() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<UserResponse> getDataUser(String username) async {
    UserResponse? dataUser;

    print("data user function");
    dataUser = await UserService.getUser(username);

    return dataUser;
  }

  void handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackbar.failedSnackbar(
        title: 'Failed',
        message: 'Please input username and password',
      );
      return;
    }

    final inputtedUsername = usernameController.text;
    final inputtedPassword = passwordController.text;

    // UserResponse cred =
    //     await getDataUser(inputtedUsername);
    change(false, status: RxStatus.loading());
    final isValid =
        await LoginService.login(inputtedUsername, inputtedPassword);
    UserResponse? dataUser;

    print("data user function");
    dataUser = await UserService.getUser(inputtedUsername);

    change(true, status: RxStatus.success());

    if (isValid ?? false) {
      final arguments = {'infoUser': dataUser, 'username': inputtedUsername};

      if (dataUser.role == "client") {
        //! get type if type==user then show user ui otherwise show doctor ui

        Get.offAllNamed(Routes.HOME, arguments: arguments);
      } else if (dataUser.role == "owner") {
        Get.offAllNamed(Routes.HOMEOWNER, arguments: arguments);
      }

      return;
    }

    CustomSnackbar.failedSnackbar(
      title: 'Failed',
      message: 'Wrong username or password',
    );
  }
}
