import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/user_model.dart';

class EditHealthRecord extends StatefulWidget {
  const EditHealthRecord({
    Key? key,
    required this.idHR,
    required this.hasPermission,
  }) : super(key: key);
  final String idHR;
  final bool hasPermission;

  @override
  State<EditHealthRecord> createState() => _EditHealthRecordState();
}

class _EditHealthRecordState extends State<EditHealthRecord> {
  final GlobalKey<FormState> _healthRecordFormKey = GlobalKey<FormState>();
  final userGlobal = Get.put(UserGlobal());
  UserManager? userManager;
  Map<String, String> temp = {
    'hospitalName': '',
    'date': '',
    'sickName': '',
    'drug': '',
  };

  getVaccineHistory(healthRecord) {
    temp['hospitalName'] = healthRecord['hospitalName'];
    temp['date'] = healthRecord['date'];
    temp['sickName'] = healthRecord['sickName'];
    temp['drug'] = healthRecord['drug'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.hasPermission
              ? const Text(
                  'Cập nhật hồ sơ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : const Text(
                  'Thông tin hồ sơ',
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
            child: StreamBuilder(
                stream: GV.healthRecordCol.doc(widget.idHR).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final healthRecord = snapshot.data!;
                    getVaccineHistory(healthRecord);
                    for (int i = 0; i < userGlobal.userManager.length; i++) {
                      if (healthRecord['idU'] ==
                          userGlobal.userManager[i].idU) {
                        userManager = userGlobal.userManager[i];
                      }
                    }
                    return Form(
                      key: _healthRecordFormKey,
                      child: Column(
                        children: [
                          if (!widget.hasPermission)
                            Container(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Hồ sơ của ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red)),
                                  Text(userManager!.name,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red)),
                                  const Text(' - ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red)),
                                  Text(userManager!.relationship,
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
                          if (!widget.hasPermission)
                            Container(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                              child: const Divider(
                                color: Colors.red,
                                thickness: 1,
                              ),
                            ),
                          CustomTextField(
                            hintText: 'Khám tại',
                            initialValue: healthRecord['hospitalName'],
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Cần phải bệnh viện bạn khám.',
                            onChanged: (input) => temp['hospitalName'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            initialValue: healthRecord['date'],
                            hintText: 'Ngày khám',
                            onChanged: (input) => temp['date'] = input!,
                            keyBoardType: TextInputType.datetime,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Ngày khám cũng rất quan trọng nhé.',
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            hintText: 'Chuẩn bệnh',
                            initialValue: healthRecord['sickName'],
                            onChanged: (input) => temp['sickName'] = input!,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Hãy nhập chuẩn đoán của bác sĩ :(',
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            initialValue: healthRecord['drug'],
                            hintText: 'Kê đơn thuốc',
                            onChanged: (input) => temp['drug'] = input!,
                            enabled: widget.hasPermission,
                            keyBoardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 100),
                          if (widget.hasPermission)
                            CustomButton(
                                text: 'Lưu',
                                width: Get.width * 0.5,
                                onTap: () async {
                                  if (_healthRecordFormKey.currentState!
                                      .validate()) {
                                    GV.healthRecordCol.doc(widget.idHR).update({
                                      if (temp['hospitalName'] !=
                                          healthRecord['hospitalName'])
                                        'hospitalName': temp['hospitalName'],
                                      if (temp['sickName'] !=
                                          healthRecord['sickName'])
                                        'sickName': temp['sickName'],
                                      if (temp['drug'] != healthRecord['drug'])
                                        'drug': temp['drug'],
                                      if (temp['date'] != healthRecord['date'])
                                        'date': temp['date'],
                                    });
                                    if (temp['hospitalName'] !=
                                            healthRecord['hospitalName'] ||
                                        temp['drug'] != healthRecord['drug'] ||
                                        temp['date'] != healthRecord['date'] ||
                                        temp['sickName'] !=
                                            healthRecord['sickName']) {
                                      await EasyLoading.showSuccess(
                                          'Cập nhật thành công!');
                                    } else {
                                      await EasyLoading.showInfo(
                                          'Không có thông tin thay đổi!');
                                    }
                                  }
                                }),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
