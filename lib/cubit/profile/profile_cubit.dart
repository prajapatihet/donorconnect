import 'package:donorconnect/cubit/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ProfileCubit definition (part of cubit/profile_cubit.dart)
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  // Call this when loading profile data
  // Call this to load profile data for a specific user
  Future<void> loadProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    emit(ProfileState(
      name: prefs.getString('${userId}_name') ?? '',
      medicalHistory: prefs.getString('${userId}_medicalHistory') ?? '',
      currentMedications: prefs.getString('${userId}_currentMedications') ?? '',
      allergies: prefs.getString('${userId}_allergies') ?? '',
      bloodType: prefs.getString('${userId}_bloodType') ?? '',
      isOrganDonor: prefs.getBool('${userId}_isOrganDonor') ?? false,
      isBloodDonor: prefs.getBool('${userId}_isBloodDonor') ?? false,
      notificationsEnabled:
          prefs.getBool('${userId}_notificationsEnabled') ?? false,
    ));
  }

  // Update methods
  void updateMedicalHistory(String history) {
    emit(state.copyWith(medicalHistory: history));
  }

  void updateCurrentMedications(String medications) {
    emit(state.copyWith(currentMedications: medications));
  }

  void updateAllergies(String allergies) {
    emit(state.copyWith(allergies: allergies));
  }

  void updateBloodType(String bloodType) {
    emit(state.copyWith(bloodType: bloodType));
  }

  void updateOrganDonorStatus(bool isOrganDonor) {
    emit(state.copyWith(isOrganDonor: isOrganDonor));
  }

  void updateBloodDonorStatus(bool isBloodDonor) {
    emit(state.copyWith(isBloodDonor: isBloodDonor));
  }

  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  // Save profile data to shared preferences
  Future<void> saveProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${userId}_name', state.name);
    await prefs.setString('${userId}_medicalHistory', state.medicalHistory);
    await prefs.setString(
        '${userId}_currentMedications', state.currentMedications);
    await prefs.setString('${userId}_allergies', state.allergies);
    await prefs.setString('${userId}_bloodType', state.bloodType);
    await prefs.setBool('${userId}_isOrganDonor', state.isOrganDonor);
    await prefs.setBool('${userId}_isBloodDonor', state.isBloodDonor);
    await prefs.setBool(
        '${userId}_notificationsEnabled', state.notificationsEnabled);
  }
}
