import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/customer.dart';
import 'package:todo_list/models/user.dart';

class CustomerProvider extends ChangeNotifier{
  Customer _customer = Customer(email: "",image: "", name: "",gender: "",age: 0,height: 0,weight: 0,typeOfTraining: "");

  void set(Customer selectedCustomer){
    _customer = selectedCustomer;
    notifyListeners();
  }

  Customer get() => _customer;
}