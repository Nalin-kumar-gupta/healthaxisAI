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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map container
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude, longitude),
                  initialZoom: 12.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
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
            // Area Information Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About $areaName',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Known for its rich culture and scenic landscapes, $areaName is home to a population primarily engaged in agriculture and small-scale industries.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  // Disease Spread Section
                  Text(
                    'Disease Spread Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    diseaseSpread,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Sources of Disease Spread
                  Text(
                    'Sources of Disease Spread',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    diseaseSources,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  // Additional Statistics
                  Text(
                    'Disease Statistics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Infection Rate', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('12%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Recovery Rate', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('85%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Vaccinated', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 4),
                          Text('65%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Call to Action
                  Text(
                    'Stay Safe!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Follow health guidelines to protect yourself and your family. Avoid crowded areas and maintain hygiene.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
