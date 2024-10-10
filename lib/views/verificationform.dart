import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images/documents
import 'dart:io'; // For handling file uploads
import '../services/verification_service.dart'; // Firebase service for verification

class VerificationForm extends StatefulWidget {
  const VerificationForm({super.key});

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final _formKey = GlobalKey<FormState>();

  File? _idDocument;
  File? _medicalCertificate;
  final picker = ImagePicker();

  bool _isSubmitting = false;

  // Pick an image for ID document
  Future<void> _pickIdDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idDocument = File(pickedFile.path);
      });
    }
  }

  // Pick an image for Medical Certificate
  Future<void> _pickMedicalCertificate() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _medicalCertificate = File(pickedFile.path);
      });
    }
  }

  // Submit the verification documents
  Future<void> _submitVerification() async {
    if (_formKey.currentState!.validate()) {
      if (_idDocument == null || _medicalCertificate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload both documents.')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      // Call the service to handle document upload and verification
      try {
        await VerificationService().submitVerification(
          idDocument: _idDocument!,
          medicalCertificate: _medicalCertificate!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documents submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting documents: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor/Recipient Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Upload ID Document'),
              const SizedBox(height: 10),
              _idDocument == null
                  ? const Text('No document selected.')
                  : Image.file(_idDocument!, height: 100),
              ElevatedButton(
                onPressed: _pickIdDocument,
                child: const Text('Select ID Document'),
              ),
              const SizedBox(height: 20),
              const Text('Upload Medical Certificate'),
              const SizedBox(height: 10),
              _medicalCertificate == null
                  ? const Text('No document selected.')
                  : Image.file(_medicalCertificate!, height: 100),
              ElevatedButton(
                onPressed: _pickMedicalCertificate,
                child: const Text('Select Medical Certificate'),
              ),
              const SizedBox(height: 30),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitVerification,
                      child: const Text('Submit Verification'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
