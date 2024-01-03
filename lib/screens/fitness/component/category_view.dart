import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';
import 'package:ai_trainer_mypt/models/category_data.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryItemList = [];
    for (var data in CategoryData.categoryList) {
      categoryItemList.add(_buildCategoryItem(data));
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: categoryItemList.map(
          (item) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 22, 8), child: item);
          },
        ).toList()));
  }

  _buildCategoryItem(CategoryData data) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(data.imagePath,
              width: 85.0, height: 85.0, fit: BoxFit.cover),
        ),
        SizedBox(
          height: 10,
        ),
        Text(data.titleText, style: AppTheme.textTheme.labelLarge),
        Text(
          "${data.exerciseCount} 운동",
          style: AppTheme.textTheme.labelSmall,
        )
      ],
    );
  }
}
