import 'package:flutter/material.dart';
import 'package:stronglier/models/validation_model.dart';
import 'package:stronglier/common/regex_textformfield.dart';

class FormProvider extends ChangeNotifier {
  ValidationModel _email = ValidationModel(null, null);
  ValidationModel _pwd = ValidationModel(null, null);
  ValidationModel _phone = ValidationModel(null, null);
  ValidationModel _name = ValidationModel(null, null);
  ValidationModel _rePwd = ValidationModel(null, null);
  ValidationModel get email => _email;
  ValidationModel get password => _pwd;
  ValidationModel get rePassword => _rePwd;
  ValidationModel get phone => _phone;
  ValidationModel get name => _name;

  void validateEmail(String? val) {
    if (val != null && val.isValidEmail) {
      _email = ValidationModel(val, null);
    } else {
      _email = ValidationModel(null, 'Hãy nhập chính xác email.');
    }
    notifyListeners();
  }

  void validatePassword(String? val) {
    if (val != null && val.isValidPassword) {
      _pwd = ValidationModel(val, null);
    } else {
      _pwd = ValidationModel(null,
          'Mật khẩu phải có ít nhất 8 ký tự bao gồm chữ hoa, chữ thường và số.');
    }
    notifyListeners();
  }

  void validateRePassword(String? val) {
    if (val != null && val.isValidPassword && val == _pwd.value) {
      _rePwd = ValidationModel(val, null);
    } else {
      _rePwd = ValidationModel(null, 'Mật khẩu xác nhận không trùng khớp.');
    }
    notifyListeners();
  }

  void validateName(String? val) {
    if (val != null && val.isValidName) {
      _name = ValidationModel(val, null);
    } else {
      _name = ValidationModel(null, 'Hãy nhập họ và tên của bạn.');
    }
    notifyListeners();
  }

  void validatePhone(String? val) {
    if (val != null && val.isValidPhone) {
      _phone = ValidationModel(val, null);
    } else {
      _phone = ValidationModel(
          null, 'Số điện thoại chỉ gồm 10 số và bắt đầu bằng 0.');
    }
    notifyListeners();
  }

  bool get validateSignIn {
    return _pwd.value != null && _email.value != null;
  }

  bool get validateSignUp {
    return _pwd.value != null &&
        _phone.value != null &&
        _name.value != null &&
        _email.value != null;
  }
}
