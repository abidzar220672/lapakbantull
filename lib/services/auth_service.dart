import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reqres_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with Firebase + ReqRes
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Register ke ReqRes API (hanya mendukung email tertentu, toleran error)
      await ReqresService.register(email: email, password: password);

      // 2. Register ke Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. Update display name
      await credential.user?.updateDisplayName(username);

      // 4. Simpan data user ke Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'role': 'user',
      });

      // 5. Simpan session lokal
      await _saveSession(
        uid: credential.user!.uid,
        email: email,
        username: username,
      );

      return {'success': true, 'user': credential.user};
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'weak-password':
          msg = 'Password terlalu lemah (minimal 6 karakter)';
          break;
        case 'email-already-in-use':
          msg = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          msg = 'Format email tidak valid';
          break;
        default:
          msg = e.message ?? 'Registrasi gagal';
      }
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Login dengan NIK atau Email
  Future<Map<String, dynamic>> login({
    required String nikOrEmail,
    required String password,
  }) async {
    try {
      String email = nikOrEmail;

      // Jika input adalah NIK (angka), cari email dari Firestore
      if (_isNik(nikOrEmail)) {
        final query = await _firestore
            .collection('users')
            .where('nik', isEqualTo: nikOrEmail)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          return {'success': false, 'message': 'NIK tidak ditemukan'};
        }
        email = query.docs.first['email'];
      }

      // 1. Login ke ReqRes (toleran error)
      await ReqresService.login(email: email, password: password);

      // 2. Login ke Firebase
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. Ambil data user dari Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      final username = userDoc.data()?['username'] ?? credential.user?.displayName ?? 'User';

      // 4. Simpan session
      await _saveSession(
        uid: credential.user!.uid,
        email: email,
        username: username,
      );

      return {'success': true, 'user': credential.user};
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'Akun tidak ditemukan';
          break;
        case 'wrong-password':
          msg = 'Password salah';
          break;
        case 'invalid-email':
          msg = 'Format email tidak valid';
          break;
        case 'user-disabled':
          msg = 'Akun dinonaktifkan';
          break;
        case 'too-many-requests':
          msg = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          msg = e.message ?? 'Login gagal';
      }
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Cek apakah input adalah NIK (numerik, 16 digit)
  bool _isNik(String input) {
    return RegExp(r'^\d{16}$').hasMatch(input);
  }

  // Simpan session lokal
  Future<void> _saveSession({
    required String uid,
    required String email,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);
  }

  // Cek session lokal
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Ambil username dari local
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'User';
  }
}
