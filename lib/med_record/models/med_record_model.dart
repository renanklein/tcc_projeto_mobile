class MedRecordModel {
  String _pacientHash;
  String _medRecordOverview;

  MedRecordModel({
    String pacientHash,
    String overview,
  }) {
    this._pacientHash = pacientHash;
    this._medRecordOverview = overview;
  }

  Map<String, dynamic> toMap() {
    return {
      'medRecordOverview': _medRecordOverview,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MedRecordModel(
      overview: map['medRecordOverview'],
    );
  }

  String get medRecordOverview => this._medRecordOverview;
  set setPacientHash(String hash) => this._pacientHash = hash;
}
