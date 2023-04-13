import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../books/domain/bookDetails.dart';


part 'orderDetails.g.dart';


@JsonSerializable(explicitToJson: true)
class OrderDetailsList {
  Map<String, OrderDetails>? ordersList;

  OrderDetailsList({required this.ordersList});
  Map<String, dynamic> toJson() => _$OrderDetailsListToJson(this);
  factory OrderDetailsList.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsListFromJson(json);
  factory OrderDetailsList.fromFirestore(doc) {
    return OrderDetailsList.fromJson(doc.data());
  }
}


@JsonSerializable(explicitToJson: true)
class OrderDetails {
  String? orderId;
  int? discount;
  int? grandTotal;
  int? total;
  int? noOfBooks;
  String? orderStatus;
  Map<String, Books> booksList;
  OrderDetails(
      this.orderId,
      this.discount,
      this.grandTotal,
      this.total,
      this.noOfBooks,
      this.orderStatus,
      this.booksList,
      );


  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
  factory OrderDetails.fromFirestore(doc) {
    return OrderDetails.fromJson(doc.data());
  }
}

@JsonSerializable(explicitToJson: true)
class OrderBooksList {
  Map<String, Books>? booksList;

  OrderBooksList({required this.booksList});
  Map<String, dynamic> toJson() => _$OrderBooksListToJson(this);
  factory OrderBooksList.fromJson(Map<String, dynamic> json) =>
      _$OrderBooksListFromJson(json);
  factory OrderBooksList.fromFirestore(doc) {
    return OrderBooksList.fromJson(doc.data());
  }
}
