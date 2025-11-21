import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/repositories/Pricing_Repository.dart';
import 'package:sandwich_shop/models/sandwich.dart'; // Ensure Sandwich is imported

class Cart extends ChangeNotifier {
  final PricingRepository _pricingRepository;
  int _quantity;
  bool _isFootlong;
  String _bread; // e.g. 'white', 'wheat', 'wholemeal'
  List<Sandwich> _sandwiches; // List to hold added sandwiches
  int total = 0;
  

  Cart({
    PricingRepository? pricingRepository,
    int initialQuantity = 0,
    bool isFootlong = true,
    String initialBread = 'White',
  })  : _pricingRepository = pricingRepository ?? PricingRepository(),
        _quantity = initialQuantity,
        _isFootlong = isFootlong,
        _bread = initialBread,
        _sandwiches = []; // Initialize the list
        

  int get quantity => _quantity;
  bool get isFootlong => _isFootlong;
  String get bread => _bread;

  double get totalPrice =>
      _pricingRepository.calculatePrice(quantity: _quantity, isFootlong: _isFootlong);

  String get formattedTotal => '£${totalPrice.toStringAsFixed(2)}';

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
    _sandwiches.clear(); // Clear the sandwiches list
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duration for the SnackBar
      ),
    );
  }

  void add(Sandwich sandwich, {int quantity = 1, BuildContext? context}) {
    _sandwiches.add(sandwich); // Add sandwich to the list
    _quantity += quantity; // Update quantity
     final String sizeText = (sandwich.isFootlong) ? 'Footlong' : 'Six-inch';

    if (context != null) {
      // Determine size and bread text from the Sandwich object (falls back to cart fields)
      //final String sizeText = (sandwich.isFootlong) ? 'Footlong' : 'Six-inch';


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$quantity $bread $sizeText ${sandwich.name} added to cart!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    notifyListeners();
  }

  @override
  String toString() => 'Cart: $_quantity sandwich(es), total $formattedTotal';

  int get countOfItems {
      total += quantity;

    return total;
  }
}