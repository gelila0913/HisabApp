import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/database_service.dart';

class AuthController {
  /// STEP 1 & 2: "Select Role" & "Business Category"
  Future<Response> registerBusiness(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final String companyName = data['business_name'] ?? 'My Business';
      final String businessType = data['business_type'] ?? 'General';

      var result = await conn.query(
        'INSERT INTO companies (company_name, business_type) VALUES (?, ?)',
        [companyName, businessType],
      );

      final int newCompanyId = result.insertId!;
      await conn.close();

      return Response.ok(
        jsonEncode({
          'status': 'success',
          'company_id': newCompanyId,
          'message': 'Business profile created'
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// STEP 4: "Create Account"
  Future<Response> signUp(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      
      final String username = data['username'];
      final String password = data['password'];
      final String role = data['role']; 
      final int companyId = data['company_id'];

      await conn.query(
        'INSERT INTO users (username, password, role, company_id, branch_id) VALUES (?, ?, ?, ?, NULL)',
        [username, password, role, companyId],
      );

      await conn.close();
      return Response.ok(
        jsonEncode({'status': 'success', 'message': 'Account successfully created!'}),
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  /// NEW: LOGIN LOGIC
  /// Checks credentials and returns user context.
  Future<Response> login(Request request) async {
    final db = DatabaseService();
    final conn = await db.getConnection();

    try {
      final Map<String, dynamic> data = jsonDecode(await request.readAsString());
      final String username = data['username'];
      final String password = data['password'];

      // Fetch user and check password (plain text for now as per your request)
      var results = await conn.query(
        'SELECT id, username, role, company_id, branch_id FROM users WHERE username = ? AND password = ?',
        [username, password],
      );

      if (results.isEmpty) {
        await conn.close();
        return Response.forbidden(
          jsonEncode({'status': 'error', 'message': 'Invalid username or password'}),
          headers: {'content-type': 'application/json'}
        );
      }

      final user = results.first;
      await conn.close();

      return Response.ok(
        jsonEncode({
          'status': 'success',
          'user_id': user[0],
          'username': user[1],
          'role': user[2],
          'company_id': user[3],
          'branch_id': user[4], // If NULL, Flutter app knows to trigger branch setup
          'message': 'Login successful'
        }),
        headers: {'content-type': 'application/json'}
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }
}