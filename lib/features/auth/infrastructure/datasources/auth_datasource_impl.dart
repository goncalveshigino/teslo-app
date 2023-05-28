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
      
    } on DioError catch (e) {
       if( e.response?.statusCode == 401 ) {
        throw CustomError(e.response?.data['message'] ?? 'Credencias incorretas');
       }
       if( e.type == DioErrorType.connectionTimeout ) throw CustomError('Revisar conexao com  internet');
       throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserEntity> register(String fullName, String email, String password ) async {
    try {
      
      final response = await dio.post('/auth/register', data: {
        'fullName': fullName,
        'email': email, 
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    }  on DioError catch (e) {
       if( e.response?.statusCode == 401 ) {
        throw CustomError(e.response?.data['message'] ?? 'Tente novamente');
       }
      if( e.type == DioErrorType.connectionTimeout ) throw CustomError('Revisar conexao com  internet');
       throw Exception();
    } catch (e) {
       throw Exception();
    }
  }

}