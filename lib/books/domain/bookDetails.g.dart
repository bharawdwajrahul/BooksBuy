// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailsList _$BookDetailsListFromJson(Map<String, dynamic> json) =>
    BookDetailsList(
      booksList: (json['booksList'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Books.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$BookDetailsListToJson(BookDetailsList instance) =>
    <String, dynamic>{
      'booksList': instance.booksList.map((k, e) => MapEntry(k, e.toJson())),
    };

Books _$BooksFromJson(Map<String, dynamic> json) => Books(
      json['bookId'] as String?,
      json['name'] as String?,
      json['author'] as String?,
      json['description'] as String?,
      json['publisher'] as String?,
      json['price'] as int?,
      json['ratings'] as int?,
      json['imageurl'] as String?,
    );

Map<String, dynamic> _$BooksToJson(Books instance) => <String, dynamic>{
      'bookId': instance.bookId,
      'name': instance.name,
      'author': instance.author,
      'description': instance.description,
      'publisher': instance.publisher,
      'price': instance.price,
      'ratings': instance.ratings,
      'imageurl': instance.imageurl,
    };
