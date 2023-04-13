
import 'package:dartz/dartz.dart';

import 'bookDetails.dart';
import 'booksFailure.dart';

abstract class IBooksFacade {
  // ignore: non_constant_identifier_names
  Stream<Either<BooksFailure, BookDetailsList>> watchAll();

}
