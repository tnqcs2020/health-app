import 'dart:convert';

class VaccineModel {
  String? idV;
  String? imageUrl;
  String? vaccineName;
  String? uses;
  String? makeBy;
  String? makeIn;
  String? timeNext;
  String? totalVac;
  String? createdAt;

  VaccineModel({
    this.idV,
    this.imageUrl,
    this.vaccineName,
    this.uses,
    this.makeBy,
    this.makeIn,
    this.timeNext,
    this.totalVac,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idV': idV,
      'imageUrl': imageUrl,
      'vaccineName': vaccineName,
      'uses': uses,
      'makeBy': makeBy,
      'makeIn': makeIn,
      'timeNext': timeNext,
      'totalVac': totalVac,
      'createdAt': createdAt,
    };
  }

  factory VaccineModel.fromMap(Map<String, dynamic> map) {
    return VaccineModel(
      idV: map['idV'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      vaccineName: map['vaccineName'] ?? '',
      uses: map['uses'] ?? '',
      makeBy: map['makeBy'] ?? '',
      makeIn: map['makeIn'] ?? '',
      timeNext: map['timeNext'] ?? '',
      totalVac: map['totalVac'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VaccineModel.fromJson(String source) =>
      VaccineModel.fromMap(json.decode(source));

  VaccineModel copyWith({
    String? idV,
    String? imageUrl,
    String? vaccineName,
    String? uses,
    String? makeBy,
    String? makeIn,
    String? timeNext,
    String? totalVac,
    String? createdAt,
  }) {
    return VaccineModel(
      idV: idV ?? this.idV,
      imageUrl: imageUrl ?? this.imageUrl,
      vaccineName: vaccineName ?? this.vaccineName,
      uses: uses ?? this.uses,
      makeBy: makeBy ?? this.makeBy,
      makeIn: makeIn ?? this.makeIn,
      timeNext: timeNext ?? this.timeNext,
      totalVac: totalVac ?? this.totalVac,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
