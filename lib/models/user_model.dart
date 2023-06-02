// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? idU,
      name,
      email,
      phone,
      password,
      gender,
      birthday,
      avatar,
      allergy,
      abstain,
      parentId,
      type;

  UserModel({
    required this.idU,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.birthday = '',
    this.gender = '',
    this.avatar = '',
    this.allergy = '',
    this.abstain = '',
    this.parentId = '',
    this.type = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'idU': idU,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'birthday': birthday,
      'avatar': avatar,
      'allergy': allergy,
      'abstain': abstain,
      'parentId': parentId,
      'type': type,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idU: map['idU'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      birthday: map['birthday'] ?? '',
      gender: map['gender'] ?? '',
      avatar: map['avatar'] ?? '',
      allergy: map['allergy'] ?? '',
      abstain: map['abstain'] ?? '',
      parentId: map['parentId'] ?? '',
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? idU,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? birthday,
    String? gender,
    String? avatar,
    String? allergy,
    String? abstain,
    String? parentId,
    String? type,
  }) {
    return UserModel(
      idU: idU ?? this.idU,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      allergy: allergy ?? this.allergy,
      abstain: abstain ?? this.abstain,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
    );
  }
}

class UserManager {
  String idU, name, relationship, avatar;
  UserManager({
    required this.idU,
    required this.name,
    required this.relationship,
    required this.avatar,
  });
  Map<String, dynamic> toMap() {
    return {
      'idU': idU,
      'name': name,
      'relationship': relationship,
      'avatar': avatar
    };
  }

  factory UserManager.fromMap(Map<String, dynamic> map) {
    return UserManager(
      idU: map['idU'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserManager.fromJson(String source) =>
      UserManager.fromMap(json.decode(source));
}
