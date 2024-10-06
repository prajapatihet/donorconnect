import 'package:donorconnect/cubit/profile/profile_cubit.dart';
import 'package:donorconnect/cubit/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
                        'Welcome to your profile',
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
                    decoration:
                        const InputDecoration(labelText: 'Medical History'),
                    onChanged: (value) => context
                        .read<ProfileCubit>()
                        .updateMedicalHistory(value),
                  ),
                  const SizedBox(height: 16),

                  // Current Medications
                  TextFormField(
                    initialValue: state.currentMedications,
                    decoration:
                        const InputDecoration(labelText: 'Current Medications'),
                    onChanged: (value) => context
                        .read<ProfileCubit>()
                        .updateCurrentMedications(value),
                  ),
                  const SizedBox(height: 16),

                  // Allergies
                  TextFormField(
                    initialValue: state.allergies,
                    decoration: const InputDecoration(labelText: 'Allergies'),
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
                    decoration: const InputDecoration(labelText: 'Blood Type'),
                  ),
                  const SizedBox(height: 16),

                  // Organ Donor
                  SwitchListTile(
                    title: const Text('Organ Donor'),
                    value: state.isOrganDonor,
                    onChanged: (value) {
                      context
                          .read<ProfileCubit>()
                          .updateOrganDonorStatus(value);
                    },
                  ),

                  // Blood Donor
                  SwitchListTile(
                    title: const Text('Blood Donor'),
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
                    title: const Text('Enable Donation Notifications'),
                    value: state.notificationsEnabled,
                    onChanged: (value) {
                      context.read<ProfileCubit>().toggleNotifications(value);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Save the profile using userId
                        await context
                            .read<ProfileCubit>()
                            .saveProfile(widget.userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Saved')),
                        );
                      }
                    },
                    child: const Text('Save Profile'),
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
