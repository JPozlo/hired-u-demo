import 'package:groceries_shopping_app/utils/constants.dart';

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
      titleTxt: Constants.drinkFoodCategory,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: Constants.pastaFoodCategory,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: Constants.wheatFoodCategory,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: Constants.wholeFoodCategory,
      isSelected: false
    ),
  ];
}
