import 'package:get/get.dart';
import 'package:stronglier/models/user_model.dart';

class UserGlobal extends GetxController {
  RxString uid = ''.obs;
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString avatar = ''.obs;
  RxString type = 'user'.obs;
  RxList<UserManager> userManager = <UserManager>[].obs;

  setUser({
    RxString? idGlobal,
    RxString? nameGlobal,
    RxString? emailGlobal,
    RxString? typeGlobal,
    RxString? avatarGlobal,
  }) {
    uid = idGlobal ?? ''.obs;
    name = nameGlobal ?? ''.obs;
    email = emailGlobal ?? ''.obs;
    avatar = avatarGlobal ?? ''.obs;
    type = typeGlobal ?? ''.obs;
  }
}
