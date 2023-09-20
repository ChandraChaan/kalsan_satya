import 'package:flutter/services.dart';

final MethodChannel _locationChannel = MethodChannel('location_channel');

class LocationService {
  static Future<void> startLocationService() async {
    try {
      await _locationChannel.invokeMethod('startLocationService');
    } on PlatformException catch (e) {
      print('Failed to start location service: ${e.message}');
    }
  }
}