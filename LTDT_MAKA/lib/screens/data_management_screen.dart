import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  List<String> _priceFiles = [];
  List<String> _sentimentFiles = [];

  List<List<dynamic>> _selectedFileData = [];
  List<String> _selectedFileHeaders = [];
  String? _selectedFileName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _listAssetFiles();
  }

  Future<void> _listAssetFiles() async {
    try {
      final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> allAssets = assetManifest.listAssets();
      
      // DEBUG: In ra tất cả các asset mà ứng dụng tìm thấy
      print('--- Assets Found in Bundle ---');
      print(allAssets);
      print('------------------------------');

      final priceAssets = allAssets
          .where((key) => key.startsWith('input_data/PRICE/') && key.toLowerCase().endsWith('.csv'))
          .toList();

      final sentimentAssets = allAssets
          .where((key) => key.startsWith('input_data/SENTIMENT/') && key.toLowerCase().endsWith('.csv'))
          .toList();
      
      print('Price files found: ${priceAssets.length}');
      print('Sentiment files found: ${sentimentAssets.length}');

      if (mounted) {
        setState(() {
          _priceFiles = priceAssets;
          _sentimentFiles = sentimentAssets;
        });
      }
    } catch (e) {
      print('Error listing assets: $e');
    }
  }

  Future<void> _loadFile(String assetPath) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _selectedFileName = assetPath.split('/').last;
        _selectedFileData = [];
        _selectedFileHeaders = [];
      });
    }

    try {
      final csvString = await rootBundle.loadString(assetPath);
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

      if (rows.isNotEmpty) {
        _selectedFileHeaders = rows.first.map((e) => e.toString()).toList();
        rows.removeAt(0); // Remove header
      }

      if (mounted) {
        setState(() {
          _selectedFileData = rows;
        });
      }
    } catch (e) {
      print('Error loading asset $assetPath: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dữ liệu hệ thống', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          const Text('Dữ liệu Price (Giá)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildFileListView(_priceFiles),
          const SizedBox(height: 32),
          const Text('Dữ liệu Sentiment (Cảm xúc)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildFileListView(_sentimentFiles),
          const SizedBox(height: 32),
          if (_selectedFileName != null) ...[
            Text('Nội dung file: $_selectedFileName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            _isLoading ? const Center(child: CircularProgressIndicator()) : _buildDataTable(),
          ],
        ],
      ),
    );
  }

  Widget _buildFileListView(List<String> files) {
    if (files.isEmpty) {
      return const Text('Không tìm thấy file nào. Vui lòng chạy lại ứng dụng.', style: TextStyle(color: Colors.white70));
    }
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D3F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final fileName = files[index].split('/').last;
          final isSelected = files[index].endsWith(_selectedFileName ?? '');
          return Material(
            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
            child: ListTile(
              title: Text(fileName, style: const TextStyle(color: Colors.white)),
              onTap: () => _loadFile(files[index]),
              dense: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataTable() {
    if (_selectedFileData.isEmpty) {
      return const Center(child: Text('File không có dữ liệu.', style: TextStyle(color: Colors.white70)));
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D3F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
          child: DataTable(
            columnSpacing: 20,
            columns: _selectedFileHeaders.map((header) => DataColumn(label: Text(header, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))).toList(),
            rows: _selectedFileData.map((row) => DataRow(cells: row.map((cell) => DataCell(Text(cell.toString(), style: const TextStyle(color: Colors.white)))).toList())).toList(),
          ),
        ),
      ),
    );
  }
}
