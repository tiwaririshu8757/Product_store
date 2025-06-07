class CartStore {
  static final CartStore _instance = CartStore._internal();
  factory CartStore() => _instance;
  CartStore._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> item) {
    _cartItems.add(item);
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
  }



  void clearCart() {
    _cartItems.clear();
  }
}
