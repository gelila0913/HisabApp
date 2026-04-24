import 'package:flutter/material.dart';

// --- 1. MINIMIZED BRANCH SUMMARY CARD ---
class BranchCountCard extends StatelessWidget {
  final String count;
  const BranchCountCard({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "BRANCHES", 
                  style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)
                ),
                const SizedBox(width: 8),
                const Icon(Icons.business, size: 18, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              count, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. BRANCH/STAFF DETAIL CARD ---
class BranchStaffCard extends StatelessWidget {
  final String branchName;
  final String location;
  final String managerName;

  const BranchStaffCard({
    super.key,
    required this.branchName,
    required this.location,
    required this.managerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.business, size: 28, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            branchName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildIconLabel(Icons.location_on_outlined, location),
          const SizedBox(height: 4),
          _buildIconLabel(Icons.person_outline, managerName),
          const SizedBox(height: 16),
          // Consistent with orange "Export Today" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share, size: 18, color: Colors.black),
              label: const Text("Export Today", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623), 
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

// --- 3. PRODUCT INVENTORY CARD ---
class ProductStockCard extends StatelessWidget {
  final String name;
  final String price;
  final String units;
  final String totalUnits;

  const ProductStockCard({
    super.key,
    required this.name,
    required this.price,
    required this.units,
    required this.totalUnits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("total-$totalUnits unit", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              _buildUnitsBadge(units),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _CompactInfo(label: "Electronics", value: "Mobile"),
              SizedBox(width: 40),
              _CompactInfo(label: "Product", value: "Tecno"),
            ],
          ),
          const SizedBox(height: 8),
          const _CompactInfo(label: "Selling Price", value: ""),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Consistent with deep navy "Add Stock" button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text("Add Stock", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              const Spacer(),
              const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 15),
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUnitsBadge(String units) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
      child: Text("$units units", style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _CompactInfo extends StatelessWidget {
  final String label, value;
  const _CompactInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        if (value.isNotEmpty) Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- TESTING BLOCK ---
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            Align(alignment: Alignment.centerLeft, child: BranchCountCard(count: "2")),
            SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: BranchStaffCard(branchName: "Goro", location: "Goro, Addis Ababa", managerName: "Helen")),
            SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: ProductStockCard(name: "Camon-20", price: "\$20,000", units: "20", totalUnits: "15")),
          ],
        ),
      ),
    ),
  ));
}