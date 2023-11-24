import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sigalogin/src/controllers/student_card_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/models/student_card.dart';
import 'package:sigalogin/src/repositories/student_card_repository.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/services/student_card_service.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sigalogin/src/widgets/show_modal_bootm_sheet_default.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCardPage extends StatefulWidget {
  const StudentCardPage({super.key});

  @override
  State<StudentCardPage> createState() => _StudentCardPageState();
}

class _StudentCardPageState extends State<StudentCardPage> {
  int activeIndex = 0;
  StudentCardController control = StudentCardController();
  bool inValidation = false;
  late Student student;
  late StudentCardRepository studentCardRep;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    studentCardRep = Provider.of<StudentCardRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteirinha de Estudante', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: inValidation? Center(child: CircularProgressIndicator(color: MainTheme.orange)):studentCardRep.studentCard.name==''?Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(onPressed: _reaQRCode, icon: Icon(Icons.qr_code, color: MainTheme.white,), label: Text('Validar',style: TextStyle(fontSize: 16,color: MainTheme.white,fontWeight: FontWeight.bold)),style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text('Gere sua carteirinha digital escaneando o QR Code presente na carteirinha fisica.',textAlign: TextAlign.center,))
              ],
            ),
            const SizedBox(height: 8),
          ],
        )
      ):Padding(padding: const EdgeInsets.all(16),
        child: CarouselSlider(
            items: [
              GestureDetector(onTap: ()=>showDialog(context: context, builder: (BuildContext context)=>Scaffold(body: GestureDetector(onTap: ()=>Navigator.pop(context),child: _cardWidget(),))),child: _cardWidget()),
              GestureDetector(
                child: Container(alignment: Alignment.center,child: QrImageView(data: studentCardRep.studentCard.validatorUrl,version: 9,eyeStyle: QrEyeStyle(color: Theme.of(context).colorScheme.onPrimary,eyeShape: QrEyeShape.square),dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square,color: Theme.of(context).colorScheme.onPrimary))),
                onTap: ()async=>await launchUrl(Uri.parse(studentCardRep.studentCard.validatorUrl),mode: LaunchMode.inAppWebView),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(onPressed: _deleteCard, icon: Icon(EvaIcons.trash,color: MainTheme.white,), label: Text('Excluir Carteirinha',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MainTheme.white)),style: ElevatedButton.styleFrom(backgroundColor: MainTheme.red)),
                ],
              )
            ],
            options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1,
                height: double.maxFinite,
                onPageChanged: (index, reason)=>setState(()=>activeIndex=index)
            )
        ),
      ),
      bottomNavigationBar: studentCardRep.studentCard.name==''? null:Padding(padding: const EdgeInsets.all(4),child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [AnimatedSmoothIndicator(activeIndex: activeIndex, count: 3,effect: WormEffect(activeDotColor: MainTheme.red))])),
    );
  }
  _reaQRCode()async{
    StudentCardService service = StudentCardService();
    PermissionStatus status = await Permission.camera.request();
    if(status.isDenied || status.isPermanentlyDenied){
      if(mounted)showModalBottomSheetDefault(context, 'É necessário conceder a permissão de acesso à câmera!');
      return;
    }
    
    setState(()=>inValidation = true);
    try{
      String code = await FlutterBarcodeScanner.scanBarcode(
          "#F97316",
          "Cancelar",
          true,
          ScanMode.QR
      );
      if(code=="-1"){
        Fluttertoast.showToast(msg: 'Não foi possível ler o QR Code. Tente novamente!');
        return;
      }
      if(!code.contains('https://siga.cps.sp.gov.br/fatec/sis_validador.aspx?')){
        Fluttertoast.showToast(msg: 'QR Code Inválido.');
        return;
      }
      studentCardRep.studentCard = await service.getValidatorInfo(code, student);
      await control.insertDatabase(studentCardRep.studentCard);
    }catch (e){
      debugPrint('ERROR : $e');
      if(e.toString().contains('Divirgência de Estudante'))Fluttertoast.showToast(msg: 'A carteirinha não pertence ao estudante logado ao app.');
      if(e.toString().contains('Erro ao carregar validação'))Fluttertoast.showToast(msg: 'Não foi possível validar a carteirinha.');
    }finally{
      setState(()=>inValidation=false);
    }
  }

  Future<void> _deleteCard()async{
    showModalBottomSheetConfirmAction(context, 'Confirmar exclusão da carteirinha', ()async{
      try{
        await control.deleteCard();
        studentCardRep.studentCard = StudentCard.empty();
        activeIndex=0;
      }catch (e){
        debugPrint('Error: $e');
      }
    });

  }

  Widget _cardWidget(){
    return RotatedBox(quarterTurns: 1,child:Column(
      children: [
        Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: Image.asset('assets/images/cps-logo.png', width: 150)),
                      Flexible(child:Image.asset('assets/images/logo-sp-old.png', width: 200)),
                      Flexible(child: Image.memory(studentCardRep.studentCard.image))
                    ],
                  )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text(studentCardRep.studentCard.fatec,style: TextStyle(color: MainTheme.red,fontWeight: FontWeight.bold)))
                    ],
                  )
                ],
              ),
            )
        ),
        Expanded(
            child:Container(
              padding: const EdgeInsets.all(8),
              color: MainTheme.red,
              child: Column(
                children: [
                  Flexible(child: Row(
                    children: [
                      Flexible(child: Text(studentCardRep.studentCard.name, style: _style(bold: true,fontSize: 16)))
                    ],
                  )),
                  const SizedBox(height: 8),
                  Flexible(child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('assets/images/fatec.png')
                    ],
                  )),
                  const SizedBox(height: 8),
                  Flexible(child: Row(
                    children: [
                      Flexible(child: Text('Curso Superior em ${studentCardRep.studentCard.course}', style: _style()))
                    ],
                  )),
                  const SizedBox(height: 8),
                  Flexible(child: Row(
                    children: [
                      Flexible(child: Text('PERIODO: ${studentCardRep.studentCard.period}', style: _style()))
                    ],
                  )),
                  const SizedBox(height: 8),
                  Flexible(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text('RA: ${studentCardRep.studentCard.ra}', style: _style())),
                      Flexible(child: Text('CPF: ${studentCardRep.studentCard.cpf}', style: _style()))
                    ],
                  )),
                  const SizedBox(height: 8),
                  Flexible(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text('EXPEDIÇÃO: ${studentCardRep.studentCard.shipmentDate}', style: _style())),
                      Flexible(child: Text('VALIDADE: ${_validityCalc()}', style: _style()))
                    ],
                  )),
                ],
              ),
            )
        )
      ],
    ));
  }
  String _validityCalc(){
    List<String> splited = studentCardRep.studentCard.shipmentDate.split('/');
    DateTime validity = DateTime(int.parse('20${splited[2]}'), int.parse(splited[1]), int.parse(splited[0])).add(const Duration(days: 365*3));
    return DateFormat('dd/MM/yy').format(validity);
  }
  TextStyle _style({bool bold = false, double? fontSize})=> TextStyle(color: MainTheme.white, fontWeight: bold?FontWeight.bold:FontWeight.normal, fontSize: fontSize);
}
