import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class LoginInput extends StatefulWidget {
  Icon? icon;
  TextEditingController controller;
  String? hint;
  bool? obscure;
  TextInputType? inputType;
  List<TextInputFormatter>? inputFormat;
  int? maxLength;
  bool? enbled;
  Iterable<String>? autofillHints;
  Function()? onEditingComplete;
  LoginInput({super.key, required this.controller, this.icon, this.hint, this.obscure, this.inputType, this.inputFormat, this.maxLength, this.enbled,this.autofillHints,this.onEditingComplete});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final FocusNode _focusNode = FocusNode();
  bool focus = false;
  late bool hidden;

  @override
  void initState() {
    _focusNode.addListener(()=>_onFocusChange());
    hidden = widget.obscure ?? false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MainTheme.white,
        borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
      child: Row(
        children: [
          Expanded(child: TextField(
            onSubmitted: (e){
              _focusNode.unfocus();
            },
            onChanged: (e){
              widget.onEditingComplete!();
            },
            onEditingComplete: widget.onEditingComplete,
            autofillHints: widget.autofillHints,
            enabled: widget.enbled,
            focusNode: _focusNode,
            inputFormatters: widget.inputFormat,
            keyboardType: widget.inputType,
            cursorColor: MainTheme.orange,
            style: TextStyle(color: MainTheme.black,fontSize: 16),
            obscureText: hidden,
            onTapOutside: (e)=>_focusNode.unfocus(),
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: widget.icon,
              iconColor: focus?MainTheme.orange:MainTheme.black,
              hintText: widget.hint,
              hintStyle: TextStyle(color: MainTheme.black),
              counterText: ''
            ),
            controller: widget.controller,
          )),
          widget.obscure!=null?IconButton(onPressed: (){setState(()=>hidden=!hidden!);}, icon: Icon(hidden?EvaIcons.eyeOff:EvaIcons.eye, color: focus?MainTheme.orange:MainTheme.black)):const SizedBox()
        ],
      )
    );
  }

  _onFocusChange(){
    if(_focusNode.hasFocus){
      setState(()=>focus=true);
    }else{
      setState(()=>focus=false);
    }
  }

}
