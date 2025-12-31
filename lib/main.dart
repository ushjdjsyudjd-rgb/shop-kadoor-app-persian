import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart'; // برای استفاده از رنگ‌هایی که تنظیم کردیم

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: kPrimaryColor),
    home: KadoorHomePage(),
  ));
}

class KadoorHomePage extends StatefulWidget {
  @override
  _KadoorHomePageState createState() => _KadoorHomePageState();
}

class _KadoorHomePageState extends State<KadoorHomePage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // اتصال مستقیم به گوگل شیت شما
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://sheetdb.io/api/v1/czatwlt4x2234'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("کادور پخش شمال"),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : GridView.builder(
              padding: EdgeInsets.all(kDefaultPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: kDefaultPadding,
                mainAxisSpacing: kDefaultPadding,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(products[index]['image'], fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(products[index]['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text("${products[index]['price']} تومان", style: TextStyle(color: kPrimaryColor)),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
