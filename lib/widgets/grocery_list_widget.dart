import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handling_user_input_with_forms/data/categories.dart';
import 'package:handling_user_input_with_forms/data/dummy_items.dart';

import '../model/grocery_item_model.dart';
import 'new_item.dart';
import 'package:http/http.dart' as http;

class GroceryListWidget extends StatefulWidget {
  const GroceryListWidget({super.key});

  @override
  State<GroceryListWidget> createState() => _GroceryListWidgetState();
}

class _GroceryListWidgetState extends State<GroceryListWidget> {
  List<GroceryItemModel> _groceryItems = [];
  // bool _isLoading = true;
  late Future<List<GroceryItemModel>> _loadedItems;

  ///Get grcery list from API
  @override
  void initState() {
    getGroceryList();
    // _loadedItems = getGroceryList();

    super.initState();
  }

//fire base API call to get the list of groceries
  void getGroceryList() async {
    final url = Uri.https("udemy-firebase-5c7a5-default-rtdb.firebaseio.com",
        "shopping-list.json");
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode >= 400) {
      throw Exception(
          "Failed to fetch grocery items. Please try again later...");
    }
    if (response.body == "null") {
      return;
    }
    final Map<String, dynamic> _apiRes = json.decode(response.body);

    List<GroceryItemModel> _groceryList = [];
    for (var item in _apiRes.entries) {
      var selectedCat = categories.entries.firstWhere((element) {
        return element.value.title == item.value["category"];
      }).value;
      _groceryList.add(GroceryItemModel(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: selectedCat));
    }
    _groceryItems = _groceryList;

    setState(() {
      _groceryItems = _groceryList;
    });
  }

  ///add item - the response comes from new item page
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItemModel>(
        MaterialPageRoute(builder: (_) => const NewItem()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void removeItem(GroceryItemModel deleteItem) {
    setState(() {
      _groceryItems.remove(deleteItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetContent = const Center(
      child: Text("No Items found....."),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
        ),
        body: _groceryItems.isEmpty
            ? widgetContent
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _groceryItems.length,
                itemBuilder: (ctx, index) => Dismissible(
                      onDismissed: (dir) {
                        removeItem(_groceryItems[index]);
                      },
                      key: ValueKey(_groceryItems[index].id),
                      child: ListTile(
                        title: Text(_groceryItems[index].name),
                        leading: Container(
                          width: 24,
                          height: 24,
                          color: _groceryItems[index].category?.color,
                        ),
                        trailing:
                            Text(_groceryItems[index].quantity.toString()),
                      ),
                    )));
  }
}
