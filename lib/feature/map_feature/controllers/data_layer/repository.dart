import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wheatmap/feature/map_feature/models/displaypoint.dart';

class MapRepository {
  MapRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;
  final SupabaseClient _supabaseClient;

  Future<List<DisplayPoint>> getAllPoints(
      {bool? iswheatDisplay = true,
      bool? isRescueDisplay = true,
      bool? isHarvestDisplay = true}) async {
    final res = await _supabaseClient.rpc(
      'allpoints',
    );
    if (res == null) {
      throw PlatformException(code: 'get all points error null data');
    }
    return DisplayPoint.pointFromData(
      data: res,
    );
  }

  Future<List<DisplayPoint>> getDisplayPointsByBounds(
      {required LatLngBounds bounds,
      bool? iswheatDisplay = true,
      bool? isRescueDisplay = true,
      bool? isHarvestDisplay = true}) async {
    final res = await _supabaseClient.rpc(
      'points_in_view',
      params: <String, dynamic>{
        'min_long': '${bounds.southwest.longitude}',
        'min_lat': '${bounds.southwest.latitude}',
        'max_long': '${bounds.northeast.longitude}',
        'max_lat': '${bounds.northeast.latitude}',
        'iswheat': iswheatDisplay,
        'isrescue': isRescueDisplay,
        'isharvest': isHarvestDisplay,
      },
    );
    if (res == null) {
      throw PlatformException(code: 'getVideosFromLocation error null data');
    }
    return DisplayPoint.pointFromData(
      data: res,
    );
  }

  Future<LatLng> getMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw PlatformException(code: 'Location service is disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<LatLng> getNearbyPoint() async {
    final location = await getMyLocation();
    final res = await _supabaseClient.rpc(
      'nearest_point',
      params: <String, dynamic>{
        'lat': location.latitude,
        'long': location.longitude,
      },
    );
    if (res == null) {
      throw PlatformException(code: 'getVideosFromLocation error null data');
    } else {
      final DisplayPoint point = DisplayPoint.pointFromData(data: res).first;
      return LatLng(point.latitude, point.longitude);
    }
  }
}
