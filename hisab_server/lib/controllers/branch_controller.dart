import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class BranchController {
  
  /// GET: Returns branches with the cashier names saved as simple text
  Future<Response> getCompanyBranches(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final int companyId = data['company_id'];

      // Simplifed Query: No JOIN needed since the name is now in the branches table
      var results = await conn.query(
        'SELECT id, name, location, cashier_name FROM branches WHERE company_id = ?',
        [companyId],
      );

      final branches = results.map((row) => {
        'id': row[0],
        'branch_name': row[1],
        'location': row[2],
        'cashier_name': row[3] ?? 'Not Assigned'
      }).toList();

      await conn.close();
      return Response.ok(jsonEncode(branches), headers: {'content-type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// POST: Saves the branch and the cashier's name as a text note
  Future<Response> addBranch(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      
      // Use null-safety defaults
      final String name = data['branch_name'] ?? 'Unnamed Branch';
      final String location = data['location'] ?? 'Unknown';
      final int companyId = data['company_id'] ?? 0;
      final String cashierName = data['cashier_name'] ?? 'Not Assigned'; 

      // Just one simple INSERT. No users created.
      var result = await conn.query(
        'INSERT INTO branches (company_id, name, location, cashier_name) VALUES (?, ?, ?, ?)',
        [companyId, name, location, cashierName],
      );

      await conn.close();
      return Response.ok(
        jsonEncode({'status': 'success', 'message': 'Branch $name saved locally!'}),
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }
}