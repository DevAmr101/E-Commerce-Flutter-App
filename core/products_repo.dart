import 'package:e_com/core/models/product_model.dart';
import 'package:e_com/core/networking/api_endpoints.dart';
import 'package:e_com/core/networking/dio_helper.dart';
import 'package:fpdart/fpdart.dart';

class ProductsRepo {
  final DioHelper _dioHelper;

  ProductsRepo(this._dioHelper);

  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
      // 💡 استخدام getRequest بدلاً من getData
      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.products,
      );

      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((e) => ProductModel.fromJson(e)).toList();
        return right(products);
      } else {
        return left("Failed to load products");
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}