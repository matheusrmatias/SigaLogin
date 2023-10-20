import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class SliverAppBarSearch extends StatefulWidget {
  Function(String)? onChanged;
  SliverAppBarSearch({super.key, required this.onChanged});


  @override
  State<SliverAppBarSearch> createState() => _SliverAppBarSearchState();
}

class _SliverAppBarSearchState extends State<SliverAppBarSearch> {
  bool focus = false;
  final FocusNode _focusNode = FocusNode();

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
      backgroundColor: MainTheme.black,
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: MainTheme.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(child: TextField(
              focusNode: _focusNode,
              style: TextStyle(fontSize: 14,color: MainTheme.black),
              cursorColor: MainTheme.orange,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(color: MainTheme.black, fontSize: 14),
                  icon: Icon(Icons.search, color: focus?MainTheme.orange:MainTheme.black)
              ),
              onTapOutside: (e)=>_focusNode.unfocus(),
              onChanged: widget.onChanged,
            )),
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
