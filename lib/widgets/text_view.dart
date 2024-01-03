import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key, this.title = '', this.viewAll = false});

  String title;
  bool viewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(this.title, style: AppTheme.textTheme.titleMedium),
      ],
    );
  }
}
