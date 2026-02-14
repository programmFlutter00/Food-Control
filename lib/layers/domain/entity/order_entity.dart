class ProductEntity {
   final String id;
   final String type;
   final bool? status;
   final String? deskId;
  
   
   ProductEntity({
    required this.id,
    required this.type,
    this.status = false,
    this.deskId
   });
}