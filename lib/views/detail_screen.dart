import 'package:cafe_frontend/controller/cart_controller.dart';
import 'package:cafe_frontend/controller/detail_controller.dart';
import 'package:cafe_frontend/models/cart_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../theme/theme.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    required this.product,
    this.onFavorite,
    this.onAddToOrder,
    this.onIceSelected,
    this.onSizeSelected,
    this.onMilkSelected,
  });

  // Constructor
  final Product product;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToOrder;

  // To pass the value outside of this
  final ValueChanged<String>? onIceSelected;
  final ValueChanged<String>? onSizeSelected;
  final ValueChanged<String>? onMilkSelected;

  static const _sizes = ['Small', 'Medium', 'Large'];
  static const _iceLevels = ['Less Ice', 'Regular Ice', 'No Ice'];

  // Controller
  final DetailController detailController = DetailController();

  double get basePrice {
    return double.parse(product.price.replaceFirst(r'$', ''));
  }

  void addToCart(BuildContext context) {
    final cartController = Get.find<CartController>();

    final line = CartLine(
      product: product,
      size: detailController.selectedSize.value,
      ice: detailController.selectedIce.value,
      milk: detailController.selectedMilk.value,
      quantity: detailController.quantity.value,
      unitPrice: detailController.unitPrice(basePrice),
    );

    cartController.addCart(line);

    // Navigator.of(
    //   context,
    // ).push(MaterialPageRoute<void>(builder: (context) => CartScreen()));
    Get.snackbar(
      'Orderd Completed',
      '${product.name}',
      duration: Duration(seconds: 3),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get.put create and register the controller
    // final detailController = Get.put(DetailController());
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.contentMaxWidth),
          child: Stack(
            children: [
              SingleChildScrollView(
                key: const Key('detail_scroll_view'),
                child: Column(
                  children: [
                    _buildHero(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.pagePadding,
                        0,
                        AppTheme.pagePadding,
                        100,
                      ),
                      child: Transform.translate(
                        // Pull the details over the bottom of the hero image.
                        offset: const Offset(0, -16),
                        child: _buildContent(context),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopBar(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildOrderBar(context),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 397,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            product.image,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 0.25, 0.58],
                colors: [
                  AppTheme.background,
                  Color(0x33FCF9F8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.pagePadding,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircleButton(
              tooltip: 'Back',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(context).pop(),
            ),
            _CircleButton(
              tooltip: 'Favorite',
              icon: Icons.favorite_border,
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppTheme.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: textTheme.displayMedium?.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(product.price, style: textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 28),
          _sectionTitle(context, 'Size'),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              children: _sizes
                  .map(
                    (value) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: value == _sizes.last ? 0 : AppTheme.itemGap,
                        ),
                        child: _ChoiceButton(
                          label: value,
                          selected:
                              detailController.selectedSize.value == value,
                          onTap: () {
                            detailController.onSelectedSize(value);
                            onSizeSelected?.call(value);
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppTheme.sectionGap),
          _sectionTitle(context, 'Ice Level'),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: _iceLevels
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(right: AppTheme.itemGap),
                        child: _PillChoice(
                          label: value,
                          selected: detailController.selectedIce.value == value,
                          onTap: () {
                            detailController.onSelectedIce(value);
                            onIceSelected?.call(value);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.sectionGap),
          _sectionTitle(context, 'Milk Alternative'),
          Obx(
            () => GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsets.only(top: 16),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.itemGap,
              crossAxisSpacing: AppTheme.itemGap,
              childAspectRatio: 1.9,
              children: [
                _MilkChoice(
                  label: 'Whole Milk',
                  icon: Icons.water_drop_outlined,
                  selected: detailController.selectedMilk.value == 'Whole Milk',
                  onTap: () {
                    detailController.onSelectedMilk('Whole Milk');
                    onMilkSelected?.call('Whole Milk');
                  },
                ),
                _MilkChoice(
                  label: 'Oat Milk',
                  icon: Icons.grass,
                  surcharge: '+0.75',
                  selected: detailController.selectedMilk.value == 'Oat Milk',
                  onTap: () {
                    detailController.onSelectedMilk('Oat Milk');
                    onMilkSelected?.call('Oat Milk');
                  },
                ),
                _MilkChoice(
                  label: 'Almond Milk',
                  icon: Icons.spa_outlined,
                  surcharge: '+0.75',
                  selected:
                      detailController.selectedMilk.value == 'Almond Milk',
                  onTap: () {
                    detailController.onSelectedMilk('Almond Milk');
                    onMilkSelected?.call('Almond Milk');
                  },
                ),
                _MilkChoice(
                  label: 'Soy Milk',
                  icon: Icons.eco_outlined,
                  surcharge: '+0.75',
                  selected: detailController.selectedMilk.value == 'Soy Milk',
                  onTap: () {
                    detailController.onSelectedMilk('Soy Milk');
                    onMilkSelected?.call('Soy Milk');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
    );
  }

  Widget _buildOrderBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppTheme.surfaceVariant)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppTheme.contentMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.pagePadding,
                14,
                AppTheme.pagePadding,
                12,
              ),
              child: Row(
                children: [
                  Obx(
                    () => Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            key: const Key('decrease_quantity'),
                            visualDensity: VisualDensity.compact,
                            onPressed: detailController.onDecreaseQuantity,
                            icon: const Icon(Icons.remove, size: 18),
                          ),
                          SizedBox(
                            width: 24,
                            child: Text(
                              '${detailController.quantity.value}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          IconButton(
                            key: const Key('increase_quantity'),
                            visualDensity: VisualDensity.compact,
                            onPressed: detailController.onIncreaseQuantity,
                            icon: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      key: const Key('add_to_order'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: const StadiumBorder(),
                        elevation: 0,
                        textStyle: Theme.of(context).textTheme.labelMedium,
                      ),
                      onPressed: onAddToOrder ?? () => addToCart(context),

                      child: Obx(
                        () => Text(
                          'Add to Order  •  \$${detailController.totalPrice(basePrice).toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.88),
        shape: BoxShape.circle,
        boxShadow: AppTheme.cardShadow,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppTheme.primaryContainer
                : AppTheme.outlineVariant,
          ),
          boxShadow: selected ? AppTheme.floatingShadow : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected ? Colors.white : AppTheme.onSurfaceVariant,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _PillChoice extends StatelessWidget {
  const _PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppTheme.secondaryContainer
                : AppTheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected ? AppTheme.primary : AppTheme.onSurfaceVariant,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _MilkChoice extends StatelessWidget {
  const _MilkChoice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.surcharge,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? surcharge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: selected ? AppTheme.surfaceLow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.outlineVariant,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: selected ? AppTheme.primary : AppTheme.outline,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.onSurfaceVariant,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            if (surcharge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    surcharge!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
