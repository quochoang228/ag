class BaseException implements Exception {
  final String message;

  BaseException(this.message): super();

  @override
  String toString(){
    return message;
  }
}