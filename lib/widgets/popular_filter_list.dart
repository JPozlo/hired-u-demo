class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Drinks',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Vegetables',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Fruits',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Pasta & Noodles',
      isSelected: false
    ),
    PopularFilterListData(
      titleTxt: 'Whole Meals',
      isSelected: false,
    ),
  ];
}
