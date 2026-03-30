import 'package:food_control/layers/domain/entity/product_entity.dart';

class OrderEntity {
  final String id;
  final String type;
  final int totalAmount;
  final bool status;
  final String? deskId;
  final List<ProductEntity>? products;

  OrderEntity({
    required this.id,
    required this.type,
    required this.totalAmount,
    this.status = false,
    this.deskId,
    this.products,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'] as String,
      type: json['type'] as String,
      totalAmount: json['totalAmount'] as int,
      status: json['status'] as bool? ?? false,
      deskId: json['deskId'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'totalAmount': totalAmount,
      'status': status,
      'deskId': deskId,
      'products': products?.map((e) => e.toJson()).toList(),
    };
  }
}