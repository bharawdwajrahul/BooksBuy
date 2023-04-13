import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookDetails.g.dart';


@JsonSerializable(explicitToJson: true)
class BookDetailsList {
  Map<String, Books> booksList;

  BookDetailsList({required this.booksList});
  Map<String, dynamic> toJson() => _$BookDetailsListToJson(this);
  factory BookDetailsList.fromJson(Map<String, dynamic> json) =>
      _$BookDetailsListFromJson(json);
  factory BookDetailsList.fromFirestore(doc) {
    return BookDetailsList.fromJson(doc.data());
  }
}

// @JsonSerializable(explicitToJson: true)
// class BooksList {
//   Map<String, Books> books;
//
//   BooksList({required this.books});
//   Map<String, dynamic> toJson() => _$BooksListToJson(this);
//   factory BooksList.fromJson(Map<String, dynamic> json) =>
//       _$BooksListFromJson(json);
//   factory BooksList.fromFirestore(doc) {
//     return BooksList.fromJson(doc.data());
//   }
// }

@JsonSerializable(explicitToJson: true)
class Books {
  String? bookId;
  String? name;
  String? author;
  String? description;
  String? publisher;
  int? price;
  int? ratings;
  String? imageurl;
  Books(
      this.bookId,
      this.name,
      this.author,
      this.description,
      this.publisher,
      this.price,
      this.ratings,
      this.imageurl,
      );


  Map<String, dynamic> toJson() => _$BooksToJson(this);
  factory Books.fromJson(Map<String, dynamic> json) =>
      _$BooksFromJson(json);
  factory Books.fromFirestore(doc) {
    return Books.fromJson(doc.data());
  }
}