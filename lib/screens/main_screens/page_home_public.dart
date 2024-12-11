/// Copyright 2020 Logica Booleana Authors

// Dependencias
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
// Los link de de las depedencias se pueden encontrar en "Más" => Dependencias
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Variables
const List listaPersonas = [
  {
    "nombre": "Lucas ivan",
    "usuario": "aiivan3434",
    "live": false,
    "vista": false,
    "url_foto_perfil":
        "https://ichef.bbci.co.uk/news/640/cpsprodpb/153EB/production/_105191078_selfie1.jpg",
    "dashes": 1,
  },
  {
    "nombre": "Leonel Messi",
    "usuario": "leomessi10",
    "live": true,
    "vista": false,
    "url_foto_perfil": "https://pbs.twimg.com/media/B338156CIAAABM_.jpg",
    "dashes": 14,
    "url_image_post":
        "https://yt3.googleusercontent.com/EiSNfp4PrK2C1lRckYaf6ysm_TcIfhUldoMjBInAO0C62JF-ipIgrcI4yYqXYBDBSNkDSair=s160-c-k-c0x00ffffff-no-rj",
  },
  {
    "nombre": "Leonela Ibañes",
    "usuario": "leonela21324",
    "live": true,
    "vista": false,
    "url_foto_perfil":
        "https://juanbustos.com/wp-content/uploads/2018/10/Selfie.jpg",
    "dashes": 2,
    "url_image_post":
        "https://i.ytimg.com/an_webp/FwWrsdaIe5U/mqdefault_6s.webp?du=3000&sqp=CKf0_bkG&rs=AOn4CLA-FloSfxhMlcBmS2Qq0mHEhrWh-g",
  },
  {
    "nombre": "Matia Cat",
    "usuario": "matieldm753",
    "live": false,
    "vista": false,
    "url_foto_perfil": "https://i.ytimg.com/vi/gLxO5R61hFI/maxresdefault.jpg",
    "dashes": 5,
    "url_image_post":
        "https://i.ytimg.com/vi/CixYBRBJsd0/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA90uVQ3rMtd0prz7JJYzs8j-0CGg",
  },
  {
    "nombre": "Eugenia Suarez",
    "usuario": "eugedehuracan",
    "vista": false,
    "url_foto_perfil":
        "https://i.pinimg.com/564x/3b/e1/e5/3be1e5f82073d219df18ea2b09db1f3a.jpg",
    "dashes": 2,
    "url_image_post":
        "https://i.ytimg.com/an_webp/Pav33jYfxWw/mqdefault_6s.webp?du=3000&sqp=CPSF_rkG&rs=AOn4CLBQmjA6LIRKLKDJdgJkVVTE1rvQdg",
  },
  {
    "nombre": "Jenifer Solange Urquiza",
    "usuario": "jeniurquiza2",
    "live": false,
    "vista": false,
    "url_foto_perfil":
        "https://i.pinimg.com/474x/77/56/06/775606b331fcb0a44dad916143bddf61.jpg",
    "dashes": 1,
    "url_image_post":
        "https://i.ytimg.com/an_webp/onByrBWqByg/mqdefault_6s.webp?du=3000&sqp=CLD6_bkG&rs=AOn4CLCBThPKotiHa5ugzOPK1TgcjxSLRQ",
  },
  {
    "nombre": "Manuel Albastro",
    "usuario": "manualbastro93",
    "live": false,
    "vista": false,
    "url_foto_perfil":
        "https://www.okchicas.com/wp-content/uploads/2015/10/chico-transg%C3%A9nero-toma-una-selfie-cada-d%C3%ADa-4.jpg",
    "dashes": 0,
    "url_image_post":
        "https://i.ytimg.com/an_webp/zUMTe5vXAnE/mqdefault_6s.webp?du=3000&sqp=CJXz_bkG&rs=AOn4CLBRssmPdHgbJs2OGv-rOsbTeUHkUg",
  },
  {
    "nombre": "Maria Lopez",
    "usuario": "mariilopez93",
    "live": false,
    "vista": false,
    "url_foto_perfil":
        "https://viapais.cdncimeco.com/media/cache/resolve/medium/http://viapais.com.ar/files/2017/10/20171020160548_30251308_0_body.jpg",
    "dashes": 0,
    "url_image_post":
        "https://i.ytimg.com/an_webp/srP_nJ3D0ks/mqdefault_6s.webp?du=3000&sqp=CJD-_bkG&rs=AOn4CLAlLkRTbm1MwOsyM8Z-bdHwCoFP1Q",
  },
];
bool isDarkMode = false;
List<Color> colorGradientInstagram = [
  Color.fromRGBO(129, 52, 175, 1.0),
  Color.fromRGBO(129, 52, 175, 1.0),
  Color.fromRGBO(221, 42, 123, 1.0),
  Color.fromRGBO(254, 218, 119, 1.0)
];

