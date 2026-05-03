import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Branch Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExportArchivePage(),
      routes: {
        '/export-archive': (context) => const ExportArchivePage(),
      },
    );
  }
}

class ExportArchivePage extends StatefulWidget {
  const ExportArchivePage({super.key});

  @override
  State<ExportArchivePage> createState() => _ExportArchivePageState();
}

class _ExportArchivePageState extends State<ExportArchivePage> {
  // Search functionality: stores the entered date (YYYY-MM-DD)
  String _searchQuery = '';

  // Sample data for the report boxes
  final List<Map<String, dynamic>> _allReports = [
    {
      'date': '2026-04-08',
      'branch': 'Goro',
      'amount': '\$90,000',
      'units': '3 units',
      'products': '2 products',
      'cost': '\$0 cost',
      'status': 'pending',
      'statusColor': Colors.amber.shade700,
    },
    {
      'date': '2026-04-08',
      'branch': 'CBE',
      'amount': '\$60,000',
      'units': '3 units',
      'products': '1 product',
      'cost': '\$200 cost',
      'status': 'deposited',
      'statusColor': Colors.green,
    }
  ];

  // Filter reports based on search query (YYYY-MM-DD)
  List<Map<String, dynamic>> get _filteredReports {
    if (_searchQuery.isEmpty) return _allReports;
    return _allReports.where((report) {
      return report['date'].toString().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Export / Archive'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading: Export / Archive
            const Text(
              'Export / Archive',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),

            Opacity(
              opacity: 0.5,
              child: const Text(
                'Closed and archive daily reports',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Search rectangular component (FUNCTIONAL)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade500, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by date (YYYY-MM-DD)',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // List of report boxes
            Expanded(
              child: _filteredReports.isEmpty
                  ? Center(
                      child: Opacity(
                        opacity: 0.5,
                        child: Text(
                          'No reports found for $_searchQuery',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredReports.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final report = _filteredReports[index];
                        return _buildReportBox(report);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportBox(Map<String, dynamic> report) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // First column: Export file icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.file_upload_outlined,
              size: 28,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),

          // Second column: Branch, money, date, units, products, cost
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text(
                  report['date'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Branch and amount (branch + bold amount)
                Row(
                  children: [
                    Text(
                      report['branch'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      report['amount'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Units, products, and cost (low opacity)
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${report['units']} • ${report['products']} • ${report['cost']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Third column: Status (with background color)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: report['statusColor'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  report['status'] == 'pending' ? Icons.access_time : Icons.check_circle,
                  size: 14,
                  color: report['statusColor'],
                ),
                const SizedBox(width: 6),
                Text(
                  report['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: report['statusColor'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}