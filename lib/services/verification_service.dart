import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload the documents to Firebase Storage and update the Firestore with verification status
  Future<void> submitVerification({
    required File idDocument,
    required File medicalCertificate,
  }) async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found.');
      }

      // Create a unique path for each document
      String userId = user.uid;
      String idDocumentPath = 'verifications/$userId/id_document.jpg';
      String medicalCertificatePath = 'verifications/$userId/medical_certificate.jpg';

      // Upload the ID document
      await _uploadFile(idDocument, idDocumentPath);

      // Upload the medical certificate
      await _uploadFile(medicalCertificate, medicalCertificatePath);

      // Save verification details to Firestore
      await _firestore.collection('verifications').doc(userId).set({
        'userId': userId,
        'idDocumentUrl': await _getDownloadUrl(idDocumentPath),
        'medicalCertificateUrl': await _getDownloadUrl(medicalCertificatePath),
        'status': 'pending', // Verification starts as pending
        'submittedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error submitting verification: $e');
    }
  }

  // Helper method to upload a file to Firebase Storage
  Future<void> _uploadFile(File file, String filePath) async {
    try {
      await _storage.ref(filePath).putFile(file);
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  // Get the download URL of an uploaded file
  Future<String> _getDownloadUrl(String filePath) async {
    try {
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error fetching file URL: $e');
    }
  }
}