class PageListaInstagram extends StatefulWidget {
  @override
  _PageListaInstagramState createState() => _PageListaInstagramState();
}

class _PageListaInstagramState extends State<PageListaInstagram>
    with SingleTickerProviderStateMixin {
  // var
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(),
      body: body(context: context),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

// WIDGETS VIEWS
  PreferredSizeWidget appbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Text("Cliff Pickleball",
          style: GoogleFonts.abel(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).iconTheme.color)),
      actions: <Widget>[
        IconButton(
            icon: const FaIcon(Icons.send, size: 24.0),
            onPressed: () {},
            color: Theme.of(context).iconTheme.color)
      ],
    );
  }

  Widget body({required BuildContext context}) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listaPersonas.length,
        itemBuilder: (context, index) => index == 0
            ? listViewHorizontalHistory(context: context)
            : Publication(context: context, obj: listaPersonas[index]),
      ),
    );
  }

  Widget listViewHorizontalHistory({required BuildContext context}) {
    double size = 120.0;

    return SizedBox(
      height: size,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listaPersonas.length,
          itemBuilder: (BuildContext context, int index) {
            return index == 0
                ? AddStory(
                    size: size - 40,
                    context: context,
                    person: listaPersonas[index])
                : listaPersonas[index]["live"] ?? false
                    ? LiveStoryCircle(
                        size: size - 40,
                        color: Colors.purple,
                        person: listaPersonas[index],
                        colorCanvas: Theme.of(context).canvasColor)
                    : StoryCicle(person: listaPersonas[index], size: size - 40);
          }),
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(canvasColor: Theme.of(context).scaffoldBackgroundColor),
      child: BottomNavigationBar(
        elevation: 10.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.search, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.plusSquare, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 12.0,
                  backgroundImage:
                      NetworkImage(listaPersonas[0]["url_foto_perfil"])),
              label: "Más"),
        ],
        currentIndex: 0,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white60
            : Colors.black54,
      ),
    );
  }

  // Function
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}

class Publication extends StatefulWidget {
  const Publication({
    required this.context,
    required this.obj,
  });

  final BuildContext context;
  final dynamic obj;

  @override
  _PublicationState createState() => _PublicationState();
}

class _PublicationState extends State<Publication> {
  bool like = false;
  bool save = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  DashedCircle(
                    dashes: widget.obj["dashes"],
                    gradientColor: colorGradientInstagram,
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                            backgroundColor: Theme.of(context).canvasColor,
                            radius: 15.0,
                            backgroundImage:
                                NetworkImage(widget.obj["url_foto_perfil"]))),
                  ),
                  SizedBox(width: 10.0),
                  Text(widget.obj["nombre"],
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              IconButton(icon: Icon(Icons.more_vert), onPressed: null)
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            color: Colors.black12,
            child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.color,
                width: MediaQuery.of(context).size.width,
                imageUrl:
                    widget.obj["url_image_post"] ?? "https://picsum.photos/500",
                placeholder: (context, urlImage) => Container(
                      color: Colors.grey[300],
                      height: 300,
                    ),
                errorWidget: (context, urlImage, error) => Center(
                        child: Container(
                      color: Colors.grey[300],
                      height: 300,
                      child: Center(
                          child: Icon(
                        Icons.error_outline_outlined,
                        color: Colors.white,
                      )),
                    ))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () => setState(() => like = !like),
                    icon: Icon(
                        like
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: like ? Colors.red : null),
                  ),
                  SizedBox(width: 12.0),
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.comment),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () => setState(() => save = !save),
                icon: Icon(
                    save
                        ? FontAwesomeIcons.solidBookmark
                        : FontAwesomeIcons.bookmark,
                    color: save ? Colors.black : null),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: const <TextSpan>[
                TextSpan(text: 'Le gusto a '),
                TextSpan(
                    text: '_leslie23 ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'y a '),
                TextSpan(
                    text: '528 personas más',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: <TextSpan>[
                TextSpan(
                    text: '${widget.obj["usuario"]} ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'A publication'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: Text('ver los 12 comentarios',
              style: TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.obj["url_foto_perfil"])),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Agregar un comentario...",
                        hintStyle: TextStyle(fontSize: 14.0))),
              ),
            ],
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            child: Text("Hace 1 día",
                style: TextStyle(color: Colors.grey, fontSize: 11.0)))
      ],
    );
  }
}

