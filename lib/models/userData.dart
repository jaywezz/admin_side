import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{

  final String user_id;
  final String names;
  final String address;
  final String city;
  final String country;
  final String phone_number;
  final String email;
  final String credit_number;
  final DateTime date_entered;
  final String gender;
  final String id_no;
  final String payment_method;

  UserData({this.user_id, this.names, this.address, this.city, this.country, this.phone_number, this.email, this.credit_number, this.date_entered, this.gender, this.id_no, this.payment_method});



}