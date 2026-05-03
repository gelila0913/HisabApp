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
      home: const BranchPage(),
      routes: {
        '/branch': (context) => const BranchPage(),
      },
    );
  }
}

class BranchPage extends StatelessWidget {
  const BranchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Branch Overview'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading: Branch
            const Text(
              'Branches',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            // Supporting line with low opacity, displaying two branches in numerics
            Opacity(
              opacity: 0.5,
              child: Text(
                '2 branches',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Add Branch Button - with BOLDER plus icon
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add branch tapped ')),
                  );
                },
                icon: const Icon(Icons.add, size: 18, weight: 800, color: Colors.black), // 
                label: const Text(
                  'Add Branch',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // First large box (GORO branch)
            _buildBranchCard(
              buildingIcon: Icons.business, // 
              branchName: 'GORO',
              locationText: 'GORO, Addis Ababa',
              personCode: 'Helen',
              onExportPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export GORO today (UI mock)')),
                );
              },
            ),
            const SizedBox(height: 20),
            // Second large box (CBE branch)
            _buildBranchCard(
              buildingIcon: Icons.business, // 
              branchName: 'CBE',
              locationText: 'Stadium, Addis Ababa',
              personCode: 'Helen',
              onExportPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export CBE today')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard({
    required IconData buildingIcon,
    required String branchName,
    required String locationText,
    required String personCode,
    required VoidCallback onExportPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Building icon - weight already applied
          Icon(buildingIcon, size: 42, weight: 800, color: Colors.grey.shade700),
          const SizedBox(height: 12),
          Text(
            branchName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // First line: location icon + text (low opacity)
          Opacity(
            opacity: 0.6,
            child: Row(
              children: [
                Icon(Icons.location_on, size: 18, weight: 800, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  locationText,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Second line: person icon + code (low opacity)
          Opacity(
            opacity: 0.6,
            child: Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  personCode,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Export button - elongated (wider), rectangular, golden background
          Center(
            child: ElevatedButton.icon(
              onPressed: onExportPressed,
              icon: Icon(Icons.file_upload, size: 18, color: Colors.black),
              label: const Text(
                'Export today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}