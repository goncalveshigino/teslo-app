import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';


class AuthDataSourceImpl extends AuthDatasource {

 final dio = Dio(
   BaseOptions(
     baseUrl: Environment.apiUrl,
   )
 );

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    
    try {

      final response = await dio.post('/auth/login', data: {
         'email': email, 
         'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
      
    } catch (e) {
       throw WrongCredenctial();
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}