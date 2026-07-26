import 'package:cafe_frontend/models/cart_line.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cart = <CartLine>[].obs;

  int get itemCount {
    return cart.fold(0, (total, cart) => total = total + cart.quantity);
  }

  double get subtotal {
    return cart.fold(0, (total, cart) => total = total + cart.total);
  }

  double get total {
    return subtotal;
  }
  void addCart(CartLine line) {
    cart.add(line);
  }

  void removeCart(CartLine line) {
    cart.remove(line);
  }

  void clear() {
    cart.clear();
  }
}
