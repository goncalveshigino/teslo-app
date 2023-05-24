//! 1 - State de provider
import 'package:teslo_shop/features/shared/shared.dart';

class LoginFormState {

  final bool isPostiong;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  
  LoginFormState({
     this.isPostiong = false,
     this.isFormPosted = false,
     this.isValid = false,
     this.email = const Email.pure(),
     this.password = const Password.pure(),
  });

  
}
