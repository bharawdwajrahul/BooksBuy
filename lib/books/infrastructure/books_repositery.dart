
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:software/books/domain/bookDetails.dart';
import 'package:software/books/domain/booksFailure.dart';
import 'package:software/books/domain/books_facade.dart';

@LazySingleton(as: IBooksFacade)
class FirebaseAuthFacade implements IBooksFacade {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Future<Option> getSignedInUser() {
    throw UnimplementedError();
  }

  @override
  Stream<Either<BooksFailure, BookDetailsList>> watchAll() async* {
    FirebaseAuth auth = FirebaseAuth.instance;
    String user = auth.currentUser!.uid;
    print('--------------------------------');
    yield* FirebaseFirestore.instance
        .collection('books')
        .doc('books')
        .snapshots()
        .map((snapshot) => right<BooksFailure, BookDetailsList>(
        BookDetailsList.fromFirestore(snapshot)))
      ..onErrorReturnWith((e, stackTrace) {
        if (e is FirebaseException &&
            e.message!.contains('PERMISSION_DENIED')) {
          return left(const BooksFailure.insufficientPermission());
        } else {
          return left(const BooksFailure.unexpected());
        }
      });
  }

}
