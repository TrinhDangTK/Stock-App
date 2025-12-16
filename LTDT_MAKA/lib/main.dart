import 'package:flutter/material.dart';
import 'package:ltdt_maka/screens/data_management_screen.dart';
import 'package:ltdt_maka/screens/stock_forecast_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống dự báo chứng khoán',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF766656), // Mocha Mousse
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF766656),
          brightness: Brightness.dark, // Dark theme as per image
        ).copyWith(
          primary: const Color(0xFF766656),
          surface: const Color(0xFF1E1E2E),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E1E2E), // Dark background
        cardTheme: CardThemeData(
          color: const Color(0xFF2D2D3F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const IntroductionScreen(),
    const StockForecastScreen(),
    const DataManagementScreen(),
    const PlaceholderScreen(title: 'Cài đặt hệ thống'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Giới thiệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Dự báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Dữ liệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2D2D3F),
      ),
    );
  }
}

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Hệ thống dự báo chứng khoán',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chào mừng đến với Hệ thống Dự báo Chứng khoán Báo Đầu Tư',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
            ),
            child: const Text(
              'Hệ thống này được thiết kế để cung cấp các công cụ mạnh mẽ cho việc phân tích và dự báo giá cổ phiếu, kết hợp giữa các mô hình học máy tiên tiến và dữ liệu tài chính từ các nguồn đáng tin cậy.',
              style: TextStyle(color: Colors.white, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Các chức năng chính:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            icon: Icons.trending_up,
            title: '1. Dự báo giá cổ phiếu',
            description: '• Dự báo đa mô hình: Sử dụng các mô hình Random Forest, XGBoost, LightGBM và Decision Tree.\n• Trực quan hóa tương tác: Biểu đồ giá lịch sử và dự báo.\n• Tích hợp Báo Đầu Tư: Neo dự báo theo các điểm dữ liệu uy tín.',
          ),
          _buildFeatureCard(
            context,
            icon: Icons.storage,
            title: '2. Quản lý dữ liệu',
            description: '• Cập nhật tự động: Công cụ để cào và xử lý dữ liệu mới từ trang Báo Đầu Tư.\n• Xem dữ liệu thô: Truy cập và xem lại các bảng dữ liệu đã được thu thập.',
          ),
          _buildFeatureCard(
            context,
            icon: Icons.settings,
            title: '3. Cài đặt hệ thống',
            description: '• Huấn luyện lại mô hình: Tùy chọn để huấn luyện lại tất cả các mô hình trên bộ dữ liệu mới nhất.\n• Thông tin gỡ lỗi: Hiển thị thông tin chi tiết về quá trình hoạt động.',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20), // Green button
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Vui lòng chọn một chức năng từ Menu chức năng ở thanh bên để bắt đầu!',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
