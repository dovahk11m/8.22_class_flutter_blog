// 게시글 쓰기를 위한 데이터 설계

import 'package:flutter/cupertino.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//게시글 작성 진행항태를 나타내는 열거형
enum PostWriteStatus {
  initial, // 초기상태 (아무것도 안하는 상태)
  loading, // 작성중(서버통신중
  success, // 작성 성공
  failure, // 작성 실패
}

//게시글 작성 상태를 설계 (창고데이터)
class PostWriteModel {
  final PostWriteStatus status;
  final String? message;
  final Post? createPost;

  //작성 성공시 생성된 게시글
  PostWriteModel({
    this.status = PostWriteStatus.initial,
    this.message,
    this.createPost,
  });

  //불변성 패턴
  //copyWith 메서드 호출하면 새로운 객체 생성
  PostWriteModel copyWith({
    PostWriteStatus? status,
    String? message,
    Post? createPost,
  }) {
    return PostWriteModel(
      status: status ?? this.status,
      message: message ?? this.message,
      createPost: createPost ?? this.createPost,
    );
  }

  @override
  String toString() {
    return 'PostWriteModel{status: $status, message: $message, createPost: $createPost}';
  }
} //end of class PostWriteModel;

// 창고 메뉴얼 설계
// 가능한 순수 비즈니스 로직만 담당하도록 설계한다
// SRP 단일 책임 원칙
class PostWriteNotifier extends Notifier<PostWriteModel> {
  @override
  PostWriteModel build() {
    return PostWriteModel();
  }

  Future<void> writePost(String title, String content) async {
    // 기본적으로 예외처리 해야하나.. 생략
    // 중복클릭 방지를 위한 상태변경
    // 로딩상태
    state = state.copyWith(status: PostWriteStatus.loading);
    // UI단에서 로딩상태라면 VoidCallback 값을 null 처리
    // 버튼을 비활성화한다.

    Map<String, dynamic> response =
        await PostRepository().write(title, content);

    if (response["success"] == true) {
      Post createdPost = Post.fromMap(response["response"]);
      state = state.copyWith(
        status: PostWriteStatus.success,
        message: "게시글이 작성됐습니다",
        createPost: createdPost,
      );
    } else {
      state = state.copyWith(
        status: PostWriteStatus.failure,
        message: "${response["errorMessage"]} - 글 작성에 실패했습니다",
      );
    }
  }
} // end of notifier

final postWriteProvider = NotifierProvider<PostWriteNotifier, PostWriteModel>(
  () => PostWriteNotifier(),
);
