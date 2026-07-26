import 'package:cafe_frontend/controller/cart_controller.dart';
import 'package:cafe_frontend/models/cart_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    this.onEditItem,
    this.onRemoveItem,
    this.onCheckout,
  });

  final ValueChanged<String>? onEditItem;
  final ValueChanged<String>? onRemoveItem;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Cart',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.contentMaxWidth),
          child: Obx(() {
            if (cartController.cart.isEmpty) {
              return Center(child: Text('Your cart is empty'));
            }
            return ListView(
              key: const Key('cart_scroll_view'),
              padding: const EdgeInsets.fromLTRB(
                AppTheme.pagePadding,
                18,
                AppTheme.pagePadding,
                112,
              ),
              children: [
                ...cartController.cart.map(
                  (cart) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CartLine(
                      cart: cart,
                      onEdit: () => onEditItem?.call(cart.product.name),
                      onRemove: () {
                        cartController.removeCart(cart);
                        onRemoveItem?.call(cart.product.name);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                _OrderSummary(
                  subtotal: cartController.subtotal,
                  total: cartController.total,
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Obx(
        () => _CheckoutBar(
          total: cartController.total,
          hasItems: cartController.cart.isNotEmpty,
          onCheckout:
              onCheckout ?? () => _CheckoutSnackBar(cartController.total),
        ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({
    required this.cart,
    required this.onEdit,
    required this.onRemove,
  });

  final CartLine cart;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 136,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              cart.product.image,
              width: 92,
              height: 108,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        cart.product.name,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${cart.size}, ${cart.ice}, ${cart.milk} • Qty ${cart.quantity}',
                  style: textTheme.bodySmall,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _Action(
                      label: 'EDIT',
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 14),
                    _Action(
                      label: 'REMOVE',
                      icon: Icons.delete_outline,
                      color: AppTheme.error,
                      onTap: onRemove,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppTheme.onSurfaceVariant,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 9,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.subtotal, required this.total});

  final double subtotal;
  final double total;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceVariant),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: textTheme.headlineSmall?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _summaryRow(context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Total',
                style: textTheme.headlineSmall?.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: textTheme.headlineSmall?.copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.total,
    required this.hasItems,
    this.onCheckout,
  });

  final double total;
  final bool hasItems;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.surfaceVariant)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
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
              child: FilledButton(
                key: const Key('checkout_button'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(letterSpacing: 1.1),
                ),
                onPressed: hasItems ? onCheckout : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CHECKOUT  •  \$${total.toStringAsFixed(2)}'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _CheckoutSnackBar(double total) {
  Get.snackbar(
    'Order Placed',
    "Your order total is \$${total.toStringAsFixed(2)}",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppTheme.primary,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
  );
}
