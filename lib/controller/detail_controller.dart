import 'package:get/get.dart';

class DetailController extends GetxController {
  final selectedSize = 'Medium'.obs;
  final selectedIce = 'Regular Ice'.obs;
  final selectedMilk = 'Whole Milk'.obs;
  final quantity = 1.obs;

  double get sizeSurcharge {
    switch (selectedSize.value) {
      case 'Small':
        return -0.5;
      case 'Large':
        return 0.75;
      default:
        return 0;
    }
  }

  double get milkSurcharge {
    switch (selectedMilk.value) {
      case 'Oat Milk':
        return 0.75;
      case 'Almond Milk':
        return 0.75;
      case 'Soy Milk':
        return 0.75;
      default:
        return 0;
    }
  }

  double unitPrice(double basePrice) {
    return basePrice + sizeSurcharge + milkSurcharge; 
  }

  double totalPrice(double basePrice) {
    return unitPrice(basePrice) * quantity.value;
  }

  void onIncreaseQuantity() {
    quantity.value++;
  }

  void onDecreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void onSelectedIce(String value) {
    selectedIce.value = value;
  }

  void onSelectedSize(String value) {
    selectedSize.value = value;
  }

  void onSelectedMilk(String value) {
    selectedMilk.value = value;
  }
}
