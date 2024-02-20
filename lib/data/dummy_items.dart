import 'package:handling_user_input_with_forms/model/grocery_item_model.dart';

import '../model/category_model.dart';
import 'categories.dart';

final groceryItems = [
  GroceryItemModel(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: (categories[Categories.diary]!)),
  GroceryItemModel(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruits]!),
  GroceryItemModel(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
