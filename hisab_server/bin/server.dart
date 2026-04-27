import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// FIX: Changed 'controllers' to 'services' to match your folder move
import 'package:hisab_server/services/database_service.dart'; 
// ADD: Import your new AuthController
import 'package:hisab_server/controllers/auth_controller.dart';

void main(List<String> args) async {
  // Initialize your controller
  final authCtrl = AuthController();

  // 1. Define the Router
  final _router = Router()
    ..get('/', _rootHandler)
    ..get('/db-test', _dbTestHandler)
    ..post('/login', _loginHandler)
    // ADD: The route for registering the business name
    ..post('/register-business', authCtrl.registerBusiness); 

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router);

  final server = await serve(handler, ip, port);
  
  print('--- HisabApp Full-Stack Engine ---');
  print('Server live at: http://localhost:${server.port}/');
  print('Registration Route: http://localhost:${server.port}/register-business');
}

// --- HANDLERS ---

Response _rootHandler(Request req) {
  return Response.ok(
    'HisabApp Backend is running!',
    headers: {'content-type': 'text/plain'},
  );
}

Future<Response> _dbTestHandler(Request request) async {
  final db = DatabaseService();
  try {
    final conn = await db.getConnection();
    await conn.query('SELECT 1'); 
    await conn.close();
    return Response.ok(jsonEncode({'status': 'connected'}), headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}

Future<Response> _loginHandler(Request request) async {
  // (Your existing login logic remains the same here...)
  return Response.ok('Login logic running');
}