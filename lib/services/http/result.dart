import 'package:cliff_pickleball/domain/message.dart';

class Result<T> {
  bool success = false;
  T? obj;
  Object? error;
  StackTrace? stackTrace;
  String? errorMessage;
  Message? msg;

  Result(this.success, this.obj, this.error, this.stackTrace, this.errorMessage,
      this.msg);

  Result.fail(this.error, this.stackTrace) {
    errorMessage = stackTrace.toString();
  }

  Result.failWithErrorMessage(this.errorMessage, this.error, this.stackTrace);

  Result.failMsg(this.errorMessage);

  factory Result.msg(Message msg,
      {String? errorMessage, bool success = false}) {
    return Result(success, null, null, null, errorMessage, msg);
  }

  Result.success(this.obj) : success = true;

  factory Result.result(Result<dynamic> result) {
    return Result(result.success, null, result.error, result.stackTrace,
        result.errorMessage, result.msg);
  }

  static Result<S> transform<S, T>(Result<T> result) {
    return Result<S>(result.success, null, result.error, result.stackTrace,
        result.errorMessage, result.msg);
  }

  @override
  String toString() {
    return 'Result{success: $success, obj: $obj, error: $error, stackTrace: $stackTrace, errorMessage: $errorMessage}';
  }
}
