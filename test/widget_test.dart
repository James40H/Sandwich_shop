import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/log_in_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as the home screen',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('LoginScreen', () {
    testWidgets('login button disabled when fields empty and enabled when filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // initial: two TextFields and one ElevatedButton (disabled)
      final Finder textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      final Finder loginButtonFinder = find.byType(ElevatedButton);
      expect(loginButtonFinder, findsOneWidget);

      final ElevatedButton loginButtonWidget =
          tester.widget<ElevatedButton>(loginButtonFinder);
      expect(loginButtonWidget.onPressed, isNull);

      // enter username and password
      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pumpAndSettle();

      final ElevatedButton enabledButton =
          tester.widget<ElevatedButton>(loginButtonFinder);
      expect(enabledButton.onPressed, isNotNull);
    });

    testWidgets('successful login shows loading then returns true to caller',
        (WidgetTester tester) async {
      bool? result;

      // host widget that opens LoginScreen and captures the result
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                child: const Text('OpenLogin'),
                onPressed: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  result = res;
                },
              ),
            ),
          );
        }),
      ));
    });
  });
 group('OrderScreen Drawer', () {
    testWidgets('shows hamburger icon and opens drawer with menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: OrderScreen()));

      // The automatic drawer button has tooltip "Open navigation menu"
      final Finder menuButton = find.byTooltip('Open navigation menu');
      expect(menuButton, findsOneWidget);

      // Open drawer
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Drawer should contain the expected items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('tapping Cart in drawer navigates to /cart',
        (WidgetTester tester) async {
      final app = MaterialApp(
        home: OrderScreen(),
        routes: {
          '/cart': (context) => const Scaffold(body: Center(child: Text('Cart Page'))),
          '/about': (context) => const Scaffold(body: Center(child: Text('About Page'))),
        },
      );

      await tester.pumpWidget(app);

      // Open drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Tap the "Cart" item
      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();

      // Should have navigated to the Cart Page route
      expect(find.text('Cart Page'), findsOneWidget);
    });
  });
}

