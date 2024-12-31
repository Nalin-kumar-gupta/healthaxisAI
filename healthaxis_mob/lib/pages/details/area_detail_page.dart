import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AreaDetailPage extends StatelessWidget {
  final String areaName;
  final double latitude;
  final double longitude;
  final String diseaseSpread;
  final String diseaseSources;

  AreaDetailPage({
    required this.areaName,
    required this.latitude,
    required this.longitude,
    required this.diseaseSpread,
    required this.diseaseSources,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$areaName Details'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Map container
          Container(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude), // Initial map center
                initialZoom: 12.0, // Initial zoom level
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'], // OpenStreetMap tile server subdomains
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(latitude, longitude), // Marker position
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Disease spread and sources information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disease spread details
                Text(
                  'Disease Spread in $areaName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(diseaseSpread),
                SizedBox(height: 16),
                // Sources of disease spread
                Text(
                  'Sources of Disease Spread',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(diseaseSources),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
