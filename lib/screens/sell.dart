import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homecook/components/flushbar_alert.dart';
import 'package:homecook/models/item.dart';
import 'package:homecook/apis/items.dart';
import 'package:homecook/utilities/convertor.dart';
import 'package:homecook/utilities/globals.dart' as globals;

class SellScreen extends StatefulWidget {
  static const String routeName = '/sell-screen';

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();

  final _priceFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _preparationTimeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _descriptionController = TextEditingController();

  Item _currentItem = Item();
  List _suggestedItems = [];

  @override
  void initState() {
    _populateHistory();
    super.initState();
  }

  void _populateHistory() {
    ItemsApi().fetchMyItems().then((items) {
      setState(() {
        _suggestedItems = items;
      });
    }).catchError((e) => print(e));
  }

  void _submitItem() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ItemsApi().createItem(_currentItem).then((value) {
        _currentItem = Item();
        _formKey.currentState.reset();
        _initializeFormState();
        _populateHistory();
        showFlushbarAlert(
            context: context,
            title: 'Yohooo !',
            message: 'Item created.',
            color: Colors.green);
      }).catchError((e) {
        showFlushbarAlert(
            context: context,
            title: 'Oops !',
            message: 'Item creation failed.',
            color: Colors.redAccent);
      });
    }
  }

  void _initializeFormState() {
    _nameController.text = _currentItem.name ?? '';
    _priceController.text =
        _currentItem.price != null ? _currentItem.price.toString() : '';
    _quantityController.text =
        _currentItem.quantity != null ? _currentItem.quantity.toString() : '';
    _preparationTimeController.text = _currentItem.preparationTime != null
        ? _currentItem.preparationTime.toString()
        : '';
    _descriptionController.text = _currentItem.description ?? '';
  }

  void _showHistoryBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext cntxt) {
        return ListView.builder(
          itemCount: _suggestedItems.length,
          itemBuilder: (BuildContext context, index) {
            Item item = _suggestedItems[index];
            return Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                title: Text(item.name),
                trailing: Text(
                  formatTimestamp(item.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _currentItem = item;
                  });
                  _initializeFormState();
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 10,
        ),
        child: RaisedButton(
          child: Text(
            'Submit Item',
            textScaleFactor: 1.2,
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            _submitItem();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/pan.jpg',
              height: 350,
              fit: BoxFit.cover,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: globals.screenWidth,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Switch(
                                value: _currentItem.isVeg,
                                onChanged: (value) => setState(() {
                                  _currentItem.isVeg = !_currentItem.isVeg;
                                }),
                                activeTrackColor: Colors.green,
                                activeColor: Colors.white,
                                inactiveTrackColor: Colors.red,
                              ),
                              Text(_currentItem.isVeg ? 'Veg' : 'Non-Veg'),
                            ],
                          ),
                          Spacer(),
                          OutlineButton(
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onPressed: () => _showHistoryBottomSheet(context),
                            child: Row(
                              children: [
                                Text('Choose from history'),
                                Icon(Icons.keyboard_arrow_up),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Item Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter item name.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _currentItem.name = value.trim();
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Price per Serving',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        var data = double.tryParse(value.trim());
                        if (data == null || data < 1) {
                          return 'Please enter valid quantity.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_quantityFocusNode);
                      },
                      onSaved: (value) {
                        _currentItem.price = double.parse(value.trim());
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      focusNode: _quantityFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        var data = int.tryParse(value.trim());
                        if (data == null || data < 1) {
                          return 'Please enter valid quantity.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_preparationTimeFocusNode);
                      },
                      onSaved: (value) {
                        _currentItem.quantity = int.parse(value.trim());
                      },
                    ),
                    TextFormField(
                      controller: _preparationTimeController,
                      focusNode: _preparationTimeFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Preparation Time (in minutes)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        var data = int.tryParse(value.trim());
                        if (data == null || data < 1) {
                          return 'Please enter preparation time.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _currentItem.preparationTime = int.parse(value.trim());
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      maxLength: 300,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter item description.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _submitItem();
                      },
                      onSaved: (value) {
                        _currentItem.description = value.trim();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
