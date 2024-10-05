class ProfileState {
  final String name;
  final String medicalHistory;
  final String currentMedications;
  final String allergies;
  final String bloodType;
  final bool isOrganDonor;
  final bool isBloodDonor;
  final bool notificationsEnabled;

  ProfileState({
    this.name = '',
    this.medicalHistory = '',
    this.currentMedications = '',
    this.allergies = '',
    this.bloodType = '',
    this.isOrganDonor = false,
    this.isBloodDonor = false,
    this.notificationsEnabled = true,
  });

  ProfileState copyWith({
    String? name,
    String? medicalHistory,
    String? currentMedications,
    String? allergies,
    String? bloodType,
    bool? isOrganDonor,
    bool? isBloodDonor,
    bool? notificationsEnabled,
  }) {
    return ProfileState(
      name: name ?? this.name,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      currentMedications: currentMedications ?? this.currentMedications,
      allergies: allergies ?? this.allergies,
      bloodType: bloodType ?? this.bloodType,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      isBloodDonor: isBloodDonor ?? this.isBloodDonor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