class AddStory extends StatelessWidget {
  AddStory({required this.context, required this.person, this.size = 80.0});
  final BuildContext context;
  final double size;
  final dynamic person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: size * 0.95,
                  height: size * 0.95,
                  padding: EdgeInsets.all(4.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[isDarkMode ? 900 : 200],
                      radius: 50.0,
                      backgroundImage: NetworkImage(person["url_foto_perfil"])),
                ),
                Positioned(
                  right: size * 0.08,
                  bottom: size * 0.08,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).canvasColor,
                    child: CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        radius: 8.5,
                        child:
                            Icon(Icons.add, size: 14.0, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Text("Tu historia",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

//  Dibujamos una circulo para representar una historia
const List<Color> _DefaultGradient = [Color.fromRGBO(129, 52, 175, 1.0)];

class StoryCicle extends StatelessWidget {
  StoryCicle({required this.person, this.size = 80});
  final dynamic person;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: size * 0.95,
                    height: size * 0.95,
                    child: DashedCircle(
                      dashes: person["dashes"],
                      gradientColor: colorGradientInstagram,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CircleAvatar(
                            backgroundColor:
                                Colors.grey[isDarkMode ? 900 : 200],
                            radius: 24.0,
                            backgroundImage:
                                NetworkImage(person["url_foto_perfil"])),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text("${person["usuario"]}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center)
            ]));
  }
}

class DashedCircle extends StatelessWidget {
  // var
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;
  final Widget child;

  DashedCircle(
      {required this.child,
      this.dashes = 20,
      this.gradientColor = _DefaultGradient,
      this.gapSize = 3.0,
      this.strokeWidth = 2.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(
          gradientColor: gradientColor,
          dashes: dashes,
          gapSize: gapSize,
          strokeWidth: strokeWidth),
      child: child,
    );
  }
}

// CustomPainter
class _DashedCirclePainter extends CustomPainter {
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;

  _DashedCirclePainter(
      {this.dashes = 0,
      this.gradientColor = _DefaultGradient,
      this.gapSize = 3.0,
      this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = pi / 180 * gapSize;
    final double singleAngle = (pi * 2) / dashes;

    // crear un cuadrado delimitador, basado en el centro y el radio del arco
    Rect rect = Rect.fromCircle(center: Offset(165.0, 55.0), radius: 190.0);
    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..shader = RadialGradient(colors: gradientColor).createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawArc(Offset.zero & size, gap + singleAngle * i,
          singleAngle - gap * 1, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      dashes != oldDelegate.dashes;
}

//  CLASS: Dibujamos una circulo animado para representar un Vivo
class LiveStoryCircle extends StatefulWidget {
  const LiveStoryCircle(
      {Key? key,
      required this.person,
      this.size = 100.0,
      this.color = Colors.purple,
      this.colorCanvas = Colors.transparent})
      : super(key: key);
  final double size;
  final Color color, colorCanvas;
  final dynamic person;

  @override
  _LiveStoryCircleState createState() => _LiveStoryCircleState();
}

class _LiveStoryCircleState extends State<LiveStoryCircle>
    with SingleTickerProviderStateMixin {
  // var
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    _startAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    controller.stop();
    controller.reset();
    controller.repeat(period: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(bottom: 5),
                  width: widget.size * 0.95,
                  height: widget.size * 0.95,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: SpritePainter(
                            animation: controller, sizePaint: widget.size),
                        child: Container(
                            color: Colors.transparent,
                            width: widget.size * 0.70,
                            height: widget.size * 0.70,
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.person["url_foto_perfil"] ??
                                      "default"),
                              backgroundColor: Colors.transparent,
                            )),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border:
                                  Border.all(color: widget.color, width: 2.0))),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: widget.colorCanvas,
                            width: widget.size * 0.03),
                        borderRadius: BorderRadius.circular(8),
                        color: widget.color),
                    child: Text("VIVO",
                        style: TextStyle(
                            fontSize: widget.size * 0.08, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text("${widget.person["usuario"]}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

// anim CustomPainter
class SpritePainter extends CustomPainter {
  SpritePainter(
      {required this.animation,
      this.sizePaint = 100.0,
      this.color = Colors.purple})
      : super(repaint: animation);
  final Animation<double> animation;
  final double sizePaint;
  final Color color;

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(.0, 1.0);
    Color color = this.color.withOpacity(opacity);

    double size = this.sizePaint / 2;
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}
