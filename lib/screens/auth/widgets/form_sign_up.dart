// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/regex_textformfield.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/user_model.dart';
import 'package:stronglier/router.dart';
import 'package:stronglier/providers/form_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronglier/screens/drawer/drawer_screen.dart';

// ignore: must_be_immutable
class FormSignUp extends StatelessWidget {
  FormSignUp({
    super.key,
    required GlobalKey<FormState> signUpFormKey,
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController pwdCtrl,
    required TextEditingController rePwdCtrl,
    required FormProvider formProvider,
  })  : _signUpFormKey = signUpFormKey,
        _nameCtrl = nameCtrl,
        _emailCtrl = emailCtrl,
        _phoneCtrl = phoneCtrl,
        _pwdCtrl = pwdCtrl,
        _rePwdCtrl = rePwdCtrl,
        _formProvider = formProvider;
  final GlobalKey<FormState> _signUpFormKey;
  final TextEditingController _nameCtrl;
  final TextEditingController _emailCtrl;
  final TextEditingController _phoneCtrl;
  final TextEditingController _pwdCtrl;
  final TextEditingController _rePwdCtrl;
  final FormProvider _formProvider;
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Thông tin',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          CustomTextField(
            controller: _nameCtrl,
            hintText: 'Họ tên',
            onChanged: _formProvider.validateName,
            errorText: _formProvider.name.error,
            validator: (val) => val!.isNotEmpty
                ? val.isValidName
                    ? null
                    : _formProvider.name.error
                : 'Hãy nhập họ tên',
            keyBoardType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _phoneCtrl,
            hintText: 'Số điện thoại',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"[0-9]"),
              )
            ],
            onChanged: _formProvider.validatePhone,
            errorText: _formProvider.phone.error,
            validator: (val) => val!.isNotEmpty
                ? val.isValidPhone
                    ? null
                    : _formProvider.phone.error
                : 'Hãy nhập số điện thoại',
            keyBoardType: TextInputType.phone,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Tài khoản',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          CustomTextField(
            controller: _rePwdCtrl,
            hintText: 'Xác nhận mật khẩu',
            isPassword: true,
            onChanged: _formProvider.validateRePassword,
            errorText: _formProvider.rePassword.error,
            validator: (val) => val!.isNotEmpty
                ? val == _pwdCtrl.text && val.isValidPassword
                    ? null
                    : _formProvider.rePassword.error
                : 'Hãy xác nhận lại mật khẩu',
            maxLines: 1,
          ),
          const SizedBox(height: 55),
          CustomButton(
            text: 'Đăng Ký',
            width: Get.width * 0.5,
            onTap: () async {
              QuerySnapshot isExistEmail = await GV.userCol
                  .where('email', isEqualTo: _emailCtrl.text)
                  .get();
              if (isExistEmail.docs.isEmpty) {
                if (_signUpFormKey.currentState!.validate()) {
                  final UserCredential newUser = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailCtrl.text,
                    password: _pwdCtrl.text,
                  );
                  if (newUser != null) {
                    final userModel = UserModel(
                      idU: newUser.user!.uid,
                      name: _nameCtrl.text,
                      email: _emailCtrl.text,
                      phone: _phoneCtrl.text,
                      password: _pwdCtrl.text,
                    );
                    final docUser = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userModel.idU);
                    final json = userModel.toMap();
                    await docUser.set(json);
                    final SharedPreferences sharedPref =
                        await SharedPreferences.getInstance();
                    sharedPref.setString(
                      'email',
                      _emailCtrl.text,
                    );
                    userGlobal.setUser(
                      idGlobal: newUser.user!.uid.obs,
                      nameGlobal: _nameCtrl.text.obs,
                      emailGlobal: _emailCtrl.text.obs,
                    );
                    Get.offUntil(
                        MaterialPageRoute(builder: (_) => const DrawerScreen()),
                        (route) => false);
                  }
                }
              } else {
                EasyLoading.showError('Tài khoản email đã tồn tại!');
              }
            },
          ),
        ],
      ),
    );
  }
}
