import 'package:flutter/material.dart';
import 'package:ai_trainer_mypt/models/category_data.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryItemList = [];
    for(var data in CategoryData.categoryList){
      categoryItemList.add(_buildCategoryItem(data));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryItemList.map((item){
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
            child: item
          );
        },
      ).toList()
      )
    );
  }

  _buildCategoryItem(CategoryData data){
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            data.imagePath,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover
          ),
        ), 
        Text(data.titleText),
        Text("${data.exerciseCount}개")
      ],
    );
  }
}