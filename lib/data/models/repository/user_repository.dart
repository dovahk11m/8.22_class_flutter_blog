import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/main.dart';
import 'package:logger/logger.dart';

class UserRepository {
  // 회원 가입 요청 - post 요청
  Future<Map<String, dynamic>> join(
      String username, String email, String password) async {
    // 1. 요청 데이터 구성 - map 구조로 설계
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };

    // 2. HTTP post 요청
    Response response = await dio.post("/join", data: requestBody);

    // 3. 응답 처리
    final responseBody = response.data; // body 데이터 모두
    Logger().d("11111111111"); // 개발용 로깅 처리
    Logger().d(responseBody); // 개발용 로깅 처리

    // 4. 리턴
    return responseBody;
  }

  // 로그인 요청
  Future<Map<String, dynamic>> login(String username, String password) async {
    final requestBody = {
      "username": username,
      "password": password,
    };

    Response response = await dio.post("/login", data: requestBody);

    Map<String, dynamic> responseBody = response.data;
    // 개발 로깅용
    Logger().d(responseBody);
    return responseBody;
  }

  // 자동 로그인 - 토큰 값이 유효하다면
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    );

    Map<String, dynamic> responseBody = response.data;
    Logger().e(responseBody);
    return responseBody;
  }
}
