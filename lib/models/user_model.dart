import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isOrganDonor;
  final bool isBloodDonor;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.isOrganDonor,
    required this.isBloodDonor,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    bool? isOrganDonor,
    bool? isBloodDonor,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      isBloodDonor: isBloodDonor ?? this.isBloodDonor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'isOrganDonor': isOrganDonor,
      'isBloodDonor': isBloodDonor,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isOrganDonor: map['isOrganDonor'] ?? false,
      isBloodDonor: map['isBloodDonor'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, isOrganDonor: $isOrganDonor, isBloodDonor: $isBloodDonor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.uid == uid &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.isOrganDonor == isOrganDonor &&
      other.isBloodDonor == isBloodDonor;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      isOrganDonor.hashCode ^
      isBloodDonor.hashCode;
  }
}
