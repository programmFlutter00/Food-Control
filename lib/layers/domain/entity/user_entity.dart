import 'package:food_control/layers/domain/entity/order_entity.dart';
import 'package:food_control/layers/domain/entity/product_entity.dart';


class UserEntity {
  final String uidName;
  final String role;
  final String ownerUid;
  final String? userName;
  final List<OrderEntity>? orders;
  final List<ProductEntity>? products;

  UserEntity({
    required this.uidName,
    required this.role,
    required this.ownerUid,
    this.userName,
    this.orders,
    this.products,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uidName: json['uidName'] as String,
      role: json['role'] as String,
      ownerUid: json['ownerUid'] as String,
      userName: json['user_name'] as String?,
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uidName': uidName,
      'role': role,
      'ownerUid': ownerUid,
      'user_name': userName,
      'orders': orders?.map((e) => e.toJson()).toList(),
      'products': products?.map((e) => e.toJson()).toList(),
    };
  }
}