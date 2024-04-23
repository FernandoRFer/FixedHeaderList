// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:signals/signals_flutter.dart';

class ListHeader {
  Widget header;
  Size size;
  ListHeader({
    this.header = const SizedBox(),
    this.size = const Size(0, 0),
  });
}

class HeaderFixed extends StatefulWidget {
  final List<List<Widget>> listItens;
  const HeaderFixed({
    super.key,
    required this.listItens,
  });
  @override
  State<HeaderFixed> createState() => _HeaderFixedState();
}

class _HeaderFixedState extends State<HeaderFixed> {
  double? heightAppBar;
  double? heightPaddingTop;
  Size header1Size = Size.zero;
  Size header2Size = Size.zero;
  List<Size> listSize = [];
  GlobalKey keyHeader1 = GlobalKey();
  GlobalKey keyHeader2 = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String title1 = "Header - 1";
  String title2 = "Header - 2";

  List<List<Widget>> listItensKey = [];

  List<ListHeader> listHeader = [];
  ListHeader currentHeader = ListHeader();
  List<bool> listVisible = [];

  late List<GlobalKey> _keys;

  List<RenderBox> listRender = [];

  bool isFirstconfiguration = true;

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.listItens.length,
      (int i) => GlobalKey(),
    );

    _scrollController.addListener(_updatePosition);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // _insertKeys();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _insertKeys();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  // void _scrollListener() {
  //   double posicaoInicial = 100; // Substitua com a posição inicial desejada
  //   if (_scrollController.offset >= posicaoInicial && _position != 1.0) {
  //     setState(() {
  //       _position = _scrollController.offset;
  //     });
  //   } else if (_scrollController.offset < posicaoInicial && _position != 0.0) {
  //     setState(() {
  //       _position = 0.0;
  //     });
  //   }
  // }

  void _insertKeys() {
    log("_insertKeys");
    for (var i = 0; widget.listItens.length > i; i++) {
      Widget header = Container(key: _keys[i], child: widget.listItens[i][0]);

      listHeader.add(ListHeader(
          header: Container(
              alignment: Alignment.topCenter,
              height: _keys[i].currentContext?.size?.height ?? 0,
              child: widget.listItens[i][0]),
          size: _keys[i].currentContext?.size ?? const Size(0, 0)));

      widget.listItens[i].removeAt(0);

      i == 0 ? listVisible.add(true) : listVisible.add(false);

      listItensKey.add([header, ...widget.listItens[i]]);
    }
  }

  void _visible(int? positionList) {
    for (var indexVisible = 0;
        listVisible.length > indexVisible;
        indexVisible++) {
      listVisible[indexVisible] = false;
    }

    if (positionList != null) {
      currentHeader = listHeader[positionList];
      listVisible[positionList] = true;
    } else {
      currentHeader = ListHeader();
    }
    setState(() {});
  }

  void _updatePosition() {
    List<double> positions = [];
    for (int i = 0; _keys.length > i; i++) {
      GlobalKey key = _keys[i];
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      positions.add(renderBox.localToGlobal(Offset.zero).dy -
          (heightAppBar ?? 0.0) -
          (heightPaddingTop ?? 0.0));
    }

    for (int i = 0; positions.length > i; i++) {
      if (!(listVisible[i])) {
        if (positions.length == i + 1) {
          if ((positions[i]) <= 0) {
            _visible(i);
            break;
          }
        } else {
          if (positions[i] <= 0 &&
              positions[i + 1] >= 0 &&
              positions[i + 1] - 150.0 >= 0) {
            log(positions[i].toString());
            _visible(i);
            break;
          }
        }
      } else {
        if (positions.length == i + 1) {
          if ((positions[i]) >= 0) {
            _visible(null);
            break;
          }
        } else {
          if (positions[i] <= 0 && (positions[i + 1] - 150.0) <= 0) {
            _visible(null);
            break;
          }
        }
      }
    }
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Fixed headers"),
    );
  }

  void _configuration(BuildContext context) {
    if (heightAppBar == null || heightPaddingTop == null) {
      heightAppBar = _appBar().preferredSize.height;
      heightPaddingTop = MediaQuery.of(context).padding.top;
    }

    isFirstconfiguration = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstconfiguration) {
      _configuration(context);
    }

    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ...listItensKey.map(
                    (e) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: e),
                  ),
                ],
              )),
          SizedBox(height: 150, child: currentHeader.header),
        ],
      ),
    );
  }
}
