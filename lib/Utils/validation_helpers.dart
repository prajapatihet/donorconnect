class ValidationHelpers {
  // Validate if a file is uploaded
  static String? validateFileUpload(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return 'Please upload the required document.';
    }
    return null;
  }

  // Validate if the ID document meets criteria (e.g., file extension)
  static String? validateIDDocument(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return 'Please upload your ID document.';
    }
    if (!_isValidFileFormat(filePath, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'])) {
      return 'Invalid file format. Allowed formats: jpg, jpeg, png, pdf.';
    }
    return null;
  }

  // Validate if the medical certificate meets criteria (e.g., file extension)
  static String? validateMedicalCertificate(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return 'Please upload your medical certificate.';
    }
    if (!_isValidFileFormat(filePath, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'])) {
      return 'Invalid file format. Allowed formats: jpg, jpeg, png, pdf.';
    }
    return null;
  }

  // Check if the file has an allowed extension
  static bool _isValidFileFormat(String filePath, {required List<String> allowedExtensions}) {
    String fileExtension = filePath.split('.').last.toLowerCase();
    return allowedExtensions.contains(fileExtension);
  }

  // Optional: Validate other fields like name or phone number for recipient/donor
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required.';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters long.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required.';
    }
    if (!_isValidPhoneNumber(phoneNumber)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static bool _isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}
