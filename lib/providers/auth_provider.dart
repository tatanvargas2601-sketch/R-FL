import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/token_storage.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Usuario? usuario;
  final AppRole? role;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.usuario,
    this.role,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Usuario? usuario,
    AppRole? role,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      usuario: usuario ?? this.usuario,
      role: role ?? this.role,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _restoreSession();
  }

  final _authService = AuthService();
  final _tokenStorage = TokenStorage();

  
  
  Future<void> _restoreSession() async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      state = const AuthState(isLoading: false, isAuthenticated: false);
      return;
    }
    final payload = await _authService.verifyToken();
    if (payload == null) {
      await _tokenStorage.clear();
      state = const AuthState(isLoading: false, isAuthenticated: false);
      return;
    }
    
    
    
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      role: roleFromString(payload['rol']),
    );
  }

  Future<void> login(String correo, String contrasena) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _authService.login(correo: correo, contrasena: contrasena);
      await _tokenStorage.saveToken(result.token);
      state = AuthState(
        isLoading: false,
        isAuthenticated: true,
        usuario: result.usuario,
        role: result.role,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    state = const AuthState(isLoading: false, isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
