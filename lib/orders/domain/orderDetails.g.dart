// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsList _$OrderDetailsListFromJson(Map<String, dynamic> json) =>
    OrderDetailsList(
      ordersList: (json['ordersList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, OrderDetails.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$OrderDetailsListToJson(OrderDetailsList instance) =>
    <String, dynamic>{
      'ordersList': instance.ordersList?.map((k, e) => MapEntry(k, e.toJson())),
    };

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
      json['orderId'] as String?,
      json['discount'] as int?,
      json['grandTotal'] as int?,
      json['total'] as int?,
      json['noOfBooks'] as int?,
      json['orderStatus'] as String?,
      (json['booksList'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Books.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'discount': instance.discount,
      'grandTotal': instance.grandTotal,
      'total': instance.total,
      'noOfBooks': instance.noOfBooks,
      'orderStatus': instance.orderStatus,
      'booksList': instance.booksList.map((k, e) => MapEntry(k, e.toJson())),
    };

OrderBooksList _$OrderBooksListFromJson(Map<String, dynamic> json) =>
    OrderBooksList(
      booksList: (json['booksList'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Books.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$OrderBooksListToJson(OrderBooksList instance) =>
    <String, dynamic>{
      'booksList': instance.booksList?.map((k, e) => MapEntry(k, e.toJson())),
    };
