import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../di/injection.dart';
import '../../services/http/domain/productModel.dart';
import '../../styles/bg.dart';
import '../../styles/domain/app_theme.dart';
import '../../styles/text.dart';
import '../../styles/theme_provider.dart';
import '../../utils/pos_getter.dart';
import '../../widgets/cards.dart';
import '../cancel_payment/cancel_payment_bloc.dart';
import '../sales/bloc/sales_eq_bloc.dart';
import 'bloc/pos_eq_bloc.dart';

class PosWidget extends StatefulWidget {
  final PosEqBloc bloc;
  final AppTheme appTheme;
  PosWidget({super.key, required this.bloc, required this.appTheme});
  @override
  _PosWidgetState createState() => _PosWidgetState();
}

class _PosWidgetState extends State<PosWidget> {
  final _logget = Logger();
  bool collapsePospaid = false;
  PosEqBloc _bloc() => widget.bloc;

  @override
  void initState() {
    _bloc().init();
    super.initState();
  }

  Widget _showErrorMessage(
      {String errorMessage = "NO HAY VISTAS DISPONIBLES"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Lottie.asset("assets/img/warning.json",
                repeat: false, width: 100, height: 100)),
        const SizedBox(height: 10),
        Text(errorMessage),
      ],
    );
  }

  Widget _loadingServices() {
    return const LoadingList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocConsumer<PosEqBloc, PosEqState>(
      bloc: _bloc(),
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PosInitialState || state is PosLoadingProductState) {
          _bloc().init();
          return _loadingServices();
        }
        if (state is PosLoadedProductState) {
          var views = state.views ?? [];
          List<Widget> viewColumn = [];

          for (var view in views) {
            var nameLC = view.name?.toLowerCase();
            var imgRoute = getImgName(nameLC ?? "", widget.appTheme);
            var route = getRoute(nameLC ?? "");
            viewColumn.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                child: Cards(
                  title: Text(
                    translate(view.name ?? ""),
                    style: titleStyleText("", 15),
                  ),
                  subtitle: Text(
                    getSubtitle(nameLC ?? ""),
                    style: subtitleStyleText("", 12),
                  ),
                  icon: Image(
                    image:
                        AssetImage("${widget.appTheme.assetsImg.uri}$imgRoute"),
                  ),
                  rgbColor: const Color.fromARGB(255, 56, 103, 204),
                ),
                onTap: () => context.go("/home/$route"),
              ),
            ));
          }
          if (views.isEmpty) {
            return _showErrorMessage();
          }
          return Column(
            children: viewColumn,
          );
        }
        return _showErrorMessage();
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc().close();
  }
}

class LoadingList extends StatelessWidget {
  const LoadingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> viewLoad = [];
    for (var i = 0; i < 20; i++) {
      viewLoad.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Cards(
            title: Text(
              "Cargando servicios",
              style: titleStyleText("", 15),
            ),
            subtitle: Text(
              "Cargando servicios",
              style: subtitleStyleText("", 12),
            ),
            icon: const SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()),
            rgbColor: const Color.fromARGB(255, 56, 103, 204),
          ),
        ),
      );
    }
    return Column(children: viewLoad);
  }
}
