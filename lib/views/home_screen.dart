import 'package:cafe_frontend/controller/cart_controller.dart';
import 'package:cafe_frontend/models/cart_line.dart';
import 'package:cafe_frontend/views/profile_screen.dart';
import 'package:cafe_frontend/views/store_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_screen.dart';
import 'detail_screen.dart';
import '../models/product.dart';
import '../theme/theme.dart';

final cartController = Get.find<CartController>();

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
    this.onSearchChanged,
    this.onCategorySelected,
    this.onAddProduct,
    this.onRewardsTap,
    this.onOrdersTap,
    this.onProfileTap,
  });

  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onCategorySelected;
  final ValueChanged<String>? onAddProduct;
  final VoidCallback? onRewardsTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onProfileTap;

  

  final List<String> _categories = [
    'All',
    'Espresso-based',
    'Frappes',
    'Pastries',
    'Teas',
    'Cake',
  ];

  void _openDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppTheme.contentMaxWidth,
            ),
            child: CustomScrollView(
              key: const Key('home_scroll_view'),
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar(context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.pagePadding,
                      12,
                      AppTheme.pagePadding,
                      24,
                    ),
                    child: Column(
                      children: [
                        _buildGreeting(context),
                        const SizedBox(height: 28),
                        _buildFeatured(context),
                        const SizedBox(height: 24),
                        _buildCategories(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.pagePadding,
                    0,
                    AppTheme.pagePadding,
                    28,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppTheme.itemGap,
                          crossAxisSpacing: AppTheme.itemGap,
                          childAspectRatio: 0.73,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      _buildProductCard,
                      childCount: catalogProducts.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BrewNavigation(
        onRewardsTap: onRewardsTap,
        onOrdersTap:
            onOrdersTap ??
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            ),
        onProfileTap:
            onProfileTap ??
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, int index) {
    final product = catalogProducts[index];
    return _ProductCard(
      product: product,
      onTap: () => _openDetail(context, product),
      onAdd: () {
        cartController.addCart(
          CartLine(
            product: product,
            size: 'Medium',
            ice: 'Regular Ice',
            milk: 'Whole Milk',
            quantity: 1,
            unitPrice: double.parse(product.price.replaceFirst(r'$', '')),
          ),
        );
        _addtoCartSnackBar();
        onAddProduct?.call(product.name);
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.pagePadding,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          Text('The Brew', style: Theme.of(context).textTheme.headlineSmall),
          IconButton(
            tooltip: 'Location',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => StoreLocationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Good morning,\n',
            children: [
              TextSpan(
                text: 'Coffee Lover!',
                style: textTheme.displayMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          style: textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('coffee_search_field'),
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'What are you craving?',
            prefixIcon: Icon(Icons.search, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatured(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 192,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/featured_brew.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.96),
                    AppTheme.primary.withValues(alpha: 0.12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 205,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FEATURED BREW',
                        style: textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFFBDCCE),
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Autumn Spiced Flat White',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Warm notes of cinnamon & nutmeg.',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFDEC1B3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = index == 0;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onCategorySelected?.call(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : AppTheme.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                category,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? Colors.white : AppTheme.onSurfaceVariant,
                  letterSpacing: 0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppTheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: Key('product_${product.name}'),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox.expand(
                    child: Image.asset(product.image, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(letterSpacing: 0),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    product.price,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  InkResponse(
                    key: Key('add_${product.name}'),
                    radius: 20,
                    onTap: onAdd,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrewNavigation extends StatelessWidget {
  const _BrewNavigation({
    this.onRewardsTap,
    this.onOrdersTap,
    this.onProfileTap,
  });

  final VoidCallback? onRewardsTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: true,
              ),
              _NavItem(
                icon: Icons.card_membership_outlined,
                label: 'Rewards',
                onTap: onRewardsTap,
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                label: 'Orders',
                onTap: onOrdersTap,
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: onProfileTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppTheme.primary : AppTheme.secondary,
              size: 21,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? AppTheme.primary : AppTheme.secondary,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _addtoCartSnackBar() {
  Get.snackbar(
    'Added ',
    'Click the cart button to place order',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppTheme.primary,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
  );
}
