class ApiResponse<T> {
  final T? data;
  final Status status;
  const ApiResponse({required this.data, required this.status});
  const ApiResponse.initial({this.data, this.status = Status.initial});
  ApiResponse.loading({this.data, this.status = Status.loading});
  ApiResponse.completed(this.data, {this.status = Status.completed});
  ApiResponse.error({this.data, this.status = Status.error});
}

enum Status { initial, loading, completed, error }
