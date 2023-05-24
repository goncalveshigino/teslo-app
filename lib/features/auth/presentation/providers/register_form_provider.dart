import 'package:formz/formz.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! 3 - StateNotifierProvider - Que sera consumido fora
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  return RegisterFormNotifier();
});

//! 2 - Como implementamos um notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.fullname,
        ]));
  }

  onFullnameChange(String value) {
    final fullname = Fullname.dirty(value);
    state = state.copyWith(
        fullname: fullname,
        isValid: Formz.validate([
          fullname,
          state.email,
          state.password,
        ]));
  }

  onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
        password: password,
        isValid: Formz.validate([
          password,
          state.email,
          state.fullname,
        ]));
  }

  onReapitPasswordChange(String value) {
    final reapit = Password.dirty(value);
    state = state.copyWith(
        password: reapit,
        isValid: Formz.validate(
            [reapit, state.email, state.fullname, state.password]));
  }

  onFormSubmit() {
    _touchEveryField();

    if (!state.isValid) return;

    if (state.password != state.reapit) return;

    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullname = Fullname.dirty(state.fullname.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        fullname: fullname,
        isValid: Formz.validate([state.email, state.password, state.fullname]));
  }
}

//! 1 - State de provider

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Password reapit;
  final Fullname fullname;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.reapit = const Password.pure(),
    this.fullname = const Fullname.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Password? reapit,
    Fullname? fullname,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        reapit: reapit ?? this.reapit,
        fullname: fullname ?? this.fullname,
      );

  @override
  String toString() {
    return '''
   LoginFormState: 
   isPosting: $isPosting
   isFormPosted: $isFormPosted
   isValid: $isValid
   email: $email
   password: $password
   reapit: $reapit
   fullname: $fullname
   ''';
  }
}
