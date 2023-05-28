

class WrongCredenctial implements Exception {} 
class InvalidTOken implements Exception {}
class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;

  //final int errorCode;
  
  CustomError(
     this.message
  );
}

