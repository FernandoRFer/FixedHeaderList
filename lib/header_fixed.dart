import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class HeaderFixed extends StatefulWidget {
  const HeaderFixed({super.key, required this.title});

  final String title;

  @override
  State<HeaderFixed> createState() => _HeaderFixedState();
}

class _HeaderFixedState extends State<HeaderFixed> {
  double? heightAppBar;
  double? heightPaddingTop;
  final visibleHeader1 = signal(false);
  final visibleHeader2 = signal(false);
  Size header1Size = Size.zero;
  Size header2Size = Size.zero;
  List<Size> listSize = [];
  GlobalKey keyHeader1 = GlobalKey();
  GlobalKey keyHeader2 = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String title1 = "Header - 1";
  String title2 = "Header - 2";

  List<List<Widget>> listItens = [
    testList(),
    testList2(),
    testList3(),
    testList(),
    testList2(),
    testList3(),
    testList(),
    testList2(),
    testList3()
  ];

  List<List<Widget>> listItensKey = [];

  List<Widget> listHeader = [];
  Widget? currentHeader;

  final listVisible = signal([]);

  late List<GlobalKey> _keys;

  List<RenderBox> listRender = [];

  @override
  void initState() {
    super.initState();

    log("initState");
    _keys = List<GlobalKey>.generate(
      listItens.length,
      (int i) => GlobalKey(),
    );

    _scrollController.addListener(_updatePosition);
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
    for (var i = 0; listItens.length > i; i++) {
      Widget header = Container(key: _keys[i], child: listItens[i][0]);
      listHeader.add(Container(
          alignment: Alignment.topCenter,
          height: _keys[i].currentContext?.size?.height ?? 0,
          child: listItens[i][0]));
      listItens[i].removeAt(0);
      i == 0 ? listVisible.value.add(true) : listVisible.value.add(false);
      listItensKey.add([header, ...listItens[i]]);
    }
  }

  void _visible(int? positionList) {
    for (var indexVisible = 0;
        listVisible.value.length > indexVisible;
        indexVisible++) {
      listVisible.value[indexVisible] = false;
    }

    if (positionList != null) {
      currentHeader = listHeader[positionList];
      listVisible.value[positionList] = true;
    } else {
      currentHeader = const SizedBox();
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
      if (!(listVisible.value[i])) {
        if (positions.length > (i + 1) &&
            positions[i] <= 0 &&
            positions[i + 1] >= 0 &&
            positions[i + 1] - 150.0 >= 0) {
          log(positions[i].toString());
          _visible(i);
          break;
        }
        // if (positions.length == (i + 1) && positions[i] <= 0) {
        //   _visible(i);
        //   break;
        // }
      } else {
        if (positions[i] <= 0 && (positions[i + 1] - 150.0) <= 0) {
          log("null --- ${positions[i]}");
          _visible(null);
          break;
        }
      }
    }
    // Melhorar incialização de metodo
    // final RenderBox header1 =
    //     keyHeader1.currentContext!.findRenderObject() as RenderBox;
    // final RenderBox header2 =
    //     keyHeader2.currentContext!.findRenderObject() as RenderBox;

    // if (header1Size == Size.zero && header2Size == Size.zero) {
    //   header1Size = header1.size;
    //   header2Size = header2.size;
    // }

    // final renderBoxHeadPrimari = header1.localToGlobal(Offset.zero).dy -
    //     (heightAppBar ?? 0.0) -
    //     (heightPaddingTop ?? 0.0);

    // final renderBoxRedLast = header2.localToGlobal(Offset.zero).dy -
    //     (heightAppBar ?? 0.0) -
    //     (heightPaddingTop ?? 0.0);

    // header1Size = header1.size;
    // header2Size = header2.size;

    // if (renderBoxHeadPrimari <= 0 && (renderBoxRedLast - 24) >= 0) {
    //   if (visibleHeader1.value != true) {
    //     visibleHeader1.value = true;
    //   }
    // } else {
    //   if (visibleHeader1.value != false) {
    //     visibleHeader1.value = false;
    //   }
    // }

    // if (renderBoxRedLast <= 0) {
    //   if (visibleHeader2.value != true) {
    //     visibleHeader2.value = true;
    //   }
    // } else {
    //   if (visibleHeader2.value != false) {
    //     visibleHeader2.value = false;
    //   }
    // }
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Fixed headers"),
    );
  }

  Widget _header({GlobalKey? globalKey, required String title}) {
    return Padding(
      key: globalKey,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
    );
  }

  Widget _headerFixed(String title) {
    return Container(
        alignment: Alignment.topCenter,
        height: header1Size.height,
        color: Colors.white,
        child: _header(title: title));
  }

  bool _configuration(BuildContext context) {
    currentHeader ??= listHeader[0];
    if (heightAppBar == null || heightPaddingTop == null) {
      heightAppBar = _appBar().preferredSize.height;
      heightPaddingTop = MediaQuery.of(context).padding.top;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // _insertKeys();
    if (heightPaddingTop == null) {
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
          SizedBox(height: 150, child: currentHeader!),

          // ...listHeader.map((e) {log(e.key.toString());})
        ],
      ),
    );
  }
}

List<Widget> testList() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: const Text("Header 1")),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}

List<Widget> testList2() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: Colors.red,
        child: const Text("Header 1")),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}

List<Widget> testList3() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: Colors.green,
        child: const Center(
          child: Text(
            "Header 3",
          ),
        )),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}
