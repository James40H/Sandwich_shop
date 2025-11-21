import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/repositories/Pricing_Repository.dart';

class Cart extends ChangeNotifier {
  final PricingRepository _pricingRepository;
  int _quantity;
  bool _isFootlong;
  String _bread; // e.g. 'white', 'wheat', 'wholemeal'

  Cart({
    PricingRepository? pricingRepository,
    int initialQuantity = 0,
    bool isFootlong = true,
    String initialBread = 'white',
  })  : _pricingRepository = pricingRepository ?? PricingRepository(),
        _quantity = initialQuantity,
        _isFootlong = isFootlong,
        _bread = initialBread;

  int get quantity => _quantity;
  bool get isFootlong => _isFootlong;
  String get bread => _bread;

  double get totalPrice =>
      _pricingRepository.calculatePrice(quantity: _quantity, isFootlong: _isFootlong);

  String get formattedTotal => '£${totalPrice.toStringAsFixed(2)}';

  /// Human readable summary of what's in the cart
  String get summary =>
      '$_quantity ${_bread} ${_isFootlong ? 'footlong' : 'six-inch'} sandwich(es): $formattedTotal';

  void increment([int amount = 1]) {
    _quantity += amount;
    notifyListeners();
  }

  void decrement([int amount = 1]) {
    if (_quantity - amount < 0) return;
    _quantity -= amount;
    notifyListeners();
  }

  void setSandwichType(bool value) {
    if (_isFootlong == value) return;
    _isFootlong = value;
    notifyListeners();
  }

  void setBread(String breadType) {
    if (_bread == breadType) return;
    _bread = breadType;
    notifyListeners();
  }

  void clear() {
    _quantity = 0;
    notifyListeners();
  }

  @override
  String toString() => 'Cart: $_quantity sandwich(es), total $formattedTotal';
}
