import 'package:teslo_shop/features/auth/domain/domain.dart';

import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDataSourceImpl();

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<UserEntity> register(String fullName, String email, String password ) {
    return datasource.register(fullName, email, password );
  }
}
