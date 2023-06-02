// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/regex_textformfield.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/providers/form_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronglier/screens/drawer/drawer_screen.dart';

class FormSignIn extends StatelessWidget {
  FormSignIn({
    super.key,
    required GlobalKey<FormState> signInFormKey,
    required TextEditingController emailCtrl,
    required FormProvider formProvider,
    required TextEditingController pwdCtrl,
  })  : _signInFormKey = signInFormKey,
        _emailCtrl = emailCtrl,
        _formProvider = formProvider,
        _pwdCtrl = pwdCtrl;

  final GlobalKey<FormState> _signInFormKey;
  final TextEditingController _emailCtrl;
  final FormProvider _formProvider;
  final TextEditingController _pwdCtrl;
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            hintText: 'Email',
            onChanged: _formProvider.validateEmail,
            errorText: _formProvider.email.error,
            validator: (val) => val!.isNotEmpty
                ? val.isValidEmail
                    ? null
                    : _formProvider.email.error
                : 'Hãy nhập email',
            keyBoardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _pwdCtrl,
            hintText: 'Mật khẩu',
            isPassword: true,
            onChanged: _formProvider.validatePassword,
            errorText: _formProvider.password.error,
            validator: (val) => val!.isNotEmpty
                ? val.isValidPassword
                    ? null
                    : _formProvider.password.error
                : 'Bạn chưa nhập mật khẩu',
            maxLines: 1,
          ),
          const SizedBox(height: 100),
          CustomButton(
            text: 'Đăng Nhập',
            width: Get.width * 0.5,
            onTap: () async {
              QuerySnapshot isExistEmail = await GV.userCol
                  .where('email', isEqualTo: _emailCtrl.text)
                  .get();
              if (isExistEmail.docs.isNotEmpty) {
                QuerySnapshot isMatchPwd = await GV.userCol
                    .where(
                      'email',
                      isEqualTo: _emailCtrl.text,
                    )
                    .where(
                      'password',
                      isEqualTo: _pwdCtrl.text,
                    )
                    .get();
                if (_signInFormKey.currentState!.validate() &&
                    isMatchPwd.docs.isNotEmpty) {
                  await GV.auth.signInWithEmailAndPassword(
                    email: _emailCtrl.text,
                    password: _pwdCtrl.text,
                  );
                  final SharedPreferences sharedPref =
                      await SharedPreferences.getInstance();
                  sharedPref.setString(
                    'email',
                    _emailCtrl.text,
                  );
                  userGlobal.setUser(
                      idGlobal: '${isMatchPwd.docs[0]['idU']}'.obs,
                      nameGlobal: '${isMatchPwd.docs[0]['name']}'.obs,
                      emailGlobal: _emailCtrl.text.obs,
                      typeGlobal: '${isMatchPwd.docs[0]['type']}'.obs,
                      avatarGlobal: '${isMatchPwd.docs[0]['avatar']}'.obs,
                      );
                  print(isMatchPwd.docs[0]['idU']);
                  print(isMatchPwd.docs[0]['name']);
                  print(_emailCtrl.text);        
                  print(isMatchPwd.docs[0]['type']);
                  Get.offUntil(
                      MaterialPageRoute(builder: (_) => const DrawerScreen()),
                      (route) => false);
                } else {
                  EasyLoading.showError('Mật khẩu không đúng!');
                }
              } else {
                EasyLoading.showError('Tài khoản email không tồn tại!');
              }
            },
          ),
        ],
      ),
    );
  }
}
