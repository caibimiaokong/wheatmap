part of 'map_bloc.dart';

enum MapStatus {
  initial,
  loading,
  loaded,
  error,
}

class MapState extends Equatable {
  final MapStatus status;
  final MapType mapType;
  final CameraPosition cameraPosition;
  final bool isWheatDisplayed;
  final bool isRescueDisplayed;
  final bool isSearchDisplayed;
  final List<DisplayPoint> displayPoints;

  const MapState({
    this.status = MapStatus.initial,
    this.mapType = MapType.normal,
    this.cameraPosition = const CameraPosition(
      target: LatLng(33.740452, 33.740452),
      zoom: 7,
    ),
    this.isWheatDisplayed = false,
    this.isRescueDisplayed = false,
    this.isSearchDisplayed = false,
    this.displayPoints = const [],
  });

  MapState copyWith({
    MapStatus? status,
    MapType? mapType,
    CameraPosition? cameraPosition,
    bool? isWheatDisplayed,
    bool? isRescueDisplayed,
    bool? isSearchDisplayed,
    List<DisplayPoint>? displayPoints,
  }) {
    return MapState(
      status: status ?? this.status,
      mapType: mapType ?? this.mapType,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isWheatDisplayed: isWheatDisplayed ?? this.isWheatDisplayed,
      isRescueDisplayed: isRescueDisplayed ?? this.isRescueDisplayed,
      isSearchDisplayed: isSearchDisplayed ?? this.isSearchDisplayed,
      displayPoints: displayPoints ?? this.displayPoints,
    );
  }

  @override
  List<Object> get props => [
        status,
        mapType,
        cameraPosition,
        isWheatDisplayed,
        isRescueDisplayed,
        isSearchDisplayed,
        List.from(displayPoints)
      ];
}
