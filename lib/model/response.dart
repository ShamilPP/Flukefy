enum Status { initial, loading, completed, error }

class Response<T> {
  Status status;
  T? data;
  String? message;

  Response.initial(this.message) : status = Status.initial;

  Response.loading(this.message) : status = Status.loading;

  Response.completed(this.data) : status = Status.completed;

  Response.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
