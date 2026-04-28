import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class SalesController {
  
  Future<Response> recordSale(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      
      final int branchId = data['branch_id'];
      final int userId = data['user_id'];
      final int staffId = data['staff_id']; 
      final double totalAmount = double.parse(data['total_amount'].toString());
      final String customerName = data['customer_name'] ?? 'Walk-in';
      final List items = data['items']; 

      await conn.query('START TRANSACTION');

      // 1. Create the Main Sale Record
      var saleResult = await conn.query(
        'INSERT INTO sales (branch_id, user_id, total_amount, customer_name) VALUES (?, ?, ?, ?)',
        [branchId, userId, totalAmount, customerName]
      );
      final int saleId = saleResult.insertId!;

      int totalQtySoldInThisSale = 0;

      // 2. Loop through items to update inventory and staff performance breakdown
      for (var item in items) {
        int pId = item['product_id'];
        int qty = int.parse(item['quantity'].toString());
        double sPrice = double.parse(item['price'].toString());
        double cPrice = double.parse(item['cost'].toString()); 

        totalQtySoldInThisSale += qty;

        // A. Decrease Product Stock
        await conn.query('UPDATE products SET current_stock = current_stock - ? WHERE id = ?', [qty, pId]);

        // B. Get Product Name to use as a key in the JSON summary
        var productRes = await conn.query('SELECT name FROM products WHERE id = ?', [pId]);
        String productName = productRes.first['name'].toString();

        // C. DYNAMIC JSON UPDATE: Update or Add the specific product count for this staff member
        // This handles the logic: if existing count is 5 and qty is 2, result is 7
        String jsonPath = '\$."$productName"';
        await conn.query('''
          UPDATE staff 
          SET sold_items_summary = JSON_SET(
            IFNULL(sold_items_summary, JSON_OBJECT()), 
            ?, 
            (IFNULL(JSON_EXTRACT(sold_items_summary, ?), 0) + ?)
          ) 
          WHERE id = ?
        ''', [jsonPath, jsonPath, qty, staffId]);

        // D. Record individual item
        await conn.query(
          'INSERT INTO sale_items (sale_id, product_id, quantity, price_at_sale, cost_price_at_sale) VALUES (?, ?, ?, ?, ?)',
          [saleId, pId, qty, sPrice, cPrice]
        );

        // E. Log to inventory_transactions
        await conn.query('INSERT INTO inventory_transactions (product_id, user_id, type, quantity) VALUES (?, ?, "sale", ?)', [pId, userId, qty]);
      }

      // 3. Update the staff member's total units count
      await conn.query(
        'UPDATE staff SET total_units_sold = total_units_sold + ? WHERE id = ?',
        [totalQtySoldInThisSale, staffId]
      );

      await conn.query('COMMIT');
      return Response.ok(jsonEncode({'status': 'success', 'sale_id': saleId}));

    } catch (e) {
      await conn.query('ROLLBACK');
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }
}