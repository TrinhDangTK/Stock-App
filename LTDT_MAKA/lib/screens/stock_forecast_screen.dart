import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StockForecastScreen extends StatefulWidget {
  const StockForecastScreen({super.key});

  @override
  State<StockForecastScreen> createState() => _StockForecastScreenState();
}

class _StockForecastScreenState extends State<StockForecastScreen> {
  String _selectedStock = 'HNX-Index';
  DateTime _startDate = DateTime(2025, 3, 3);
  DateTime _endDate = DateTime(2025, 4, 8);
  
  // Mock data
  late List<FlSpot> _actualData;
  late List<FlSpot> _rfData;
  late List<FlSpot> _xgbData;
  late List<FlSpot> _lgbData;
  late List<FlSpot> _dtData;

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    final random = Random();
    _actualData = [];
    _rfData = [];
    _xgbData = [];
    _lgbData = [];
    _dtData = [];

    double basePrice = 240.0;
    for (int i = 0; i < 30; i++) {
      double noise = (random.nextDouble() - 0.5) * 5;
      double trend = -0.5 * i; // Downward trend as seen in image
      
      double actual = basePrice + trend + noise;
      _actualData.add(FlSpot(i.toDouble(), actual));

      // Forecasts follow actual but with some deviation
      _rfData.add(FlSpot(i.toDouble(), actual + (random.nextDouble() - 0.5) * 2 - 5));
      _xgbData.add(FlSpot(i.toDouble(), actual + (random.nextDouble() - 0.5) * 2 - 3));
      _lgbData.add(FlSpot(i.toDouble(), actual + (random.nextDouble() - 0.5) * 2 - 4));
      _dtData.add(FlSpot(i.toDouble(), actual + (random.nextDouble() - 0.5) * 3 - 6));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hệ thống dự báo chứng khoán',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Warning Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D3F),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Một số file dữ liệu về đồ thị bị thiếu:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      'META_TT.csv',
                      style: TextStyle(color: Colors.yellow[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Controls
          _buildControls(),
          
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D3F),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                child: const Text('Cập nhật dự báo'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D3F),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                child: const Text('Bổ sung Báo Đầu Tư'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Text(
            'Biểu đồ dự báo chi tiết',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Chart Title
          const Text(
            'Biểu đồ giá HNX-Index',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 400,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        // Mock dates
                        final date = _startDate.add(Duration(days: value.toInt()));
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MMM d').format(date),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 29,
                minY: 180,
                maxY: 260,
                lineBarsData: [
                  // Actual Price
                  LineChartBarData(
                    spots: _actualData,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // RF Forecast
                  LineChartBarData(
                    spots: _rfData,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                  // XGB Forecast
                  LineChartBarData(
                    spots: _xgbData,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                  // LGB Forecast
                  LineChartBarData(
                    spots: _lgbData,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                  // DT Forecast
                  LineChartBarData(
                    spots: _dtData,
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF2D2D3F),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        _buildDropdown('Chọn mã chứng khoán', _selectedStock),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDatePicker('Ngày bắt đầu', _startDate)),
            const SizedBox(width: 16),
            Expanded(child: _buildDatePicker('Ngày kết thúc', _endDate)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D3F),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF2D2D3F),
              style: const TextStyle(color: Colors.white),
              items: ['HNX-Index', 'VN-Index', 'UPCOM'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStock = newValue!;
                  _generateMockData(); // Regenerate data on change
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF766656),
                      onPrimary: Colors.white,
                      surface: Color(0xFF2D2D3F),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != date) {
              setState(() {
                if (label == 'Ngày bắt đầu') {
                  _startDate = picked;
                } else {
                  _endDate = picked;
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D3F),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem('Giá thực tế', Colors.blue, isDashed: false),
        _buildLegendItem('Dự báo (Tương lai) RF', Colors.red, isDashed: true),
        _buildLegendItem('Dự báo (Tương lai) XGB', Colors.orange, isDashed: true),
        _buildLegendItem('Dự báo (Tương lai) LGB', Colors.green, isDashed: true),
        _buildLegendItem('Dự báo (Tương lai) DT', Colors.purple, isDashed: true),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {required bool isDashed}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            border: isDashed ? Border(bottom: BorderSide(color: color, width: 2, style: BorderStyle.solid)) : null, // Simplified dash
          ),
          child: isDashed 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) => Container(width: 4, height: 2, color: color)),
              )
            : null,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
