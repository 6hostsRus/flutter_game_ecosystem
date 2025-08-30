
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Offer {
  final String id; final String title; final String description; final double price; // USD or soft currency
  final bool isIap;
  const Offer({required this.id, required this.title, required this.description, required this.price, this.isIap=false});
}

class OffersService {
  List<Offer> listStoreOffers() => const [
    Offer(id:'coins_s', title:'Coin Pack S', description:'+100 coins', price:0.99, isIap:true),
    Offer(id:'coins_m', title:'Coin Pack M', description:'+300 coins', price:1.99, isIap:true),
  ];
}

final offersServiceProvider = Provider<OffersService>((_) => OffersService());
