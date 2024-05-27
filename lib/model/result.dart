enum ResultStatus { idle, loading, success, failed }

class Result<T> {
  ResultStatus status;
  T? data;
  String? message;

  Result() : status = ResultStatus.idle;

  Result.initial() : status = ResultStatus.idle;

  Result.loading() : status = ResultStatus.loading;

  Result.success(this.data) : status = ResultStatus.success;

  Result.error(this.message) : status = ResultStatus.failed;

  void setStatus(ResultStatus _status) {
    status = _status;
  }

  void resetStatus() {
    status = ResultStatus.idle;
  }

  void setMessage(String msg) {
    message = msg;
  }

  @override
  String toString() {
    return "ResultStatus : $status \n Message : $message \n Data : $data";
  }
}
