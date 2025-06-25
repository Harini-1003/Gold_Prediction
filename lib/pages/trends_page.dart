import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../widgets/nav_bar.dart';

class TrendsPage extends StatefulWidget {
  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  List<dynamic> trendData = [];
  String selectedRange = 'week';

  @override
  void initState() {
    super.initState();
    loadTrends(selectedRange);
  }

  Future<void> loadTrends(String range) async {
    final data = await ApiService.fetchTrends(range);
    setState(() {
      trendData = data;
      selectedRange = range;
    });
  }

  // Helper method to calculate dynamic Y-axis range
  Map<String, double> _getYAxisRange() {
    if (trendData.isEmpty) return {'min': 0, 'max': 2200};

    List<double> prices = trendData.map((e) =>
    double.tryParse(e['Price'].toString()) ?? 0).toList();

    double minPrice = prices.reduce((a, b) => a < b ? a : b);
    double maxPrice = prices.reduce((a, b) => a > b ? a : b);

    // Add padding to min/max for better visualization
    double padding = (maxPrice - minPrice) * 0.1;
    return {
      'min': (minPrice - padding).clamp(0, double.infinity),
      'max': maxPrice + padding
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Orange Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE67E22), Color(0xFFD35400)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gold Predictor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'AI-Powered Price Analysis',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'INR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trends Title with Icon
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Color(0xFFE67E22),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Gold Price Trends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE67E22),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Time Range Selector
                  Row(
                    children: ["week", "month", "1y", "10y", "25y"].map((range) {
                      bool isSelected = selectedRange == range;
                      String displayText = range == "week" ? "1W" :
                      range == "month" ? "1M" :
                      range == "1y" ? "1Y" :
                      range == "10y" ? "10Y" : "25Y";

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: range != "25y" ? 8 : 0),
                          child: GestureDetector(
                            onTap: () => loadTrends(range),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFFE67E22) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  displayText,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 30),

                  // Chart
                  Expanded(
                    child: trendData.isEmpty
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE67E22),
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(right: 16, top: 16),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: null, // Let it calculate automatically
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[200]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  );
                                  // Show day numbers as in the image
                                  List<String> days = ['23', '26', '29', '1', '3', '5', '7', '9', '12', '15', '18', '21'];
                                  int index = value.toInt();
                                  if (index >= 0 && index < days.length && index < trendData.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(days[index], style: style),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: null, // Let it calculate automatically
                                reservedSize: 50,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                  );
                                  return Text('₹${value.toInt()}', style: style, textAlign: TextAlign.right);
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: (trendData.length - 1).toDouble(),
                          minY: _getYAxisRange()['min']!,
                          maxY: _getYAxisRange()['max']!,
                          lineBarsData: [
                            LineChartBarData(
                              spots: trendData.asMap().entries.map((e) {
                                double price = double.tryParse(e.value['Price'].toString()) ?? 0;
                                return FlSpot(e.key.toDouble(), price);
                              }).toList(),
                              isCurved: true,
                              color: Color(0xFFE67E22),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Color(0xFFE67E22),
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(0xFFE67E22).withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 2),
    );
  }
}