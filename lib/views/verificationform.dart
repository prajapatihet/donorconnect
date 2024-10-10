import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images/documents
import 'dart:io'; // For handling file uploads
import '../services/verification_service.dart'; // Firebase service for verification

class VerificationForm extends StatefulWidget {
  @override
  _VerificationFormState createState() => _VerificationFormState();
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
          SnackBar(content: Text('Please upload both documents.')),
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
          SnackBar(content: Text('Documents submitted successfully!')),
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
        title: Text('Donor/Recipient Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Upload ID Document'),
              SizedBox(height: 10),
              _idDocument == null
                  ? Text('No document selected.')
                  : Image.file(_idDocument!, height: 100),
              ElevatedButton(
                onPressed: _pickIdDocument,
                child: Text('Select ID Document'),
              ),
              SizedBox(height: 20),
              Text('Upload Medical Certificate'),
              SizedBox(height: 10),
              _medicalCertificate == null
                  ? Text('No document selected.')
                  : Image.file(_medicalCertificate!, height: 100),
              ElevatedButton(
                onPressed: _pickMedicalCertificate,
                child: Text('Select Medical Certificate'),
              ),
              SizedBox(height: 30),
              _isSubmitting
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitVerification,
                      child: Text('Submit Verification'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
