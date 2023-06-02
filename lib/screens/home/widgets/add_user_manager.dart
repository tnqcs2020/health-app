import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/regex_textformfield.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/user_model.dart';
import 'package:stronglier/providers/form_provider.dart';

class AddUserManager extends StatefulWidget {
  const AddUserManager({Key? key}) : super(key: key);

  @override
  State<AddUserManager> createState() => _AddUserManagerState();
}

class _AddUserManagerState extends State<AddUserManager> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _rePwdCtrl = TextEditingController();
  final TextEditingController _relationshipCtrl = TextEditingController();
  String avatar = '';
  late FormProvider _formProvider;
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    _formProvider = Provider.of<FormProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tạo tài khoản con',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Obx(
                  () => Text(
                    'Xin chào ${userGlobal.name.value}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              )),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            // constraints: BoxConstraints(minHeight: Get.bottomBarHeight),
            padding: const EdgeInsets.only(top: 10, bottom: 50),
            child: Column(
              children: [
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 70,
                          child: avatar != ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(64),
                                  child: CachedNetworkImage(
                                    cacheManager: GV.customCacheManager,
                                    key: UniqueKey(),
                                    imageUrl: avatar,
                                    height: 134,
                                    width: 134,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.black12,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            color: Colors.black12,
                                            child: const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 50,
                                            )),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 68,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 105,
                        left: 100,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200,
                            shape: const CircleBorder(
                                side: BorderSide(color: Colors.black)),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await uploadAvatar();
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Thông tin',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      CustomTextField(
                        controller: _nameCtrl,
                        hintText: 'Họ tên người thân',
                        onChanged: _formProvider.validateName,
                        errorText: _formProvider.name.error,
                        validator: (val) => val!.isNotEmpty
                            ? val.isValidName
                                ? null
                                : _formProvider.name.error
                            : 'Hãy nhập họ tên',
                        keyBoardType: TextInputType.name,
                      ),
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
                        keyBoardType: TextInputType.phone,
                        validator: (val) => val!.isNotEmpty
                            ? val.isValidPhone
                                ? null
                                : _formProvider.phone.error
                            : 'Hãy nhập số điện thoại',
                      ),
                      CustomTextField(
                        controller: _relationshipCtrl,
                        hintText: 'Mối quan hệ',
                        errorText: _formProvider.name.error,
                        validator: (val) =>
                            val!.isEmpty ? 'Hãy cho biết mối quan hệ' : null,
                        keyBoardType: TextInputType.text,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Tài khoản',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
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
                      const SizedBox(height: 35),
                      CustomButton(
                        text: 'Tạo',
                        width: Get.width * 0.5,
                        onTap: () async {
                          QuerySnapshot isExistEmail = await GV.userCol
                              .where('email', isEqualTo: _emailCtrl.text)
                              .get();
                          if (isExistEmail.docs.isEmpty) {
                            if (_signUpFormKey.currentState!.validate()) {
                              //     await GV.auth.createUserWithEmailAndPassword(
                              //   email: _emailCtrl.text,
                              //   password: _pwdCtrl.text,
                              // );
                              FirebaseApp app = await Firebase.initializeApp(
                                  name: 'secondary',
                                  options: Firebase.app().options);
                              final UserCredential newUser =
                                  await FirebaseAuth.instanceFor(app: app)
                                      .createUserWithEmailAndPassword(
                                          email: _emailCtrl.text,
                                          password: _pwdCtrl.text);
                              app.delete();
                              if (newUser != null) {
                                final userModel = UserModel(
                                  idU: newUser.user!.uid,
                                  name: _nameCtrl.text,
                                  email: _emailCtrl.text,
                                  phone: _phoneCtrl.text,
                                  password: _pwdCtrl.text,
                                  avatar: avatar,
                                  parentId: uid,
                                );
                                await GV.userCol
                                    .doc(newUser.user!.uid)
                                    .set(userModel.toMap());
                                final userManager = UserManager(
                                    idU: newUser.user!.uid,
                                    name: _nameCtrl.text,
                                    relationship: _relationshipCtrl.text,
                                    avatar: avatar);
                                await GV.userCol
                                    .doc(uid)
                                    .collection('userManagers')
                                    .doc(newUser.user!.uid)
                                    .set(userManager.toMap());

                                await EasyLoading.showSuccess(
                                    'Tạo thành công.');
                                Get.back();
                              }
                            }
                          } else {
                            await EasyLoading.showError(
                                'Tài khoản email đã tồn tại!');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadAvatar() async {
    final imagePicker = ImagePicker();
    XFile? image;
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      var name =
          normalizeVie(_nameCtrl.text.toLowerCase()).split(' ').join('-');
      await EasyLoading.show(status: 'Đang tải ảnh lên!');
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('avatar')
          .child(
              'avatar-$name-${getRandomString(28)}.${image.path.split('.').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      var link = await snapshot.ref.getDownloadURL();
      setState(() {
        avatar = link;
      });
      await EasyLoading.showSuccess('Thêm ảnh thành công!');
    } else {
      await EasyLoading.showError('Không tìm thấy ảnh nào!');
    }
  }
}
