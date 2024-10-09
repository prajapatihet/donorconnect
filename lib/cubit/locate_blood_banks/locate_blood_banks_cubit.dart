// Define States
import 'package:donorconnect/services/blood_bank_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class LocateBloodBanksState {}

class LocateBloodBanksInitial extends LocateBloodBanksState {}

class LocateBloodBanksLoading extends LocateBloodBanksState {}

class LocateBloodBanksLoaded extends LocateBloodBanksState {
  final List<dynamic> bloodBanks;
  LocateBloodBanksLoaded(this.bloodBanks);
}

class LocateBloodBanksFiltered extends LocateBloodBanksState {
  final List<dynamic> filteredBloodBanks;
  LocateBloodBanksFiltered(this.filteredBloodBanks);
}

class LocateBloodBanksError extends LocateBloodBanksState {
  final String error;
  LocateBloodBanksError(this.error);
}

// Define Cubit
class LocateBloodBanksCubit extends Cubit<LocateBloodBanksState> {
  final BloodBankService bloodBankService;
  List<dynamic> bloodBanks = []; // Store original data for filtering

  LocateBloodBanksCubit(this.bloodBankService)
      : super(LocateBloodBanksInitial());

  // Fetch all blood banks
  void fetchBloodBanks() async {
    try {
      emit(LocateBloodBanksLoading());
      bloodBanks = await bloodBankService.getBloodBanks();
      emit(LocateBloodBanksLoaded(bloodBanks));
    } catch (e) {
      emit(LocateBloodBanksError(e.toString()));
    }
  }

  // Filter blood banks based on search criteria
  void filterBloodBanks({String? city, String? district, String? state}) {
    final filteredBloodBanks = bloodBanks.where((bloodBank) {
      final matchesCity = city == null ||
          bloodBank['_city']
              .toString()
              .toLowerCase()
              .contains(city.toLowerCase());
      final matchesDistrict = district == null ||
          bloodBank['_district']
              .toString()
              .toLowerCase()
              .contains(district.toLowerCase());
      final matchesState = state == null ||
          bloodBank['_state']
              .toString()
              .toLowerCase()
              .contains(state.toLowerCase());
      return matchesCity && matchesDistrict && matchesState;
    }).toList();

    emit(LocateBloodBanksFiltered(filteredBloodBanks));
  }
}
