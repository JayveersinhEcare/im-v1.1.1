import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/time_line_screen_controller.dart';

class TimeLineScreenView extends GetView<TimeLineScreenController> {
  const TimeLineScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeLine'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TimeLineScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
