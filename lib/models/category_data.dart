class CategoryData {
    CategoryData({
        this.imagePath = '',
        this.titleText = '',
        this.exerciseCount = 0
    });

    String imagePath;
    String titleText;
    int exerciseCount;

    static List<CategoryData> categoryList = <CategoryData>[
    CategoryData(
        imagePath: 'assets/images/category/back.jpg',
        titleText: '등',
        exerciseCount: 5
    ),
    CategoryData(
        imagePath: 'assets/images/category/chest.jpg',
        titleText: '가슴',
        exerciseCount: 3
    ),
    CategoryData(
        imagePath: 'assets/images/category/leg.jpg',
        titleText: '하체',
        exerciseCount: 4
    ),
    CategoryData(
        imagePath: 'assets/images/category/sixpack.jpg',
        titleText: '복근',
        exerciseCount: 3
    ),
    CategoryData(
        imagePath: 'assets/images/category/full_body.jpg',
        titleText: '전신',
        exerciseCount: 2
    ),
];


}