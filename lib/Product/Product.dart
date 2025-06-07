import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interviw/Cart/cart.dart';
import 'package:interviw/Cart/cart_store.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  List<dynamic> products = [];
  Set<String> selectedCategories = {};
  List<String> allCategories = [];

  void fetch() async {
    const url = "https://fakestoreapi.com/products";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    setState(() {
      products = json;
      allCategories = json.map<String>((p) => p['category'] as String).toSet().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter by Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: allCategories.map((category) {
              return CheckboxListTile(checkColor: Colors.white,
                title: Text(category),
                value: selectedCategories.contains(category),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      selectedCategories.add(category);
                    } else {
                      selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesCategory = selectedCategories.isEmpty ||
          selectedCategories.contains(product['category']);
      return matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Page",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedCategories.isNotEmpty)
            Container(color: Colors.purpleAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Filtered BY: ${selectedCategories.join(', ')}",
                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 10,
                thickness: 5,
                color: Colors.purpleAccent,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final title = product['title'];
                final desc = product['description'];
                final image = product['image'];
                final rating = product['rating']['rate'];
                final cost = product['price'];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        image,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title.toString(),
                              style: TextStyle(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text("\$${cost.toString()}",
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            desc.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Text("Rating: $rating"),
                        ],
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        CartStore().addItem({
                          'title': title,
                          'price': cost,
                          'image': image,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item Added to cart'),
                            backgroundColor: Colors.lightGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text("Shop",style: TextStyle(fontSize: 20, color: Colors.white),),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
