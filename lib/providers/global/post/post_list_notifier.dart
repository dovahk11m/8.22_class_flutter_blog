// 1 게시글 목록에 대한 데이터를 설계하자

// 클래스 이름은?
// 리스트 목록을 관리하는 녀석.. 상태가 계속 변한다
import 'package:flutter_blog/_core/utils/exception_handler.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber; // 현재 페이지 번호를 나타낸다 0 ~
  int size; // 페이지당 게시글 수
  int totalPage; // 전체 페이지 수
  // 게시글 목록
  List<Post> posts;

  PostListModel(
    this.isFirst,
    this.isLast,
    this.pageNumber,
    this.size,
    this.totalPage,
    this.posts,
  );

  // 서버 응답 데이터를 PostListModel 객체로 변환하는 생성자
  // N생성자 호출시 멤버변수에 값을 할당하려면?
  // 초기화 키워드를 사용
  PostListModel.fromMap(Map<String, dynamic> data)
      : isFirst = data["isFirst"],
        isLast = data["isLast"],
        pageNumber = data["pageNumber"],
        size = data["size"],
        totalPage = data["totalPage"],
        // posts...
        // 어떻게 파싱처리하지?
        // List<Post> -> Post(), Post(), Post()
        // 반복문을 돌려야 하나?
        //
        // posts = data["posts"]
        // posts = (data["posts"] as List)
        // posts = (data["posts"] as List).map()
        // posts = (data["posts"] as List).map((e) => Post.fromMap(e))
        posts = (data["posts"] as List).map((e) => Post.fromMap(e)).toList();

  PostListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? pageNumber,
    int? size,
    int? totalPage,
    List<Post>? posts,
  }) {
    //
    return PostListModel(
      isFirst ?? this.isFirst,
      isLast ?? this.isLast,
      pageNumber ?? this.pageNumber,
      size ?? this.size,
      totalPage ?? this.totalPage,
      posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return 'PostListModel{isFirst: $isFirst, isLast: $isLast, pageNumber: $pageNumber, size: $size, totalPage: $totalPage, posts: $posts}';
  }
} //end of class PostListModel

class PostListNotifier extends Notifier<PostListModel?> {
  //Nullable로 하면 편할때가 있음

  @override
  PostListModel? build() {
    // 창고데이터 초기모델은..
    // 통신 요청 이후에 결정된다 -> Nullable 필요
    // TODO 초기화 메서드 필요
    fetchPosts();
    return null;
  }

  // 비즈니스 로직
  // 1 fetchPosts - 게시글 목록 가져오기
  Future<Map<String, dynamic>> fetchPosts({int page = 0}) async {
    // TODO 예외처리 필요
    Map<String, dynamic> body = await PostRepository().getList(page: page);
    if (body["success"]) {
      // 서버가 정상적으로 데이터를 보내주면
      // json 데이터를 PostListModel 객체로 파싱
      PostListModel newModel = PostListModel.fromMap(body["response"]);
      // 상태 state 에 반영
      state = newModel;
      return {"success": true};
    } else {
      // 서버가 에러메시지를 보내면
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }

  // 2 refreshPostList - 새로고침

  // 3 loadMorePosts` - 추가 데이터 요청
  Future<Map<String, dynamic>> loadMorePosts() async {
    print("현재 페이지 번호: ${state!.pageNumber}");
    print("다음 페이지 번호: ${state!.pageNumber + 1}");

    int nextPage = state!.pageNumber + 1;
    Map<String, dynamic> body = await PostRepository().getList(page: nextPage);
    if (body["success"]) {
      PostListModel newPostListModel = PostListModel.fromMap(body["response"]);
      List<Post> newPosts = [...state!.posts, ...newPostListModel.posts];
      state = newPostListModel.copyWith(posts: newPosts);
      return {"seccess": true};
    } else {
      return {"seccess": false};
    }
  }
} //end of class PostListNotifier

final postListProvider = NotifierProvider<PostListNotifier, PostListModel?>(
    () => PostListNotifier());
