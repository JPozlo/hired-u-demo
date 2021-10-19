class Errors {
  Errors({this.errors = const []});

  final List<CustomError> errors;

  Map<String, dynamic> toJson() => {
    "errors": errors
  };
}

class CustomError {
  CustomError({this.error = ""});
  final String error;

    Map<String, dynamic> toJson() => {
    "error": error
  };
}
