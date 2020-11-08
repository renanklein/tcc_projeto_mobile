import 'package:flutter/cupertino.dart';

class ExamSwiperTile extends StatelessWidget {
  final List dynamicFieldsList;
  ExamSwiperTile({@required this.dynamicFieldsList});
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: this.dynamicFieldsList);
  }

  static List<ExamSwiperTile> fromFieldsList(List examDetailsList) {
    var examSwiperList = <ExamSwiperTile>[];

    if (examDetailsList != null) {
      examDetailsList.forEach((el) {
        var examSwiper = ExamSwiperTile(dynamicFieldsList: el.fieldsWidgetList);
        examSwiperList.add(examSwiper);
      });
    }

    return examSwiperList;
  }
}
