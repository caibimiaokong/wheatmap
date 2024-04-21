import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheatmap/feature/map_feature/controllers/data_layer/repository.dart';
import 'package:wheatmap/feature/map_feature/models/displaypoint.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(this.mapRespository) : super(const MapState()) {
    on<FetchAllPoints>(_fetchAllPoints);
    on<FetchPointsByBounds>(_fetchPointsByBounds);
    on<ChangeMapType>(_changeMapType);
    on<CatchMyLocation>(_catchMyLocation);
  }

  // final _levels = const [1.0, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5];
  GoogleMapController? mapController;
  final MapRepository mapRespository;

  void initMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _fetchAllPoints(
      FetchAllPoints event, Emitter<MapState> emit) async {
    try {
      List<DisplayPoint> dispoint = await mapRespository.getAllPoints();
      emit(state.copyWith(
        status: MapStatus.loaded,
        displayPoints: dispoint,
      ));
    } on Exception catch (e) {
      debugPrint("an error occur $e");
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  Future<void> _fetchPointsByBounds(
      FetchPointsByBounds event, Emitter<MapState> emit) async {
    try {
      var bounds = await mapController!.getVisibleRegion();
      debugPrint(bounds.toString());
      List<DisplayPoint> dispoint =
          await mapRespository.getDisplayPointsByBounds(bounds: bounds);
      emit(state.copyWith(
        displayPoints: dispoint,
      ));
    } on Exception catch (e) {
      debugPrint("an error occur $e");
      emit(state.copyWith(status: MapStatus.error));
    }
  }

  void _changeMapType(ChangeMapType event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.loaded, mapType: event.mapType));
  }

  Future<void> _catchMyLocation(
      CatchMyLocation event, Emitter<MapState> emit) async {
    try {
      final searchLocation = await mapRespository.getMyLocation();
      debugPrint('searchLocation: $searchLocation');
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: searchLocation,
          zoom: 11,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error));
    }
  }
}
