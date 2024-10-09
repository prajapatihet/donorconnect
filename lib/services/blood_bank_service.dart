import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey =
    "579b464db66ec23bdd00000163b9abb70e404aca75573c10a5468e4b";

class BloodBankService {
  final String apiUrl =
      'https://api.data.gov.in/resource/fced6df9-a360-4e08-8ca0-f283fc74ce15?api-key=$apiKey&format=json&offset=0&limit=3000';

  Future<List<dynamic>> getBloodBanks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['records']; // Modify as per the API response structure
    } else {
      throw Exception('Failed to load blood banks');
    }
  }
}
