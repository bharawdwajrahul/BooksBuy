
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/cartDetails.dart';
import '../domain/cartFailure.dart';
import '../domain/cart_facade.dart';


@LazySingleton(as: ICartFacade)
class FirebaseAuthFacade implements ICartFacade {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Future<Option> getSignedInUser() {
    throw UnimplementedError();
  }

  @override
  Stream<Either<CartFailure, CartDetailsList>> watchAll(String userID) async* {
    //anOJS7zHY2cebx1OgVQ1blgjWJp1

    yield* FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .snapshots()
        .map((snapshot) => right<CartFailure, CartDetailsList>(
        CartDetailsList.fromFirestore(snapshot)))
      ..onErrorReturnWith((e, stackTrace) {
        if (e is FirebaseException &&
            e.message!.contains('PERMISSION_DENIED')) {
          return left(const CartFailure.insufficientPermission());
        } else {
          return left(const CartFailure.unexpected());
        }
      });
  }

}
