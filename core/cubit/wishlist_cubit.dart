// مثال مبسط للـ WishlistCubit
import 'package:e_com/core/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<List<ProductModel>> {
  WishlistCubit() : super([]);

  void toggleFavorite(ProductModel product) {
    final currentList = List<ProductModel>.from(state);
    if (currentList.contains(product)) {
      currentList.remove(product); // حذف إذا كان موجوداً
    } else {
      currentList.add(product); // إضافة إذا لم يكن موجوداً
    }
    emit(currentList);
  }
}








