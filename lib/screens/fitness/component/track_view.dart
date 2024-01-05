import 'package:ai_trainer_mypt/models/track_data.dart';
import 'package:ai_trainer_mypt/theme.dart';
import 'package:flutter/material.dart';

class TrackView extends StatelessWidget {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context) {
    List<TrackPage> trackPageList = [];
    int trackPageCount = TrackData.trackListData.length ~/ 3;

    return Container(
        height: 320,
        child: PageView.builder(
          itemCount: trackPageCount,
          itemBuilder: (context, index) {
            return TrackPage(
              index: index,
            );
          },
          controller: PageController(viewportFraction: 0.9),
        ));
  }
}

class TrackPage extends StatelessWidget {
  TrackPage({super.key, required this.index});

  int index;

  @override
  Widget build(BuildContext context) {
    var itemList = TrackData.trackListData;
    return Container(
      child: Column(children: [
        TrackItem(data: itemList[3 * index]),
        const SizedBox(
          height: 10,
        ),
        TrackItem(data: itemList[3 * index + 1]),
        const SizedBox(
          height: 10,
        ),
        TrackItem(data: itemList[3 * index + 2])
      ]),
    );
  }
}

class TrackItem extends StatelessWidget {
  TrackItem({super.key, required this.data});

  final TrackData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              data.imagePath,
              width: 85.0,
              height: 85.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            width: 200,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTheme.textTheme.titleSmall,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    SizedBox(
                      child: Text(data.difficulty,
                          style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppTheme.lightText)),
                      width: 40,
                    ),
                    Text('|   ${data.time}분',
                        style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppTheme.lightText))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
