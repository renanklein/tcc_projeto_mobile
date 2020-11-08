import 'package:flutter/cupertino.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';

class ExamSwiperTile extends StatelessWidget {
  final List dynamicFieldsList;
  ExamSwiperTile({@required this.dynamicFieldsList});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [...this.dynamicFieldsList],
    );
  }

  static List<ExamSwiperTile> fromFieldsList(
      List examDetailsList) {
    var examSwiperList = <ExamSwiperTile>[];

    examDetailsList.forEach((el) {
      var examSwiper = ExamSwiperTile(dynamicFieldsList: el.fieldsWidgetList);
      examSwiperList.add(examSwiper);
    });

    return examSwiperList;
  }
}
