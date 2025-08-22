import 'package:flutter/material.dart'
    show ScaffoldMessenger, Text, SnackBar, Navigator;
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/models/repository/user_repository.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/form/join_form_notifier.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 세션이라는 데이터를 구조화 해보자
// 창고 데이터 구상하기
class SessionModel {
  User? user;
  bool? isLogin;

  SessionModel({this.user, this.isLogin = false});

  @override
  String toString() {
    return 'SessionModel{user: $user, isLogin: $isLogin}';
  }
}

// 창고 매뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  @override
  SessionModel build() {
    return SessionModel();
  }

  // 로그인 로직 설계 -> 비즈니스 로직에 집중
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      Map<String, dynamic> body =
          await UserRepository().login(username, password);

      if (body["seccess"] == false) {
        //서버에서 내려준 에러 정보를 그대로 반환 -> UI 측으로.
        return body;
      }

      // 서버에서 받은 사용자 정보(맵)를 앱에서 사용할 수 있는 형태(유저)로 변환
      User user = User.fromMap(body["response"]);

      // 로컬 저장소에 JWT 토큰을 저장해 두자.
      // Shared... 보안에 강화된 녀석 // yml 라이브러리 선언 됨
      await secureStorage.write(key: "accessToken", value: user.accessToken);

      state = SessionModel(user: user, isLogin: true);

      // 로그인 성공 이후에 서버측에 통신 요청할 때마다 JWT 토큰을 주입해야 된다
      dio.options.headers['Authorization'] = user.accessToken;

      // 로그인 성공 정보 반환
      return {"success": true};
    } catch (e) {
      // 네트워크 장애로 꺼져있다면
      return {"seccess": false, "errorMessage": "네트워크 오류 발생했습니다"};
    }
  }

  // 로그 아웃 기능
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: "accessToken");
      //빈 세션 객체
      state = SessionModel();
      dio.options.headers['Authorization'] = "";
      Logger().d("로그아웃 완료");
    } catch (e) {
      //빈값
      Logger().e("로그아웃 오류 발생");
      state = SessionModel();
      dio.options.headers['Authorization'] = "";
    }
  }

  // 자동 로그인 기능
  // Future<Map<String, dynamic>> autoLogin() async {
  //   final accessToken = await secureStorage.read(key: "accessToken") ?? "";
  //   if (accessToken.isEmpty) {
  //     return {"success": false};
  //   }
  //
  //   final response = await UserRepository().autoLogin(accessToken);
  //   return {"success": true};
  // }

  Future<bool> autoLogin() async {
    try {
      // 1 저장소에서 인증 토큰 확인
      String? accessToken = await secureStorage.read(key: "accessToken");
      if (accessToken == null) {
        return false;
      }
      // 2 UserRepository() 에 자동 로그인 요청
      Map<String, dynamic> body = await UserRepository().autoLogin(accessToken);

      // 3 서버에서 받은 사용자정보를 창고에 다시 넣는다
      User user = User.fromMap(body["response"]);
      user.accessToken = accessToken;

      // 4 창고 데이터에 로그인된 상태로 업그레이드
      state = SessionModel(user: user, isLogin: true);

      // 5 이후 모든 http 요청에 인증 열쇠 자동 부여
      dio.options.headers['Authorization'] = user.accessToken;
      Logger().d("자동 로그인 성공");

      return true;
    } catch (e) {
      Logger().e("자동 로그인 오류 발생: ${e}");
      return false;
    }
  }

  // 회원 가입 로직 추가하기
  Future<Map<String, dynamic>> join(
    String username,
    String email,
    String password,
  ) async {
    Logger()
        .d("username : ${username}, email: ${email}, password : ${password}");

    Map<String, dynamic> body =
        await UserRepository().join(username, email, password);

    // 횐가입 실패시 처리
    if (body["success"] == false) {
      return {"success": false, "errorMessage": body["errorMessage"]};
    }
    return {"success": true};
  }
} // end of SessionNotifier

// 실제 창고 개설
final sessionProvider =
    NotifierProvider<SessionNotifier, SessionModel>(() => SessionNotifier());
