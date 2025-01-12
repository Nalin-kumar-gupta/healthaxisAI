import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';


class StockTrackingPage extends StatefulWidget {
  @override
  _StockTrackingPageState createState() => _StockTrackingPageState();
}

class _StockTrackingPageState extends State<StockTrackingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;
  String selectedTimeFrame = '3 Months';
  String selectedItem = 'All Items';

  // Enhanced stock data with more fields
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
      'history': [180, 200, 220, 190, 200],
      'cost': 15.99,
      'location': 'Shelf A1',
      'lastOrdered': '2024-12-15',
      'orderFrequency': 'Monthly',
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
      'history': [130, 145, 160, 140, 150],
      'cost': 12.99,
      'location': 'Shelf A2',
      'lastOrdered': '2024-12-10',
      'orderFrequency': 'Bi-monthly',
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
      'history': [280, 300, 320, 290, 300],
      'cost': 10.99,
      'location': 'Shelf B1',
      'lastOrdered': '2024-12-01',
      'orderFrequency': 'Monthly',
    },
  ];

  // Prediction data
  final Map<String, List<Map<String, dynamic>>> predictionData = {
    'Aspirin': [
      {'date': '2025-02', 'predicted': 250, 'actual': 230, 'confidence': 0.92, 'seasonalImpact': 'High', 'trend': 'Increasing'},
      {'date': '2025-03', 'predicted': 280, 'actual': 260, 'confidence': 0.89, 'seasonalImpact': 'Medium', 'trend': 'Stable'},
      {'date': '2025-04', 'predicted': 310, 'actual': null, 'confidence': 0.85, 'seasonalImpact': 'Low', 'trend': 'Increasing'},
      {'date': '2025-05', 'predicted': 340, 'actual': null, 'confidence': 0.82, 'seasonalImpact': 'Low', 'trend': 'Increasing'},
      {'date': '2025-06', 'predicted': 360, 'actual': null, 'confidence': 0.78, 'seasonalImpact': 'Medium', 'trend': 'Peak'},
    ],
    'Ibuprofen': [
      {'date': '2025-02', 'predicted': 180, 'actual': 175, 'confidence': 0.94, 'seasonalImpact': 'Medium', 'trend': 'Stable'},
      {'date': '2025-03', 'predicted': 200, 'actual': 190, 'confidence': 0.91, 'seasonalImpact': 'High', 'trend': 'Increasing'},
      {'date': '2025-04', 'predicted': 220, 'actual': null, 'confidence': 0.87, 'seasonalImpact': 'High', 'trend': 'Peak'},
      {'date': '2025-05', 'predicted': 240, 'actual': null, 'confidence': 0.83, 'seasonalImpact': 'Medium', 'trend': 'Decreasing'},
      {'date': '2025-06', 'predicted': 260, 'actual': null, 'confidence': 0.79, 'seasonalImpact': 'Low', 'trend': 'Stable'},
    ],
    'Paracetamol': [
      {'date': '2025-02', 'predicted': 320, 'actual': 310, 'confidence': 0.93, 'seasonalImpact': 'High', 'trend': 'Increasing'},
      {'date': '2025-03', 'predicted': 350, 'actual': 340, 'confidence': 0.90, 'seasonalImpact': 'High', 'trend': 'Peak'},
      {'date': '2025-04', 'predicted': 380, 'actual': null, 'confidence': 0.86, 'seasonalImpact': 'Medium', 'trend': 'Stable'},
      {'date': '2025-05', 'predicted': 400, 'actual': null, 'confidence': 0.82, 'seasonalImpact': 'Low', 'trend': 'Decreasing'},
      {'date': '2025-06', 'predicted': 420, 'actual': null, 'confidence': 0.77, 'seasonalImpact': 'Low', 'trend': 'Stable'},
    ],
  };
  final Map<String, Map<String, dynamic>> usagePatterns = {
    'Aspirin': {
      'peakMonths': ['December', 'January', 'February'],
      'lowMonths': ['June', 'July'],
      'demographicTrends': {
        'age': 'Higher usage in 45+ age group',
        'gender': 'Balanced usage across genders',
        'conditions': ['Cardiovascular', 'Pain Relief'],
      },
      'regionalDemand': {
        'North': 'High',
        'South': 'Medium',
        'East': 'Medium',
        'West': 'High',
      },
      'complementaryProducts': ['Omeprazole', 'Vitamin C'],
      'substitutes': ['Ibuprofen', 'Naproxen'],
    },
    'Ibuprofen': {
      'peakMonths': ['March', 'April', 'October'],
      'lowMonths': ['August', 'September'],
      'demographicTrends': {
        'age': 'Popular in 25-45 age group',
        'gender': 'Slightly higher female usage',
        'conditions': ['Arthritis', 'Sports Injuries', 'Fever'],
      },
      'regionalDemand': {
        'North': 'Medium',
        'South': 'High',
        'East': 'High',
        'West': 'Medium',
      },
      'complementaryProducts': ['Paracetamol', 'Antacids'],
      'substitutes': ['Aspirin', 'Naproxen'],
    },
    'Paracetamol': {
      'peakMonths': ['June', 'July', 'December'],
      'lowMonths': ['March', 'April'],
      'demographicTrends': {
        'age': 'Universal usage across age groups',
        'gender': 'Balanced usage',
        'conditions': ['Fever', 'Headache', 'General Pain'],
      },
      'regionalDemand': {
        'North': 'High',
        'South': 'High',
        'East': 'Medium',
        'West': 'High',
      },
      'complementaryProducts': ['Vitamin C', 'Cough Syrup'],
      'substitutes': ['Ibuprofen'],
    },
  };

  // Settings data
  Map<String, dynamic> settings = {
    'notifications': true,
    'lowStockAlerts': true,
    'expiryAlerts': true,
    'autoReorder': false,
    'defaultSupplier': 'PharmaCo',
    'currency': 'USD',
    'language': 'English',
    'theme': 'Light',
    'backupFrequency': 'Daily',
    'reportGeneration': 'Weekly',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      child: InkWell(
        onTap: () => _showItemDetails(item),
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
              _buildInfoRow('Location', item['location']),
              _buildInfoRow('Category', item['category']),
              _buildInfoRow('Expiry', '${daysUntilExpiry} days'),
              _buildInfoRow('Cost', '\$${item['cost']}'),
              SizedBox(height: AppDimensions.spacing12),
              LinearProgressIndicator(
                value: item['quantity'] / (item['reorderPoint'] * 1.5),
                backgroundColor: AppColors.surfaceMedium,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                ),
                Text(item['item'], style: AppTextStyles.headline2),
                SizedBox(height: AppDimensions.spacing16),
                _buildDetailSection('Stock Information', [
                  _buildDetailRow('Current Quantity', '${item['quantity']} ${item['unit']}'),
                  _buildDetailRow('Minimum Required', '${item['minRequired']} ${item['unit']}'),
                  _buildDetailRow('Reorder Point', '${item['reorderPoint']} ${item['unit']}'),
                ]),
                _buildDetailSection('Supply Details', [
                  _buildDetailRow('Supplier', item['supplier']),
                  _buildDetailRow('Last Ordered', item['lastOrdered']),
                  _buildDetailRow('Order Frequency', item['orderFrequency']),
                  _buildDetailRow('Cost per Unit', '\$${item['cost']}'),
                ]),
                _buildDetailSection('Storage Information', [
                  _buildDetailRow('Location', item['location']),
                  _buildDetailRow('Batch Number', item['batchNumber']),
                  _buildDetailRow('Expiry Date', item['expiry']),
                ]),
                SizedBox(height: AppDimensions.spacing24),
                ElevatedButton(
                  onPressed: () => _showReorderDialog(item),
                  child: Text('Place New Order'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
          child: Text(title, style: AppTextStyles.subtitle1),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacing16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Text(value, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  void _showReorderDialog(Map<String, dynamic> item) {
    int orderQuantity = item['reorderPoint'] - item['quantity'];
    if (orderQuantity < 0) orderQuantity = item['reorderPoint'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Place New Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order details for ${item['item']}'),
            SizedBox(height: AppDimensions.spacing16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: orderQuantity.toString()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement order placement logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order placed successfully')),
              );
            },
            child: Text('Place Order'),
          ),
        ],
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

  Widget _buildAnalyticsTab() {
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

  // Replace the existing _buildPredictionTab with this enhanced version
  Widget _buildPredictionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPredictionHeader(),
          SizedBox(height: AppDimensions.spacing24),
          _buildPredictionChart(),
          SizedBox(height: AppDimensions.spacing24),
          _buildConfidenceIndicator(),
          SizedBox(height: AppDimensions.spacing24),
          _buildDetailedAnalysis(),
          SizedBox(height: AppDimensions.spacing24),
          _buildSmartRecommendations(),
          SizedBox(height: AppDimensions.spacing24),
          _buildSeasonalInsights(),
          SizedBox(height: AppDimensions.spacing24),
          _buildMarketTrends(),
        ],
      ),
    );
  }

  Widget _buildPredictionHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedItem,
                decoration: InputDecoration(
                  labelText: 'Select Item',
                  border: OutlineInputBorder(),
                ),
                items: ['All Items', ...stockItems.map((item) => item['item'] as String)]
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value!;
                  });
                },
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedTimeFrame,
                decoration: InputDecoration(
                  labelText: 'Time Frame',
                  border: OutlineInputBorder(),
                ),
                items: ['1 Month', '3 Months', '6 Months']
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTimeFrame = value!;
                  });
                },
              ),
            ),
          ],
        ),
        if (selectedItem != 'All Items') ...[
          SizedBox(height: AppDimensions.spacing16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Insights', style: AppTextStyles.subtitle1),
                  SizedBox(height: AppDimensions.spacing8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInsightTile(
                        'Trend',
                        predictionData[selectedItem]?.last['trend'] ?? 'N/A',
                        Icons.trending_up,
                      ),
                      _buildInsightTile(
                        'Confidence',
                        '${(predictionData[selectedItem]?.last['confidence'] ?? 0 * 100).toStringAsFixed(0)}%',
                        Icons.verified,
                      ),
                      _buildInsightTile(
                        'Season',
                        predictionData[selectedItem]?.last['seasonalImpact'] ?? 'N/A',
                        Icons.calendar_today,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInsightTile(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(height: AppDimensions.spacing4),
        Text(title, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.subtitle2),
      ],
    );
  }

  Widget _buildConfidenceIndicator() {
    if (selectedItem == 'All Items' || !predictionData.containsKey(selectedItem)) {
      return SizedBox.shrink();
    }

    final confidence = predictionData[selectedItem]?.last['confidence'] ?? 0.0;
    final color = confidence > 0.9
        ? AppColors.success
        : confidence > 0.7
            ? AppColors.warning
            : AppColors.error;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prediction Confidence', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            LinearProgressIndicator(
              value: confidence,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              '${(confidence * 100).toStringAsFixed(1)}% confidence in predictions',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
    if (selectedItem == 'All Items' || !usagePatterns.containsKey(selectedItem)) {
      return SizedBox.shrink();
    }

    final patterns = usagePatterns[selectedItem]!;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detailed Analysis', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            _buildAnalysisRow('Peak Demand', patterns['peakMonths'].join(', ')),
            _buildAnalysisRow('Low Demand', patterns['lowMonths'].join(', ')),
            _buildAnalysisRow('Age Group', patterns['demographicTrends']['age']),
            _buildAnalysisRow('Gender Distribution', patterns['demographicTrends']['gender']),
            _buildAnalysisRow('Primary Uses', patterns['demographicTrends']['conditions'].join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.body2),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRecommendations() {
    if (selectedItem == 'All Items' || !usagePatterns.containsKey(selectedItem)) {
      return SizedBox.shrink();
    }

    final patterns = usagePatterns[selectedItem]!;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Recommendations', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: AppColors.primary),
              title: Text('Bundle Opportunities'),
              subtitle: Text('Consider stocking ${patterns['complementaryProducts'].join(' and ')} together'),
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz, color: AppColors.warning),
              title: Text('Alternative Products'),
              subtitle: Text('Keep ${patterns['substitutes'].join(' and ')} as alternatives'),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: AppColors.success),
              title: Text('Regional Focus'),
              subtitle: Text(_buildRegionalRecommendation(patterns['regionalDemand'])),
            ),
          ],
        ),
      ),
    );
  }

  String _buildRegionalRecommendation(Map<String, String> regionalDemand) {
    final highDemandRegions = regionalDemand.entries
        .where((e) => e.value == 'High')
        .map((e) => e.key)
        .toList();
    return 'Prioritize stock distribution in ${highDemandRegions.join(' and ')} regions';
  }

