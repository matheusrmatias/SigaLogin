import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/models/student_card.dart';

class StudentCardService {
  StudentCardService();

  Future<StudentCard> getValidatorInfo(String url, Student student)async{
    try{
      final response = await http.get(Uri.parse(url));

      if(response.statusCode!=200)throw Exception('Erro ao carregar validação');

      final document = parse(response.body);
      final table = document.getElementsByTagName('tbody')[2];
      final name = table.children[2].children[1].text.trim();
      final shippingDate = table.children[1].children[1].text.trim();

      if(!student.name.contains(name))throw Exception('Divirgência de Estudante');

      return StudentCard(
          name: name,
          ra: student.ra,
          cpf: student.cpf,
          course: student.graduation,
          period: student.period,
          fatec: student.fatec,
          image: student.imageUrl,
          validatorUrl: url,
          shipmentDate: shippingDate
      );
    }catch(e){
      debugPrint('Error: $e');
      throw Exception('Erro ao carregar validação');
    }
  }
}