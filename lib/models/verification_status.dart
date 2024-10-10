import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationStatus {
  final String userId;
  final String idDocumentUrl;
  final String medicalCertificateUrl;
  final String status; // "pending", "verified", "rejected"
  final DateTime submittedAt;

  VerificationStatus({
    required this.userId,
    required this.idDocumentUrl,
    required this.medicalCertificateUrl,
    required this.status,
    required this.submittedAt,
  });

  // Factory constructor to create an instance from Firestore data
  factory VerificationStatus.fromMap(Map<String, dynamic> map) {
    return VerificationStatus(
      userId: map['userId'] ?? '',
      idDocumentUrl: map['idDocumentUrl'] ?? '',
      medicalCertificateUrl: map['medicalCertificateUrl'] ?? '',
      status: map['status'] ?? 'pending', // Default to pending
      submittedAt: (map['submittedAt'] as Timestamp).toDate(),
    );
  }

  // Convert instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'idDocumentUrl': idDocumentUrl,
      'medicalCertificateUrl': medicalCertificateUrl,
      'status': status,
      'submittedAt': submittedAt,
    };
  }
}
