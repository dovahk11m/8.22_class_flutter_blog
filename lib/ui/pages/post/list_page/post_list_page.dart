import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';

class PostListPage extends StatelessWidget {
  // scaffoldKey 하위 위젯에 키를 전달
  // scaffoldKey 키를 통해 drawer 위젯을 다룬다
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // refreshIndicator 관련 키
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {},
        child: PostListBody(),
      ),
    );
  }
}
