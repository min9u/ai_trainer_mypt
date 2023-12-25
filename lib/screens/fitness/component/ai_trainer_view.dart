import 'package:ai_trainer_mypt/models/ai_trainer_view_data.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';

class AiTrainerView extends StatelessWidget {
  const AiTrainerView({super.key});

  @override
  Widget build(BuildContext context) {
    List<AiTrainerItem> aiTrainerItemList = [];
    for (var data in AiTrainerViewData.aiTrainerViewDataList) {
      aiTrainerItemList.add(AiTrainerItem(
        data: data,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: aiTrainerItemList.map((item) {
        return Padding(
          padding: EdgeInsets.only(right: 15),
          child: item,
        );
      }).toList()),
    );
  }
}

class AiTrainerItem extends StatelessWidget {
  AiTrainerItem({super.key, required this.data});

  AiTrainerViewData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 330,
          height: 160,
        ),
        Positioned(
          top: 10,
          child: Container(
            width: 330,
            height: 150,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('assets/images/ai/background_1.jpg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        Positioned(
            left: 170,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/images/ai/squat.png'),
                    fit: BoxFit.fitHeight),
              ),
            )),
        Positioned(
            top: 70,
            left: 15,
            child: Text(
              'AI 스쿼트\n트레이너',
              style: AppTheme.textTheme.headlineSmall,
            ))
      ],
    );
    ;
  }
}
