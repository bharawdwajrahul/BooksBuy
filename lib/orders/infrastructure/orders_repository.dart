
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../books/domain/bookDetails.dart';
import '../domain/orderDetails.dart';
import '../domain/ordersFacade.dart';
import '../domain/ordersFailure.dart';


@LazySingleton(as: IOrdersFacade)
class FirebaseAuthFacade implements IOrdersFacade {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Future<Option> getSignedInUser() {
    throw UnimplementedError();
  }

  @override
  Stream<Either<OrdersFailure, OrderDetailsList>> watchAll() async* {
    FirebaseAuth auth = FirebaseAuth.instance;
    String user = auth.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection('Users')
        .doc(user).collection('userOrders').doc('orders')
        .snapshots()
        .map((snapshot) => right<OrdersFailure, OrderDetailsList>(
        OrderDetailsList.fromFirestore(snapshot)))
      ..onErrorReturnWith((e, stackTrace) {
        if (e is FirebaseException &&
            e.message!.contains('PERMISSION_DENIED')) {
          return left(const OrdersFailure.insufficientPermission());
        } else {
          return left(const OrdersFailure.unexpected());
        }
      });
  }

}
