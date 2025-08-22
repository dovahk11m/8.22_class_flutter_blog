import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// stl 위젯은 중앙 저장고에 접근 못한다
// 창고에 접근할 수 있는 stf 위젯으로 확장해야 한다.

class CustomNavigation extends ConsumerWidget {
  final scaffoldKey;

  const CustomNavigation(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    SessionNotifier sessionNotifier = ref.read(sessionProvider.notifier);
    //
    return Container(
      // 화면 크기의 60%
      width: getDrawerWidth(context),
      // 꽉차게
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                  Navigator.pushNamed(context, "/post/write");
                },
                child: const Text(
                  "글쓰기",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () async {
                  // 로그아웃 기능 호출
                  await sessionNotifier.logout();
                  scaffoldKey.currentState!.openEndDrawer();
                  Navigator.popAndPushNamed(context, "/login");
                },
                child: const Text(
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  //내 기능
                },
                child: Text(
                  "내 정보",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
