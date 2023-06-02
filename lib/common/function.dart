import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String getDayNow(DateTime now) {
  final DateTime now = DateTime.now();
  final DateFormat format = DateFormat('dd-MM-yyyy');
  final String formattedDate = format.format(now);
  return formattedDate;
}

Future deleteData({required String collection, required String doc}) async {
  await FirebaseFirestore.instance.collection(collection).doc(doc).delete();
}

String normalizeVie(String str) {
  var from =
          "àáãảạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệđùúủũụưừứửữựòóỏõọôồốổỗộơờớởỡợìíỉĩịäëïîöüûñçýỳỹỵỷ",
      to =
          "aaaaaaaaaaaaaaaaaeeeeeeeeeeeduuuuuuuuuuuoooooooooooooooooiiiiiaeiiouuncyyyyy";
  for (var i = 0, l = from.length; i < l; i++) {
    str = str.replaceAll(RegExp(from[i]), to[i]);
  }
  return str;
}
