import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handling_user_input_with_forms/data/categories.dart';
import 'package:handling_user_input_with_forms/model/category_model.dart';
import 'package:handling_user_input_with_forms/model/grocery_item_model.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQty = 1;
  var selectedCategory = categories[Categories.vegetables];

  bool _isSending = false;
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https("udemy-firebase-5c7a5-default-rtdb.firebaseio.com",
          "shopping-list.json");
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": _enteredName,
            "quantity": _enteredQty,
            "category": selectedCategory?.title
          }));
      print(response.body);
      Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (!context.mounted) {
        return;
      } else {
        Navigator.of(context).pop(GroceryItemModel(
            id: decodedResponse["name"],
            name: _enteredName,
            quantity: _enteredQty,
            category: selectedCategory));
      }
    }
  }

  //call API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 40,
                  decoration: const InputDecoration(
                    label: Text("NAME"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty == true ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return "Must be between 1 and 50 characters";
                    }
                    return null;
                  },
                  onSaved: (savedVal) {
                    _enteredName = savedVal ?? '';
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredQty.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Must be valid, positive number";
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          _enteredQty = int.parse(newVal!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: Text(_isSending ? "Sending..." : "Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add item'),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
