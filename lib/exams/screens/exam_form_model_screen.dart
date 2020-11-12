import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_swiper_tile.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamFormModelScreen extends StatefulWidget {
  List dynamicFieldsList;
  final refreshExamFormModel;
  ExamFormModelScreen(
      {@required this.dynamicFieldsList, @required this.refreshExamFormModel});
  @override
  _ExamFormModelScreenState createState() => _ExamFormModelScreenState();
}

class _ExamFormModelScreenState extends State<ExamFormModelScreen> {
  MedRecordBloc _medRecordBloc;

  List<Widget> get dynamicFieldsList => this.widget.dynamicFieldsList;
  Function get refreshExamFormModel => this.widget.refreshExamFormModel;

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
            setFieldsModel(0);
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          cubit: this._medRecordBloc,
          builder: (context, state) {
            if (state is ExamProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return Stack(
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Swiper.children(
                        children:
                            ExamSwiperTile.fromFieldsList(this.examDetails),
                        onIndexChanged: (index) {
                          setFieldsModel(index);
                        },
                        autoplay: false,
                        pagination: SwiperPagination(),
                        control: SwiperControl())),
                _createInsertModelButton()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _createInsertModelButton() {
    return Positioned(
      top: 500.0,
      left: 58.0,
      height: 40.0,
      width: 300.0,
      child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text("Adicionar modelo",
              style: TextStyle(fontSize: 16.0, color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
            this.refreshExamFormModel(this.dynamicFieldsList);
          }),
    );
  }

  void setFieldsModel(int index) {
    if (this.examDetails != null) {
      this.widget.dynamicFieldsList = (examDetails[index].getFieldsWidgetList);
    }
  }
}
