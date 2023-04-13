import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../books/domain/bookDetails.dart';

part 'cartDetails.g.dart';


@JsonSerializable(explicitToJson: true)
class CartDetailsList {
  Map<String, Books> cart;

  CartDetailsList({required this.cart});
  Map<String, dynamic> toJson() => _$CartDetailsListToJson(this);
  factory CartDetailsList.fromJson(Map<String, dynamic> json) =>
      _$CartDetailsListFromJson(json);
  factory CartDetailsList.fromFirestore(doc) {
    return CartDetailsList.fromJson(doc.data());
  }
}

