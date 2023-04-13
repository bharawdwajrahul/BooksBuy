import 'package:dartz/dartz.dart';

import 'cartDetails.dart';
import 'cartFailure.dart';



abstract class ICartFacade {
  // ignore: non_constant_identifier_names
  Stream<Either<CartFailure, CartDetailsList>> watchAll(String userId);

}
