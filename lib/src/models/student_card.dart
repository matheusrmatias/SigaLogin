import 'dart:typed_data';

class StudentCard{
  String name;
  String ra;
  String cpf;
  String course;
  String period;
  String fatec;
  Uint8List image;
  String validatorUrl;

  String shipmentDate;

  StudentCard({
    required this.name,
    required this.ra,
    required this.cpf,
    required this.course,
    required this.period,
    required this.fatec,
    required this.shipmentDate,
    required this.image,
    required this.validatorUrl
  });

  factory StudentCard.empty()=>StudentCard(
    cpf: '',
    course: '',
    fatec: '',
    name: '',
    period: '',
    ra: '',
    image: Uint8List.fromList([]),
    shipmentDate: '',
    validatorUrl: ''
  );
}