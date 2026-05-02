import 'package:flutter/material.dart';

class CashierDashboard extends StatelessWidget {
  const CashierDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.menu, color: Colors.black87, size: 28),
        ),
        title: Row(
          children: [
            const Icon(Icons.shopping_cart_checkout, color: Color(0xFFF2A007), size: 24),
            const SizedBox(width: 8),
            Text(
              "HisabApp",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cashier Dashboard",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Wednesday, April 8, 2026",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Record Sale Button
            SizedBox(
              width: 170,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  // This is where you'll trigger your BLoC event to navigate to the Sale Screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2A007), // Golden-orange from photo_1_2026-04-27_12-57-04_2.jpg
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: const Text(
                  "Record sale",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2x2 Stats Grid (No external SummaryCard widget)
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              children: [
                _buildStatTile("Total Product", "50", const Icon(Icons.inventory_2_outlined, color: Colors.black87)),
                _buildStatTile("Today's Income", "\$90,000", const Icon(Icons.trending_up, color: Color(0xFF4CAF50))),
                _buildStatTile("Low Stock", "50", const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB74D))),
                _buildStatTile("Today's cost", "\$200", const Icon(Icons.attach_money, color: Color(0xFFE57373))),
              ],
            ),
            const SizedBox(height: 32),

            // Low Stock Alerts Container
            _buildSectionBox("Low Stock Alerts", "All Stock levels are healthy"),
            const SizedBox(height: 20),

            // Recent Sales Container
            _buildSectionBox("Recent Sales", "No recent Sales."),
          ],
        ),
      ),
    );
  }

  // Helper for the grid items to maintain a flat file structure
  Widget _buildStatTile(String label, String value, Widget icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ),
              icon,
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Helper for the wide information containers
  Widget _buildSectionBox(String title, String placeholder) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              placeholder,
              style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
