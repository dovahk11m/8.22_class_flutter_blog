import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_write_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ref를 쓰기위해 컨슈머 위젯으로 업글
class PostWriteForm extends ConsumerWidget {
  // 폼 유효성 검사용 키
  final _formKey = GlobalKey<FormState>();

  // 제목 입력 컨트롤러
  final _title = TextEditingController();

  // 내용 입력 컨트롤러
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 게시글 작성 상태 데이터
    // 이녀석의 주된 목적은..
    // 상태가 변결될 때마다 빌드 메서드가 다시 호출되도록 하는 것
    // 그러면 UI가 업데이트된다.
    final PostWriteModel postWriteModel = ref.watch(postWriteProvider);

    // 복습정리
    // 상태를 감시하는 메서드는 3가지가 있다.
    // ref.read(provider)
    // ref.watch(provider)
    // ref.listen(provider, listener) *
    // 여기서는 리슨을 활용해보자
    // 리슨은 메서드 내부에서 initState 에서 사용 가능하다.
    // 상태 변화에 따른 *사이드이펙트 처리에 사용한다.
    // 주로 네비게이션, 다이얼로그, 스낵바 등..
    // 일회성 액션이 필요한 곳에서 사용된다.
    // 참고로 사이드이펙트는 람다표현식에서 많이 활용된다.

    ref.listen(
      postWriteProvider,
      (previous, next) {
        // next = 모델
        if (next.status == PostWriteStatus.success) {
          // 사이드이펙트1: 성공메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("게시글 작성 완료"),
              backgroundColor: Colors.green,
            ),
          );

          // 사이드이펙트2: 목록 새로고침 (통신은 자제할것)
          ref.read(postListProvider.notifier).refreshAfterWrite();

          // 사이드이펙트3: 화면 이동
          Navigator.pop(context);
        } else if (next.status == PostWriteStatus.failure) {
          //게시글 작성 실패시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("게시글 작성 실패"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
    );

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
            //value = 작성값
            validator: (value) =>
                value?.trim().isEmpty == true ? "제목을 입력하세요" : null,
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            //value = 작성값
            validator: (value) =>
                value?.trim().isEmpty == true ? "내용을 입력하세요" : null,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: postWriteModel.status == PostWriteStatus.loading
                ? "작성중..."
                : "글쓰기",
            click: postWriteModel.status == PostWriteStatus.loading
                ? null
                : () => _handleSubmit(ref),
          ),
        ],
      ),
    );
  } //end of build

  void _handleSubmit(WidgetRef ref) {
    // 폼 유효성 검사
    // 사용자가 작성한 값을 들고 올거야
    // 상태관리 비즈니스 로직을 호출할거야 (게시글 작성)
    if (_formKey.currentState!.validate()) {
      //
      final title = _title.text.trim();
      final content = _title.text.trim();

      ref.read(postWriteProvider.notifier).writePost(title, content);
    }
  }
}
