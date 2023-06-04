import 'package:formz/formz.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import 'providers.dart';

//! 3 - StateNotifierProvider - Que sera consumido fora
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).register;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos um notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.fullName,
        ]));
  }

  onFullnameChange(String value) {
    final fullName = FullName.dirty(value);
    state = state.copyWith(
        fullName: fullName,
        isValid: Formz.validate([
          fullName,
          state.email,
          state.password,
        ]));
  }

  onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
        password: state.password,
        isValid: Formz.validate([
          password,
          state.email,
          state.fullName,
        ]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid ) return;

    await registerUserCallback(
      state.fullName.value,
      state.email.value,
      state.password.value,
    );

  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        fullName: fullName,
        isValid: Formz.validate([state.email, state.password, state.fullName]));
  }
}

//! 1 - State de provider

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final FullName fullName;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.fullName = const FullName.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    FullName? fullName,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
      );

  @override
  String toString() {
    return '''
   RegisterFormState: 
   isPosting: $isPosting
   isFormPosted: $isFormPosted
   isValid: $isValid
   email: $email
   password: $password
   fullName: $fullName
   ''';
  }
}
