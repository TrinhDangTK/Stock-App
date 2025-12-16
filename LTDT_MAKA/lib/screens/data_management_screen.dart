import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart' hide Border; 
import 'package:flutter/material.dart' as material; 
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  // Data for Raw Table
  List<Map<String, String>> _rawData = [];
  final String _assetInputPath = 'input_data/';

  Future<void> _loadDataFromAssets() async {
    try {
      // 1. Lấy danh sách assets bằng API mới
      final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> assets = assetManifest.listAssets();
      
      // 2. Lọc ra các file nằm trong input_data/
      List<String> inputFiles = assets
          .where((key) => key.startsWith(_assetInputPath))
          .where((key) => key.endsWith('.xlsx') || key.endsWith('.xls') || key.endsWith('.csv'))
          .toList();

      if (inputFiles.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy file dữ liệu nào trong Assets (input_data/).')),
          );
        }
        return;
      }

      // 3. Đọc file đầu tiên tìm thấy
      String targetFile = inputFiles.first;
      print('Loading asset: $targetFile');

      // 4. Load file content
      ByteData data = await rootBundle.load(targetFile);
      List<int> bytes = data.buffer.asUint8List();
      
      await _processFileContent(bytes, targetFile);

    } catch (e) {
      print('Error loading assets: $e');
      // Fallback cho Flutter version cũ hơn nếu AssetManifest.loadFromAssetBundle không có
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        List<String> inputFiles = manifestMap.keys
            .where((key) => key.startsWith(_assetInputPath))
            .where((key) => key.endsWith('.xlsx') || key.endsWith('.xls') || key.endsWith('.csv'))
            .toList();
            
        if (inputFiles.isNotEmpty) {
           String targetFile = inputFiles.first;
           ByteData data = await rootBundle.load(targetFile);
           List<int> bytes = data.buffer.asUint8List();
           await _processFileContent(bytes, targetFile);
           return;
        }
      } catch (e2) {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi tải assets: $e')),
          );
        }
      }
    }
  }

  Future<void> _processFileContent(List<int> bytes, String fileName) async {
    List<Map<String, String>> newData = [];
    int idCounter = 0; 
    
    String lowerName = fileName.toLowerCase();

    if (lowerName.endsWith('.csv')) {
      try {
        String csvContent = utf8.decode(bytes);
        List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);
        newData = _processRows(rows, refIdCounter: idCounter);
      } catch (e) {
        print('Error reading CSV: $e');
      }
    } else {
      try {
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet == null) continue;
          
          List<List<dynamic>> rows = [];
          for (var row in sheet.rows) {
            rows.add(row.map((cell) => cell?.value).toList());
          }
          
          newData = _processRows(rows, refIdCounter: idCounter);
          break; 
        }
      } catch (e) {
        print('Error reading Excel: $e');
      }
    }

    setState(() {
      _rawData = newData;
    });

    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tải ${newData.length} dòng dữ liệu từ $fileName')),
      );
    }
  }

  List<Map<String, String>> _processRows(List<List<dynamic>> rows, {required int refIdCounter}) {
    List<Map<String, String>> result = [];
    bool isFirstRow = true;
    int localCounter = refIdCounter;

    for (var row in rows) {
      if (isFirstRow) {
        isFirstRow = false;
        continue; // Skip header
      }

      String getCellValue(int index) {
        if (index < row.length && row[index] != null) {
           return row[index].toString();
        }
        return '';
      }

      String createdAt = getCellValue(0);
      String header = getCellValue(1);
      String content = getCellValue(2);

      if (createdAt.isNotEmpty || header.isNotEmpty || content.isNotEmpty) {
        result.add({
          'id': localCounter.toString(),
          'createdAt': createdAt,
          'header': header,
          'content': content,
        });
        localCounter++;
      }
    }
    return result;
  }
  
  void _resetData() {
    setState(() {
      _rawData = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa toàn bộ dữ liệu')),
    );
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _loadDataFromAssets,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D3F),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('Cào dữ liệu'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _resetData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C), // Dark red for reset
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('Reset dữ liệu'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Table 1: Raw Data
          const Text(
            'Dữ liệu vào được từ Báo đầu tư',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return _buildRawDataTable(context, constraints.maxWidth);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRawDataTable(BuildContext context, double maxWidth) {
    return _buildTableContainer(
      context,
      ConstrainedBox(
        constraints: BoxConstraints(minWidth: maxWidth),
        child: DataTable(
          columnSpacing: 10,
          horizontalMargin: 10,
          columns: const [
            DataColumn(
              label: Text('#'),
            ),
            DataColumn(
              label: Text('Created At'),
            ),
            DataColumn(
              label: Expanded(child: Text('Header')),
            ),
            DataColumn(
              label: Expanded(child: Text('Content')),
            ),
          ],
          rows: _rawData.map((row) {
            return DataRow(cells: [
              DataCell(Text(row['id'] ?? '')),
              DataCell(Text(row['createdAt'] ?? '')),
              DataCell(
                Container(
                  width: maxWidth * 0.3,
                  child: Text(row['header'] ?? '', overflow: TextOverflow.ellipsis),
                ),
              ),
              DataCell(
                Container(
                  width: maxWidth * 0.4,
                  child: Text(row['content'] ?? '', overflow: TextOverflow.ellipsis),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTableContainer(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D3F),
        borderRadius: BorderRadius.circular(8),
        border: material.Border.all(color: Colors.white10), // Explicitly use material.Border
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.white10,
          dataTableTheme: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.05)),
            dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              return null; // Use default
            }),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              fontSize: 13,
            ),
            dataTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: child,
        ),
      ),
    );
  }
}
