import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/models/vaccine_model.dart';

class AddVaccine extends StatefulWidget {
  const AddVaccine({Key? key}) : super(key: key);

  @override
  State<AddVaccine> createState() => _AddVaccineState();
}

class _AddVaccineState extends State<AddVaccine> {
  final GlobalKey<FormState> _vaccineFormKey = GlobalKey();
  final TextEditingController _vaccineNameCtrl = TextEditingController();
  final TextEditingController _usesCtrl = TextEditingController();
  final TextEditingController _makeByCtrl = TextEditingController();
  final TextEditingController _makeInCtrl = TextEditingController();
  final TextEditingController _timeNextCtrl = TextEditingController();
  final TextEditingController _totalVacCtrl = TextEditingController();

  final userGlobal = Get.put(UserGlobal());
  String imageVaccine = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thêm vắc-xin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
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
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            constraints: BoxConstraints(minHeight: Get.bottomBarHeight),
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Center(
                  child: imageVaccine != ''
                      ? InkWell(
                          onTap: () async {
                            await uploadImageVaccine();
                          },
                          child: GFImageOverlay(
                            height: 180,
                            width: 200,
                            image: NetworkImage(imageVaccine),
                            boxFit: BoxFit.fill,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await uploadImageVaccine();
                          },
                          child: GFImageOverlay(
                            height: 150,
                            width: 200,
                            image: const AssetImage(GV.noImage),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                ),
                Form(
                  key: _vaccineFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _vaccineNameCtrl,
                        hintText: 'Tên vắc-xin',
                        validator: (val) => _vaccineNameCtrl.text.isNotEmpty
                            ? null
                            : 'Cần phải nhập tên vắc-xin.',
                      ),
                      CustomTextField(
                        controller: _usesCtrl,
                        hintText: 'Công dụng',
                        validator: (val) => _usesCtrl.text.isNotEmpty
                            ? null
                            : 'Cần nhập công dụng của vắc-xin.',
                      ),
                      CustomTextField(
                        controller: _makeByCtrl,
                        hintText: 'Công ty sản xuất',
                      ),
                      CustomTextField(
                        controller: _makeInCtrl,
                        hintText: 'Quốc gia sản xuất',
                      ),
                      CustomTextField(
                        controller: _totalVacCtrl,
                        hintText: 'Tổng số mũi tiêm',
                        keyBoardType: TextInputType.number,
                        validator: (val) => _totalVacCtrl.text.isNotEmpty &&
                                int.parse(_totalVacCtrl.text) == 0
                            ? 'Hãy nhập số lớn hơn hoặc bằng 1 hoặc để trống.'
                            : null,
                      ),
                      if (_totalVacCtrl.text.isNotEmpty &&
                          int.parse(_totalVacCtrl.text) > 1) ...[
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _timeNextCtrl,
                          hintText: 'Thời gian tái chủng',
                          keyBoardType: TextInputType.multiline,
                        ),
                      ],
                      const SizedBox(height: 35),
                      CustomButton(
                        text: 'Lưu',
                        width: Get.width * 0.5,
                        onTap: () async {
                          if (_vaccineFormKey.currentState!.validate() &&
                              _vaccineNameCtrl.text.isNotEmpty &&
                              _usesCtrl.text.isNotEmpty) {
                            final idV = getRandomString(20);
                            final vaccineModel = VaccineModel(
                              idV: idV,
                              imageUrl: imageVaccine,
                              vaccineName: _vaccineNameCtrl.text,
                              uses: _usesCtrl.text,
                              makeBy: _makeByCtrl.text,
                              makeIn: _makeInCtrl.text,
                              totalVac: _totalVacCtrl.text,
                              timeNext: _timeNextCtrl.text,
                              createdAt: getDayNow(DateTime.now()),
                            );
                            final docVaccine = GV.vaccineCol.doc(idV);
                            final json = vaccineModel.toMap();
                            await docVaccine.set(json);
                            Get.back();
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

  uploadImageVaccine() async {
    final imagePicker = ImagePicker();
    XFile? image;
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      await EasyLoading.show(status: 'Đang tải ảnh lên!');
      String vacName;
      _vaccineNameCtrl.text.isEmpty
          ? vacName = image.path.split('/').last
          : vacName = '${_vaccineNameCtrl.text}.${image.path.split('.').last}';
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('vaccine')
          .child('vaccine-$vacName')
          .putFile(file)
          .whenComplete(() => print('success'));
      await EasyLoading.showSuccess('Thêm ảnh thành công!');
      var link = await snapshot.ref.getDownloadURL();
      setState(() {
        imageVaccine = link;
      });
    } else {
      await EasyLoading.showError('Không tìm thấy ảnh nào!');
    }
  }
}
