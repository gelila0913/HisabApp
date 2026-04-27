import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class AuthController {
  Future<Response> registerBusiness(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final String body = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(body);

      // 1. Get the name from your Flutter text input
      final String companyName = data['business_name'] ?? 'New Company';
      final String businessType = data['business_type'] ?? 'General Retail';

      // 2. Insert into the 'companies' table first
      var companyResult = await conn.query(
        'INSERT INTO companies (company_name) VALUES (?)',
        [companyName],
      );
      final int newCompanyId = companyResult.insertId!;

      // 3. Automatically create the first branch linked to this company
      // We use the newCompanyId as a Foreign Key
      var branchResult = await conn.query(
        'INSERT INTO branches (company_id, name, business_type) VALUES (?, ?, ?)',
        [newCompanyId, '$companyName - Main', businessType],
      );

      final int newBranchId = branchResult.insertId!;
      await conn.close();

      return Response.ok(
        jsonEncode({
          'status': 'success',
          'message': '$companyName registered with its main branch!',
          'company_id': newCompanyId,
          'branch_id': newBranchId, // Keep this for the next Admin Creation step
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'status': 'error', 'message': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}