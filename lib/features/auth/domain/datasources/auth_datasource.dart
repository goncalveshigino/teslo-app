
import '../domain.dart';

abstract class AuthDatasource {

   Future<UserEntity> login( String email, String password);
   Future<UserEntity> register(String fullName, String email, String password);
   Future<UserEntity> checkAuthStatus( String token);
}