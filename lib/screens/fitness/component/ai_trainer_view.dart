import 'package:ai_trainer_mypt/models/ai_trainer_view_data.dart';
import 'package:ai_trainer_mypt/providers/exercise_info_provider.dart';
import 'package:ai_trainer_mypt/screens/fitness/exercise_preparation_page.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return GestureDetector(
      onTap: () {
        Provider.of<ExerciseInfoProvider>(context, listen: false)
            .updateExerciseInfo(
          ExerciseInfo(
              type: data.type,
              targetCount: 5,
              showAnimation: true,
              supportTTS: true),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExercisePreparationPage()),
        );
      },
      child: Stack(
        children: [
          const SizedBox(
            width: 330,
            height: 160,
          ),
          Positioned(
            top: 10,
            child: Container(
              width: 330,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(data.backgroundImagePath),
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
                  image: DecorationImage(
                      image: AssetImage(data.bodyImagePath),
                      fit: BoxFit.fitHeight),
                ),
              )),
          Positioned(
              top: 70,
              left: 15,
              child: Text(
                data.prepararationTitle,
                style: AppTheme.textTheme.headlineSmall,
              ))
        ],
      ),
    );
    ;
  }
}
