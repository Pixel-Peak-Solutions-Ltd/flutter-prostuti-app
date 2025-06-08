class RegisterState {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String otp;
  final String? emailError;
  final String? passwordError;

  RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.otp = '',
    this.emailError,
    this.passwordError,
  });

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? otp,
    String? emailError,
    String? passwordError,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      emailError: emailError,
      passwordError: passwordError,
    );
  }
}
