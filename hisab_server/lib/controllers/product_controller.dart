import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class ProductController {
  
  /// GET: Fetch stock list for a specific branch
  /// Used to populate the cards showing 'Camon-20', '20 units', etc.
  Future<Response> getBranchProducts(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final int branchId = data['branch_id'];

      // Selecting columns based on your specific phpMyAdmin structure
      var results = await conn.query(
        '''
        SELECT id, name, brand, category, specification, selling_price, current_stock 
        FROM products 
        WHERE branch_id = ?
        ''',
        [branchId],
      );

      final products = results.map((row) => {
        'id': row[0],
        'name': row[1],
        'brand': row[2],
        'category': row[3],
        'specification': row[4],
        'selling_price': row[5],
        'units': row[6] 
      }).toList();

      await conn.close();
      return Response.ok(
        jsonEncode(products), 
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// POST: Create a brand new product entry
  /// Handles the "Add Product" form
  Future<Response> addProduct(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      
      final int branchId = data['branch_id'];
      final String name = data['product_name'] ?? ''; 
      final String brand = data['brand'] ?? '';       
      final String category = data['category'] ?? ''; 
      final String spec = data['specification'] ?? ''; 
      
      // Using .toString() to prevent "int is not a subtype of String" errors
      final double sPrice = double.parse(data['selling_price'].toString());
      final double cPrice = double.parse(data['cost_price'].toString());
      final int stock = int.parse(data['total_stock'].toString());
      
      final int lowAlert = int.parse((data['low_stock_alert'] ?? '5').toString());
      final int highAlert = int.parse((data['high_stock_alert'] ?? '10').toString());

      var result = await conn.query(
        '''
        INSERT INTO products 
        (branch_id, name, brand, category, specification, cost_price, selling_price, current_stock, total_inventory, low_stock_alert, high_stock_alert) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [branchId, name, brand, category, spec, cPrice, sPrice, stock, stock, lowAlert, highAlert],
      );

      await conn.close();
      return Response.ok(
        jsonEncode({'status': 'success', 'id': result.insertId}), 
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// POST: Update stock for an existing product
  /// Handles the "Add Stock" black button and the popup form
  Future<Response> updateStock(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      
      final int productId = data['product_id'];
      final int unitsToAdd = int.parse(data['units_to_add'].toString());
      
      // Optional: New prices if the cost changed for this specific batch
      final double? newSellingPrice = data['new_selling_price'] != null 
          ? double.parse(data['new_selling_price'].toString()) : null;
      final double? newCostPrice = data['new_cost_price'] != null 
          ? double.parse(data['new_cost_price'].toString()) : null;

      await conn.query('START TRANSACTION');

      // Update logic: Increases both current and total stock
      String query = '''
        UPDATE products 
        SET current_stock = current_stock + ?, 
            total_inventory = total_inventory + ?
      ''';
      List<dynamic> params = [unitsToAdd, unitsToAdd];

      if (newSellingPrice != null) {
        query += ", selling_price = ?";
        params.add(newSellingPrice);
      }
      if (newCostPrice != null) {
        query += ", cost_price = ?";
        params.add(newCostPrice);
      }

      query += " WHERE id = ?";
      params.add(productId);

      await conn.query(query, params);
      await conn.query('COMMIT');
      
      await conn.close();
      return Response.ok(
        jsonEncode({'status': 'success', 'message': 'Stock updated for product ID: $productId'}),
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      // Attempt to rollback if the transaction started, 
      // but wrap it in its own try-catch so it doesn't crash if connection is lost
      try {
        await conn.query('ROLLBACK');
      } catch (_) {
        // Connection might be closed, that's okay
      }
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    } finally {
      // Always close the connection to prevent memory leaks
      await conn.close();
    }
  }
}