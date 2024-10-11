import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/sales/bloc/sales_eq_bloc.dart';
import 'package:cliff_pickleball/styles/theme_provider.dart';

import '../../di/injection.dart';
import '../../services/http/domain/productModel.dart';
import '../../styles/bg.dart';
import '../../styles/domain/app_theme.dart';
import '../../styles/text.dart';
import '../../widgets/cards.dart';
import '../cancel_payment/cancel_payment_bloc.dart';

class SalesWidget extends StatefulWidget {
  final SalesEqBloc bloc;
  const SalesWidget({super.key, required this.bloc});
  @override
  _SalesWidgetState createState() => _SalesWidgetState();
}

class _SalesWidgetState extends State<SalesWidget> {
  AppTheme appTheme() {
    return getIt<ThemeProvider>().appTheme();
  }

  final _logget = Logger();
  List<String> listCompanies = [
    "movistar",
    "digitel",
    "simpletv",
    "cantv",
    "movilnet"
  ];
  bool collapsePospaid = false;
  SalesEqBloc _bloc() => widget.bloc;

  @override
  void initState() {
    _bloc().init();
    super.initState();
  }

  Widget _showErrorMessage(
      {String errorMessage = "NO HAY SERVICIOS DISPONIBLE"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Lottie.asset("assets/img/warning.json",
                repeat: false, width: 100, height: 100)),
        SizedBox(height: 10),
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
        child: BlocConsumer<SalesEqBloc, SalesEqState>(
      bloc: _bloc(),
      listener: (context, state) {
        if (state is SuccessState) {}
      },
      builder: (context, state) {
        if (state is SalesInitialState || state is SalesLoadingProductState) {
          _bloc().init();
          return _loadingServices();
        }
        if (state is SalesLoadedProductState) {
          var products = state.products ?? [];
          products.retainWhere((element) => element.name != "CANTV_INTERNET");
          List<Widget> productColumn = [];

          for (var product in products) {
            var company = product.company?.toLowerCase();
            int isExistsImage = listCompanies.indexOf(company ?? "");
            productColumn.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  child: Cards(
                    title: Text(
                      product.formattedName ?? "",
                      style: titleStyleText("", 15),
                    ),
                    subtitle: Text(
                      product.category ?? "",
                      style: subtitleStyleText("", 12),
                    ),
                    icon: isExistsImage != -1
                        ? Image.asset("assets/img/$company.png")
                        : Image.asset("assets/img/not_found.png"),
                    rgbColor: const Color.fromARGB(255, 56, 103, 204),
                  ),
                  onTap: () => context.go("/home/product", extra: product)),
            ));
          }
          if (products.isEmpty) {
            return _showErrorMessage();
          }
          return Column(
            children: productColumn,
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
