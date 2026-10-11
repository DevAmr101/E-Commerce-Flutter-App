import 'dart:convert';
import 'package:e_com/core/models/cart_item_model.dart';
import 'package:e_com/core/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItemModel> items;
  final double subTotal;
  final double vat;
  final double shippingFee;
  final double total;

  CartUpdated({
    required this.items,
    required this.subTotal,
    required this.vat,
    required this.shippingFee,
    required this.total,
  });
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    loadCart();
  }

  final List<CartItemModel> _cartItems = [];

  static const double _vatRate = 0.14;
  static const double _standardShippingFee = 45.0;
  static const double _freeShippingThreshold = 500.0;
  static const String _storageKey = "saved_cart_items";

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartString = prefs.getString(_storageKey);

      if (cartString != null) {
        List<dynamic> decodedList = jsonDecode(cartString);
        _cartItems.clear();
        _cartItems.addAll(decodedList.map((item) => CartItemModel.fromJson(item)).toList());
        _calculateTotals();
      }
    } catch (e) {
      debugPrint("Error loading cart: $e");
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> encodedList = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(encodedList));
    } catch (e) {
      debugPrint("Error saving cart: $e");
    }
  }

  void addProduct(ProductModel product) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItemModel(product: product));
    }

    _calculateTotals();
    _saveCartToStorage();
  }

  void removeProduct(ProductModel product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    _calculateTotals();
    _saveCartToStorage();
  }

  void incrementQuantity(CartItemModel cartItem) {
    cartItem.quantity++;
    _calculateTotals();
    _saveCartToStorage();
  }

  void decrementQuantity(CartItemModel cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _cartItems.removeWhere((item) => item.product.id == cartItem.product.id);
    }
    _calculateTotals();
    _saveCartToStorage();
  }

  void _calculateTotals() {
    double subTotal = 0.0;
    for (var item in _cartItems) {
      subTotal += item.totalItemPrice;
    }

    double vat = subTotal * _vatRate;
    double shipping = _cartItems.isEmpty ? 0.0 : (subTotal >= _freeShippingThreshold ? 0.0 : _standardShippingFee);
    double total = subTotal + vat + shipping;

    emit(CartUpdated(
      items: List.from(_cartItems),
      subTotal: subTotal,
      vat: vat,
      shippingFee: shipping,
      total: total,
    ));
  }
}