import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/health_record_model.dart';
import 'package:stronglier/common/function.dart';

class AddHealthRecord extends StatefulWidget {
  const AddHealthRecord({Key? key}) : super(key: key);

  @override
  State<AddHealthRecord> createState() => _AddHealthRecordState();
}

class _AddHealthRecordState extends State<AddHealthRecord> {
  final GlobalKey<FormState> _healthRecordFormKey = GlobalKey();
  final TextEditingController _hospitalNameCtrl = TextEditingController();
  final TextEditingController _sickNameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _drugCtrl = TextEditingController();
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thêm hồ sơ',
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
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            constraints: BoxConstraints(minHeight: Get.bottomBarHeight),
            padding: const EdgeInsets.only(top: 25),
            child: Form(
              key: _healthRecordFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Khám tại',
                    controller: _hospitalNameCtrl,
                    validator: (val) => val!.isNotEmpty
                        ? null
                        : 'Cần phải nhập bệnh viện bạn khám.',
                  ),
                  CustomTextField(
                    controller: _dateCtrl,
                    hintText: 'Ngày khám',
                    keyBoardType: TextInputType.datetime,
                    validator: (val) => val!.isNotEmpty
                        ? null
                        : 'Ngày khám cũng rất quan trọng nhé.',
                  ),
                  CustomTextField(
                    controller: _sickNameCtrl,
                    hintText: 'Chuẩn bệnh',
                    validator: (val) => val!.isNotEmpty
                        ? null
                        : 'Hãy nhập chuẩn đoán của bác sĩ :(',
                  ),
                  CustomTextField(
                    controller: _drugCtrl,
                    hintText: 'Kê đơn thuốc',
                    keyBoardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 120),
                  CustomButton(
                    text: 'Lưu',
                    width: Get.width * 0.5,
                    onTap: () async {
                      if (_healthRecordFormKey.currentState!.validate()) {
                        final idHR = getRandomString(20);
                        final healthRecordModel = HealthRecordModel(
                          idHR: idHR,
                          idU: uid,
                          hospitalName: _hospitalNameCtrl.text,
                          sickName: _sickNameCtrl.text,
                          date: _dateCtrl.text,
                          drug: _drugCtrl.text,
                          createdAt: getDayNow(DateTime.now()),
                        );
                        final docHealthRecord = GV.healthRecordCol.doc(idHR);
                        final json = healthRecordModel.toMap();
                        await docHealthRecord.set(json);
                        Get.back();
                      }
                    },
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
