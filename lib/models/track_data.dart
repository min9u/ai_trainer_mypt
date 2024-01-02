class TrackData {
  TrackData({
    this.imagePath = '',
    this.title = '',
    this.difficulty = '',
    this.time = 0,
    this.exerciseCount = 0
  });

  String imagePath;
  String title;
  String difficulty;
  int time;
  int exerciseCount;

  static List<TrackData> trackListData = <TrackData>[
    TrackData(
      imagePath: 'assets/images/track/track_back.jpg',
      title: '선명한 등 만들기',
      difficulty: '상급',
      time: 20,
      exerciseCount: 3
    ),
    TrackData(
      imagePath: 'assets/images/track/track_belly.jpg',
      title: '뱃살 태우기 🔥',
      difficulty: '초급',
      time: 15,
      exerciseCount: 4
    ),
    TrackData(
      imagePath: 'assets/images/track/track_hanging.jpg',
      title: '매달려서 하는 운동',
      difficulty: '상급',
      time: 20,
      exerciseCount: 3
    ),
    TrackData(
      imagePath: 'assets/images/track/track_dumbbell.jpg',
      title: '덤벨을 사용하는 전신 운동',
      difficulty: '중급',
      time: 15,
      exerciseCount: 3
    ),
    TrackData(
      imagePath: 'assets/images/track/track_stretch.jpg',
      title: '운동 전 가벼운 스트레칭',
      difficulty: '초급',
      time: 10,
      exerciseCount: 2
    ),
    TrackData(
      imagePath: 'assets/images/track/track_health.jpg',
      title: '회사원들을 위한 체력 기르기',
      difficulty: '중급',
      time: 20,
      exerciseCount: 4
    ),
    TrackData(
      imagePath: 'assets/images/track/track_shoulder.jpg',
      title: '어깨뽕 만들기',
      difficulty: '중급',
      time: 15,
      exerciseCount: 2
    ),
    TrackData(
      imagePath: 'assets/images/track/track_yoga.jpg',
      title: '마음과 몸을 편안하게, 요가',
      difficulty: '중급',
      time: 15,
      exerciseCount: 4
    ),
    TrackData(
      imagePath: 'assets/images/track/track_arm.jpg',
      title: '소매를 꽉 채우는 팔 운동',
      difficulty: '중급',
      time: 20,
      exerciseCount: 3
    ),
  ];
}