// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDetailsList _$CartDetailsListFromJson(Map<String, dynamic> json) =>
    CartDetailsList(
      cart: (json['cart'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Books.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$CartDetailsListToJson(CartDetailsList instance) =>
    <String, dynamic>{
      'cart': instance.cart.map((k, e) => MapEntry(k, e.toJson())),
    };
