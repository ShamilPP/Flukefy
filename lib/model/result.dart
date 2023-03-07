enum Status { initial, loading, success, error }

class Result<T> {
  Status status;
  T? data;
  String? message;

  Result.initial(this.message) : status = Status.initial;

  Result.loading(this.message) : status = Status.loading;

  Result.success(this.data) : status = Status.success;

  Result.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
