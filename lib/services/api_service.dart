import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Instance unique (Singleton)
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://project.20260143.xyz',
    // baseUrl: 'http://10.0.2.2:3002',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {'Content-Type': 'application/json'},
  ));

  final _storage = const FlutterSecureStorage();

  ApiService._internal() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // TODO: Déclencher une redirection vers l'écran de login (Token expiré)
          print("Alerte: Token expiré ou invalide !");
        }
        return handler.next(e);
      },
    ));
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("Erreur Login: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await dio.delete('/api/auth/logout');
    } finally {
      await _storage.delete(key: 'auth_token');
    }
  }

  Future<Map<String, dynamic>?> getProductReviews(String productId) async {
    try {
      final response = await dio.get('/api/products/$productId/reviews');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print("Erreur récupération avis: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  Future<List<dynamic>?> getDropPacks(String dropId, {String? category}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (category != null) {
        queryParameters['category'] = category;
      }

      final response = await dio.get(
        '/api/drops/$dropId/packs',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print("Erreur récupération packs: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> generatePackCode(String packId) async {
    try {
      final response = await dio.post(
        '/api/packs/generate-code',
        data: {'packId': packId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Erreur lors de la génération du code: $e");
      return null;
    }
  }
}