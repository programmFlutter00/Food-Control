import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/widgets/pick_image_page.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:gap/gap.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  File? selectedImage;

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  final FocusNode _focusNode = FocusNode();
  String category = 'Asosiy taom';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    priceController = TextEditingController(text: widget.product['price'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1️⃣ Butun ekran kengligida, balandligi 500 bo‘lgan image
          GestureDetector(
            onTap: () async {
              final image = await pickImageFromGallery();

              if (image != null) {
                setState(() {
                  selectedImage = image;
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: 350,
              child: selectedImage == null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(widget.product['image'], fit: BoxFit.cover)),
                    )
                  : ClipRRect( borderRadius: BorderRadius.circular(12), child: Image.file(selectedImage!, fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(height: 16),

          /// 2️⃣ Maxsulot nomi uchun input (border NONE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: nameController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: "Mahsulot nomi...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none, // 👈 border yo‘q
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 8),

          /// 3️⃣ Maxsulot narxi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: "Mahsulot narxi...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none, // 👈 border yo‘q
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Gap(8),
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              if (value == 'usd') {
              } else if (value == 'rub') {
              } else if (value == 'uzs') {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'usd',
                child: Row(
                  children: [
                    Gap(10),
                    Text(
                      'USD (\$)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'rub',
                child: Row(
                  children: [
                    Text(
                      'RUB (₽)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'uzs',
                child: Row(
                  children: [
                    Text(
                      'UZS (so\'m)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              // onTap: () {},
              leading: Icon(
                Icons.grid_view_rounded,
                // color: Colors.,
                size: 25,
              ),
              title: Text(
                "Mahsulot turi",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                category,
                style: TextStyle(color: Colors.blue, fontSize: 19),
              ),
            ),
          ),

          // Gap(10),
         

          Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.standart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: Text(
                'Saqlash',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
