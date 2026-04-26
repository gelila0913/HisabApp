import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:hisab_server/database_service.dart'; 

// 1. Define the Router
final _router = Router()
  ..get('/', _rootHandler)           // Browser: General Status
  ..get('/db-test', _dbTestHandler)  // Browser: Real MySQL Connection Test
  ..post('/login', _loginHandler);   // App: Login logic for go_router

/// Route: GET /
/// Confirms the Dart server is awake.
Response _rootHandler(Request req) {
  return Response.ok(
    'HisabApp Backend is running!\nVisit /db-test to verify MySQL connection.',
    headers: {'content-type': 'text/plain'},
  );
}

/// Route: GET /db-test
/// This is the "Truth Test" for your XAMPP connection.
Future<Response> _dbTestHandler(Request request) async {
  final db = DatabaseService();
  try {
    final conn = await db.getConnection();
    // We run a simple query. If this fails, the 'catch' block triggers.
    await conn.query('SELECT 1'); 
    await conn.close();
    
    return Response.ok(
      jsonEncode({'status': 'connected', 'message': 'Dart is officially talking to XAMPP MySQL!'}),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'status': 'error', 
        'message': 'Database connection failed. Is XAMPP running?',
        'details': e.toString()
      }),
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Route: POST /login
/// Handles credentials and returns the role for go_router navigation.
Future<Response> _loginHandler(Request request) async {
  try {
    final String body = await request.readAsString();
    final Map<String, dynamic> data = jsonDecode(body);
    
    final String username = data['username'] ?? '';
    final String password = data['password'] ?? '';

    if (username.isEmpty || password.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({'status': 'error', 'message': 'Missing credentials'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final db = DatabaseService();
    final conn = await db.getConnection();

    var results = await conn.query(
      'SELECT id, role, branch_id FROM users WHERE username = ? AND password = ?',
      [username, password],
    );

    await conn.close();

    if (results.isNotEmpty) {
      final user = results.first;
      return Response.ok(
        jsonEncode({
          'status': 'success',
          'user': {
            'id': user[0],
            'role': user[1],     // 'owner' or 'cashier'
            'branch_id': user[2],
          }
        }),
        headers: {'content-type': 'application/json'},
      );
    } else {
      return Response.forbidden(
        jsonEncode({'status': 'error', 'message': 'Invalid username or password'}),
        headers: {'content-type': 'application/json'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'status': 'error', 'message': 'Server Error: $e'}),
      headers: {'content-type': 'application/json'},
    );
  }
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router);

  final server = await serve(handler, ip, port);
  
  print('--- HisabApp Full-Stack Engine ---');
  print('Server live at: http://localhost:${server.port}/');
  print('Check MySQL link: http://localhost:${server.port}/db-test');
}