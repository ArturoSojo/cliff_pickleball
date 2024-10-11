import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import '../../styles/theme_provider.dart';
import '../../utils/error_message.dart';
import '../../utils/staticNamesRoutes.dart';
import '../recharge/models/recharge_model.dart';
import 'bloc/store_bloc.dart';
import 'models/store_model.dart';

class StoreScreen extends StatefulWidget {
  StoreBloc bloc;
  StoreScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  StoreBloc _bloc() => widget.bloc;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  Widget _loadingCenter(){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text("Cargando inventario")
          ]),
    );
  }


  Widget _buttonPayment() {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.payment, color: ColorUtil.white),
          style: TextButton.styleFrom(
            backgroundColor: _colorProvider.primary(),
            padding: const EdgeInsets.all(20)),
          onPressed: () => _bloc().goNext(path: StaticNames.recharge.name),
          label: const Text(
            "COMPRA DE INVENTARIO", 
            style: TitleTextStyle(color: ColorUtil.white),
          )),
    );
  }
  Widget _consigedWidget(Results consigned){
    return Column(children: [
      const Text(
        "INVENTARIO EN CONSIGNACIÓN", 
        style: TitleTextStyle(
          fontWeight: FontWeight.bold, 
          color: ColorUtil.black, 
          fontSize: 20
        ),
      ),
      const Text(
        "(Pospago)", 
        style: TitleTextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.grey, 
          fontSize: 12
        ),
      ),
      const SizedBox(height: 15),
      consigned.minLimit != null 
      ? Column(
          children: [
            const Text(
              "Cantidad límite unidades: ", 
              style: TitleTextStyle(
                fontWeight: FontWeight.bold, 
                color: ColorUtil.black, 
                fontSize: 15
              ),
            ),
            Text(
              "${consigned.formattedMinLimit?.toString()} unid.", 
              style: TitleTextStyle(
                fontWeight: FontWeight.bold, 
                color: _colorProvider.primary(), 
                fontSize: 25
              ),
            ),
          ],
        )
      : const SizedBox(),
      consigned.balance != null 
      ? Column(
          children: [
            const Text(
              "Cantidad de unidades disponibles: ", 
              style: TitleTextStyle(
                fontWeight: FontWeight.bold, 
                color: ColorUtil.black, 
                fontSize: 15
              ),
            ),
            Text(
              "${consigned.formattedBalance?.toString()} unid.", 
              style: TitleTextStyle(
                fontWeight: FontWeight.bold, 
                color: _colorProvider.primary(), 
                fontSize: 25
              ),
            ),
          ],
        )
      : const SizedBox(),
      TextButton(
        onPressed: () => _bloc().goNext(path: StaticNames.detailsStore.name, product: consigned),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: const [
              Text("Ver detalles"), Icon(Icons.arrow_forward)
            ],
          )
        ),
    ]);
  }

  Widget _inventory(Results product, Results? consigned){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              product.type=="PREPAY" ? Column(
                children: [
                  const Text(
                    "INVENTARIO DISPONIBLE", 
                    style: TitleTextStyle(
                      fontWeight: FontWeight.bold, 
                      color: ColorUtil.black, 
                      fontSize: 20
                    )
                  ),
                  const Text("(Prepago)", style: TitleTextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),),
                  Text("${product.formattedBalance!} unid.", style: TitleTextStyle(fontWeight: FontWeight.bold, color: _colorProvider.primary(), fontSize: 30),),
                  TextButton(onPressed: () => _bloc().goNext(path: StaticNames.detailsStore.name, product: product),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: const [
                          Text("Ver detalles"), 
                          Icon(Icons.arrow_forward)
                        ],
                      )
                    ),
                  const SizedBox(height: 10),
                  consigned != null ? _consigedWidget(consigned) : SizedBox(),
                ],
              ): consigned != null ? _consigedWidget(consigned) : SizedBox(),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _buttonPayment()
            ],)

          ],
        ),
      ),
    );
  }

  void dialog(String errorMessage) =>
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(title: Text(errorMessage),);
          });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StoreBloc, StoreState>(
        bloc: _bloc(),
        listener: (context, state){
          if(state is StoreGoNextState){
            if(state.product!=null){
              context.goNamed(state.next, extra: state.product);
            }else{
              if(state.listTypes!=null){
                context.goNamed(state.next, extra: state.listTypes);
              }
              // context.goNamed(state.next);
            }
          }
        },
        builder: (context, state){
          if(state is StoreLoadedState){
            var inventory = state.inventory?.results?[0];
            var consigned = state.consigned;

            if(inventory!=null){
              return _inventory(inventory, consigned);
            }
          }
          if(state is StoreLoadingState){
            _bloc().mInventory();
            return _loadingCenter();
          }
          if(state is StoreErrorState){
            return Center(child: SingleChildScrollView(child: ShowErrorMessage(errorMessage: state.errorMessage, error: true)));
          }
          return Center(child: SingleChildScrollView(child: ShowErrorMessage(errorMessage: "No hay inventario disponible", error: false)));
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc().close();
    super.dispose();
  }
}
