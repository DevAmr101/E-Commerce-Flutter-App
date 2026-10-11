import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper(this._storage);

  // مفتاح حفظ الـ Token
  static const String _tokenKey = 'user_token';

  // 1. حفظ الـ Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 2. قراءة الـ Token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 3. حذف الـ Token (عند تسجيل الخروج Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // 4. التحقق مما إذا كان المستخدم مسجلاً بالفعل
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}