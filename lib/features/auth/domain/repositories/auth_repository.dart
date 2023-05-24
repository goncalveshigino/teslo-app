import '../domain.dart';


abstract class AuthRepository {

   Future<UserEntity> login( String email, String password);
   Future<UserEntity> register( String email, String password, String fullName);
   Future<UserEntity> checkAuthStatus( String token);
   
}