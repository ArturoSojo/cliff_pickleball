// Dependencias de Flutter
import 'package:cliff_pickleball/screens/main_screens/page_home_public.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
// Dependencias de la app
// Dependencias de https://pub.dev/
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PageProfileInstagram extends StatefulWidget {
  const PageProfileInstagram({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageProfileInstagramState createState() => _PageProfileInstagramState();
}

class _PageProfileInstagramState extends State<PageProfileInstagram>
    with SingleTickerProviderStateMixin {
  // var
  late TabController tabController;
  late ScrollController scrollController;
  double get randHeight => math.Random().nextInt(100).toDouble();
  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    scrollController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: body(),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  // WIDGETS VIEWS
  Widget body() {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        // le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        headerSliverBuilder: (context, _) {
          return [
            sliverAppBar,
            SliverList(
                delegate: SliverChildListDelegate(
                    [ContentProfileUser(context: context)])),
            sliverTabs,
          ];
        },
        // La vista de pestaña va aqui */
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _gridList(),
                  _gridList(cantidadFotos: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar get sliverAppBar {
    // style
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    // SliverAppBar : crea una barra de aplicaciones que se puede contraer y expandir
    return SliverAppBar(
      floating:
          true, // la barra de aplicaciones se desplaza hacia arriba o hacia abajo para mostrar el appbar inmediatamente
      snap:
          true, // la barra de aplicaciones se desplaza hacia arriba o hacia abajo para mostrar el appbar inmediatamente
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // view : nombre de usuario
      title: Row(
        children: [
          Text('aiivancabrera',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(width: 0.0),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ],
      ),
      actions: <Widget>[
        WidgetsUtilsApp().buttonClasicThemeBrighness(context: context),
        IconButton(
            icon: Icon(
              FontAwesomeIcons.bars,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: () {}),
      ],
    );
  }

  SliverPersistentHeader get sliverTabs {
    //! problema !// cuando se cambia de brillo el tema no se actualiza el background de [SliverAppBarDelegate]

    // style
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
// SliverPersistentHeader : astilla con [tabs] persistente al hacer scroll
    return SliverPersistentHeader(
      pinned: true, // la astilla permanece visible incluso cuando se desplaza
      delegate: SliverAppBarDelegate(
        backgroundColor: backgroundColor,
        tabBar: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Theme.of(context).textTheme.bodyLarge?.color,
          unselectedLabelColor:
              Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.5),
          indicatorColor: Theme.of(context).textTheme.bodyLarge?.color,
          tabs: const [
            Tab(icon: Icon(Icons.grid_on_outlined)),
            Tab(icon: Icon(Icons.person_pin_outlined)),
          ],
        ),
      ),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.house, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 24.0), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded, size: 24.0), label: ""),
          //BottomNavigationBarItem(icon: CircleAvatar( radius: 12.0,backgroundImage: NetworkImage( valuesApp.listaPersonas[0]["url_foto_perfil"] )) ,title:Text("Más", style: TextStyle(fontWeight: FontWeight.bold))),
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

  GridView _gridList({int cantidadFotos = 0}) {
    /// Generamos una GridList de imagenes */
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(
          cantidadFotos == 0 ? listFotos.length : cantidadFotos, (index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.black12,
            child: Image.network(listFotos[index], fit: BoxFit.cover),
          ),
        );
      }),
    );
  }
}

// Contenido del perfil del usuario
class ContentProfileUser extends StatelessWidget {
  const ContentProfileUser({super.key, required this.context});

