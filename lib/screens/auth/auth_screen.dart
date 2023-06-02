import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/providers/form_provider.dart';
import 'package:stronglier/screens/auth/widgets/form_sign_in.dart';
import 'package:stronglier/screens/auth/widgets/form_sign_up.dart';
import 'package:provider/provider.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _authMethod = Auth.signIn;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _rePwdCtrl = TextEditingController();
  late FormProvider _formProvider;

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    _pwdCtrl.dispose();
    _rePwdCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: GV.greyBackgroundColor,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            constraints: BoxConstraints(minHeight: Get.height),
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 25),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    'STRONGLIER',
                    style: GV.robotoBold().copyWith(
                          fontSize: 45,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 35),
                  if (_authMethod == Auth.signIn)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ĐĂNG NHẬP',
                              style: GV.robotoBold().copyWith(
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            FormSignIn(
                              signInFormKey: _signInFormKey,
                              emailCtrl: _emailCtrl,
                              pwdCtrl: _pwdCtrl,
                              formProvider: _formProvider,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: GV.robotoRegular().copyWith(
                                        color: GV.primaryColor,
                                      ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bạn chưa có tài khoản?',
                                  style: GV.robotoRegular(),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _authMethod = Auth.signUp;
                                      _emailCtrl.text = '';
                                      _nameCtrl.text = '';
                                      _phoneCtrl.text = '';
                                      _pwdCtrl.text = '';
                                      _rePwdCtrl.text = '';
                                    });
                                  },
                                  child: Text(
                                    'Đăng ký ngay',
                                    style: GV.robotoBold().copyWith(
                                          color: GV.primaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (_authMethod == Auth.signUp)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ĐĂNG KÝ',
                              style: GV.robotoBold().copyWith(
                                    fontSize: 22,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Container(
                              color: GV.greyBackgroundColor,
                              child: FormSignUp(
                                signUpFormKey: _signUpFormKey,
                                nameCtrl: _nameCtrl,
                                emailCtrl: _emailCtrl,
                                phoneCtrl: _phoneCtrl,
                                pwdCtrl: _pwdCtrl,
                                rePwdCtrl: _rePwdCtrl,
                                formProvider: _formProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 130, vertical: 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 1,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      'hoặc',
                                      style: GV.robotoBold(),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      height: 1,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/facebook.png'),
                                  const SizedBox(width: 24),
                                  Image.asset('assets/images/google.png'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bạn đã có tài khoản?',
                                  style: GV.robotoRegular(),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _authMethod = Auth.signIn;
                                      _emailCtrl.text = '';
                                      _nameCtrl.text = '';
                                      _phoneCtrl.text = '';
                                      _pwdCtrl.text = '';
                                    });
                                  },
                                  child: Text(
                                    'Đăng nhập ngay',
                                    style: GV.robotoBold().copyWith(
                                          color: GV.primaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
