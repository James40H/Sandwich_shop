class PricingRepository {
  double getSandwichPrice({
    required bool isFootlong,
    required String sandwichType,

  }) {
    double basePrice = 0.0;
    if (sandwichType == 'footlong') {
      basePrice += 11.0;
    }
    else {
      basePrice += 7.0;
    }
   


   

   

    return basePrice;
  }
}