  // values
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          fotoPerfilContadores(context: context),
          const SizedBox(height: 12.0),
          descripcion(),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  flex: 1,
                  child: button(onPressed: () {}, label: 'Editar perfil')),
              const SizedBox(width: 5.0),
              Flexible(
                  flex: 1,
                  child: button(onPressed: () {}, label: 'Compartir perfil')),
              const SizedBox(width: 5.0),
              Flexible(
                  flex: 0,
                  child:
                      button(onPressed: () {}, iconData: Icons.person_add_alt)),
            ],
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget button(
      {IconData? iconData, String? label, required Function() onPressed}) {
    // style
    Color accentColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.grey.shade200;
// Widgets
    Widget icon = iconData == null
        ? Container()
        : Icon(iconData, color: accentColor, size: 20);
    Widget text = label == null
        ? Container()
        : Text(
            label,
            style: TextStyle(color: accentColor, fontSize: 14),
          );

    return Container(
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(5.0)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              icon,
              text,
            ],
          ),
        ),
      ),
    );
  }

  Widget fotoPerfilContadores({required BuildContext context}) {
    // style
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white24
        : Colors.black12;
    double radius = 35.0;

    // var

    String imageUrl = listaPersonas[0]["url_foto_perfil"] ?? '';
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2,
              )),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).canvasColor,
              radius: radius,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ),
        // view : contadores (publicaciones : seguidores : seguidos)
        Expanded(child: _contadoroes()),
      ],
    );
  }

  /// WIDGETS
  Widget _contadoroes() {
    // Devuelve una vista con los contadores publiccaciones : seguidores : seguidos
    const double sizeWidth = 70;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: sizeWidth,
          child: Column(children: <Widget>[
            Text(
              "${listFotos.length}",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Publicaciones",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        const SizedBox(width: 5.0),
        const SizedBox(
          width: sizeWidth,
          child: Column(children: <Widget>[
            Text(
              "2.456",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Seguidores",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        const SizedBox(width: 5.0),
        const SizedBox(
          width: sizeWidth,
          child: Column(children: <Widget>[
            Text(
              "1526",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Seguidos",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ],
    );
  }

  Widget descripcion() {
    // Crea una vista de la descripción del perfil
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text("Iván Cabrera",
            style: TextStyle(fontWeight: FontWeight.w500)),
        const Text(
          "Desarrollador android 💻 \n Fotografia 🤩 \nVivo en Argetina🇦🇷",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        hyperlinkButton(urls: [
          "github.com/logicabooleana",
          "instagram.com/aiivancabrera",
          "twitter.com/aiivancabrera",
          "facebook.com/aiivancabrera"
        ]),
      ],
    );
  }

  // WIDGETS COMPONENTS
  Widget hyperlinkButton({required List<String> urls}) {
    // style
    Color accentColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    TextStyle textStyle =
        TextStyle(color: accentColor, fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: () {
        // ...
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.link_outlined, size: 16.0, color: accentColor),
          const SizedBox(width: 5.0),
          SizedBox(
              width: 150,
              child: Text(
                urls[0],
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              )),
          urls.length > 1 ? Text("y ", style: textStyle) : Container(),
          urls.length > 1
              ? Text("${urls.length - 1} más", style: textStyle)
              : Container(),
        ],
      ),
    );
  }
}

/// Delegate used to create a persistent header for the profile Instagram page.
/// Delegado utilizado para crear un encabezado persistente
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  SliverAppBarDelegate({required this.tabBar, required this.backgroundColor});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor, // Establece el color de fondo del Container
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class WidgetsUtilsApp {
  // This method returns a simple IconButton for theme brightness
  Widget buttonClasicThemeBrighness({required BuildContext context}) {
    return IconButton(
      icon: Icon(
        Icons.brightness_6,
        // Icon for theme brightness
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        // Handle theme brightness change logic here
      },
    );
  }
}

List<String> listFotos = [
  'https://example.com/image1.jpg',
  'https://example.com/image2.jpg',
  // Add more image URLs
];

GridView _gridList({int cantidadFotos = 0}) {
  return GridView.count(
    crossAxisCount: 3,
    children: List.generate(
        cantidadFotos == 0 ? listFotos.length : cantidadFotos, (index) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.black12,
          child: Image.network(listFotos[index], fit: BoxFit.cover),
        ),
      );
    }),
  );
}
