import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
     
class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  void _saveItem(){
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  label: const Text('Name')),
                  validator:(value) {
                    if (value == null || value.trim().length <= 1) {
                      return 'Name must have at least 2 characters.';
                    }
                    return null;
                  },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Quantity')),
                        initialValue: '1',
                        validator:(value) {
                          if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Input must be positive.';
                          }
                          return null;
                        }
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: DropdownButtonFormField<Categories>(
                      items: [
                        for (final category in categories.entries)
                        DropdownMenuItem<Categories>(
                          value: category.key,
                          child: Row(
                            children: [
                             Container(
                              width: 16, height: 16,
                               color: category.value.color,

                               ),
                               SizedBox(width: 6,),
                               Text(category.value.title),
                            ],)

                        )
                      ],
                      onChanged: (value) {}
                      ,)
                   ,)
                ],
              ),
              Row(
                children: [ TextButton(onPressed: () {}, child: const Text('Reset')),
                ElevatedButton(onPressed: _saveItem, child: const Text('Add Item'))
                ],
                )
            ],
            ),
        ),
      )
    );
  }
}