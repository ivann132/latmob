import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../data/models/user.dart';
import '../controllers/home_controller.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final List<UserModel> allUser = [];

  Future<void> getAllUser() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/5'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        allUser.add(UserModel.fromJson(data));
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authControl = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => authControl.logout(), icon: Icon(Icons.logout_outlined))
        ],
      ),
      body:FutureBuilder(
        future: getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading ...."),
            );
          } else {
            if (allUser.isEmpty) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            }
            return ListView.builder(
              itemCount: allUser.length,
              itemBuilder: (context, index) => ListTile(
                title: Text("${allUser[index].userId} ${allUser[index].id}"),
                subtitle: Text(allUser[index].title),
              ),
            );
          }
        },
      ),
    );
  }
}
