import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePasswordView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UpdatePasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
