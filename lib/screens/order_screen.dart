import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/orders_history.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderHistory> ordersHistory = [
    OrderHistory(
      id: "2683",
      total: 230,
      time: "2020/12/01",
    ),
    OrderHistory(
      id: "7393",
      total: 892,
      time: "2021/05/01",
    ),
    OrderHistory(
      id: "7832",
      total: 1672,
      time: "2021/01/01",
    ),
    OrderHistory(
      id: "8002",
      total: 9022,
      time: "2021/08/21",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Orders History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                itemCount: ordersHistory.length,
                itemBuilder: (context, index) {
                  var currentOrder = ordersHistory[index];
                  return Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: ListTile(
                      title: Text("KSh ${currentOrder.total.toString()}"),
                      subtitle: Text("#${currentOrder.id}"),
                      trailing: Text(currentOrder.time),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
