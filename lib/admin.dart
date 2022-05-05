import 'dart:convert';

import 'package:admin_panel/sold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/orders.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Order> values = [];
  @override
  void initState() {
    super.initState();
    idk();
  }

  Future<void> idk() async {
    var resp = await http.get(
      Uri.parse("https://aracquine.000webhostapp.com/getAllOrders.php"),
    );
    var h = jsonDecode(resp.body);
    for (int i = 0; i < h.length; i++) {
      Order order = Order(
          id: h[i]['order_id'],
          custId: h[i]['cust_id'],
          price: h[i]['total_price']);
      values.add(order);
    }
    setState(() {});
  }

  String email = "", password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AdminHomePAge"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Admin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Color(0xFF1DA1F2)),
            ),
            ListTile(
              title: Text("All Sold"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SoldScreen(id: "-1");
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () {
              String id = "";
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Enter Customer ID"),
                      content: TextField(
                        decoration: InputDecoration(hintText: 'Customer Id'),
                        onChanged: (value) {
                          id = value;
                        },
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SoldScreen(id: id + "a");
                            }));
                          },
                          child: Text("GO"),
                        ),
                      ],
                    );
                  });
            },
            child: Text("See Orders by ID"),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Email",
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20),
                          child: TextField(
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password",
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Map<String, String> m = {
                              'email': email,
                              'password': password,
                            };
                            var resp = await http.post(
                              Uri.parse(
                                  "https://aracquine.000webhostapp.com/addAdmin.php"),
                              body: jsonEncode(m),
                            );
                            print(resp.statusCode);
                            Navigator.pop(context);
                          },
                          child: Text("Add"),
                        ),
                      ],
                    );
                  });
            },
            child: Text("Add Admin"),
          ),
          Text(
            "All Orders",
            style: TextStyle(fontSize: 25),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: values.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SoldScreen(id: values[i].id);
                      }));
                    },
                    leading: Text("Order ID:" + values[i].id),
                    title: Text("Customer ID: " + values[i].custId),
                    trailing: Text("Price: " + values[i].price),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String id = "",
              name = "",
              price = "",
              category = "",
              content = "",
              quantity = "";
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Shop ID",
                          ),
                          onChanged: (value) {
                            id = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name",
                          ),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Price",
                          ),
                          onChanged: (value) {
                            price = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Category",
                          ),
                          onChanged: (value) {
                            category = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Content",
                          ),
                          onChanged: (value) {
                            content = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Quantity",
                          ),
                          onChanged: (value) {
                            quantity = value;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> m = {
                            'shop_id': id,
                            'name': name,
                            'price': price,
                            'category': category,
                            'content': content,
                            'quantity': quantity,
                          };
                          await http.post(
                            Uri.parse(
                                "https://aracquine.000webhostapp.com/addProduct.php"),
                            body: jsonEncode(m),
                          );
                          Navigator.pop(context);
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
