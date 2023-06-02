import 'dart:convert';

class VaccineHistoryModel {
  String? idVH;
  String? idU;
  // String? idVC;
  String? vacName;
  String? numOfVac;
  String? dateOfInjection;
  String? location;
  String? uses;
  String? createdAt;

  VaccineHistoryModel({
    this.idVH,
    this.idU,
    // this.idVC,
    this.vacName,
    this.dateOfInjection,
    this.location,
    this.numOfVac,
    this.uses,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idVH': idVH,
      'idU': idU,
      // 'idVC': idVC,
      'vacName': vacName,
      'numOfVac': numOfVac,
      'dateOfInjection': dateOfInjection,
      'location': location,
      'uses': uses,
      'createdAt': createdAt,
    };
  }

  factory VaccineHistoryModel.fromMap(Map<String, dynamic> map) {
    return VaccineHistoryModel(
      idVH: map['idVH'] ?? '',
      idU: map['idU'] ?? '',
      // idVC: map['idVC'] ?? '',
      vacName: map['vacName'] ?? '',
      numOfVac: map['numOfVac'] ?? '',
      dateOfInjection: map['dateOfInjection'] ?? '',
      location: map['location'] ?? '',
      uses: map['uses'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VaccineHistoryModel.fromJson(String source) =>
      VaccineHistoryModel.fromMap(json.decode(source));

  VaccineHistoryModel copyWith({
    String? idVH,
    String? idU,
    // String? idVC,
    String? vacName,
    String? numOfVac,
    String? location,
    String? dateOfInjection,
    String? uses,
    String? createdAt,
  }) {
    return VaccineHistoryModel(
      idVH: idVH ?? this.idVH,
      idU: idU ?? this.idU,
      // idVC: idVC ?? this.idVC,
      vacName: vacName ?? this.vacName,
      numOfVac: numOfVac ?? this.numOfVac,
      dateOfInjection: dateOfInjection ?? this.dateOfInjection,
      location: location ?? this.location,
      uses: uses ?? this.uses,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
