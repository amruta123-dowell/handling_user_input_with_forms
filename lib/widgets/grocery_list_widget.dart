import 'package:flutter/material.dart';
import 'package:handling_user_input_with_forms/data/dummy_items.dart';

import '../model/grocery_item_model.dart';
import 'new_item.dart';

class GroceryListWidget extends StatefulWidget {
  const GroceryListWidget({super.key});

  @override
  State<GroceryListWidget> createState() => _GroceryListWidgetState();
}

class _GroceryListWidgetState extends State<GroceryListWidget> {
  final List<GroceryItemModel> _groceryItems = [];
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
