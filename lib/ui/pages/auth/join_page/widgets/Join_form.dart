import 'package:flutter/material.dart';
import 'package:flutter_blog/data/models/repository/user_repository.dart';
import 'package:flutter_blog/providers/form/join_form_notifier.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../widgets/custom_auth_text_form_field.dart';
import '../../../../widgets/custom_elavated_button.dart';
import '../../../../widgets/custom_text_button.dart';

//
class JoinForm extends ConsumerWidget {
  const JoinForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 값 감시
    JoinModel joinModel = ref.watch(joinProvider);
    JoinFormNotifier formNotifier = ref.read(joinProvider.notifier);
    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            title: "Username",
            errorText: joinModel.usernameError,
            onChanged: (value) {
              // 입력값 변경시 상태 업데이트 + 실시간 검증
              print("value : ${value}");
              formNotifier.username(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Email",
            errorText: joinModel.emailError,
            onChanged: (value) {
              formNotifier.email(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Password",
            obscureText: true,
            errorText: joinModel.passwordError,
            onChanged: (value) {
              formNotifier.password(value);
            },
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "회원가입",
            click: () async {
              // 최종 검증
              bool isValid = formNotifier.validate();
              if (!isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("유효성 검사 실패입니다")),
                );
                return;
              }
              final Map<String, dynamic> result =
                  await ref.read(sessionProvider.notifier).join(
                        joinModel.username,
                        joinModel.email,
                        joinModel.password,
                      );
              if (result["success"] == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${result["errorMessage"]}")),
                );
                return;
              } else {
                // 횐가입 성공시 로긴 페이지
                Navigator.pushNamed(context, "/login");
              }
            },
          ),
          CustomTextButton(
            text: "로그인 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
