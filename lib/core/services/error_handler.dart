class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();

  ErrorHandler._internal();

  factory ErrorHandler() => _instance;

  String? _errorMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
  }

  String getErrorMessage() {
    return _errorMessage ?? 'An unexpected error occurred.';
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}
