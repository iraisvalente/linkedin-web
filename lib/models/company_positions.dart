import 'package:project/models/position.dart';

class CompanyPositions {
  String company;
  List<Position> positions;

  CompanyPositions({
    required this.company,
    required this.positions,
  });

  factory CompanyPositions.fromMap(Map<String, dynamic> map) {
    return CompanyPositions(
      company: map['Company'],
      positions: List<Position>.from(
        map['Positions']?.map((x) => Position.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Company': company,
      'Positions': List<dynamic>.from(positions.map((x) => x.toJson())),
    };
  }
}
