import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier( authRepository: authRepository );
});

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository
  }) : super(AuthState());

  void loginUser(String email, String password) async {
    await Future.delayed(const Duration( milliseconds: 500));
    
    try {
       final user = await authRepository.login(email, password);
       _setLoggedUser(user);
    } on WrongCredenctial {
       logout( ' Credenciais nao validas' );
    } catch(e){
       logout( 'Erro nao controlado' );
    }
  }

  void register(String email, String fullname, String password) async {

  }

  void checkAuthStatus() async {

  }
  void _setLoggedUser( UserEntity user ) {
    // TODO: guardar token 
    state = state.copyWith(
      user: user, 
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([ String? errorMessage ]) async {
    //TODO limpar token
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
