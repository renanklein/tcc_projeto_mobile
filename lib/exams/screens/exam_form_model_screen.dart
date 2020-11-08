import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_swiper_tile.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamFormModelScreen extends StatefulWidget {
  List dynamicFieldsList;
  final refreshExamFormModel;
  int examDetailsIndex = 0;
  ExamFormModelScreen(
      {@required this.dynamicFieldsList, @required this.refreshExamFormModel});
  @override
  _ExamFormModelScreenState createState() => _ExamFormModelScreenState();
}

class _ExamFormModelScreenState extends State<ExamFormModelScreen> {
  MedRecordBloc _medRecordBloc;

  List<Widget> get dynamicFieldsList => this.widget.dynamicFieldsList;
  Function get refreshExamFormModel => this.widget.refreshExamFormModel;
  int get examDetailsIndex => this.widget.examDetailsIndex;

  List examDetails;
  @override
  void initState() {
    this._medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    this._medRecordBloc.add(GetExams(pacientHash: null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modelos de exames"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocListener<MedRecordBloc, MedRecordState>(
        cubit: this._medRecordBloc,
        listener: (context, state) {
          if (state is GetExamsSuccess) {
            this.examDetails = state.getExamDetails;
            this.widget.dynamicFieldsList = setFieldsModel(0);
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          cubit: this._medRecordBloc,
          builder: (context, state) {
            if (state is ExamProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Swiper.children(
                children: ExamSwiperTile.fromFieldsList(this.examDetails),
                onIndexChanged: (index) {
                  this.widget.dynamicFieldsList = setFieldsModel(index);
                },
                autoplay: false,
                pagination: SwiperPagination(),
                control: SwiperControl(),
                containerHeight: 200.0,
              ),
            );
          },
        ),
      ),
    );
  }

  List setFieldsModel(int examDetailsListIndex) {
    var examDetails = this.examDetails[examDetailsListIndex];
    return examDetails.fieldsWidgetList;
  }

  // Padding(
  //             padding: const EdgeInsets.all(14.0),
  //             child: ListView(
  //               children: <Widget>[...this.dynamicFieldsList],
  //             ),
  //           );
}
