import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  bool _headerAnimated = false;
  final Set<int> _animatedGridItems = {};
  int _selectedIndex = 0;

  String get selectedCategory => _selectedCategory;
  bool get headerAnimated => _headerAnimated;
  Set<int> get animatedGridItems => _animatedGridItems;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void startHeaderAnimation() {
    if (!_headerAnimated) {
      _headerAnimated = true;
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }

  void animateGridItem(int index) {
    if (_animatedGridItems.add(index)) {
      notifyListeners();
    }
  }
}
