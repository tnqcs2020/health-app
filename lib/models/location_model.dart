import 'dart:convert';

class LocationModel {
  String? idL;
  String? facilityName;
  String? companyManager;
  String? address;
  // String? uses;
  // String? expiryDate;
  // String? totalVac;
  // String? createdAt;

  LocationModel({
    this.idL,
    this.facilityName,
    this.companyManager,
    this.address,
    // this.uses,
    // this.expiryDate,
    // this.totalVac,
    // this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idL': idL,
      'facilityName': facilityName,
      'companyManager': companyManager,
      'address': address,
      // 'uses': uses,
      // 'expiryDate': expiryDate,
      // 'totalVac': totalVac,
      // 'createdAt': createdAt,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      idL: map['idL'] ?? '',
      facilityName: map['facilityName'] ?? '',
      companyManager: map['companyManager'] ?? '',
      address: map['address'] ?? '',
      // uses: map['uses'] ?? '',
      // expiryDate: map['expiryDate'] ?? '',
      // totalVac: map['totalVac'] ?? '',
      // createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  LocationModel copyWith({
    String? idL,
    String? facilityName,
    String? companyManager,
    String? address,
    // String? uses,
    // String? expiryDate,
    // String? totalVac,
    // String? createdAt,
  }) {
    return LocationModel(
      idL: idL ?? this.idL,
      facilityName: facilityName ?? this.facilityName,
      companyManager: companyManager ?? this.companyManager,
      address: address ?? this.address,
      // uses: uses ?? this.uses,
      // expiryDate: expiryDate ?? this.expiryDate,
      // totalVac: totalVac ?? this.totalVac,
      // createdAt: createdAt ?? this.createdAt,
    );
  }
}
