import 'package:handling_user_input_with_forms/model/category_model.dart';

class GroceryItemModel {
  final String id;
  final String name;
  final int quantity;
  final CategoryModel? category;

  const GroceryItemModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});
}
