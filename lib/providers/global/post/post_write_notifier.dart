// 게시글 쓰기를 위한 데이터 설계

import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteModel {
  String title;
  String content;

  PostWriteModel(
    this.title,
    this.content,
  );

  @override
  String toString() {
    return 'PostWriteModel{title: $title, content: $content}';
  }
} // end of class PostWriteModel

// 창고 메뉴얼 설계
class PostWriteFormNotifier extends Notifier<PostWriteModel?> {
  @override
  PostWriteModel? build() {
    return null;
  }

  // 게시글 작성 로직
  Future<bool> write(String title, String content) async {
    Future body = PostRepository().write(title, content);

    return true;
  }
}

// 실제 창고를 메모리에 올리자 - 전역 변수로 관리
final postWriteProvider =
    NotifierProvider<PostWriteFormNotifier, PostWriteModel?>(
        () => PostWriteFormNotifier());
