import 'package:donorconnect/views/pages/camps/calendarPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Camps extends StatefulWidget {
  const Camps({super.key});

  @override
  _Camps createState() => _Camps();
}

class _Camps extends State<Camps> with SingleTickerProviderStateMixin {
  Position? _currentPosition;
  List<Map<String, dynamic>> _upcomingCamps = [];
  List<Map<String, dynamic>> _pastCamps = [];
  List<Map<String, dynamic>> _registeredCamps = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchDonationCamps();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permissions are denied.")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   _currentPosition = position;
    // });
  }

  Future<void> _fetchDonationCamps() async {
    try {
      var db = await mongo.Db.create(
          'mongo url');
      await db.open();
      var collection = db.collection('BloodDonationCamps');
      List<Map<String, dynamic>> camps = await collection.find().toList();

      double distanceThreshold = 25 * 1000;
      // setState(() {
        _upcomingCamps = camps.where((camp) {
          double campLatitude = camp['latitude'];
          double campLongitude = camp['longitude'];
          double distanceInMeters = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              campLatitude,
              campLongitude);
          return DateTime.parse(camp['date']).isAfter(DateTime.now()) &&
              distanceInMeters <= distanceThreshold;
        }).toList();
        _pastCamps = camps.where((camp) {
          double campLatitude = camp['latitude'];
          double campLongitude = camp['longitude'];
          double distanceInMeters = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              campLatitude,
              campLongitude);
          return DateTime.parse(camp['date']).isBefore(DateTime.now()) &&
              distanceInMeters <= distanceThreshold;
        }).toList();
        _isLoading = false;
      // });
      setState(() {
        
      });
      await _fetchRegisteredCamps(db);
      await db.close();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching donation camps: $e")),
      );
    }
  }

  Future<void> _fetchRegisteredCamps(mongo.Db db) async {
    var registrationCollection = db.collection('CampRegistrations');
    String userId = 'testUser@gmail.com'; // Example user ID

    List<Map<String, dynamic>> registeredCamps =
        await registrationCollection.find({'userId': userId}).toList();

    setState(() {
      _registeredCamps = registeredCamps;
    });
  }

  void _showCampDetailsDialog(Map<String, dynamic> camp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(camp['campName'] ?? 'No Name',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 8),
                Text("Date: ${camp['date'] ?? 'Unknown'}"),
                Text("Time: ${camp['time'] ?? 'Unknown'}"),
                Text("Location: ${camp['location'] ?? 'Unknown'}"),
                Text("Organizer: ${camp['organizer'] ?? 'Unknown'}"),
                Text("Verified: ${camp['isVerified'] ?? false ? 'Yes' : 'No'}"),
                Text("Rating: ${camp['rating'] ?? 'Not Rated'}"),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _navigateToMap(camp['latitude'], camp['longitude']);
                      },
                      child: Text("Navigate"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _registerForCamp(camp);
                        Navigator.of(context).pop();
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToMap(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      final Uri googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

      launchUrl(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid coordinates.")),
      );
    }
  }

  Future<void> _registerForCamp(Map<String, dynamic> camp) async {
    try {
      var db = await mongo.Db.create(
          'mongo url');
      await db.open();
      var registrationCollection = db.collection('CampRegistrations');

      String userId = 'testUser@gmail.com'; // Example user ID

      var existingRegistration = await registrationCollection.findOne({
        'userId': userId,
        'campId': camp['_id'],
      });

      if (existingRegistration != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are already registered for this camp.")),
        );
      } else {
        await registrationCollection.insert({
          'userId': userId,
          'campId': camp['_id'],
          'campName': camp['campName'],
          'date': camp['date'],
          'time': camp['time'],
          'location': camp['location'],
          'registeredAt': DateTime.now().toIso8601String(),
          'organizer': camp['organizer'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful.")),
        );
      }

      await db.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error registering for camp: $e")),
      );
    }
  }

  void _showAddCampForm() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddCampForm()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camps"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
            Tab(text: "Registered"),
          ],
        ),
        actions:[
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              print("hello");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage()));
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : _isLoading
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCampList(_upcomingCamps),
                    _buildCampList(_pastCamps),
                    _buildCampList(_registeredCamps),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCampForm,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCampList(List<Map<String, dynamic>> camps) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: camps.isEmpty
          ? [Center(child: Text("No camps available."))]
          : camps.map((camp) => _buildCampCard(camp)).toList(),
    );
  }

  Widget _buildCampCard(Map<String, dynamic> camp) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              camp['campName'] ?? 'No Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text("Date: ${camp['date'] ?? 'Unknown'}"),
            Text("Time: ${camp['time'] ?? 'Unknown'}"),
            ElevatedButton(
              onPressed: () {
                _showCampDetailsDialog(camp);
              },
              child: Text("View Details"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCampForm extends StatefulWidget {
  @override
  _AddCampFormState createState() => _AddCampFormState();
}

class _AddCampFormState extends State<AddCampForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _organizer = '';
  String _description = '';
  String _address = '';
  String _location = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double? _latitude=0;
  double? _longitude=0;

  @override
  void initState() {
    super.initState();
    _selectLocation(); // Automatically trigger location selection when the page opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Blood Donation Camp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                    labelText: 'Camp Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter camp name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                    labelText: 'Organizer Name',
                    ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organizer name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _organizer = value!;
                  },
                ),
                 SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                    labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                 SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                    labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address = value!;
                  },
                ),
                SizedBox(height: 10),
                // Date picker with ListTile
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
                // Time picker with ListTile
                ListTile(
                  title: Text(
                    _selectedTime == null
                        ? 'Select Time'
                        : 'Time: ${_selectedTime!.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(Icons.access_time),
                  onTap: _selectTime,
                ),
                SizedBox(height: 10),
                if (_location.isNotEmpty) ...[
                  Text("Location: $_location"),
                ],
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(112, 10, 140, 15),
                ),
                  onPressed: _submitForm,
                  child: Text("Add Camp", style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectLocation() async {
    try {
      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update the latitude and longitude with the current location
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Optionally, you can update the location name using reverse geocoding (not implemented here)
      _location = 'Current Location: Lat: ${_latitude}, Long: ${_longitude}';

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Store the selected date
      });
    }
  }

  // Function to select a time
  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime; // Store the selected time
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var db = await mongo.Db.create(
            'mongo url');
        await db.open();
        var collection = db.collection('BloodDonationCamps');
        await collection.insert({
          'campName': _name,
          'organizer': _organizer,
          'description': _description,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
          'time': _selectedTime!.format(context),
          'address': _address,
          'location': _location,
          'latitude': _latitude,
          'longitude': _longitude,
          'isVerified': false,
          'rating': 0,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Camp added successfully.")),
        );

        await db.close();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding camp: $e")),
        );
      }
    }
  }
}
