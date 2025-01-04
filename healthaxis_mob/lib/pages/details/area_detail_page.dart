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

  // List of problematic areas with their details
  final List<Map<String, dynamic>> hotspots = [
    {
      'name': 'Main Market',
      'location': LatLng(27.6637, 79.4200),
      'cause': 'Overcrowding and lack of hygiene',
      'severity': 'High',
    },
    {
      'name': 'Local School',
      'location': LatLng(27.6625, 79.4185),
      'cause': 'Poor ventilation and close contact',
      'severity': 'Moderate',
    },
    {
      'name': 'Bus Station',
      'location': LatLng(27.6650, 79.4195),
      'cause': 'Crowds during peak hours',
      'severity': 'High',
    },
  ];

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
            // Map with hotspots
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude, longitude),
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      // Main marker for the area
                      Marker(
                        point: LatLng(latitude, longitude),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                      // Markers for problematic areas
                      ...hotspots.map((hotspot) {
                        return Marker(
                          point: hotspot['location'],
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(hotspot['name']),
                                  content: Text(
                                    'Cause: ${hotspot['cause']}\nSeverity: ${hotspot['severity']}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              Icons.warning,
                              color: hotspot['severity'] == 'High' ? Colors.red : Colors.yellow,
                              size: 30.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Legend for markers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                      SizedBox(width: 4),
                      Text('Main Area'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 20),
                      SizedBox(width: 4),
                      Text('High Risk'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.yellow, size: 20),
                      SizedBox(width: 4),
                      Text('Moderate Risk'),
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
                  // Disease Statistics
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
