import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/admin/widgets/show_dialog/delete_show_dialog.dart';
import 'package:food_control/layers/presentation/extensions/extensions.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';
import 'package:food_control/layers/presentation/style/icons.dart';
import 'package:food_control/layers/presentation/widgets/standart_padding.dart';
import 'package:gap/gap.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _orders = [
    {
      "type": "desk",
      "status": false,
      "deskId": 15,
      "orders": [
        {
          "image": AppIcons.osh,
          "name": "Osh",
          "price": 45000,
          "type": "asosiy",
        },
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
      ],
    },
    {
      "type": "delivery",
      "status": false,
      "deskId": null,
      "orders": [
        {
          "image": AppIcons.osh,
          "name": "Osh",
          "price": 45000,
          "type": "asosiy",
        },
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
      ],
    },
    {
      "type": "desk",
      "status": true,
      "deskId": 17,
      "orders": [
        {
          "image": AppIcons.osh,
          "name": "Osh",
          "price": 45000,
          "type": "asosiy",
        },
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
      ],
    },
    {
      "type": "delivery",
      "status": true,
      "deskId": null,
      "orders": [
        {
          "image": AppIcons.osh,
          "name": "Osh",
          "price": 45000,
          "type": "asosiy",
        },
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
      ],
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 35),
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
            backgroundColor: Colors.transparent, // MUHIM
            elevation: 0, // 👈 endi xavfsiz
            scrolledUnderElevation: 0,
            title: const Text(
              "Buyurtmalar",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [IconButton(
                onPressed: () {
                  customDeleteShowDialog(context);
                },
                icon: Icon(Icons.logout, size: 25, color: Colors.white),
              ),],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(35),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelColor: Colors.white70,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Stol"),
                  Tab(text: "Dostafka"),
                  Tab(text: "Tugallangan"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          switch (_tabController.index) {
            case 0:
              return DeskOrdersList(orders: _orders);
            case 1:
              return DeliveryOrdersList(orders: _orders);
            default:
              return FinallyOrdersList(orders: _orders);
          }
        },
      ),
    );
  }
}

// ------------------------------------------------------
//DeliveryOrdersList
// ------------------------------------------------------
class DeskOrdersList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  const DeskOrdersList({super.key, required this.orders});

  @override
  State<DeskOrdersList> createState() => _DeskOrdersListState();
}

class _DeskOrdersListState extends State<DeskOrdersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final item = widget.orders[index];
        List<Map<String, dynamic>> allOrders = item['orders'];
        int total = 0;
        for (var i = 0; i < allOrders.length; i++) {
          final money = allOrders[i]['price'];
          total += money as int;
        }

          // filter
          // List<Map<String, dynamic>> filteredOrders = allOrders.where((orders) {
          //   if (orders['type']  == 'desk') return true;
          //   return false;
          // }).toList();
        return  Column(
            children: [
            //  Gap(14),
             if(index == 0) Gap(14),
            //  if(index != 0) Gap(14),
              Container(
                decoration: BoxDecoration(
                 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 6, // xiralik darajasi
                      spreadRadius: 1, // tarqalish radiusi
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(14),
                      StandartPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 30,
                                  color: Colors.amber,
                                ),
                                Gap(7),
                                Text(
                                  "${item['deskId'].toString()}-stol",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                 "${total.toMoney().toString()} so'm",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ],
                        ),
                      ),
                      Gap(13),
                      Divider(height: 1,),
                      SizedBox(
                        height: 270, // horizontal kartalar balandligi
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
          
                            return Row(
                            
                              children:[Gap(index == 0 ? 14 : 0), _buildTaskCardItem(allOrders[index], allOrders[index]['price']), Gap(14)],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                
              ),
             Gap(14),     
            ],
        );
      },
    );
  }

  Widget _buildTaskCardItem(Map<String, dynamic> orders, int price) {
    return SizedBox(
      width: 300,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(12),
          InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, // har bir karta kengligi
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(orders['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
             
                ),
             
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        orders["name"],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        orders['type'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      
                    ],
                  ),
                
                  const Gap(15),
                        Text(
                          "${price.toMoney()} so'm",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//
// class DeskOrdersList extends StatefulWidget {
//   final List<Map<String, dynamic>> orders;
//   const DeskOrdersList({super.key, required this.orders});
//   @override
//   State<DeskOrdersList> createState() => _DeskOrdersListState();
// }
// class _DeskOrdersListState extends State<DeskOrdersList> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.orders.length,
//       itemBuilder: (context, index) {
//         final item = widget.orders[index];
//         List<Map<String, dynamic>> allOrders = item['orders'];
//         int total = 0;
//         for (var i = 0; i < allOrders.length; i++) {
//           final money = allOrders[i]['price'];
//           total += money as int;
//         }

//           // filter
//           // List<Map<String, dynamic>> filteredOrders = allOrders.where((orders) {
//           //   if (orders['type']  == 'desk') return true;
//           //   return false;
//           // }).toList();
//         return StandartPadding(
//           child: Column(
//               children: [
//                if(index == 0) Gap(14),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         offset: const Offset(0, 3),
//                         blurRadius: 6, // xiralik darajasi
//                         spreadRadius: 1, // tarqalish radiusi
//                       ),
//                     ],
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Gap(14),
//                         StandartPadding(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: 5,
//                                     height: 30,
//                                     color: Colors.amber,
//                                   ),
//                                   Gap(7),
//                                   Text(
//                                     "${item['deskId'].toString()}-stol",
//                                     style: TextStyle(
//                                       color: Colors.amber,
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                    "${total.toMoney().toString()} so'm",
//                                     style: TextStyle(
//                                       color: Colors.green,
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                             ],
//                           ),
//                         ),
//                         Gap(13),
//                         Divider(height: 1,),
//                         SizedBox(
//                           height: 270, // horizontal kartalar balandligi
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: allOrders.length,
//                             itemBuilder: (context, index) {
            
//                               return Row(
//                                 // padding: EdgeInsets.only(
//                                 //   left: index == 0 ? 0 : 8,
//                                 //   right: 8,
//                                 // ),
                                
//                                 children:[Gap(index == 0 ? 14 : 0), _buildTaskCardItem(allOrders[index], allOrders[index]['price']), Gap(14)],
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
                  
//                 ),
//                Gap(14),     
//               ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTaskCardItem(Map<String, dynamic> orders, int price) {
//     return SizedBox(
//       width: 175,
//       child: Column(
//         // mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Gap(12),
//           InkWell(
//             onTap: () {},
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity, // har bir karta kengligi
//                   height: 170,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     image: DecorationImage(
//                       image: AssetImage(orders['image']),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
             
//                 ),
             
//                  Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         orders["name"],
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 19,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         // maxLines: 1,
//                         // overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         orders['type'],
//                         style: const TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
                      
//                     ],
//                   ),
                
//                   const Gap(15),
//                         Text(
//                           "${price.toMoney()} so'm",
//                           style: const TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// ------------------------------------------------------
// DeliveryOrdersList
// ------------------------------------------------------
class DeliveryOrdersList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  const DeliveryOrdersList({super.key, required this.orders});

  @override
  State<DeliveryOrdersList> createState() => _DeliveryOrdersListState();
}

class _DeliveryOrdersListState extends State<DeliveryOrdersList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ------------------------------------------------------
// FinallyOrdersList
// ------------------------------------------------------
class FinallyOrdersList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  const FinallyOrdersList({super.key, required this.orders});

  @override
  State<FinallyOrdersList> createState() => _FinallyOrdersListState();
}

class _FinallyOrdersListState extends State<FinallyOrdersList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
