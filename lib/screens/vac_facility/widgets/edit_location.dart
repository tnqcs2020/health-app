import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';

class EditLocation extends StatefulWidget {
  const EditLocation({
    Key? key,
    required this.idL,
    required this.hasPermission,
  }) : super(key: key);
  final String idL;
  final bool hasPermission;

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  final GlobalKey<FormState> _locationFormKey = GlobalKey<FormState>();
  final userGlobal = Get.put(UserGlobal());
  Map<String, String> temp = {
    'facilityName': '',
    'companyManager': '',
    'address': '',
    // 'dateOfInjection': '',
    // 'numOfVac': '',
  };

  getLocation(vacHistoryData) {
    temp['facilityName'] = vacHistoryData['facilityName'];
    temp['companyManager'] = vacHistoryData['companyManager'];
    temp['address'] = vacHistoryData['address'];
    // temp['dateOfInjection'] = vacHistoryData['dateOfInjection'];
    // temp['numOfVac'] = vacHistoryData['numOfVac'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.hasPermission
              ? const Text(
                  'Cập nhật cơ sở tiêm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : const Text(
                  'Thông tin cơ sở tiêm',
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
                stream: GV.locationCol.doc(widget.idL).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final vacHistoryData = snapshot.data!;
                    getLocation(vacHistoryData);
                    return Form(
                      key: _locationFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Tên cơ sở tiêm',
                            initialValue: vacHistoryData['facilityName'],
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Cần phải nhập tên cơ sở tiêm.',
                            onChanged: (input) => temp['facilityName'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            initialValue: vacHistoryData['companyManager'],
                            hintText: 'Đơn vị quản lý',
                            onChanged: (input) =>
                                temp['companyManager'] = input!,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Cần phải nhập đơn vị quản lý.',
                            enabled: widget.hasPermission,
                          ),
                          CustomTextField(
                            hintText: 'Địa chỉ',
                            initialValue: vacHistoryData['address'],
                            onChanged: (input) => temp['address'] = input!,
                            enabled: widget.hasPermission,
                          ),
                          // SizedBox(
                          //   height: 65,
                          //   child: CustomTextField(
                          //     initialValue: vacHistoryData['dateOfInjection'],
                          //     hintText: 'Ngày tiêm',
                          //     keyBoardType: TextInputType.datetime,
                          //     onChanged: (input) =>
                          //         temp['dateOfInjection'] = input!,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 65,
                          //   child: CustomTextField(
                          //     initialValue: vacHistoryData['numOfVac'],
                          //     hintText: 'Mũi tiêm thứ',
                          //     onChanged: (input) => temp['numOfVac'] = input!,
                          //     keyBoardType: TextInputType.number,
                          //     validator: (val) =>
                          //         val!.isNotEmpty && int.parse(val) < 1
                          //             ? 'Hãy nhập số lớn hơn hoặc bằng 1.'
                          //             : null,
                          //   ),
                          // ),
                          const SizedBox(height: 100),
                          if (widget.hasPermission)
                            CustomButton(
                                text: 'Lưu',
                                width: Get.width * 0.5,
                                onTap: () async {
                                  if (_locationFormKey.currentState!
                                      .validate()) {
                                    GV.locationCol.doc(widget.idL).update({
                                      if (temp['facilityName'] !=
                                          vacHistoryData['facilityName'])
                                        'facilityName': temp['facilityName'],
                                      if (temp['companyManager'] !=
                                          vacHistoryData['companyManager'])
                                        'companyManager':
                                            temp['companyManager'],
                                      if (temp['address'] !=
                                          vacHistoryData['address'])
                                        'address': temp['address'],
                                      // if (temp['dateOfInjection'] !=
                                      //     vacHistoryData['dateOfInjection'])
                                      //   'dateOfInjection': temp['dateOfInjection'],
                                      // if (temp['numOfVac'] !=
                                      //     vacHistoryData['numOfVac'])
                                      //   'numOfVac': temp['numOfVac'],
                                    });
                                    if (temp['facilityName'] !=
                                                vacHistoryData[
                                                    'facilityName'] ||
                                            temp['companyManager'] !=
                                                vacHistoryData[
                                                    'companyManager'] ||
                                            temp['address'] !=
                                                vacHistoryData['address']
                                        //|| temp['dateOfInjection'] !=
                                        //     vacHistoryData['dateOfInjection'] ||
                                        // temp['numOfVac'] !=
                                        //     vacHistoryData['numOfVac']
                                        ) {
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
