// profile_state.dart
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String medicalHistory;
  final String currentMedications;
  final String allergies;
  final String bloodType;
  final bool isOrganDonor;
  final bool isBloodDonor;
  final bool notificationsEnabled;
  final String errorMessage;

  const ProfileState({
    this.name = '',
    this.medicalHistory = '',
    this.currentMedications = '',
    this.allergies = '',
    this.bloodType = '',
    this.isOrganDonor = false,
    this.isBloodDonor = false,
    this.notificationsEnabled = false,
    this.errorMessage = '',
  });

  // Adding a copyWith method to update the state with new data
  ProfileState copyWith({
    String? name,
    String? medicalHistory,
    String? currentMedications,
    String? allergies,
    String? bloodType,
    bool? isOrganDonor,
    bool? isBloodDonor,
    bool? notificationsEnabled,
    String? errorMessage,
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
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        medicalHistory,
        currentMedications,
        allergies,
        bloodType,
        isOrganDonor,
        isBloodDonor,
        notificationsEnabled,
        errorMessage,
      ];

  static ProfileState error({required String message}) {
    return ProfileState(errorMessage: message);
  }
}
