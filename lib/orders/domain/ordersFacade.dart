
import 'package:dartz/dartz.dart';

import 'orderDetails.dart';
import 'ordersFailure.dart';



abstract class IOrdersFacade {
  // ignore: non_constant_identifier_names
  Stream<Either<OrdersFailure, OrderDetailsList>> watchAll();

}
