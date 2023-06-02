import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/models/location_model.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final GlobalKey<FormState> _locationFormKey = GlobalKey();
  final TextEditingController _facilityNameCtrl = TextEditingController();
  final TextEditingController _companyManagerCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thêm cơ sở',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
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
              key: _locationFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _facilityNameCtrl,
                    hintText: 'Tên cơ sở',
                  ),
                  CustomTextField(
                    controller: _companyManagerCtrl,
                    hintText: 'Đơn vị quản lý',
                  ),
                  CustomTextField(
                    controller: _addressCtrl,
                    hintText: 'Địa chỉ',
                  ),
                  const SizedBox(height: 120),
                  CustomButton(
                    text: 'Lưu',
                    width: Get.width * 0.5,
                    onTap: () async {
                      if (_locationFormKey.currentState!.validate()) {
                        final idL = getRandomString(20);
                        final locationModel = LocationModel(
                          idL: idL,
                          facilityName: _facilityNameCtrl.text,
                          companyManager: _companyManagerCtrl.text,
                          address: _addressCtrl.text,
                        );
                        final docLocation = GV.locationCol.doc(idL);
                        final json = locationModel.toMap();
                        await docLocation.set(json);
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
