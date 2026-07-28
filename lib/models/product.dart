class Product {
  const Product({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  final String name;
  final String price;
  final String image;
  final String description;
}

const List<Product> catalogProducts = [
  Product(
    name: 'Iced Latte',
    price: '\$4.50',
    image: 'assets/images/iced_latte.jpg',
    description:
        'Rich espresso with chilled milk, served over ice for a smooth and '
        'refreshing drink.',
  ),
  Product(
    name: 'Caramel Macchiato',
    price: '\$5.25',
    image: 'assets/images/caramel_macchiato.jpg',
    description: 'Espresso and steamed milk finished with vanilla and caramel.',
  ),
  Product(
    name: 'Espresso Shot',
    price: '\$3.00',
    image: 'assets/images/espresso.jpg',
    description: 'A concentrated shot of bold, full-bodied espresso.',
  ),
  Product(
    name: 'Iced Americano',
    price: '\$4',
    image: 'assets/images/iced_americano.jpg',
    description: 'it is an americano, isn\'t it',
  ),
];
