import 'package:donorconnect/cubit/locate_blood_banks/locate_blood_banks_cubit.dart';
import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocateBloodBanks extends StatefulWidget {
  const LocateBloodBanks({super.key});

  @override
  State<LocateBloodBanks> createState() => _LocateBloodBanksState();
}

class _LocateBloodBanksState extends State<LocateBloodBanks> {
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    // Fetch data when the page is built
    context.read<LocateBloodBanksCubit>().fetchBloodBanks();

    return Scaffold(
      appBar: AppBar(
        title: Text(_text.locate_blood_bank),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: _text.city),
                    onChanged: (value) => _filterBloodBanks(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: districtController,
                    decoration: InputDecoration(labelText: _text.district),
                    onChanged: (value) => _filterBloodBanks(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: stateController,
                    decoration: InputDecoration(labelText: _text.state),
                    onChanged: (value) => _filterBloodBanks(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<LocateBloodBanksCubit, LocateBloodBanksState>(
              builder: (context, state) {
                if (state is LocateBloodBanksLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LocateBloodBanksLoaded ||
                    state is LocateBloodBanksFiltered) {
                  final bloodBanks = state is LocateBloodBanksLoaded
                      ? state.bloodBanks
                      : (state as LocateBloodBanksFiltered).filteredBloodBanks;

                  return ListView.builder(
                    itemCount: bloodBanks.length,
                    itemBuilder: (context, index) {
                      final bloodBank = bloodBanks[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bloodBank['_blood_bank_name'] ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '${_text.state}: ${bloodBank['_state'] ?? 'N/A'}'),
                              Text(
                                  '${_text.district}: ${bloodBank['_district'] ?? 'N/A'}'),
                              Text(
                                  '${_text.city}: ${bloodBank['_city'] ?? 'N/A'}'),
                              Text(
                                  '${_text.contact}: ${bloodBank['_contact_no'] ?? 'N/A'}'),
                              Text(
                                  '${_text.email}: ${bloodBank['_email'] ?? 'N/A'}'),
                              Text(
                                  '${_text.nodal_officer}: ${bloodBank['_nodal_officer_'] ?? 'N/A'}'),
                              Text(
                                  '${_text.contact_nodal_officer}: ${bloodBank['_mobile_nodal_officer'] ?? 'N/A'}'),
                              Text(
                                  '${_text.category}: ${bloodBank['_category'] ?? 'N/A'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is LocateBloodBanksError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Center(child: Text(_text.no_data_available));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Call the filter function in Cubit
  void _filterBloodBanks() {
    final city = cityController.text;
    final district = districtController.text;
    final state = stateController.text;

    context.read<LocateBloodBanksCubit>().filterBloodBanks(
          city: city.isEmpty ? null : city,
          district: district.isEmpty ? null : district,
          state: state.isEmpty ? null : state,
        );
  }

  @override
  void dispose() {
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();
    super.dispose();
  }
}
