import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_control/layers/presentation/admin/widgets/products/add_product.dart';
import 'package:food_control/layers/presentation/admin/widgets/products/product_detail.dart';
import 'package:food_control/layers/presentation/auth/bloc/cubit/auth_cubit.dart';
import 'package:food_control/layers/presentation/extensions/extensions.dart';
import 'package:food_control/layers/presentation/splash/splash_logo_page.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/style/icons.dart';
import 'package:food_control/layers/presentation/widgets/custom_floating_action_button.dart';
import 'package:gap/gap.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final List<Map<String, dynamic>> _orders = [
    {"image": AppIcons.osh, "name": "Osh", "price": 45000, "type": "asosiy"},
    {
      "image": AppIcons.burger,
      "name": "Burger",
      "price": 25000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.pizza,
      "name": "Pitsa",
      "price": 95000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.chicken,
      "name": "Tovuq",
      "price": 25000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.pizza,
      "name": "Pitsa",
      "price": 105000,
      "type": "asosiy",
    },
    {"image": AppIcons.osh, "name": "Osh", "price": 45000, "type": "asosiy"},
    {
      "image": AppIcons.burger,
      "name": "Burger",
      "price": 35000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.chicken,
      "name": "Tovuq",
      "price": 25000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.pizza,
      "name": "Pitsa",
      "price": 15000,
      "type": "asosiy",
    },
    {"image": AppIcons.osh, "name": "Osh", "price": 15000, "type": "asosiy"},
    {
      "image": AppIcons.burger,
      "name": "Burget",
      "price": 15000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.chicken,
      "name": "Tovuq",
      "price": 15000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.pizza,
      "name": "Pitsa",
      "price": 15000,
      "type": "asosiy",
    },
    {"image": AppIcons.osh, "name": "Osh", "price": 15000, "type": "asosiy"},
    {
      "image": AppIcons.burger,
      "name": "Burger",
      "price": 15000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.chicken,
      "name": "Tovuq",
      "price": 15000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.pizza,
      "name": "Pitsa",
      "price": 15000,
      "type": "asosiy",
    },
    {"image": AppIcons.osh, "name": "Osh", "price": 15000, "type": "asosiy"},
    {
      "image": AppIcons.burger,
      "name": "Burger",
      "price": 15000,
      "type": "asosiy",
    },
    {
      "image": AppIcons.chicken,
      "name": "Tovuq",
      "price": 15000,
      "type": "asosiy",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.standart,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 3), // 👈 faqat pastga
              ),
            ],
          ),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.standart,
            titleSpacing: 14,
            // leading: IconButton(
            //     onPressed: () {
            //       _showDeskSelectionConfirmation();
            //     },
            //     icon: Icon(Icons.logout, size: 25, color: Colors.white),
            //   ),
            title: Text(
              "Mahsulotlar",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _showDeskSelectionConfirmation();
                },
                icon: Icon(Icons.logout, size: 25, color: Colors.white),
              ),
             
                       
              IconButton(
                onPressed: () {
                },
                icon: Icon(Icons.format_list_bulleted_outlined, size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [Gap(16), _productItem(), Gap(16)]),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _showTypeBottomSheet(context),
      ),
    );
  }

  Widget _productItem() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: EdgeInsets.symmetric(horizontal: 14),
      itemCount: _orders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = _orders[index];
        int price = item['price'];
        return InkWell(
          onTap: () {
            _showProductDetail(context, item);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
                  padding: const EdgeInsets.all(0),
          
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      item['image'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            item['type'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
          
                      const Gap(10),
                      Text(
                        "${price.toMoney()} so'm",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTypeBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddProduct();
      },
    );
  }

   Future<void> _showProductDetail(BuildContext context, Map<String, dynamic> product) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ProductDetail(product: product,);
      },
    );
  }

  Future<bool> _showDeskSelectionConfirmation() async {
    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          
          backgroundColor: Colors.white,
          title: Text(
            'Ishonchingiz komilmi?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          content: Text(
            'Ushbu hisobni to\'liq o\'chirib yubomoqchimisiz?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Bekor qilish',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Bloc ichidagi state orqali uidName ni olish
                final uidName = context
                    .read<AuthCubit>()
                    .state
                    .account
                    ?.uidName;

                if (uidName != null) {
                  // await context.read<AuthCubit>().deleteAccount(uidName);

                  // Delete tugagach sahifani Login/Register ga yo'naltirish
                  if (!mounted) return;
                  Navigator.of(dialogContext).pop(true);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SplashLogoPage()),
                    (route) => false,
                  );
                }
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'O\'chirish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
