class RespData<T> {
  int code = -1;
  String message = '';

  // late T data;
}

class Paging<T> {
  int nowPage = -1;
  int pageSize = -1;
  bool hasMore = false;
  int total = -1;
  List<T> rows = [];
}

class LiveItem {
  int id = -1;
  // ignore: non_constant_identifier_names
  String socket_id = '-1';
}


// Map<String, LiveItem>