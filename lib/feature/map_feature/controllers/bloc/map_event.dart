part of 'map_bloc.dart';

sealed class MapEvent {}

class FetchAllPoints extends MapEvent {}

class FetchPointsByBounds extends MapEvent {}

class ChangeMapType extends MapEvent {
  final MapType mapType;
  ChangeMapType(this.mapType);
}

class CatchMyLocation extends MapEvent {}
