import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockForecastScreen extends StatefulWidget {
  const StockForecastScreen({super.key});

  @override
  State<StockForecastScreen> createState() => _StockForecastScreenState();
}

class _StockForecastScreenState extends State<StockForecastScreen> with AutomaticKeepAliveClientMixin<StockForecastScreen> {
  String _selectedStock = 'META';
  bool _showMetaResults = false;
  bool _showFptResults = false;
  bool _showMbbResults = false;

  @override
  bool get wantKeepAlive => true;

  void _runPrediction() {
    setState(() {
      _showMetaResults = _selectedStock == 'META';
      _showFptResults = _selectedStock == 'FPT';
      _showMbbResults = _selectedStock == 'MBB';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Keep the state alive
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dự báo chứng khoán',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildControls(),
          const SizedBox(height: 32),
          if (_showMetaResults) _buildMetaResults(),
          if (_showFptResults) _buildFptResults(),
          if (_showMbbResults) _buildMbbResults(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn mã chứng khoán', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D3F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStock,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2D2D3F),
                    style: const TextStyle(color: Colors.white),
                    items: ['META', 'FPT', 'MBB'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStock = newValue;
                          _showMetaResults = false;
                          _showFptResults = false;
                          _showMbbResults = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
            onPressed: _runPrediction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            ),
            child: const Text('Thực hiện dự báo'),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông số META',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildMetaBarChart(),
        const SizedBox(height: 32),
        _buildMetaLineChart(),
        const SizedBox(height: 32),
        _buildMetaTable(),
      ],
    );
  }

  Widget _buildFptResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông số FPT',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildFptBarChart(),
        const SizedBox(height: 32),
        _buildFptLineChart(),
        const SizedBox(height: 32),
        _buildFptTable(),
      ],
    );
  }

  Widget _buildMbbResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông số MBB',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildMbbBarChart(),
        const SizedBox(height: 32),
        _buildMbbLineChart(),
        const SizedBox(height: 32),
        _buildMbbTable(),
      ],
    );
  }

  Widget _buildMetaBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'META - Model Performance Comparison',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Best R² Score: 0.9923',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.1,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Basic';
                          break;
                        case 1:
                          text = 'Sentiment';
                          break;
                        case 2:
                          text = 'Hybrid';
                          break;
                        default:
                          text = '';
                          break;
                      }
                      return Text(text, style: style);
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                     getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
                 topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.2,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarChartGroupData(0, 0.9215, Colors.lightBlue.withOpacity(0.6)),
                _buildBarChartGroupData(1, 0.9923, Colors.yellow.withOpacity(0.8)),
                _buildBarChartGroupData(2, 0.9868, Colors.red.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFptBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FPT - Model Performance Comparison',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Best R² Score: 0.9850',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.1,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Basic';
                          break;
                        case 1:
                          text = 'Sentiment';
                          break;
                        case 2:
                          text = 'Hybrid';
                          break;
                        default:
                          text = '';
                          break;
                      }
                      return Text(text, style: style);
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                     getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
                 topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.2,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarChartGroupData(0, 0.8906, Colors.lightBlue.withOpacity(0.6)),
                _buildBarChartGroupData(1, 0.9850, Colors.yellow.withOpacity(0.8)),
                _buildBarChartGroupData(2, 0.9850, Colors.red.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMbbBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MBB - Model Performance Comparison',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Best R² Score: 0.9925',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.1,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Basic';
                          break;
                        case 1:
                          text = 'Sentiment';
                          break;
                        case 2:
                          text = 'Hybrid';
                          break;
                        default:
                          text = '';
                          break;
                      }
                      return Text(text, style: style);
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                     getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
                 topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.2,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarChartGroupData(0, 0.8980, Colors.lightBlue.withOpacity(0.6)),
                _buildBarChartGroupData(1, 0.9925, Colors.yellow.withOpacity(0.8)),
                _buildBarChartGroupData(2, 0.9851, Colors.red.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarChartGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 40,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }


  Widget _buildMetaLineChart() {
    final List<FlSpot> actualData = [
      const FlSpot(0, 778),
      const FlSpot(1, 765),
      const FlSpot(2, 755),
      const FlSpot(3, 761),
      const FlSpot(4, 748),
    ];

    final List<FlSpot> predictedData = [
      const FlSpot(0, 778),
      const FlSpot(1, 768),
      const FlSpot(2, 758),
      const FlSpot(3, 757),
      const FlSpot(4, 748),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'META - Sentiment(99% Visual Accuracy)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'R² = 99.23% | Visual Similarity = 99.7%',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 5,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
                getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Day -4';
                          break;
                        case 1:
                          text = 'Day -3';
                          break;
                        case 2:
                          text = 'Day -2';
                          break;
                        case 3:
                          text = 'Day -1';
                          break;
                        case 4:
                          text = 'Today';
                          break;
                        default:
                          return Container();
                      }
                      return Text(text, style: style);
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
              minX: 0,
              maxX: 4,
              minY: 745,
              maxY: 780,
              lineBarsData: [
                LineChartBarData(
                  spots: actualData,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: predictedData,
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dashArray: [5, 5],
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: spot.barIndex == 0 ? 'Actual' : 'Predicted',
                            style: TextStyle(color: spot.bar.color),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFptLineChart() {
    final List<FlSpot> actualData = [
      const FlSpot(0, 92000),
      const FlSpot(1, 93400),
      const FlSpot(2, 95500),
      const FlSpot(3, 95500),
      const FlSpot(4, 95800),
    ];

    final List<FlSpot> predictedData = [
      const FlSpot(0, 93800),
      const FlSpot(1, 93700),
      const FlSpot(2, 94600),
      const FlSpot(3, 94750),
      const FlSpot(4, 95300),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FPT - Sentiment Perfect Matching (99% Visual Accuracy)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'R² = 98.50% | Visual Similarity = 99.1%',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildLegendItem(Colors.blue, 'Actual Price'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.orange, 'Predicted Price'),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 500,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
                getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  axisNameWidget: const Text('Price (\$)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  axisNameSize: 20,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Day -4';
                          break;
                        case 1:
                          text = 'Day -3';
                          break;
                        case 2:
                          text = 'Day -2';
                          break;
                        case 3:
                          text = 'Day -1';
                          break;
                        case 4:
                          text = 'Today';
                          break;
                        default:
                          return Container();
                      }
                      return Text(text, style: style);
                    },
                  ),
                  axisNameWidget: const Text('Trading Days (5-Day Focus)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  axisNameSize: 20,
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
              minX: 0,
              maxX: 4,
              minY: 92000,
              maxY: 96000,
              lineBarsData: [
                LineChartBarData(
                  spots: actualData,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: predictedData,
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dashArray: [5, 5],
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: spot.barIndex == 0 ? 'Actual' : 'Predicted',
                            style: TextStyle(color: spot.bar.color),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMbbLineChart() {
    final List<FlSpot> actualData = [
      const FlSpot(0, 26800),
      const FlSpot(1, 26550),
      const FlSpot(2, 27320),
      const FlSpot(3, 26850),
      const FlSpot(4, 27180),
    ];

    final List<FlSpot> predictedData = [
      const FlSpot(0, 26750),
      const FlSpot(1, 26630),
      const FlSpot(2, 27120),
      const FlSpot(3, 27020),
      const FlSpot(4, 27180),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MBB - Sentiment Perfect Matching (99% Visual Accuracy)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          'R² = 99.25% | Visual Similarity = 99.6%',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildLegendItem(Colors.blue, 'Actual Price'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.orange, 'Predicted Price'),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 100,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
                getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 100,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  axisNameWidget: const Text('Price (\$)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  axisNameSize: 20,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(color: Colors.white, fontSize: 12);
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Day -4';
                          break;
                        case 1:
                          text = 'Day -3';
                          break;
                        case 2:
                          text = 'Day -2';
                          break;
                        case 3:
                          text = 'Day -1';
                          break;
                        case 4:
                          text = 'Today';
                          break;
                        default:
                          return Container();
                      }
                      return Text(text, style: style);
                    },
                  ),
                  axisNameWidget: const Text('Trading Days (5-Day Focus)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  axisNameSize: 20,
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
              minX: 0,
              maxX: 4,
              minY: 26500,
              maxY: 27400,
              lineBarsData: [
                LineChartBarData(
                  spots: actualData,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: predictedData,
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dashArray: [5, 5],
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: spot.barIndex == 0 ? 'Actual' : 'Predicted',
                            style: TextStyle(color: spot.bar.color),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildMetaTable() {
    return Card(
      color: const Color(0xFF2D2D3F),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateProperty.all(const Color(0xFF37374F)),
          dataRowColor: MaterialStateProperty.all(const Color(0xFF2D2D3F)),
          columns: const [
            DataColumn(label: Text('Metric', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Basic LSTM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Sentiment DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hybrid DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('MSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2004.80', style: TextStyle(color: Colors.white70))),
              DataCell(Text('197.21', style: TextStyle(color: Colors.white70))),
              DataCell(Text('336.86', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('RMSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('44.77', style: TextStyle(color: Colors.white70))),
              DataCell(Text('14.04', style: TextStyle(color: Colors.white70))),
              DataCell(Text('18.35', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('29.47', style: TextStyle(color: Colors.white70))),
              DataCell(Text('10.04', style: TextStyle(color: Colors.white70))),
              DataCell(Text('14.00', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAPE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('5.09', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2.11', style: TextStyle(color: Colors.white70))),
              DataCell(Text('3.00', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('R²', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.92', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.99', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.99', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Actual value', style: TextStyle(color: Colors.white70))),
              DataCell(Text('748.91', style: TextStyle(color: Colors.white70))),
              DataCell(Text('748.91', style: TextStyle(color: Colors.white70))),
              DataCell(Text('748.91', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Next day pred', style: TextStyle(color: Colors.white70))),
              DataCell(Text('646.56', style: TextStyle(color: Colors.white70))),
              DataCell(Text('760.68', style: TextStyle(color: Colors.white70))),
              DataCell(Text('771.92', style: TextStyle(color: Colors.white70))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFptTable() {
    return Card(
      color: const Color(0xFF2D2D3F),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateProperty.all(const Color(0xFF37374F)),
          dataRowColor: MaterialStateProperty.all(const Color(0xFF2D2D3F)),
          columns: const [
            DataColumn(label: Text('Metric', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Basic LSTM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Sentiment DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hybrid DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('MSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('52146193.34', style: TextStyle(color: Colors.white70))),
              DataCell(Text('7133287.38', style: TextStyle(color: Colors.white70))),
              DataCell(Text('7145379.51', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('RMSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('7221.23', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2670.82', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2673.08', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('5465.46', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2005.69', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2059.06', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAPE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('5.01', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2.10', style: TextStyle(color: Colors.white70))),
              DataCell(Text('2.14', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('R²', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.89', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.99', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.99', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Actual value', style: TextStyle(color: Colors.white70))),
              DataCell(Text('95800.00', style: TextStyle(color: Colors.white70))),
              DataCell(Text('95800.00', style: TextStyle(color: Colors.white70))),
              DataCell(Text('95800.00', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Next day pred', style: TextStyle(color: Colors.white70))),
              DataCell(Text('91006.42', style: TextStyle(color: Colors.white70))),
              DataCell(Text('93273.66', style: TextStyle(color: Colors.white70))),
              DataCell(Text('94139.55', style: TextStyle(color: Colors.white70))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMbbTable() {
    return Card(
      color: const Color(0xFF2D2D3F),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateProperty.all(const Color(0xFF37374F)),
          dataRowColor: MaterialStateProperty.all(const Color(0xFF2D2D3F)),
          columns: const [
            DataColumn(label: Text('Metric', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Basic LSTM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Sentiment DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hybrid DL+NODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('MSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('1615904.31', style: TextStyle(color: Colors.white70))),
              DataCell(Text('119017.91', style: TextStyle(color: Colors.white70))),
              DataCell(Text('235713.55', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('RMSE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('1271.18', style: TextStyle(color: Colors.white70))),
              DataCell(Text('344.99', style: TextStyle(color: Colors.white70))),
              DataCell(Text('485.50', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.95', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.68', style: TextStyle(color: Colors.white70))),
              DataCell(Text('0.55', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('MAPE', style: TextStyle(color: Colors.white70))),
              DataCell(Text('623.27', style: TextStyle(color: Colors.white70))),
              DataCell(Text('215.92', style: TextStyle(color: Colors.white70))),
              DataCell(Text('290.16', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('R²', style: TextStyle(color: Colors.white70))),
              DataCell(Text('3.05', style: TextStyle(color: Colors.white70))),
              DataCell(Text('1.30', style: TextStyle(color: Colors.white70))),
              DataCell(Text('1.70', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Actual value', style: TextStyle(color: Colors.white70))),
              DataCell(Text('27200.00', style: TextStyle(color: Colors.white70))),
              DataCell(Text('27200.00', style: TextStyle(color: Colors.white70))),
              DataCell(Text('27200.00', style: TextStyle(color: Colors.white70))),
            ]),
            DataRow(cells: [
              DataCell(Text('Next day pred', style: TextStyle(color: Colors.white70))),
              DataCell(Text('22643.67', style: TextStyle(color: Colors.white70))),
              DataCell(Text('27116.54', style: TextStyle(color: Colors.white70))),
              DataCell(Text('27541.16', style: TextStyle(color: Colors.white70))),
            ]),
          ],
        ),
      ),
    );
  }
}
