import 'package:flutter/foundation.dart';
import 'package:homecook/apis/items.dart';
import 'package:homecook/models/item.dart';

class ItemsProvider extends ChangeNotifier {
  List _items = [], _filteredItems = [];
  final sortKeys = ['price', 'ratings', 'distance'];
  Map _filterSettings = {
    'distanceRange': 1.0,
    'priceRange': 1.0,
    'ratingsRange': 1.0,
    'minPrice': 0.0,
    'maxPrice': 1.0,
    'isVegSelected': false,
    'sortBy': 'price',
  };

  get items => _items;

  get filteredItems {
    _processItems();
    return [..._filteredItems];
  }

  get filterSettings => _filterSettings;

  set filterSettings(Map fs) {
    _filterSettings = fs;
    notifyListeners();
  }

  set items(newItems) {
    _items = newItems;
    notifyListeners();
  }

  void initializeItems() {
    ItemsApi().fetchOthersItems().then((fetchedItems) {
      items = fetchedItems;
      _initializeFilterSettings();
    }).catchError((e) {
      print(e);
      items = [];
    });
  }

  void _processItems() {
    var temp = _items.where((item) => _itemIsEligible(item)).toList();
    temp = _sortItems(temp);
    _filteredItems = temp;
  }

  bool _itemIsEligible(Item item) {
    double distance = item.getDistanceFromUser();
    bool eligibleByDistance = distance < filterSettings['distanceRange'];
    bool eligibleByPrice = item.price <= filterSettings['priceRange'];
    bool eligibleByChoice = item.isVeg == filterSettings['isVegSelected'];
    bool eligibleByQuantity = item.quantity > 0;
    if (filterSettings['isVegSelected'] == false) {
      eligibleByChoice = true;
    }
    bool eligible = eligibleByChoice &&
        eligibleByDistance &&
        eligibleByQuantity &&
        eligibleByPrice;
    return eligible;
  }

  List _sortItems(filteredItems) {
    List tempItems = filteredItems;
    if (filterSettings['sortBy'] == 'price') {
      tempItems.sort((a, b) => a.price.compareTo(b.price));
    }
    if (filterSettings['sortBy'] == 'distance') {
      tempItems.sort(
        (a, b) => a.getDistanceFromUser().compareTo(b.getDistanceFromUser()),
      );
    }
    return tempItems;
  }

  void _initializeFilterSettings() {
    double maxPrice = items[0].price;
    double minPrice = items[0].price;
    for (var item in items) {
      maxPrice = item.price > maxPrice ? item.price : maxPrice;
      minPrice = item.price < minPrice ? item.price : minPrice;
    }
    minPrice = minPrice == maxPrice ? 0 : minPrice;
    Map newFilterSettings = {
      'distanceRange': 1.0,
      'priceRange': maxPrice,
      'ratingsRange': 1.0,
      'maxPrice': maxPrice,
      'minPrice': minPrice,
      'isVegSelected': false,
      'sortBy': 'price',
    };
    filterSettings = newFilterSettings;
  }
}