// ... (previous code remains the same until _buildSeasonalInsights)

  Widget _buildSeasonalInsights() {
    if (selectedItem == 'All Items' || !predictionData.containsKey(selectedItem)) {
      return SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seasonal Insights', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            Row(
              children: predictionData[selectedItem]!
                  .map((data) => Expanded(
                        child: Column(
                          children: [
                            Text(data['date'].toString().substring(5),
                                style: AppTextStyles.caption),
                            Icon(
                              _getSeasonalIcon(data['seasonalImpact']),
                              color: _getSeasonalColor(data['seasonalImpact']),
                            ),
                            Text(data['seasonalImpact'],
                                style: AppTextStyles.caption.copyWith(
                                    color: _getSeasonalColor(data['seasonalImpact']))),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: AppDimensions.spacing16),
            _buildSeasonalAdvice(),
          ],
        ),
      ),
    );
  }

  IconData _getSeasonalIcon(String impact) {
    switch (impact) {
      case 'High':
        return Icons.wb_sunny;
      case 'Medium':
        return Icons.cloud;
      case 'Low':
        return Icons.ac_unit;
      default:
        return Icons.help_outline;
    }
  }

  Color _getSeasonalColor(String impact) {
    switch (impact) {
      case 'High':
        return AppColors.success;
      case 'Medium':
        return AppColors.warning;
      case 'Low':
        return AppColors.error;
      default:
        return AppColors.neutral;
    }
  }

  Widget _buildSeasonalAdvice() {
    final patterns = usagePatterns[selectedItem]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: AppDimensions.spacing8),
        Text('Seasonal Recommendations',
            style: AppTextStyles.subtitle2),
        SizedBox(height: AppDimensions.spacing8),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildAdviceItem(
              'Peak Season Preparation',
              'Stock up before ${patterns['peakMonths'].join(', ')}',
              Icons.trending_up,
            ),
            _buildAdviceItem(
              'Inventory Optimization',
              'Reduce stock during ${patterns['lowMonths'].join(', ')}',
              Icons.trending_down,
            ),
            _buildAdviceItem(
              'Storage Planning',
              'Adjust storage capacity based on seasonal demand',
              Icons.warehouse,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdviceItem(String title, String content, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: AppDimensions.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body2),
                Text(content, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrends() {
    if (selectedItem == 'All Items' || !usagePatterns.containsKey(selectedItem)) {
      return SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Market Analysis & Trends', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            _buildTrendSection(),
            SizedBox(height: AppDimensions.spacing16),
            _buildCompetitiveAnalysis(),
            SizedBox(height: AppDimensions.spacing16),
            _buildOpportunityInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendSection() {
    final patterns = usagePatterns[selectedItem]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Demographic Trends', style: AppTextStyles.subtitle2),
        SizedBox(height: AppDimensions.spacing8),
        _buildTrendCard(
          'Age Distribution',
          patterns['demographicTrends']['age'],
          Icons.people_alt,
          AppColors.primary,
        ),
        _buildTrendCard(
          'Gender Analysis',
          patterns['demographicTrends']['gender'],
          Icons.wc,
          AppColors.success,
        ),
        _buildTrendCard(
          'Primary Conditions',
          patterns['demographicTrends']['conditions'].join(', '),
          Icons.medical_services,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildTrendCard(String title, String content, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: AppTextStyles.body2),
        subtitle: Text(content, style: AppTextStyles.caption),
      ),
    );
  }

  Widget _buildCompetitiveAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Market Position', style: AppTextStyles.subtitle2),
        SizedBox(height: AppDimensions.spacing8),
        Table(
          border: TableBorder.all(color: AppColors.divider),
          children: [
            TableRow(
              decoration: BoxDecoration(color: AppColors.surfaceMedium),
              children: [
                _buildTableHeader('Factor'),
                _buildTableHeader('Status'),
                _buildTableHeader('Action'),
              ],
            ),
            _buildTableRow(
              'Market Share',
              '32%',
              'Maintain position',
            ),
            _buildTableRow(
              'Price Point',
              'Competitive',
              'Monitor changes',
            ),
            _buildTableRow(
              'Availability',
              'High',
              'Optimize stock',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing8),
      child: Text(
        text,
        style: AppTextStyles.subtitle2,
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(String factor, String status, String action) {
    return TableRow(
      children: [
        _buildTableCell(factor),
        _buildTableCell(status),
        _buildTableCell(action),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing8),
      child: Text(
        text,
        style: AppTextStyles.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOpportunityInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Growth Opportunities', style: AppTextStyles.subtitle2),
        SizedBox(height: AppDimensions.spacing8),
        _buildOpportunityCard(
          'Market Expansion',
          'Potential for growth in East region',
          'High Priority',
          AppColors.success,
        ),
        _buildOpportunityCard(
          'Product Bundle',
          'Cross-sell with complementary products',
          'Medium Priority',
          AppColors.warning,
        ),
        _buildOpportunityCard(
          'Pricing Strategy',
          'Optimize pricing based on seasonal demand',
          'Medium Priority',
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildOpportunityCard(String title, String description, String priority, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: ListTile(
        title: Row(
          children: [
            Text(title, style: AppTextStyles.body1),
            SizedBox(width: AppDimensions.spacing8),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing8,
                vertical: AppDimensions.spacing4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Text(
                priority,
                style: AppTextStyles.caption.copyWith(color: color),
              ),
            ),
          ],
        ),
        subtitle: Text(description, style: AppTextStyles.caption),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Implement detailed opportunity view
          _showOpportunityDetails(title, description, priority);
        },
      ),
    );
  }

  void _showOpportunityDetails(String title, String description, String priority) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: AppTextStyles.subtitle2),
            Text(description, style: AppTextStyles.body2),
            SizedBox(height: AppDimensions.spacing16),
            Text('Priority:', style: AppTextStyles.subtitle2),
            Text(priority, style: AppTextStyles.body2),
            SizedBox(height: AppDimensions.spacing16),
            Text('Recommended Actions:', style: AppTextStyles.subtitle2),
            SizedBox(height: AppDimensions.spacing8),
            _buildActionItem('1. Conduct market research'),
            _buildActionItem('2. Develop implementation plan'),
            _buildActionItem('3. Set timeline and milestones'),
            _buildActionItem('4. Allocate resources'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement action plan creation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Action plan created')),
              );
            },
            child: Text('Create Action Plan'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing4),
      child: Text(text, style: AppTextStyles.body2),
    );
  }
  Widget _buildChartCard(String title, Widget chart, IconData icon) {
    return Card(
      elevation: AppDimensions.elevationSmall,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                SizedBox(width: AppDimensions.spacing8),
                Text(title, style: AppTextStyles.subtitle1),
              ],
            ),
            SizedBox(height: AppDimensions.spacing16),
            SizedBox(
              height: 300,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        // Convert to double explicitly
        maxY: (stockItems.map((item) => (item['quantity'] as int)).reduce((a, b) => a > b ? a : b)).toDouble() * 1.2,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= stockItems.length) return const Text('');
                return Text(
                  stockItems[value.toInt()]['item'].toString().substring(0, 3),
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: stockItems.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: (entry.value['quantity'] as int).toDouble(),
                color: AppColors.primary,
                width: 20,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart() {
    final Map<String, double> categoryTotals = {};
    for (var item in stockItems) {
      final category = item['category'] as String;
      // Convert int to double during calculation
      categoryTotals[category] = (categoryTotals[category] ?? 0) + (item['quantity'] as int).toDouble();
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: categoryTotals.entries.map((entry) {
          return PieChartSectionData(
            color: AppColors.primary.withOpacity(0.5 + categoryTotals.keys.toList().indexOf(entry.key) * 0.1),
            value: entry.value,
            title: '${entry.key}\n${entry.value.toInt()}',
            radius: 100,
            titleStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnPrimary),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= stockItems[0]['history'].length) return const Text('');
                return Text(
                  'Day ${value.toInt() + 1}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: stockItems.map((item) {
          // Explicitly convert to List<double>
          final List<double> history = (item['history'] as List).map((e) => (e as num).toDouble()).toList();
          return LineChartBarData(
            spots: history.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2,
            dotData: FlDotData(show: false),
          );
        }).toList(),
      ),
    );
  }

Widget _buildPredictionChart() {
  // Create a list to store all line data
  List<LineChartBarData> allLines = [];
  
  // Add a line for each stock item's predictions
  predictionData.forEach((itemName, data) {
    // Create predicted line
    List<FlSpot> predictedSpots = [];
    for (int i = 0; i < data.length; i++) {
      final predictedValue = data[i]['predicted'];
      if (predictedValue != null && predictedValue is num) {
        predictedSpots.add(FlSpot(i.toDouble(), predictedValue.toDouble()));
      }
    }
    
    // Create actual line
    List<FlSpot> actualSpots = [];
    for (int i = 0; i < data.length; i++) {
      final actualValue = data[i]['actual'];
      if (actualValue != null && actualValue is num) {
        actualSpots.add(FlSpot(i.toDouble(), actualValue.toDouble()));
      }
    }

    // Add predicted line with unique color
    allLines.add(
      LineChartBarData(
        spots: predictedSpots,
        isCurved: true,
        color: _getItemColor(itemName, true),
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        // itemName: '$itemName (Predicted)',
      ),
    );

    // Add actual line with unique color
    allLines.add(
      LineChartBarData(
        spots: actualSpots,
        isCurved: true,
        color: _getItemColor(itemName, false),
        dotData: FlDotData(show: true),
        dashArray: [5, 5], // Dashed line for actual values
        belowBarData: BarAreaData(show: false),
        // name: '$itemName (Actual)',
      ),
    );
  });

  return Column(
    children: [
      SizedBox(height: AppDimensions.spacing16),
      // Legend
      Wrap(
        spacing: AppDimensions.spacing8,
        runSpacing: AppDimensions.spacing8,
        children: predictionData.keys.expand((itemName) => [
          _buildLegendItem('$itemName (Predicted)', _getItemColor(itemName, true)),
          _buildLegendItem('$itemName (Actual)', _getItemColor(itemName, false)),
        ]).toList(),
      ),
      SizedBox(height: AppDimensions.spacing16),
      // Chart
      SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= predictionData.values.first.length) {
                      return const Text('');
                    }
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        predictionData.values.first[index]['date'].toString().substring(5),
                        style: AppTextStyles.caption,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: AppTextStyles.caption,
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: allLines,
            minY: 0,
          ),
        ),
      ),
    ],
  );
}

