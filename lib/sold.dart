import 'dart:convert';

import 'package:admin_panel/models/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SoldScreen extends StatefulWidget {
  String id;
  SoldScreen({required this.id});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  List<Item> values = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idk();
  }

  Future<void> idk() async {
    if (widget.id == "-1") {
      var resp = await http.get(
        Uri.parse("https://aracquine.000webhostapp.com/getAllProductsSold.php"),
      );
      var ans = jsonDecode(resp.body);
      for (int i = 0; i < ans.length; i++) {
        Item item = Item(
            custId: ans[i]['cust_id'],
            id: ans[i]['order_id'],
            price: ans[i]['price'],
            productId: ans[i]['product_id'],
            quantity: ans[i]['quantity'],
            shopId: ans[i]['shop_id']);
        values.add(item);
      }
      setState(() {});
    } else if (widget.id[widget.id.length - 1] == 'a') {
      String cust = "";
      for (int i = 0; i < widget.id.length - 1; i++) {
        cust += widget.id[i];
      }
      Map<String, String> m = {
        'cust_id': cust,
      };
      var resp = await http.post(
          Uri.parse(
              "https://aracquine.000webhostapp.com/getOrdersByCustomers.php"),
          body: jsonEncode(m));
      print(resp.body);
      var ans = jsonDecode(resp.body);
      for (int i = 0; i < ans.length; i++) {
        Item item = Item(
            custId: ans[i]['cust_id'],
            id: ans[i]['order_id'],
            price: ans[i]['price'],
            productId: ans[i]['product_id'],
            quantity: ans[i]['quantity'],
            shopId: ans[i]['shop_id']);
        values.add(item);
      }
      setState(() {});
    } else {
      Map<String, String> m = {
        'order_id': widget.id,
      };
      var resp = await http.post(
          Uri.parse("https://aracquine.000webhostapp.com/getOrderById.php"),
          body: jsonEncode(m));
      var ans = jsonDecode(resp.body);
      for (int i = 0; i < ans.length; i++) {
        Item item = Item(
            custId: ans[i]['cust_id'],
            id: ans[i]['order_id'],
            price: ans[i]['price'],
            productId: ans[i]['product_id'],
            quantity: ans[i]['quantity'],
            shopId: ans[i]['shop_id']);
        values.add(item);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sold"),
      ),
      body: ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, i) {
          return Card(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID: " + values[i].id),
                    Text("Customer ID: " + values[i].custId),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product ID: " + values[i].productId),
                    Text("Quantity: " + values[i].quantity),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price: " + values[i].price),
                    Text("Shop ID: " + values[i].shopId),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
