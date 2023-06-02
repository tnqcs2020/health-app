import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/regex_textformfield.dart';
import 'package:stronglier/common/user_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    required this.inDrawer,
    this.idUserManage,
    this.relationship,
  });
  final bool inDrawer;
  final String? idUserManage;
  final String? relationship;
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();
  Map<String, String> temp = {
    'name': '',
    'avatar': '',
    'email': '',
    'birthday': '',
    'gender': '',
    'phone': '',
    'allergy': '',
    'abstain': '',
  };
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  String? urlImage;

  getProfile(userData) {
    temp['name'] = userData['name'];
    temp['avatar'] = userData['avatar'];
    temp['email'] = userData['email'];
    temp['birthday'] = userData['birthday'];
    temp['gender'] = userData['gender'];
    temp['phone'] = userData['phone'];
    temp['allergy'] = userData['allergy'];
    temp['abstain'] = userData['abstain'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: !widget.inDrawer
            ? AppBar(
                title: const Text(
                  'Tài Khoản',
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
              )
            : null,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            constraints: BoxConstraints(minHeight: Get.bottomBarHeight),
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder(
              stream: GV.userCol.doc(widget.idUserManage ?? uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  getProfile(userData);
                  return Column(
                    children: [
                      if (widget.idUserManage != null)
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Đây là thông tin của ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red)),
                              Text('${widget.relationship}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red)),
                              const Text(' bạn.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      if (widget.idUserManage != null)
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: const Divider(
                            color: Colors.red,
                            thickness: 1,
                          ),
                        ),
                      SizedBox(
                        height: 150.0,
                        width: 150.0,
                        child: Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 70,
                                child: userData['avatar'] != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(64),
                                        child: CachedNetworkImage(
                                          cacheManager: GV.customCacheManager,
                                          key: UniqueKey(),
                                          imageUrl: userData['avatar'],
                                          height: 134,
                                          width: 134,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
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
                            if (widget.idUserManage == null)
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
                        key: _accountFormKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              initialValue: userData['name'],
                              hintText: 'Họ tên',
                              onChanged: (input) => temp['name'] = input!,
                              validator: (val) =>
                                  val.isValidName ? null : 'Hãy nhập họ tên',
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            CustomTextField(
                              initialValue: userData['birthday'],
                              hintText: 'Ngày sinh',
                              onChanged: (input) => temp['birthday'] = input!,
                              keyBoardType: TextInputType.datetime,
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            CustomTextField(
                              initialValue: userData['gender'],
                              hintText: 'Giới tính',
                              onChanged: (input) => temp['gender'] = input!,
                              validator: (val) => val!.isEmpty ||
                                      val.toLowerCase() == 'nam' ||
                                      val == 'nữ'
                                  ? null
                                  : 'Giới tính bao gồm: Nam và Nữ.',
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            CustomTextField(
                              initialValue: userData['email'],
                              hintText: 'Email',
                              enabled: false,
                            ),
                            CustomTextField(
                              initialValue: userData['phone'],
                              hintText: 'Số điện thoại',
                              onChanged: (input) => temp['phone'] = input!,
                              validator: (val) => val.isValidPhone
                                  ? null
                                  : 'Số điện thoại chỉ gồm 10 số và bắt đầu bằng 0.',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9]"),
                                )
                              ],
                              keyBoardType: TextInputType.phone,
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            CustomTextField(
                              initialValue: userData['allergy'],
                              hintText: 'Dị ứng',
                              onChanged: (input) => temp['allergy'] = input!,
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            CustomTextField(
                              initialValue: userData['abstain'],
                              hintText: 'Kiêng cử',
                              onChanged: (input) => temp['abstain'] = input!,
                              enabled:
                                  widget.idUserManage != null ? false : true,
                            ),
                            // if (widget.idUserManage != null)
                            // CustomTextField(
                            //   initialValue: userData['abstain'],
                            //   hintText: 'Kiêng cử',
                            //   onChanged: (input) => temp['abstain'] = input!,
                            //   enabled:
                            //       widget.idUserManage == null ? false : true,
                            // ),
                            const SizedBox(height: 45),
                            if (widget.idUserManage == null)
                              CustomButton(
                                text: 'Cập nhật',
                                width: Get.width * 0.5,
                                onTap: () async {
                                  if (_accountFormKey.currentState!
                                      .validate()) {
                                    GV.userCol.doc(uid).update({
                                      if (temp['name'] != userData['name'])
                                        'name': temp['name'],
                                      if (temp['birthday'] !=
                                          userData['birthday'])
                                        'birthday': temp['birthday'],
                                      if (temp['gender'] != userData['gender'])
                                        'gender': temp['gender'],
                                      if (temp['phone'] != userData['phone'])
                                        'phone': temp['phone'],
                                      if (temp['allergy'] !=
                                          userData['allergy'])
                                        'allergy': temp['allergy'],
                                      if (temp['abstain'] !=
                                          userData['abstain'])
                                        'abstain': temp['abstain'],
                                    });
                                    if (userData['parentId'] != '') {
                                      GV.userCol
                                          .doc(userData['parentId'])
                                          .collection('userManagers')
                                          .doc(uid)
                                          .update({
                                        if (temp['name'] != userData['name'])
                                          'name': temp['name'],
                                        if (userGlobal.avatar.value !=
                                            userData['avatar'])
                                          'avatar': userGlobal.avatar.value,
                                      });
                                    }
                                    if (temp['name'] != userData['name'] ||
                                        temp['birthday'] !=
                                            userData['birthday'] ||
                                        temp['gender'] != userData['gender'] ||
                                        temp['phone'] != userData['phone'] ||
                                        temp['allergy'] !=
                                            userData['allergy'] ||
                                        temp['abstain'] !=
                                            userData['abstain']) {
                                      await EasyLoading.showSuccess(
                                          'Cập nhật thành công!');
                                    } else {
                                      await EasyLoading.showInfo(
                                          'Không có thông tin thay đổi!');
                                    }
                                  }
                                },
                              ),
                            const SizedBox(height: 35),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
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
      var name = normalizeVie(userGlobal.name.value.toLowerCase())
          .split(' ')
          .join('-');
      await EasyLoading.show(status: 'Đang tải ảnh lên!');
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('avatar')
          .child('avatar-$name-$uid.${image.path.split('.').last}')
          .putFile(file)
          .whenComplete(() => print('success'));
      userGlobal.avatar.value = await snapshot.ref.getDownloadURL();
      await GV.userCol.doc(uid).update({
        'avatar': userGlobal.avatar.value,
      });
      await EasyLoading.showSuccess('Cập nhật ảnh thành công!');
    } else {
      await EasyLoading.showError('Không tìm thấy ảnh nào!');
    }
  }
}
