import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/products_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

enum SortOption {
  none,
  priceLowToHigh,
  priceHighToLow,
  topRated,
}

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo;

  ProductsCubit(this._productsRepo) : super(ProductsInitial());

  List<ProductModel> _allProducts = [];
  String selectedCategory = "All";
  String searchQuery = "";
  SortOption currentSortOption = SortOption.none;

  // 🗺️ خريطة الأقسام المتوافقة مع الـ API
  static const Map<String, String> _categoriesMap = {
    "All": "All",
    "Men's Apparel": "men's clothing",
    "Women's Apparel": "women's clothing",
    "Fine Jewelry": "jewelery",
    "Electronics": "electronics",
  };

  /// 1️⃣ جلب المنتجات من السيرفر
  Future<void> getProducts() async {
    emit(ProductsLoading());
    final result = await _productsRepo.getProducts();

    result.fold(
      (failure) => emit(ProductsError(failure)),
      (products) {
        _allProducts = products;
        _applyFiltersAndSort();
      },
    );
  }

  /// 2️⃣ التصفية حسب القسم
  void selectCategory(String category) {
    selectedCategory = category;
    _applyFiltersAndSort();
  }

  /// 3️⃣ البحث باسم المنتج
  void searchProducts(String query) {
    searchQuery = query.trim();
    _applyFiltersAndSort();
  }

  /// 4️⃣ الترتيب
  void sortProducts(SortOption option) {
    currentSortOption = option;
    _applyFiltersAndSort();
  }

  /// 🔄 الدالة المركزية لتطبيق الفلاتر والبحث الذكي والترتيب
  void _applyFiltersAndSort() {
    List<ProductModel> filteredList = List.from(_allProducts);

    // أ) تطبيق القسم
    if (selectedCategory != "All") {
      final apiCategory = _categoriesMap[selectedCategory] ?? selectedCategory;

      filteredList = filteredList.where((product) {
        return product.category.toLowerCase() == apiCategory.toLowerCase();
      }).toList();
    }

    // ب) تطبيق البحث الذكي (يتجاهل المسافات والشرطات مثل t-shirt و tshirt)
    if (searchQuery.isNotEmpty) {
      final cleanedQuery = searchQuery.toLowerCase().replaceAll(RegExp(r'[\s-]'), '');

      filteredList = filteredList.where((product) {
        final cleanedTitle = product.title.toLowerCase().replaceAll(RegExp(r'[\s-]'), '');
        return cleanedTitle.contains(cleanedQuery);
      }).toList();
    }

    // ج) تطبيق الترتيب
    switch (currentSortOption) {
      case SortOption.priceLowToHigh:
        filteredList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        filteredList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.topRated:
        filteredList.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortOption.none:
        break;
    }

    emit(ProductsSuccess(filteredList));
  }
}