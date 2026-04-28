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

      // 2. Loop through items
      for (var item in items) {
        int pId = item['product_id'];
        int qty = int.parse(item['quantity'].toString());
        double sPrice = double.parse(item['price'].toString());
        double cPrice = double.parse(item['cost'].toString()); 

        totalQtySoldInThisSale += qty;

        // A. Decrease Product Stock
        await conn.query('UPDATE products SET current_stock = current_stock - ? WHERE id = ?', [qty, pId]);

        // B. Get Product Name
        var productRes = await conn.query('SELECT name FROM products WHERE id = ?', [pId]);
        String productName = productRes.first[0].toString();

        // C. FIX: DYNAMIC JSON UPDATE
        // Using CONCAT and JSON_QUOTE ensures names like "Camon 20" work perfectly
        await conn.query('''
          UPDATE staff 
          SET sold_items_summary = JSON_SET(
            IFNULL(sold_items_summary, JSON_OBJECT()), 
            CONCAT('\$.', JSON_QUOTE(?)), 
            CAST(IFNULL(JSON_EXTRACT(sold_items_summary, CONCAT('\$.', JSON_QUOTE(?))), 0) AS UNSIGNED) + ?
          ) 
          WHERE id = ?
        ''', [productName, productName, qty, staffId]);

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
        'UPDATE staff SET total_units_sold = IFNULL(total_units_sold, 0) + ? WHERE id = ?',
        [totalQtySoldInThisSale, staffId]
      );

      await conn.query('COMMIT');
      return Response.ok(jsonEncode({'status': 'success', 'sale_id': saleId}));

    } catch (e) {
      await conn.query('ROLLBACK');
      print("ERROR: $e"); // Helpful for debugging
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    } finally {
      await conn.close();
    }
  }
}