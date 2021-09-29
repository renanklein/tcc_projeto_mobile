import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_card.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/search_bar.dart';

class ExamScreen extends StatefulWidget {
  final pacientHash;
  ExamScreen({@required this.pacientHash});
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isDecripted = false;
  MedRecordBloc medRecordBloc;
  List cardExamInfos;
  List examDetailsList;
  List fileDownloadURLs;
  List ivs;
  Uint8List decriptedBytes = Uint8List(0);
  List<Widget> examCards = <Widget>[];
  List<Widget> examDateFilter = <Widget>[];
  List<Widget> examTypeFilter = <Widget>[];
  TextEditingController searchBarController = TextEditingController();
  TextEditingController searchExamDateController = TextEditingController();

  String get pacientHash => this.widget.pacientHash;

  @override
  void initState() {
    this.medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    this.medRecordBloc.add(GetExams(pacientHash: this.pacientHash));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedRecordBloc, MedRecordState>(
      bloc: medRecordBloc,
      listener: (context, state) {
        if (state is ExamProcessingFail) {
        } else if (state is GetExamsSuccess) {
          this.cardExamInfos = state.cardExamInfos;
          this.examDetailsList = state.examDetailsList;
          this.fileDownloadURLs = state.fileDownloadURLs;
          this.ivs = state.ivs;

          this.examCards = this._getExamCards();
        } else if (state is DecryptExamSuccess) {
          this.isDecripted = true;
          this.decriptedBytes = state.decriptedBytes;
        }
      },
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        bloc: medRecordBloc,
        builder: (context, state) {
          if (state is ExamProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }
          return Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView(
                children: [
                  SearchBar(
                    onChange: onSearchBarChange,
                    placeholder: "Digite o tipo de exame para pesquisar",
                    searchBarController: this.searchBarController,
                  ),
                  LayoutUtils.buildVerticalSpacing(10.0),
                  DateTimeFormField(
                    fieldPlaceholder: "Digite a data do exame para pesquisar",
                    dateTimeController: this.searchExamDateController,
                    onSelectedDate: onSearchExamDateChange,
                  ),
                  ...this._buildScreenBody()
                ],
              ));
        },
      ),
    );
  }

  void onFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  List<Widget> _buildScreenBody() {
    if (this.examDateFilter.length > 0 && this.examTypeFilter.length > 0) {
      return this.mergeFilterResults();
    } else if (this.examDateFilter.length > 0 &&
        this.examTypeFilter.length == 0) {
      return this.examTypeFilter;
    } else if (this.examDateFilter.length == 0 &&
        this.examTypeFilter.length > 0) {
      return this.examTypeFilter;
    }
    return examCards;
  }

  List<Widget> _getExamCards() {
    if (_existsExamInfo()) {
      List<Widget> examCards = [];
      examCards.add(Text(
        "Clique no cartão para exibir os detalhes do exame",
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
      ));

      examCards.add(LayoutUtils.buildVerticalSpacing(15.0));

      for (int i = 0; i < this.cardExamInfos.length; i++) {
        examCards.add(
          ExamCard(
            medRecordBloc: this.medRecordBloc,
            fileDownloadURL: this.fileDownloadURLs[i],
            cardExamInfo: this.cardExamInfos[i],
            examDetails: this.examDetailsList[i],
            iv: this.ivs[i],
          ),
        );
        examCards.add(LayoutUtils.buildVerticalSpacing(15.0));
      }
      return examCards;
    }
    return <Widget>[
      Container(
        child: Center(
          child: Text(
            "Nenhum exame foi encontrado",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).primaryColor),
          ),
        ),
      )
    ];
  }

  bool _existsExamInfo() {
    return (this.cardExamInfos != null && this.cardExamInfos.isNotEmpty) &&
        (this.examDetailsList != null && this.examDetailsList.isNotEmpty) &&
        (this.fileDownloadURLs != null && this.fileDownloadURLs.isNotEmpty);
  }

  void onSearchExamDateChange(DateTime examDate) {
    setState(() {
      if (examDate != null) {
        this.examDateFilter = this.examCards.where((element) {
          if (element is ExamCard) {
            var convertedDate = ConvertUtils.dateTimeFromString(
                element.cardExamInfo.getExamDate);

            if (convertedDate.day == examDate.day &&
                convertedDate.month == examDate.month &&
                convertedDate.year == convertedDate.year) {
              return true;
            }

            return false;
          }

          return false;
        }).toList();
      } else{
        this.examDateFilter = <Widget>[];
      }
    });
  }

  void sortExams(List<Widget> examWidgets) {
    examWidgets.sort((a, b) {
      if (a is ExamCard && b is ExamCard) {
        var dateA = ConvertUtils.dateTimeFromString(a.getCardExamInfo.examDate);
        var dateB = ConvertUtils.dateTimeFromString(b.getCardExamInfo.examDate);

        if (dateA.isAfter(dateB)) {
          return 1;
        }

        return -1;
      }

      return -1;
    });
  }

  void onSearchBarChange(String examType) {
    setState(() {
      this.examTypeFilter = this
          .examCards
          .where((element) =>
              element is ExamCard &&
              element.getCardExamInfo.getExamType
                  .toLowerCase()
                  .contains(examType.toLowerCase()))
          .toList();
    });
  }

  List<Widget> mergeFilterResults() {
    return this.examTypeFilter.where((element) {
      if (element is ExamCard && this.examDateFilter.contains(element)) {
        return true;
      }

      return false;
    }).toList();
  }
}
