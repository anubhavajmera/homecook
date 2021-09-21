import 'package:flutter/material.dart';
import 'package:homecook/components/loader.dart';
import 'package:homecook/providers/items_provider.dart';
import 'package:homecook/utilities/globals.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map _localSettings = {};
  List _sortKeys;
  bool _processed = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      _localSettings = _itemsProvider.filterSettings;
      _sortKeys = _itemsProvider.sortKeys;
      _processed = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _processed ? buildBody(context) : Loader();
  }

  Widget buildBody(BuildContext context) {
    final _itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter items',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Lato',
                ),
              ),
              IconButton(
                iconSize: 30,
                color: Colors.black54,
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Divider(),
          Text(
            'Sort by',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Lato',
            ),
          ),
          Wrap(
            children: List<Widget>.generate(
              3,
              (int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                    padding: EdgeInsets.all(8),
                    backgroundColor: Colors.grey.shade200,
                    label: Text(_sortKeys[index]),
                    selected: _localSettings['sortBy'] == _sortKeys[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _localSettings['sortBy'] =
                            selected ? _sortKeys[index] : null;
                      });
                    },
                  ),
                );
              },
            ).toList(),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distance Range',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
              Text(_localSettings['distanceRange'].toStringAsFixed(2) + ' km'),
            ],
          ),
          Slider(
            label: 'Range',
            value: _localSettings['distanceRange'],
            min: 1,
            max: 10,
            onChanged: (value) {
              setState(() {
                _localSettings['distanceRange'] = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Range',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
              Text(inr + _localSettings['priceRange'].toStringAsFixed(2)),
            ],
          ),
          Slider(
            label: 'Range',
            value: _localSettings['priceRange'],
            min: _localSettings['minPrice'],
            max: _localSettings['maxPrice'],
            onChanged: (value) {
              setState(() {
                _localSettings['priceRange'] = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ratings Range',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
              Text(
                  _localSettings['ratingsRange'].toStringAsFixed(2) + ' stars'),
            ],
          ),
          Slider(
            label: 'Range',
            value: _localSettings['ratingsRange'],
            min: 1,
            max: 10,
            onChanged: (value) {
              setState(() {
                _localSettings['ratingsRange'] = value;
              });
            },
          ),
          Divider(),
          Text(
            'Food Type',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Lato',
            ),
          ),
          Row(
            children: [
              Text('All'),
              Switch(
                value: _localSettings['isVegSelected'],
                onChanged: (value) {
                  setState(() {
                    _localSettings['isVegSelected'] = value;
                  });
                },
                activeTrackColor: Colors.green,
                activeColor: Colors.white,
                inactiveTrackColor: Colors.red,
              ),
              Text('Veg Only'),
            ],
          ),
          Container(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    'Process Items',
                    textScaleFactor: 1.25,
                  ),
                  onPressed: () {
                    _itemsProvider.filterSettings = _localSettings;
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
