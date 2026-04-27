import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class SettingsController {
  /// Route: POST /setup/define-attributes
  /// Saves the template of dynamic product attributes defined during setup.
  Future<Response> defineProductAttributes(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final String body = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(body);

      // We need the Company ID and the list of attributes from Flutter
      final int companyId = data['company_id'];
      final List<dynamic> attributeNames = data['attributes'] ?? [];

      if (attributeNames.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'status': 'error', 'message': 'No attributes provided'}),
          headers: {'content-type': 'application/json'}
        );
      }

      // We will perform multiple inserts, so we open a transaction
      await conn.query('START TRANSACTION');

      // Loop through the list of attributes from Figma and save each one
      for (String attrName in attributeNames) {
        if (attrName.trim().isNotEmpty) {
          await conn.query(
            'INSERT INTO product_attributes (company_id, attribute_name) VALUES (?, ?)',
            [companyId, attrName.trim()],
          );
        }
      }

      // If all inserts succeeded, commit the transaction
      await conn.query('COMMIT');
      await conn.close();

      return Response.ok(
        jsonEncode({
          'status': 'success',
          'message': 'Product attributes template saved successfully for company #$companyId'
        }),
        headers: {'content-type': 'application/json'},
      );

    } catch (e) {
      // If any insert fails (e.g., unique key violation), rollback everything
      await conn.query('ROLLBACK');
      await conn.close();
      
      // Catch specific duplicate errors
      if (e.toString().contains('Duplicate entry')) {
        return Response.badRequest(
            body: jsonEncode({'status': 'error', 'message': 'One or more of these attributes already exist for your company.'}),
            headers: {'content-type': 'application/json'}
        );
      }

      return Response.internalServerError(
        body: jsonEncode({'status': 'error', 'message': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}