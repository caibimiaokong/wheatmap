import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wheatmap/feature/map_feature/controllers/bloc/map_bloc.dart';
import 'package:wheatmap/feature/map_feature/controllers/data_layer/repository.dart';
import 'package:wheatmap/feature/map_feature/components/googlemap.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final SupabaseClient client = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepositoryProvider(
      create: (context) => MapRepository(supabaseClient: client),
      child: BlocProvider(
          create: (context) =>
              MapBloc(RepositoryProvider.of<MapRepository>(context))
                ..add(FetchAllPoints()),
          child: const MapView()),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        switch (state.status) {
          case MapStatus.initial:
            // return const GoogleMapScreen();
            return const Center(child: CircularProgressIndicator());
          case MapStatus.loading:
            return const GoogleMapScreen();
          case MapStatus.loaded:
            return GoogleMapScreen(
              mapType: state.mapType,
              points: state.displayPoints,
              userLocation: state.cameraPosition,
            );
          case MapStatus.error:
            return const Center(child: Text('Failed to load map'));
        }
      },
    ));
  }
}
