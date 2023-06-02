import 'dart:convert';

class HealthRecordModel {
  String? idHR;
  String? idU;
  String? sickName;
  String? date;
  String? drug;
  String? hospitalName;
  String? createdAt;

  HealthRecordModel({
    this.idHR,
    this.idU,
    this.sickName,
    this.drug,
    this.date,
    this.hospitalName,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idHR': idHR,
      'idU': idU,
      'sickName': sickName,
      'drug': drug,
      'date': date,
      'hospitalName': hospitalName,
      'createdAt': createdAt,
    };
  }

  factory HealthRecordModel.fromMap(Map<String, dynamic> map) {
    return HealthRecordModel(
      idHR: map['idHR'] ?? '',
      idU: map['idU'] ?? '',
      sickName: map['sickName'] ?? '',
      drug: map['drug'] ?? '',
      date: map['date'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthRecordModel.fromJson(String source) =>
      HealthRecordModel.fromMap(json.decode(source));

  HealthRecordModel copyWith({
    String? idHR,
    String? idU,
    String? sickName,
    String? drug,
    String? date,
    String? hospitalName,
    String? createdAt,
  }) {
    return HealthRecordModel(
      idHR: idHR ?? this.idHR,
      idU: idU ?? this.idU,
      sickName: sickName ?? this.sickName,
      drug: drug ?? this.drug,
      date: date ?? this.date,
      hospitalName: hospitalName ?? this.hospitalName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// class SickModel {
//   String? idS;
//   String? idHR;
//   String? nameSick;
//   String? timeAbout;
//   String? drugUsed;
//   String? createdAt;
//   SickModel({
//     this.idS,
//     this.idHR,
//     this.nameSick,
//     this.timeAbout,
//     this.drugUsed,
//     this.createdAt,
//   });

//   SickModel copyWith({
//     String? idS,
//     String? idHR,
//     String? nameSick,
//     String? timeAbout,
//     String? drugUsed,
//     String? createdAt,
//   }) {
//     return SickModel(
//       idS: idS ?? this.idS,
//       idHR: idHR ?? this.idHR,
//       nameSick: nameSick ?? this.nameSick,
//       timeAbout: timeAbout ?? this.timeAbout,
//       drugUsed: drugUsed ?? this.drugUsed,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'idS': idS,
//       'idHR': idHR,
//       'nameSick': nameSick,
//       'timeAbout': timeAbout,
//       'drugUsed': drugUsed,
//       'createdAt': createdAt,
//     };
//   }

//   factory SickModel.fromMap(Map<String, dynamic> map) {
//     return SickModel(
//       idS: map['idS'] != null ? map['idS'] as String : null,
//       idHR: map['idHR'] != null ? map['idHR'] as String : null,
//       nameSick: map['nameSick'] != null ? map['nameSick'] as String : null,
//       timeAbout: map['timeAbout'] != null ? map['timeAbout'] as String : null,
//       drugUsed: map['drugUsed'] != null ? map['drugUsed'] as String : null,
//       createdAt: map['createdAt'] != null ? map['createdAt'] as String :null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory SickModel.fromJson(String source) =>
//       SickModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
