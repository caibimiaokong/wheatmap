import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsSheet {
  static void show({
    required BuildContext context,
    // required void Function(AvailableMap map) onMapTap,
    required LatLng destination,
    required int type,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (!context.mounted) return;
    String profession = '';

    if (type == 1) {
      profession = 'wheat';
    } else if (type == 3) {
      profession = 'Agricultural mechanics';
    } else {
      profession = 'rescuer';
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Text(
                "profession: $profession",
                style: const TextStyle(fontSize: 20, fontFamily: 'CrimsonText'),
              ),
              Text(
                "coordinate:  ${destination.latitude.toString().substring(0, 7)}, ${destination.longitude.toString().substring(0, 8)}",
                style: const TextStyle(fontSize: 20, fontFamily: 'CrimsonText'),
              ),
              Expanded(
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        bottom: const TabBar(
                          tabs: <Widget>[
                            Tab(
                              text: 'route',
                              icon: Icon(Icons.route),
                            ),
                            Tab(
                              text: 'Marker',
                              icon: Icon(Icons.location_on),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Wrap(
                              children: <Widget>[
                                for (var map in availableMaps)
                                  ListTile(
                                    onTap: () => map.showDirections(
                                      destination: Coords(destination.latitude,
                                          destination.longitude),
                                      destinationTitle: "destination",
                                    ),
                                    // onTap: () => onMapTap(map),
                                    title: Text(map.mapName),
                                    leading: SvgPicture.asset(
                                      map.icon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Wrap(
                              children: <Widget>[
                                for (var map in availableMaps)
                                  ListTile(
                                    onTap: () => map.showMarker(
                                      coords: Coords(destination.latitude,
                                          destination.longitude),
                                      title: "destination",
                                    ),
                                    title: Text(map.mapName),
                                    leading: SvgPicture.asset(
                                      map.icon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
