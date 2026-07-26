import 'package:cafe_frontend/models/product.dart';

class CartLine {
  const CartLine({
    required this.product,
    required this.size,
    required this.ice,
    required this.milk,
    required this.quantity,
    required this.unitPrice,
  });

  final Product product;
  final String size;
  final String ice;
  final String milk;
  final int quantity;
  final double unitPrice;

  double get total => unitPrice * quantity;
}