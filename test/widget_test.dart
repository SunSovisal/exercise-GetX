import 'package:cafe_frontend/views/detail_screen.dart';
import 'package:cafe_frontend/main.dart';
import 'package:cafe_frontend/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the coffee home screen', (tester) async {
    await tester.pumpWidget(const CoffeeApp());
    await tester.pumpAndSettle();

    expect(find.text('The Brew'), findsOneWidget);
    expect(find.text('Good morning,\nCoffee Lover!'), findsOneWidget);
    expect(find.text('Autumn Spiced Flat White'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('home_scroll_view')),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    expect(find.text('Iced Latte'), findsOneWidget);
  });

  testWidgets('opens the selected product details', (tester) async {
    await tester.pumpWidget(const CoffeeApp());
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const Key('home_scroll_view')),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('product_Iced Latte')));
    await tester.pumpAndSettle();

    expect(find.text('Iced Latte'), findsOneWidget);
    expect(
      find.text(
        'Rich espresso with chilled milk, served over ice for a smooth and '
        'refreshing drink.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail selection notifies its callback', (tester) async {
    String? selectedSize;

    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(
          product: catalogProducts.first,
          onSizeSelected: (value) => selectedSize = value,
        ),
      ),
    );

    await tester.drag(
      find.byKey(const Key('detail_scroll_view')),
      const Offset(0, -420),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Large'));
    expect(selectedSize, 'Large');
  });

  testWidgets('detail top bar stays fixed while content scrolls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(product: catalogProducts.first),
      ),
    );

    final backButton = find.byTooltip('Back');
    final initialPosition = tester.getCenter(backButton);

    await tester.drag(
      find.byKey(const Key('detail_scroll_view')),
      const Offset(0, -420),
    );
    await tester.pumpAndSettle();

    expect(tester.getCenter(backButton), initialPosition);

    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreen), findsNothing);
  });
}
