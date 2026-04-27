import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class SettingsController {
  /// STEP 3: "Define your product attributes"
  /// Saves the dynamic tags (Model, Spec, etc.) from the Figma list.
  Future<Response> defineProductAttributes(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final int companyId = data['company_id'];
      final List<dynamic> attributes = data['attributes'] ?? [];

      await conn.query('START TRANSACTION');
      for (var attr in attributes) {
        await conn.query(
          'INSERT INTO product_attributes (company_id, attribute_name) VALUES (?, ?)',
          [companyId, attr.toString()],
        );
      }
      await conn.query('COMMIT');
      await conn.close();

      return Response.ok(jsonEncode({'status': 'success'}), headers: {'content-type': 'application/json'});
    } catch (e) {
      await conn.query('ROLLBACK');
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// DASHBOARD: "Create Branch"
  /// hits when the user is logged in and fills out the manual branch form.
  Future<Response> createBranch(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final String branchName = data['branch_name'];
      final int companyId = data['company_id'];
      final int userId = data['user_id'];

      var result = await conn.query(
        'INSERT INTO branches (company_id, name) VALUES (?, ?)',
        [companyId, branchName],
      );
      final int newBranchId = result.insertId!;

      // Link the current user to this newly created branch
      await conn.query('UPDATE users SET branch_id = ? WHERE id = ?', [newBranchId, userId]);

      await conn.close();
      return Response.ok(jsonEncode({'status': 'success', 'branch_id': newBranchId}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }
}