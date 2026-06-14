import 'dart:async';

import 'package:dio/dio.dart';

class PaginationService {
  final Dio dio = Dio();

  int skip = 0;
  final int limit = 10;

  Future<List<dynamic>> fetchProducts() async {
    final response = await dio.get(
      'https://dummyjson.com/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    skip += limit;

    return response.data['products'];
  }
}

 class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(Function action) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), () {
      action();
    });
  }
}

void main() {
  final debouncer = Debouncer(milliseconds: 500);

  debouncer.run(() {
    print('Searching...');
  });
}
