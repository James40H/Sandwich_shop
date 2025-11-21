import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/Pricing_Repository.dart';

void main() {
  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart(pricingRepository: PricingRepository());
    });

    test('initial quantity should be 0', () {
      expect(cart.quantity, 0);
    });

    test('initial bread should be white', () {
      expect(cart.bread, 'white');
    });

    test('initial isFootlong should be true', () {
      expect(cart.isFootlong, true);
    });

    test('increment increases quantity', () {
      cart.increment();
      expect(cart.quantity, 1);
    });

    test('decrement decreases quantity', () {
      cart.increment(2);
      cart.decrement();
      expect(cart.quantity, 1);
    });

    test('decrement does not go below 0', () {
      cart.decrement();
      expect(cart.quantity, 0);
      cart.decrement();
      expect(cart.quantity, 0);
    });

    test('setSandwichType changes isFootlong', () {
      cart.setSandwichType(false);
      expect(cart.isFootlong, false);
    });

    test('setBread changes bread type', () {
      cart.setBread('wheat');
      expect(cart.bread, 'wheat');
    });

    test('clear resets quantity to 0', () {
      cart.increment(3);
      cart.clear();
      expect(cart.quantity, 0);
    });

    test('summary returns correct string', () {
      cart.increment(2);
      cart.setBread('wholemeal');
      expect(cart.summary, '2 wholemeal footlong sandwich(es): £${cart.totalPrice.toStringAsFixed(2)}');
    });
  });
}