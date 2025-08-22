import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:logger/logger.dart'; // main() 실행시 추가 <---

class PostRepository {
  // 글 작성 요청
  Future<Map<String, dynamic>> write(String title, String content) async {
    // 1. 데이터 준비 - 생략
    // 2. HTTP 요청
    Response response = await dio.post("/api/post", data: {
      "title": title,
      "content": content,
    });

    // 3. 응답 처리
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 목록 조회 (페이지 네이션 처리)
  Future<Map<String, dynamic>> getList({int page = 0}) async {
    // 1. 데이터 준비 - 생략
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 조회 - 단일 조회
  Future<Map<String, dynamic>> getOne(int postId) async {
    Response response = await dio.get("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 삭제
  Future<Map<String, dynamic>> deleteOne(int postId) async {
    Response response = await dio.delete("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 수정
  Future<Map<String, dynamic>> updateOne(Post post) async {
    Response response = await dio.put("/api/post/${post.id}", data: {
      "title": post.title,
      "content": post.content,
    });

    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }
}
