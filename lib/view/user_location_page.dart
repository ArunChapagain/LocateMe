import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserLocationPage extends StatefulWidget {
  final double lat, lon;

  const UserLocationPage({super.key, required this.lat, required this.lon});

  @override
  State<UserLocationPage> createState() => _UserLocationPageState();
}

class _UserLocationPageState extends State<UserLocationPage> {
  late LatLng point;

  // Initial map type (OpenStreetMap)
  String selectedMapType = 'OSM';

  // Map URL templates for different map types
  final Map<String, String> mapTypes = {
    'OSM': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'colored':
        'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png??api_key=7e32fda8-bbd1-4302-ad85-7bbcdb37960e',
    'Terrain':
        "https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}.png?api_key=7e32fda8-bbd1-4302-ad85-7bbcdb37960e"
  };

  @override
  void initState() {
    point = LatLng(widget.lat, widget.lon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  onTap: (tapPosition, point) {
                    setState(() {
                      this.point = point;
                    });
                  },
                  initialCenter: LatLng(widget.lat, widget.lon),
                  initialZoom: 10,
                  maxZoom: 30),
              children: [
                TileLayer(
                  urlTemplate: mapTypes[selectedMapType],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      child: Icon(
                        Icons.location_on,
                        size: 35,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedMapType,
                  icon: Icon(
                    Icons.layers,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMapType = newValue!;
                    });
                  },
                  items: mapTypes.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
