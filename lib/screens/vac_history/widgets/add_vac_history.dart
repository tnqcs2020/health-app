import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/models/vaccine_history_model.dart';

class AddVaccineHistory extends StatefulWidget {
  const AddVaccineHistory({Key? key}) : super(key: key);

  @override
  State<AddVaccineHistory> createState() => _AddVaccineHistoryState();
}

class _AddVaccineHistoryState extends State<AddVaccineHistory> {
  final GlobalKey<FormState> _vaccineHistoryFormKey = GlobalKey();
  final TextEditingController _vaccineNameCtrl = TextEditingController();
  final TextEditingController _usesCtrl = TextEditingController();
  final TextEditingController _dateOfInjectionCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _numOfVacCtrl = TextEditingController();
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thêm lịch sử tiêm',
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
              key: _vaccineHistoryFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _vaccineNameCtrl,
                    hintText: 'Tên loại vắc-xin',
                  ),
                  CustomTextField(
                    controller: _usesCtrl,
                    hintText: 'Phòng ngừa bệnh',
                  ),
                  CustomTextField(
                    controller: _dateOfInjectionCtrl,
                    hintText: 'Ngày tiêm',
                    keyBoardType: TextInputType.datetime,
                  ),
                  CustomTextField(
                    controller: _locationCtrl,
                    hintText: 'Nơi tiêm',
                  ),
                  CustomTextField(
                      controller: _numOfVacCtrl,
                      hintText: 'Mũi tiêm thứ',
                      keyBoardType: TextInputType.number),
                  const SizedBox(height: 75),
                  CustomButton(
                    text: 'Lưu',
                    width: Get.width * 0.5,
                    onTap: () async {
                      if (_vaccineHistoryFormKey.currentState!.validate()) {
                        final idVH = getRandomString(20);
                        final vaccineHistoryModel = VaccineHistoryModel(
                          idVH: idVH,
                          idU: uid,
                          vacName: _vaccineNameCtrl.text,
                          dateOfInjection: _dateOfInjectionCtrl.text,
                          location: _locationCtrl.text,
                          numOfVac: _numOfVacCtrl.text,
                          uses: _usesCtrl.text,
                          createdAt: getDayNow(DateTime.now()),
                        );
                        final docVaccineHistory = GV.vacHistoryCol.doc(idVH);
                        final json = vaccineHistoryModel.toMap();
                        await docVaccineHistory.set(json);
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
