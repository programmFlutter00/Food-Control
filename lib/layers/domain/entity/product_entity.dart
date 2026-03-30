class CategoryList {
  final String id;
  final String name;
  final List<ProductEntity>? product;
  final int? itemLength;

  CategoryList({
    required this.id,
    required this.name,
    this.product,
    this.itemLength,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      id: json['id'] as String,
      name: json['name'] as String,
      product: (json['product'] as List<dynamic>?)
          ?.map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemLength: json['item_length'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'product': product?.map((e) => e.toJson()).toList(),
      'item_length': itemLength,
    };
  }
}

class ProductEntity {
  final String id;
  final String imageUrl;
  final String name;
  final int price;
  final String type;
  final String category;
  final int? rebate;
  final int? rebatePercent;

  ProductEntity({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.type,
    required this.category,
    this.rebate,
    this.rebatePercent,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      type: json['type'] as String,
      category: json['category'] as String,
      rebate: json['rebate'] != null ? json['rebate'] as int : null,
      rebatePercent:
          json['rebatePercent'] != null ? json['rebatePercent'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'type': type,
      'category': category,
      'rebate': rebate,
      'rebatePercent': rebatePercent,
    };
  }
}