import 'package:flutter/material.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<StatefulWidget> createState() => UserState();
}

class UserState extends State<User> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('我的');
  }
}
