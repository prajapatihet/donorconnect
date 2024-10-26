import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/cubit/profile/profile_cubit.dart';
import 'package:donorconnect/cubit/profile/profile_state.dart';
import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:donorconnect/views/common_widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/theme_toggle/theme_cubit.dart';
import '../../../cubit/theme_toggle/theme_state.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String userId;
  const ProfileScreen({super.key, required this.name, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load profile data from storage when screen is initialized
    loadProfile();
  }

  void loadProfile() async {
    await context.read<ProfileCubit>().loadProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    return Scaffold(
      appBar: AppBar(
        title: Text(_text.profile),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _text.welcome_to_your_profile,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Medical History
                  TextFormField(
                    initialValue: state.medicalHistory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      labelText: _text.medical_history,
                    ),
                    onChanged: (value) => context
                        .read<ProfileCubit>()
                        .updateMedicalHistory(value),
                  ),
                  const SizedBox(height: 16),

                  // Current Medications
                  TextFormField(
                    initialValue: state.currentMedications,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      labelText: _text.current_medications,
                    ),
                    onChanged: (value) => context
                        .read<ProfileCubit>()
                        .updateCurrentMedications(value),
                  ),

                  const SizedBox(height: 16),

                  // Allergies
                  TextFormField(
                    initialValue: state.allergies,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      labelText: _text.allergies,
                    ),
                    onChanged: (value) =>
                        context.read<ProfileCubit>().updateAllergies(value),
                  ),
                  const SizedBox(height: 16),

                  // Blood Type
                  DropdownButtonFormField<String>(
                    value: state.bloodType.isEmpty ? null : state.bloodType,
                    items: const [
                      DropdownMenuItem(value: 'A+', child: Text('A+')),
                      DropdownMenuItem(value: 'A-', child: Text('A-')),
                      DropdownMenuItem(value: 'B+', child: Text('B+')),
                      DropdownMenuItem(value: 'B-', child: Text('B-')),
                      DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                      DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                      DropdownMenuItem(value: 'O+', child: Text('O+')),
                      DropdownMenuItem(value: 'O-', child: Text('O-')),
                    ],
                    onChanged: (value) {
                      context.read<ProfileCubit>().updateBloodType(value ?? '');
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      labelText: _text.blood_type,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Organ Donor
                  SwitchListTile(
                    title: Text(_text.organ_donor),
                    value: state.isOrganDonor,
                    onChanged: (value) {
                      context
                          .read<ProfileCubit>()
                          .updateOrganDonorStatus(value);
                    },
                  ),

                  // Blood Donor
                  SwitchListTile(
                    title: Text(_text.blood_donor),
                    value: state.isBloodDonor,
                    onChanged: (value) {
                      context
                          .read<ProfileCubit>()
                          .updateBloodDonorStatus(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notification Settings
                  SwitchListTile(
                    title: Text(_text.enable_donation_notifications),
                    value: state.notificationsEnabled,
                    onChanged: (value) {
                      context.read<ProfileCubit>().toggleNotifications(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  // theme-toggle button
                  BlocBuilder<ThemeCubit, Themestate>(
                    builder: (context, themeState) {
                      final isDarkMode = themeState.themeData.brightness == Brightness.dark;
                      return ThemeToggleButton(
                        switchValue: isDarkMode,
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(112, 10, 140, 15),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Save the profile using userId
                        await context
                            .read<ProfileCubit>()
                            .saveProfile(widget.userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_text.profile_saved)),
                        );
                      }
                    },
                    child: Text(
                      _text.save_profile,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
