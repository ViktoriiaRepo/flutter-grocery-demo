import 'package:first_app/api/http_response.dart';

class OrderCreateResponse {
  final bool isSuccess;
  final String message;
  final int? orderId;
  final double total;

  OrderCreateResponse(HttpServerResponse res)
      : message = ((res.data is Map ? res.data['message'] : '') ?? '').toString(),
        orderId = int.tryParse(
            (((res.data is Map ? res.data['data'] : {}) as Map?)?['id'] ?? '')
                .toString()),
        total = double.tryParse(
            (((res.data is Map ? res.data['data'] : {}) as Map?)?['total'] ?? '0')
                .toString()) ??
            0,
        isSuccess = (res.data is Map ? res.data['status'] == true : false);
}
