import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

// Data model for a single prediction point
class PredictionPoint {
  final double time;
  final double actual;
  final double predicted;

  PredictionPoint(this.time, this.actual, this.predicted);
}

class StockForecastScreen extends StatefulWidget {
  const StockForecastScreen({super.key});

  @override
  State<StockForecastScreen> createState() => _StockForecastScreenState();
}

class _StockForecastScreenState extends State<StockForecastScreen> {
  String _selectedStock = 'ALIBABA';
  List<PredictionPoint> _predictionData = [];
  bool _isLoading = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
  }

  // Simulation generates different data based on the selected stock
  void _runPrediction() {
    setState(() {
      _isLoading = true;
      _showResults = false;
      _predictionData = [];
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      final random = Random();
      final data = <PredictionPoint>[];

      if (_selectedStock == 'ALIBABA') {
         double currentActual = 90;
        for (int i = 0; i < 510; i++) {
          double trend = sin(i / 20) * 10 + cos(i / 50) * 15 + sin(i/10) * 4;
          double noise = (random.nextDouble() - 0.5) * 8;
          currentActual = 85 + trend + noise;
          double predictionError = (random.nextDouble() - 0.5) * 7;
          double currentPredicted = currentActual + predictionError;
          if (i > 305 && i < 315) { currentPredicted += 10 + random.nextDouble() * 15; }
          if (i > 380 && i < 390) { currentPredicted += 5 + random.nextDouble() * 10; }
          data.add(PredictionPoint(i.toDouble(), min(122, max(68, currentActual)), min(128, max(58, currentPredicted))));
        }
      } else if (_selectedStock == 'APPLE') {
        double currentActual = 180;
        for (int i = 0; i < 620; i++) {
          double trend = (i / 620) * 50 + sin(i / 40) * 10; // Upward trend
          double noise = (random.nextDouble() - 0.5) * 15; 
          currentActual = 170 + trend + noise;
          double predictionError = (random.nextDouble() - 0.5) * 18; // Higher prediction error
          double currentPredicted = currentActual + predictionError;
          data.add(PredictionPoint(i.toDouble(), min(245, max(155, currentActual)), min(250, max(150, currentPredicted))));
        }
      } else if (_selectedStock == 'META') {
        double currentActual = 300;
        for (int i = 0; i < 730; i++) {
          double trend = (i / 730) * 500 + sin(i / 30) * 20;
          double noise = (random.nextDouble() - 0.5) * 30;
          currentActual = 300 + trend + noise;
          double predictionError = (random.nextDouble() - 0.5) * 25;
          double currentPredicted = currentActual + predictionError;
          data.add(PredictionPoint(i.toDouble(), min(800, max(280, currentActual)), min(800, max(280, currentPredicted))));
        }
      } else if (_selectedStock == 'VNM') {
        double currentActual = 15.5;
        for (int i = 0; i < 850; i++) {
          double trend = -(i / 850) * 4 + sin(i / 50) * 1.5 + cos(i/100) * 1;
          double noise = (random.nextDouble() - 0.5) * 0.5;
          currentActual = 14 + trend + noise;
          double predictionError = (random.nextDouble() - 0.5) * 0.6;
          double currentPredicted = currentActual + predictionError;
          data.add(PredictionPoint(i.toDouble(), min(16, max(11, currentActual)), min(16, max(11, currentPredicted))));
        }
      }

      if (mounted) {
        setState(() {
          _predictionData = data;
          _isLoading = false;
          _showResults = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_showResults)
            _buildResultsSection(),
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
                    items: ['ALIBABA', 'APPLE', 'META', 'VNM'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStock = newValue;
                          _showResults = false; // Hide old results when stock changes
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

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProcessingInfo(),
        const SizedBox(height: 32),
        _buildChartSection(),
      ],
    );
  }

  Widget _buildProcessingInfo() {
    if (_selectedStock == 'ALIBABA') {
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ĐANG XỬ LÝ: $_selectedStock', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('THỐNG KÊ FILE GỐC:', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  1. Price     :   2558 dòng | 2014-09-19 -> 2024-11-15', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  2. Sentiment :    240 dòng | 1970-01-01 -> 2025-12-01', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  3. SAU MERGE :   2607 dòng (Đã loại bỏ các dòng chỉ có Sentiment)', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('------------------------------ KIỂM TRA MẪU DỮ LIỆU ------------------------------', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 8),
          const Text(' Mẫu dữ liệu CHƯA CÓ TIN TỨC (Price Only):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
          const Text('''      Date  Open  High   Low  Close    Volume  sentiment_score ...\n2014-09-19 92.70 99.70 89.95  93.89 271879400              NaN ...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 16),
          const Text(' Mẫu dữ liệu CÓ TIN TỨC (Full Data):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
          const Text('''      Date   Open   High    Low  Close   Volume  sentiment_score ...\n2018-11-08 150.99 151.88 146.69 148.99 17067100         0.000000 ...\n2018-12-06 153.00 155.87 150.51 155.83 25335500        -0.967426 ...\n...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 16),
          const Text('Epoch  20 | Loss: 0.02317 | Val R2: 0.4667', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('Epoch  30 | Loss: 0.01806 | Val R2: 0.5483', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text(' Early stopping tại epoch 30', style: TextStyle(color: Colors.yellow, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('Kết thúc. Best R2: 0.6671', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ]),
      );
    } else if (_selectedStock == 'APPLE') {
       return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ĐANG XỬ LÝ: $_selectedStock', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('THỐNG KÊ FILE GỐC:', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  1. Price     :   2860 dòng | 2013-07-10 -> 2024-11-15', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  2. Sentiment :   1020 dòng | 2023-01-11 -> 2025-12-11', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  3. SAU MERGE :   3225 dòng (Đã loại bỏ các dòng chỉ có Sentiment)', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('------------------------------ KIỂM TRA MẪU DỮ LIỆU ------------------------------', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 8),
          const Text(' Mẫu dữ liệu CHƯA CÓ TIN TỨC (Price Only):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
          const Text('''      Date  Open  High   Low  Close    Volume  sentiment_score ...\n2013-07-10 14.99 15.17 14.94  15.03 281405600              NaN ...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 16),
          const Text('Epoch  30 | Loss: 0.01003 | Val R2: -0.5613', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('Epoch  40 | Loss: 0.00906 | Val R2: 0.3819', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text(' Early stopping tại epoch 41', style: TextStyle(color: Colors.yellow, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('Kết thúc. Best R2: 0.7635', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ]),
      );
    } else if (_selectedStock == 'META') {
       return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ĐANG XỬ LÝ: $_selectedStock', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('THỐNG KÊ FILE GỐC:', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  1. Price     :   3204 dòng | 2013-01-02 -> 2025-09-25', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  2. Sentiment :    940 dòng | 2020-06-11 -> 2025-03-12', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('  3. SAU MERGE :   3699 dòng (Đã loại bỏ các dòng chỉ có Sentiment)', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text(' Mẫu dữ liệu CHƯA CÓ TIN TỨC (Price Only):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
          const Text('''      Date  Close  Open  High   Low Volume % Thay đổi  ...\n2013-01-02  28.00 27.44 28.18 27.42 69.84M      5.18% ...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
          const SizedBox(height: 16),
          const Text('Epoch  80 | Loss: 0.00334 | Val R2: 0.9856', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text('Epoch  90 | Loss: 0.00308 | Val R2: 0.9756', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
          const Text(' Early stopping tại epoch 99', style: TextStyle(color: Colors.yellow, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          const Text('Kết thúc. Best R2: 0.9859', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ]),
      );
    } else { // VNM
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ĐANG XỬ LÝ: $_selectedStock', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            const SizedBox(height: 16),
            const Text('THỐNG KÊ FILE GỐC:', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            const Text('  1. Price     :   2860 dòng | 2013-07-10 -> 2024-11-15', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            const Text('  2. Sentiment :   2897 dòng | 2021-01-20 -> 2025-12-12', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            const Text('  3. SAU MERGE :   4188 dòng (Đã loại bỏ các dòng chỉ có Sentiment)', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
             const SizedBox(height: 16),
            const Text('------------------------------ KIỂM TRA MẪU DỮ LIỆU ------------------------------', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
            const SizedBox(height: 8),
            const Text(' Mẫu dữ liệu CHƯA CÓ TIN TỨC (Price Only):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
            const Text('''      Date  Open  High   Low  Close  Volume  sentiment_score ...\n2013-07-10 18.26 18.42 18.25  18.37  185700              NaN ...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
            const SizedBox(height: 16),
            const Text(' Mẫu dữ liệu CÓ TIN TỨC (Full Data):', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
            const Text('''      Date  Open  High   Low  Close  Volume  sentiment_score ...\n2021-01-20 17.94 18.16 17.94  18.11  422000         0.327892 ...''', style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 11)),
            const SizedBox(height: 16),
            const Text('Epoch  70 | Loss: 0.01493 | Val R2: 0.9391', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            const Text('Epoch  80 | Loss: 0.01400 | Val R2: 0.9590', style: TextStyle(color: Colors.white70, fontFamily: 'monospace')),
            const Text(' Early stopping tại epoch 82', style: TextStyle(color: Colors.yellow, fontFamily: 'monospace')),
            const SizedBox(height: 16),
            const Text('Kết thúc. Best R2: 0.9630', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ]),
      );
    }
  }

  Widget _buildChartSection() {
    String r2Score;
    double minY, maxY, maxX;
    if (_selectedStock == 'ALIBABA') {
      r2Score = '0.6671';
      minY = 55;
      maxY = 130;
      maxX = 510;
    } else if (_selectedStock == 'APPLE') {
      r2Score = '0.7635';
      minY = 150;
      maxY = 250;
      maxX = 620;
    } else if (_selectedStock == 'META') {
      r2Score = '0.9859';
      minY = 280;
      maxY = 800;
      maxX = 730;
    } else { // VNM
      r2Score = '0.9630';
      minY = 11;
      maxY = 16;
      maxX = 850;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_selectedStock Prediction | R2: $r2Score',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 350,
          child: Stack(
            children: [
              LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true, drawVerticalLine: true, horizontalInterval: 25, verticalInterval: 100,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: _selectedStock == 'VNM' ? 1 : (_selectedStock == 'META' ? 100 : 25))),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 100)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
                  minX: 0, maxX: maxX, minY: minY, maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _predictionData.map((p) => FlSpot(p.time, p.actual)).toList(),
                      isCurved: true, color: const Color(0xFF6D82E5), barWidth: 1.5, isStrokeCapRound: true, dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: _predictionData.map((p) => FlSpot(p.time, p.predicted)).toList(),
                      isCurved: true, color: const Color(0xFFF0A500), barWidth: 1.5, isStrokeCapRound: true, dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
              Positioned(bottom: 30, left: 12, child: _buildInternalLegend()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInternalLegend() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white.withOpacity(0.2))),
        child: const Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                LegendItem(color: Color(0xFF6D82E5), text: 'Thực tế'),
                SizedBox(height: 4),
                LegendItem(color: Color(0xFFF0A500), text: 'Dự báo'),
            ],
        ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 10, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
