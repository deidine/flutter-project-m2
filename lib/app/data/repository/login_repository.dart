import 'package:mapgoog/app/data/model/Register/register_request.dart';
import 'package:get/get.dart';

import 'package:mapgoog/app/data/provider/api_provider.dart';

abstract class LoginRepository {
  static final getConnect = GetConnect();

  static Future<RegisterRequest> login(RegisterRequest request) async {
    Response<dynamic> req;
    try {
      req = await getConnect.post(ApiProvider.login, request.toJson());
    } catch (e) {
      throw Exception('Failed to send request');
    }

    return RegisterRequest.fromJson(req.body);
  }
}
