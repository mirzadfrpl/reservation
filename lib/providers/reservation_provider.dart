import 'package:flutter/material.dart';

class ReservationProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numberOfPeople = 2;
  bool _isLoading = false;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  int get numberOfPeople => _numberOfPeople;
  bool get isLoading => _isLoading;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
      notifyListeners();
    }
  }

  void incrementPeople() {
    _numberOfPeople++;
    notifyListeners();
  }

  void decrementPeople() {
    if (_numberOfPeople > 1) {
      _numberOfPeople--;
      notifyListeners();
    }
  }

  Future<bool> submitReservation() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return true;
  }
}