// Helper method to generate unique colors for each item
Color _getItemColor(String itemName, bool isPredicted) {
  final List<Color> baseColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];
  
  final int index = predictionData.keys.toList().indexOf(itemName) % baseColors.length;
  final Color baseColor = baseColors[index];
  
  return isPredicted ? baseColor : baseColor.withOpacity(0.5);
}

// Helper method to build legend items
Widget _buildLegendItem(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 4),
      Text(label, style: AppTextStyles.caption),
    ],
  );
}
  Widget _buildRecommendationsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommendations', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            ListTile(
              leading: Icon(Icons.trending_up, color: AppColors.success),
              title: Text('Stock Optimization'),
              subtitle: Text('Consider increasing stock levels for items with consistent high demand'),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: AppColors.warning),
              title: Text('Risk Management'),
              subtitle: Text('Monitor items approaching their expiry dates'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonalPatternsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seasonal Patterns', style: AppTextStyles.subtitle1),
            SizedBox(height: AppDimensions.spacing16),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Peak Seasons'),
              subtitle: Text('Historical demand peaks during winter months'),
            ),
            ListTile(
              leading: Icon(Icons.insights),
              title: Text('Trend Analysis'),
              subtitle: Text('Yearly growth rate: 15%'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection('Notifications', [
            _buildSwitchTile(
              'Enable Notifications',
              'Receive alerts for low stock and expiring items',
              settings['notifications'],
              (value) => setState(() => settings['notifications'] = value),
            ),
            _buildSwitchTile(
              'Low Stock Alerts',
              'Get notified when items are running low',
              settings['lowStockAlerts'],
              (value) => setState(() => settings['lowStockAlerts'] = value),
            ),
            _buildSwitchTile(
              'Expiry Alerts',
              'Get notified about items nearing expiration',
              settings['expiryAlerts'],
              (value) => setState(() => settings['expiryAlerts'] = value),
            ),
          ]),
          _buildSettingsSection('Ordering', [
            _buildSwitchTile(
              'Auto Reorder',
              'Automatically place orders for low stock items',
              settings['autoReorder'],
              (value) => setState(() => settings['autoReorder'] = value),
            ),
            _buildDropdownTile(
              'Default Supplier',
              'Select your primary supplier',
              settings['defaultSupplier'],
              ['PharmaCo', 'MediCorp', 'HealthPlus'],
              (value) => setState(() => settings['defaultSupplier'] = value),
            ),
          ]),
          _buildSettingsSection('System', [
            _buildDropdownTile(
              'Currency',
              'Select your preferred currency',
              settings['currency'],
              ['USD', 'EUR', 'GBP'],
              (value) => setState(() => settings['currency'] = value),
            ),
            _buildDropdownTile(
              'Language',
              'Choose your preferred language',
              settings['language'],
              ['English', 'Spanish', 'French'],
              (value) => setState(() => settings['language'] = value),
            ),
            _buildDropdownTile(
              'Theme',
              'Select application theme',
              settings['theme'],
              ['Light', 'Dark', 'System'],
              (value) => setState(() => settings['theme'] = value),
            ),
          ]),
          _buildSettingsSection('Data Management', [
            _buildDropdownTile(
              'Backup Frequency',
              'Set how often to backup your data',
              settings['backupFrequency'],
              ['Daily', 'Weekly', 'Monthly'],
              (value) => setState(() => settings['backupFrequency'] = value),
            ),
            _buildDropdownTile(
              'Report Generation',
              'Schedule automated reports',
              settings['reportGeneration'],
              ['Daily', 'Weekly', 'Monthly'],
              (value) => setState(() => settings['reportGeneration'] = value),
            ),
            ListTile(
              title: Text('Export Data'),
              subtitle: Text('Download your data as CSV'),
              trailing: Icon(Icons.download),
              onTap: () {
                // Implement export functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exporting data...')),
                );
              },
            ),
          ]),
          SizedBox(height: AppDimensions.spacing24),
          Center(
            child: Text(
              'Version 1.0.0',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
          child: Text(title, style: AppTextStyles.subtitle1),
        ),
        Card(
          child: Column(children: children),
        ),
        SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          SizedBox(height: AppDimensions.spacing8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing8,
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Stock Management',
            style: AppTextStyles.headline2.copyWith(color: AppColors.textOnPrimary)),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTextStyles.button,
          tabs: [
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.trending_up), text: 'Predictions'),
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
              showSearch(
                context: context,
                delegate: StockSearchDelegate(stockItems),
              );
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
          _buildAnalyticsTab(),
          // Predictions Tab
          _buildPredictionTab(),
          // Settings Tab
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new stock item functionality
          _showAddItemDialog();
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: AppColors.textOnPrimary),
        tooltip: 'Add New Item',
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              // Add more fields as needed
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement add item logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item added successfully')),
              );
            },
            child: Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
// Previous imports and class definitions remain the same, but now we'll add missing implementations




// Search Delegate for Stock Items
class StockSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> stockItems;

  StockSearchDelegate(this.stockItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = stockItems.where((item) =>
        item['item'].toString().toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item['item']),
          subtitle: Text('Quantity: ${item['quantity']} ${item['unit']}'),
          trailing: Text(_getStockStatus(item)),
          onTap: () {
            close(context, item['item']);
          },
        );
      },
    );
  }


  String _getStockStatus(Map<String, dynamic> item) {
    if (item['quantity'] <= item['minRequired']) {
      return 'Low';
    } else if (item['quantity'] <= item['reorderPoint']) {
      return 'Medium';
    }
    return 'Good';
  }
}