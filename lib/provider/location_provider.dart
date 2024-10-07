import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  String? _address;

  Future<void> getCurrentLocationViaGps() async {
    try {
      _isLoading = true;
      notifyListeners();
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;

      await getLocationViaLatLong(LatLng(_latitude!, _longitude!));
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getLocationViaLatLong(LatLng point) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$_latitude&lon=$_longitude');
    final response = await get(url);
    final responseData = json.decode(response.body);
    _address = responseData['display_name'];
  }

  Future getCurrentLocationViaPlace(String address) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$address&format=jsonv2&limit=1');
    final response = await get(url);

    final responseData = json.decode(response.body);
    _latitude = double.parse(responseData[0]['lat']);
    _longitude = double.parse(responseData[0]['lon']);
    print('Latitude: $_latitude, Longitude: $_longitude');
    _isLoading = false;
    notifyListeners();
  }

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get address => _address;
  bool get isLoading => _isLoading;
}
