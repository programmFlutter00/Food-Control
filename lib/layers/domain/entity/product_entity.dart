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
    this.rebatePercent
   });
}