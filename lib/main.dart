import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// تعریف مستقیم رنگ‌ها برای جلوگیری از خطا
const Color kPrimaryColor = Color(0xFFC62828); 

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
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
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
                          child: products[index]['image'] != null 
                            ? Image.network(products[index]['image'], fit: BoxFit.cover)
                            : Icon(Icons.image_not_supported),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(products[index]['title'] ?? "بدون نام", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text("${products[index]['price'] ?? '0'} تومان", style: TextStyle(color: kPrimaryColor)),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
