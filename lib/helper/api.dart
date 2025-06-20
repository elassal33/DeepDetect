import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Api {
  

  Future<dynamic> post({required String url,@required dynamic body,@required String? token})async{
    Map<String,String> headers ={};

    if (token != null) {
      headers.addAll({
        'Authorization' : 'Bearer $token'
      });
    }
    http.Response response =
        await http.post(Uri.parse(url), body: body , headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
           return data;      
        } else {
          throw Exception(
          'there is a problem with status code ${response.statusCode} with body${jsonDecode(response.body)}');
        }
        
  }
}