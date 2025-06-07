import 'package:flutter/material.dart';
import 'package:interviw/Cart/cart_store.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartStore().cartItems;

    return Scaffold(
      appBar: AppBar(title: Text("Cart",style: TextStyle(color: Colors.white)),backgroundColor: Colors.indigo,),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: Column(
              children: [

                ElevatedButton(onPressed: (){
                  setState(() {
                    CartStore().clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All Items Deleted From Cart"),backgroundColor: Colors.red,));
                  });
                }, style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),child: Text("Clear Cart",style: TextStyle(color: Colors.white),)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item['image'],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['title']),
                        subtitle: Text("\$${item['price']}",style: TextStyle(color: Colors.green),),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,color: Colors.redAccent,),
                          onPressed: () {
                            setState(() {
                              CartStore().removeItem(index);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Deleted From Cart"),backgroundColor: Colors.red,));
                            });
                          },
                        ),
                      );
                    },
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
