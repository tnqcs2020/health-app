import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/user_model.dart';

class EditVacHistory extends StatefulWidget {
  const EditVacHistory({
    Key? key,
    required this.idVH,
    required this.hasPermission,
  }) : super(key: key);
  final String idVH;
  final bool hasPermission;

  @override
  State<EditVacHistory> createState() => _EditVacHistoryState();
}

class _EditVacHistoryState extends State<EditVacHistory> {
  final GlobalKey<FormState> _vacHistoryFormKey = GlobalKey<FormState>();
  final userGlobal = Get.put(UserGlobal());
  UserManager? userManager;
  Map<String, String> temp = {
    'vacName': '',
    'location': '',
    'uses': '',
    'dateOfInjection': '',
    'numOfVac': '',
  };

  getVaccineHistory(vacHistoryData) async {
    temp['vacName'] = vacHistoryData['vacName'];
    temp['location'] = vacHistoryData['location'];
    temp['uses'] = vacHistoryData['uses'];
    temp['dateOfInjection'] = vacHistoryData['dateOfInjection'];
    temp['numOfVac'] = vacHistoryData['numOfVac'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.hasPermission
              ? const Text(
                  'Cập nhật lịch sử tiêm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : const Text(
                  'Thông tin lịch sử tiêm',
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
                stream: GV.vacHistoryCol.doc(widget.idVH).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final vacHistoryData = snapshot.data!;
                    getVaccineHistory(vacHistoryData);
                    for (int i = 0; i < userGlobal.userManager.length; i++) {
                      if (vacHistoryData['idU'] ==
                          userGlobal.userManager[i].idU) {
                        userManager = userGlobal.userManager[i];
                      }
                    }
                    return Form(
                      key: _vacHistoryFormKey,
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
                            initialValue: vacHistoryData['location'],
                            hintText: 'Cơ sở tiêm',
                            onChanged: (input) => temp['location'] = input!,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Cần phải nhập cơ sở tiêm.',
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            hintText: 'Tên vắc-xin',
                            initialValue: vacHistoryData['vacName'],
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Cần phải nhập tên vắc-xin.',
                            onChanged: (input) => temp['vacName'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            hintText: 'Phòng bệnh',
                            initialValue: vacHistoryData['uses'],
                            onChanged: (input) => temp['uses'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            initialValue: vacHistoryData['dateOfInjection'],
                            hintText: 'Ngày tiêm',
                            keyBoardType: TextInputType.datetime,
                            onChanged: (input) =>
                                temp['dateOfInjection'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            initialValue: vacHistoryData['numOfVac'],
                            hintText: 'Mũi tiêm thứ',
                            onChanged: (input) => temp['numOfVac'] = input!,
                            keyBoardType: TextInputType.number,
                            validator: (val) =>
                                val!.isNotEmpty && int.parse(val) < 1
                                    ? 'Hãy nhập số lớn hơn hoặc bằng 1.'
                                    : null,
                            enabled: widget.hasPermission,
                          ),
                          const SizedBox(height: 100),
                          if (widget.hasPermission)
                            CustomButton(
                                text: 'Lưu',
                                width: Get.width * 0.5,
                                onTap: () async {
                                  if (_vacHistoryFormKey.currentState!
                                      .validate()) {
                                    GV.vacHistoryCol.doc(widget.idVH).update({
                                      if (temp['vacName'] !=
                                          vacHistoryData['vacName'])
                                        'vacName': temp['vacName'],
                                      if (temp['uses'] !=
                                          vacHistoryData['uses'])
                                        'uses': temp['uses'],
                                      if (temp['dateOfInjection'] !=
                                          vacHistoryData['dateOfInjection'])
                                        'dateOfInjection':
                                            temp['dateOfInjection'],
                                      if (temp['numOfVac'] !=
                                          vacHistoryData['numOfVac'])
                                        'numOfVac': temp['numOfVac'],
                                      if (temp['location'] !=
                                          vacHistoryData['location'])
                                        'location': temp['location'],
                                    });
                                    if (temp['vacName'] !=
                                            vacHistoryData['vacName'] ||
                                        temp['dateOfInjection'] !=
                                            vacHistoryData['dateOfInjection'] ||
                                        temp['numOfVac'] !=
                                            vacHistoryData['numOfVac'] ||
                                        temp['location'] !=
                                            vacHistoryData['location'] ||
                                        temp['uses'] !=
                                            vacHistoryData['uses']) {
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
