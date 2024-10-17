import 'package:donorconnect/views/common_widgets/events_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Map<String, dynamic>> _events = [];
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _camps = [];
  Position? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    _fetchCamps();
    super.initState();
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
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _fetchCamps() async {
    try {
      var db = await mongo.Db.create(
          'mongo url');
      await db.open();
      var collection = db.collection('BloodDonationCamps');
      List<Map<String, dynamic>> camps = await collection.find().toList();

      double distanceThreshold = 25 * 1000;
      _camps = camps.where((camp) {
        double campLatitude = camp['latitude'];
        double campLongitude = camp['longitude'];
        double distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            campLatitude,
            campLongitude);
        return camp['date'] == DateFormat('yyyy-MM-dd').format(_selectedDate) &&
        distanceInMeters <= distanceThreshold;
      }).toList();
      _isLoading = false;
      if(_camps.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No events scheduled for the selected date.")),
        );
      }
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Calendar'),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 60)),
            onDateChanged: (value) {
              setState(() {
                _isLoading = true;
                _selectedDate = value;
                _fetchCamps();
              });
            },
          ),
          Divider(
            height: 20,
            thickness: 2,
          ),
          // Text(
          //   "Events Scheduled",
          //   style: TextStyle(),
          //   textAlign: TextAlign.start,
          // ),
          Flexible(
              child: _isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      ),
                  )
                  : _camps.isEmpty ?Image.asset('assets/images/empty_calendar.png') :ListView.builder(
                      itemCount: _camps.length,
                      itemBuilder: (context, index) {
                        return EventsCard(event: _camps[index],);
                      },
                    ))
        ],
      )),
    );
  }
}
