import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockTrackingPage extends StatefulWidget {
  @override
  _StockTrackingPageState createState() => _StockTrackingPageState();
}

class _StockTrackingPageState extends State<StockTrackingPage> {
  // Example stock data
  List<Map<String, String>> stockItems = [
    {'item': 'Aspirin', 'quantity': '200', 'expiry': '2025-05-12'},
    {'item': 'Ibuprofen', 'quantity': '150', 'expiry': '2024-08-22'},
    {'item': 'Paracetamol', 'quantity': '300', 'expiry': '2025-02-14'},
    {'item': 'Amoxicillin', 'quantity': '500', 'expiry': '2026-11-10'},
    {'item': 'Vitamin C', 'quantity': '120', 'expiry': '2025-03-05'},
  ];

  @override
  Widget build(BuildContext context) {
    // Extracting quantities and item names for graph
    List<String> itemNames = stockItems.map((item) => item['item']!).toList();
    List<int> quantities = stockItems.map((item) => int.parse(item['quantity']!)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Stock Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              
              // Bar Chart: Stock Quantity vs Items
              Container(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 600,
                    barGroups: List.generate(stockItems.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: quantities[index].toDouble(),
                            color: Colors.blueAccent,
                            width: 25,
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, titleMeta) {
                            return Text(value.toInt().toString()); // Left axis shows numbers
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, titleMeta) {
                            return Text(itemNames[value.toInt()]); // Bottom axis shows item names
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Pie Chart: Stock Expiry Distribution (Example data)
              Container(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 50,
                        title: 'Aspirin',
                        color: Colors.red,
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 30,
                        title: 'Ibuprofen',
                        color: Colors.green,
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 20,
                        title: 'Paracetamol',
                        color: Colors.blue,
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 40,
                        title: 'Amoxicillin',
                        color: Colors.orange,
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: 10,
                        title: 'Vitamin C',
                        color: Colors.purple,
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Line Chart: Stock Trend Over Time (Example data)
              Container(
                height: 250,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: 4,
                    minY: 0,
                    maxY: 600,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 200),  // Example data point for Aspirin
                          FlSpot(1, 150),  // Example data point for Ibuprofen
                          FlSpot(2, 300),  // Example data point for Paracetamol
                          FlSpot(3, 500),  // Example data point for Amoxicillin
                          FlSpot(4, 120),  // Example data point for Vitamin C
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add prediction or stock tracking functionality
                },
                child: Text('Predict Stock Requirements'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
