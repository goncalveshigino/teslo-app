import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier( 
    authRepository: authRepository, 
    keyValueStorageService: keyValueStorageService
  );
});

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final  KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository, 
    required this.keyValueStorageService
  }) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration( milliseconds: 500));
    
    try {
      final user = await authRepository.login(email, password);
       _setLoggedUser(user);
    } on CustomError catch (e) {
       logout( e.message );
    }  catch(e){
       logout( 'Erro nao controlado' );
    }
  }

  Future<void> register(String fullName, String email, String password) async {
      await Future.delayed(const Duration( milliseconds: 500));
     
     try {
       final user = await authRepository.register(fullName, email, password);
       _setLoggedUser(user);
     } on CustomError catch (e) {
       logout( e.message );
    } 
  }

  void checkAuthStatus() async {

  }

  void _setLoggedUser( UserEntity user ) async {

    await keyValueStorageService.setKeyValue('token', user.token );

    state = state.copyWith(
      user: user, 
      authStatus: AuthStatus.authenticated, 
      errorMessage: ''
    );

  }

  Future<void> logout([ String? errorMessage ]) async {

   await keyValueStorageService.removeKey('token');

   state = state.copyWith(
    authStatus: AuthStatus.notAuthenticated, 
    user: null, 
    errorMessage: errorMessage,
   );
   
  }

}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final UserEntity? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith(
    {AuthStatus? authStatus,
    UserEntity? user,
    String? errorMessage,}
  ) => AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage
    );
}
