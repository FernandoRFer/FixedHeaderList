import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:sticky_headers/sticky_headers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixed headers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? heightAppBar;
  double? heightPaddingTop;
  final visibleHeader1 = signal(false);
  final visibleHeader2 = signal(false);
  Size header1Size = Size.zero;
  Size header2Size = Size.zero;

  GlobalKey keyHeader1 = GlobalKey();
  GlobalKey keyHeader2 = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String title1 = "Header - 1";
  String title2 = "Header - 2";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updatePosition);
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

  void _updatePosition() {
    // Melhorar incialização de metodo
    final RenderBox header1 =
        keyHeader1.currentContext!.findRenderObject() as RenderBox;
    final RenderBox header2 =
        keyHeader2.currentContext!.findRenderObject() as RenderBox;

    if (header1Size == Size.zero && header2Size == Size.zero) {
      header1Size = header1.size;
      header2Size = header2.size;
    }

    final renderBoxHeadPrimari = header1.localToGlobal(Offset.zero).dy -
        (heightAppBar ?? 0.0) -
        (heightPaddingTop ?? 0.0);

    final renderBoxRedLast = header2.localToGlobal(Offset.zero).dy -
        (heightAppBar ?? 0.0) -
        (heightPaddingTop ?? 0.0);

    header1Size = header1.size;
    header2Size = header2.size;

    if (renderBoxHeadPrimari <= 0 && (renderBoxRedLast - 24) >= 0) {
      if (visibleHeader1.value != true) {
        visibleHeader1.value = true;
      }
    } else {
      if (visibleHeader1.value != false) {
        visibleHeader1.value = false;
      }
    }

    if (renderBoxRedLast <= 0) {
      if (visibleHeader2.value != true) {
        visibleHeader2.value = true;
      }
    } else {
      if (visibleHeader2.value != false) {
        visibleHeader2.value = false;
      }
    }
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
    if (heightAppBar == null || heightPaddingTop == null) {
      heightAppBar = _appBar().preferredSize.height;
      heightPaddingTop = MediaQuery.of(context).padding.top;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _configuration(context);
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _header(globalKey: keyHeader1, title: title1),
                Container(height: 150, color: Colors.yellow),
                Container(height: 150, color: Colors.yellowAccent),
                Container(height: 150, color: Colors.yellow),
                Container(height: 150, color: Colors.yellowAccent),
                Container(height: 150, color: Colors.yellow),
                _header(globalKey: keyHeader2, title: title2),
                Container(height: 150, color: Colors.grey),
                Container(height: 150, color: Colors.grey[400]),
                Container(height: 150, color: Colors.grey),
                Container(height: 150, color: Colors.grey[400]),
                Container(height: 150, color: Colors.grey),
                Container(height: 150, color: Colors.grey[400]),
              ],
            ),
          ),
          Visibility(
            visible: visibleHeader1.watch(context),
            child: _headerFixed(title1),
          ),
          Visibility(
            visible: visibleHeader2.watch(context),
            child: _headerFixed(title2),
          ),
        ],
      ),
    );
  }
}
