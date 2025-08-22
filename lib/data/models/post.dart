import 'package:flutter_blog/data/models/user.dart';

class Post {
  // TODO - (댓글은 추후 추가)
  int id; // 게시물 ID
  String title;
  String content;
  DateTime createdAt; // 생성일시
  DateTime updatedAt; // 수정일시
  User user; // 작성자 (관계형 데이터)
  int bookmarkCount; // 북마크 수

  // 현재 사용자의 북마크 여부 (로그인 상태에 따라 달라짐)
  bool? isBookmark;

  // post.createdAt.year - 2025
  // post.createdAt.month - 5
  // DateTime.now().difference(post.createdAt);

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.bookmarkCount,
    this.isBookmark,
  });

  // User.fromMap(..)
  // 문자열을 DateTime 형변환 처리 해주어야 한다.
  Post.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']),
        isBookmark = data['isBookmark'],
        user = User.fromMap(data['user']),
        bookmarkCount = data['bookmarkCount'];

  // 디버깅 용
  @override
  String toString() {
    return 'Post{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, bookmarkCount: $bookmarkCount, isBookmark: $isBookmark}';
  }
}
