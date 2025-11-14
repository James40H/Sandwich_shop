import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final pricingRepository = PricingRepository();
    test('returns correct price for footlong sandwich', () {
      final price = pricingRepository.getSandwichPrice(
        isFootlong: true,
        sandwichType: 'footlong',
      );
      expect(price, 11.0);
    });
    test('returns correct price for six-inch sandwich', () {
      final price = pricingRepository.getSandwichPrice(
        isFootlong: false,
        sandwichType: 'six-inch',
      );
      expect(price, 7.0);
    });
  });
} 