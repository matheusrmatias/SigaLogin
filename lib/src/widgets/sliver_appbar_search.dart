import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class SliverAppBarSearch extends StatefulWidget {
  Function(String)? onChanged;
  String? text;
  SliverAppBarSearch({super.key, required this.onChanged,this.text});


  @override
  State<SliverAppBarSearch> createState() => _SliverAppBarSearchState();
}

class _SliverAppBarSearchState extends State<SliverAppBarSearch> {
  bool focus = false;
  final FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {_onFocusChange();});
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      centerTitle: true,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: [
            Expanded(child: TextField(
              focusNode: _focusNode,
              controller: controller,
              style: const TextStyle(fontSize: 14),
              cursorColor: MainTheme.orange,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.text??'Pesquisar',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: Icon(Icons.search, color: focus?MainTheme.orange:Theme.of(context).colorScheme.onPrimary)
              ),
              onTapOutside: (e)=>_focusNode.unfocus(),
              onChanged: widget.onChanged,
            )),
            controller.text.isEmpty? const SizedBox():GestureDetector(onTap: (){
              controller.clear();
              widget.onChanged!('');
            }, child: Icon(Icons.close,color: MainTheme.black))
          ],
        ),
      ),
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
