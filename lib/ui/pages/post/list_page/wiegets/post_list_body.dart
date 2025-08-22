import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidget -> stl + riverpod
// 로컬 UI 상태변경이 필요한 경우
// 여러 컨트롤러 객체가 필요한 경우
// 애니메이션이 필요한 경우

class PostListBody extends ConsumerStatefulWidget {
  const PostListBody({super.key});

  @override
  _PostListBodyState createState() => _PostListBodyState();
}

class _PostListBodyState extends ConsumerState<PostListBody> {
  // 스크롤의 위치감지와 메모리 해제가 필요함
  ScrollController _scrollController = ScrollController();

  // 추가 로딩 상태 관리
  bool _isLoadingMore = false;

  @override
  void initState() {
    // 스크롤이 맨 아래에 도달했을 때
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  //print("최하단: ${_scrollController.position.maxScrollExtent}");

  // 현재 스크롤

  // if (_scrollController.offset >=
  //     _scrollController.position.maxScrollExtent) {
  //   print('스크롤이 끝에 도달했습니다.');
  // }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 5) {
      print("최하단 도달, 서버에 추가 PostList 요청");
      // TODO 여러번 호출되는 문제
      if (_isLoadingMore == false) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    // 마지막 페이지라면 요청 금지
    PostListModel? model = ref.read(postListProvider);
    if (model == null || model.isLast) {
      return;
    }

    try {
      _isLoadingMore = true;
      await ref.read(postListProvider.notifier).loadMorePosts();
    } finally {
      // 다 끝났으면 원복
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostListModel? postListModel = ref.watch(postListProvider);
    if (postListModel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          //비동기..Future
          await ref.read(postListProvider.notifier).fetchPosts();
        },
        child: ListView.separated(
          controller: _scrollController,
          itemCount: postListModel.posts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PostDetailPage()));
              },
              child: PostListItem(postListModel.posts[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      );
    }
  }
}

// class PostListBody extends ConsumerWidget {
//   const PostListBody({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     //스크롤 감지
//
//     PostListModel? postListModel = ref.watch(postListProvider);
//     if (postListModel == null) {
//       return const Center(child: CircularProgressIndicator());
//     } else {
//       return ListView.separated(
//         itemCount: postListModel.posts.length,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (_) => PostDetailPage()));
//             },
//             child: PostListItem(postListModel.posts[index]),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return const Divider();
//         },
//       );
//     }
//   }
// }
