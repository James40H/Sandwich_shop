import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }
      expect(find.text('5 white footlong sandwich(es): 🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('toggles sandwich type with Switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.textContaining('footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.textContaining('six-inch sandwich'), findsOneWidget);
    });
    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(
          find.textContaining('wholemeal footlong sandwich'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('Cart SnackBar tests', () {
    testWidgets('shows SnackBar when "add to cart" (simulated) is pressed',
        (WidgetTester tester) async {
      final cart = Cart();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => cart.showSnackBar(context, 'Item added to cart'),
                child: const Text('Add to cart'),
              ),
            );
          }),
        ),
      ));

      await tester.tap(find.text('Add to cart'));
      await tester.pump(); // start SnackBar animation

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Item added to cart'), findsOneWidget);
    });



  group('Cart bottom bar', () {
    testWidgets('cart summary at bottom updates when Add to cart is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // initial summary shown at bottom
      expect(find.text('Items in cart: 0 •  Total: £0.00'), findsOneWidget);

      // tap Add and verify bottom summary updates
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();
      expect(find.text('Items in cart: 1 • Total: £11.00'), findsOneWidget);
    });
  });
});  
}