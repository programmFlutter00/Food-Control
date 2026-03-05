import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/widgets/pick_image_page.dart';
import 'package:food_control/layers/presentation/admin/widgets/show_dialog/custom_show_dialog.dart';
import 'package:food_control/layers/presentation/helpers/snac_bar.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/style/icons.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? selectedImage;

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  final FocusNode _focusNode = FocusNode();
  String category = 'Asosiy taom';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
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
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 70,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Rasm qo‘shish uchun bosing",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(selectedImage!, fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          StandartPadding(
            child: Column(
              children: [
                /// 2️⃣ Maxsulot nomi uchun input (border NONE)
                TextField(
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: "Mahsulot nomi...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // 👈 border yo‘q
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// 3️⃣ Maxsulot narxi
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Mahsulot narxi...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // 👈 border yo‘q
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Gap(8),
                PopupMenuButton<String>(
                  color: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black,
                  onSelected: (value) {
                    if (value == 'main') {
                      category = 'Asosiy taom';
                      setState(() {});
                    } else if (value == 'snack') {
                      category = 'Gazak';
                      setState(() {});
                    } else if (value == 'drink') {
                      category = 'Ichimlik';
                      setState(() {});
                    } else if (value == 'dessert') {
                      category = 'Desert';
                      setState(() {});
                    } else if (value == 'salad') {
                      category = 'Salat';
                      setState(() {});
                    } else if (value == 'sause') {
                      category = 'Sous';
                      setState(() {});
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'main',
                          child: Row(
                            children: [
                              // Gap(10),
                              Text(
                                'Asosiy taom',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'snack',
                          child: Row(
                            children: [
                              Text(
                                'Gazak',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'drink',
                          child: Row(
                            children: [
                              Text(
                                'Ichimlik',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'dessert',
                          child: Row(
                            children: [
                              Text(
                                'Desert',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'salad',
                          child: Row(
                            children: [
                              Text(
                                'Salat',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'sause',
                          child: Row(
                            children: [
                              Text(
                                'Sous',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    // onTap: () {},
                    leading: Icon(
                      Icons.grid_view_rounded,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        Gap(10),
                        Icon(Icons.arrow_drop_down, color: Colors.blue),
                      ],
                    ),
                  ),
                ),

                Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showMessage(
                          context: context,
                          message: 'Ro\'xat mavjud emas',
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.75,
                        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ro\'yxatga qo\'shing',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30, // icon o'lchami bilan bir xil
                      height: 30,
                      child: IconButton(
                        onPressed: () async {
                          customAddTaskListDialog(context);
                        },
                        padding: EdgeInsets.zero, // ichki padding yo‘q
                        constraints:
                            const BoxConstraints(), // tashqi cheklov yo‘q
                        icon: Icon(
                          Icons.format_list_bulleted_add,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Gap(10),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(AppIcons.discount, width: 50, height: 50),
                    Gap(10),

                    Text(
                      "Chegirmalar qo'shish",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: Colors.blue, size: 25),
              ],
            ),
          ),
          Gap(10),
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
                'Qo\'shish',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
