import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


class StockTrackingPage extends StatefulWidget {
  @override
  _StockTrackingPageState createState() => _StockTrackingPageState();
}

class _StockTrackingPageState extends State<StockTrackingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;

  // Stock data remains the same
  List<Map<String, dynamic>> stockItems = [
    {
      'item': 'Aspirin',
      'quantity': 200,
      'expiry': '2025-05-12',
      'minRequired': 100,
      'category': 'Pain Relief',
      'reorderPoint': 150,
      'unit': 'tablets',
      'supplier': 'PharmaCo',
      'batchNumber': 'AS12345',
      'history': [180, 200, 220, 190, 200]
    },
    {
      'item': 'Ibuprofen',
      'quantity': 150,
      'expiry': '2024-08-22',
      'minRequired': 80,
      'category': 'Pain Relief',
      'reorderPoint': 120,
      'unit': 'tablets',
      'supplier': 'MediCorp',
      'batchNumber': 'IB67890',
      'history': [130, 145, 160, 140, 150]
    },
    {
      'item': 'Paracetamol',
      'quantity': 300,
      'expiry': '2026-03-15',
      'minRequired': 200,
      'category': 'Fever Reducer',
      'reorderPoint': 250,
      'unit': 'tablets',
      'supplier': 'HealthPlus',
      'batchNumber': 'PA54321',
      'history': [280, 300, 320, 290, 300]
    },
    // Add more items as needed
    // ... other items remain the same
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getStockStatus(Map<String, dynamic> item) {
    if (item['quantity'] <= item['minRequired']) {
      return 'Low';
    } else if (item['quantity'] <= item['reorderPoint']) {
      return 'Medium';
    }
    return 'Good';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low':
        return AppColors.error;
      case 'Medium':
        return AppColors.warning;
      case 'Good':
        return AppColors.success;
      default:
        return AppColors.neutral;
    }
  }

  Widget _buildStockCard(Map<String, dynamic> item) {
    String status = _getStockStatus(item);
    Color statusColor = _getStatusColor(status);
    DateTime expiryDate = DateTime.parse(item['expiry']);
    int daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;

    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['item'],
                    style: AppTextStyles.subtitle1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing8,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing8),
            _buildInfoRow('Quantity', '${item['quantity']} ${item['unit']}'),
            _buildInfoRow('Category', item['category']),
            _buildInfoRow('Supplier', item['supplier']),
            _buildInfoRow('Batch No', item['batchNumber']),
            _buildInfoRow('Expiry', '${daysUntilExpiry} days'),
            SizedBox(height: AppDimensions.spacing12),
            LinearProgressIndicator(
              value: item['quantity'] / (item['reorderPoint'] * 1.5),
              backgroundColor: AppColors.surfaceMedium,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.body2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart, IconData icon) {
    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: AppDimensions.iconMedium),
                SizedBox(width: AppDimensions.spacing8),
                Text(title, style: AppTextStyles.subtitle1),
              ],
            ),
            SizedBox(height: AppDimensions.spacing16),
            SizedBox(
              height: 250,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        children: [
          _buildChartCard(
            'Stock Levels',
            _buildBarChart(),
            Icons.bar_chart,
          ),
          SizedBox(height: AppDimensions.spacing16),
          _buildChartCard(
            'Category Distribution',
            _buildPieChart(),
            Icons.pie_chart,
          ),
          SizedBox(height: AppDimensions.spacing16),
          _buildChartCard(
            'Stock Trends',
            _buildLineChart(),
            Icons.show_chart,
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 600,
        barGroups: List.generate(stockItems.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: stockItems[index]['quantity'].toDouble(),
                color: _getStatusColor(_getStockStatus(stockItems[index])),
                width: 25,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusSmall)),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, titleMeta) {
                return Padding(
                  padding: EdgeInsets.only(right: AppDimensions.spacing8),
                  child: Text(
                    value.toInt().toString(),
                    style: AppTextStyles.caption,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, titleMeta) {
                return Padding(
                  padding: EdgeInsets.only(top: AppDimensions.spacing8),
                  child: Text(
                    stockItems[value.toInt()]['item'],
                    style: AppTextStyles.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: stockItems.asMap().entries.map((entry) {
          final color = Colors.primaries[entry.key % Colors.primaries.length];
          return PieChartSectionData(
            value: entry.value['quantity'].toDouble(),
            title: '${entry.value['item']}\n${entry.value['quantity']}',
            color: color,
            radius: 100,
            titleStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnPrimary),
          );
        }).toList(),
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, titleMeta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, titleMeta) {
                return Text(
                  'Week ${value.toInt() + 1}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.border),
        ),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 600,
        lineBarsData: stockItems.map((item) {
          return LineChartBarData(
            spots: List.generate(
              item['history'].length,
              (index) => FlSpot(index.toDouble(), item['history'][index].toDouble()),
            ),
            isCurved: true,
            color: _getStatusColor(_getStockStatus(item)),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: _getStatusColor(_getStockStatus(item)).withOpacity(0.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Stock Management', style: AppTextStyles.headline2.copyWith(color: AppColors.textOnPrimary)),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTextStyles.button,
          tabs: [
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Inventory Tab
          _isGridView
              ? GridView.builder(
                  padding: EdgeInsets.all(AppDimensions.spacing16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: AppDimensions.spacing16,
                    mainAxisSpacing: AppDimensions.spacing16,
                  ),
                  itemCount: stockItems.length,
                  itemBuilder: (context, index) => _buildStockCard(stockItems[index]),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(AppDimensions.spacing16),
                  itemCount: stockItems.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.spacing16),
                    child: _buildStockCard(stockItems[index]),
                  ),
                ),
          // Analytics Tab
          _buildChartTab(),
          // Settings Tab
          Center(
            child: Text('Settings Coming Soon', style: AppTextStyles.body1),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new stock item functionality
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.textOnPrimary),
        tooltip: 'Add New Item',
      ),
    );
  }
}