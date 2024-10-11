import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';
import 'package:cliff_pickleball/pages/new_sale/view/input_screen.dart';
import 'package:cliff_pickleball/pages/new_sale/view/insert_card.dart';
import 'package:cliff_pickleball/pages/new_sale/view/receipt.dart';

import '../../../styles/bg.dart';
import '../../../styles/text.dart';
import '../new_sale_bloc.dart';
import 'choose_type_account.dart';
import 'error.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({Key? key}) : super(key: key);

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  final _logger = Logger();
  final _flutterPluginQpos = FlutterPluginQpos();

  NewSaleBloc _bloc() {
    return context.read<NewSaleBloc>();
  }

  @override
  void initState() {
    //_flutterPluginQpos.resetQPosStatus();
    _bloc().add(const NewSaleInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    _flutterPluginQpos.resetQPosStatus();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return BlocConsumer<NewSaleBloc, NewSaleState>(
        bloc: _bloc(),
        listener: (context, state) {
          if (state is ExitState) {
            _exit();
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case NewSaleInitialState:
              return const SizedBox();
            case InputAmountState:
              return Center(
                child: SingleChildScrollView(
                  child: InputScreen("MONTO", "COBRAR", _bloc().amountPresenter,
                      _nextEvent(const InputIdDocEvent())),
                ),
              );
            case InputIdDocState:
              return Center(
                child: SingleChildScrollView(
                  child: InputScreen("CÉDULA", "SIGUIENTE",
                      _bloc().idDocPresenter, () => _bloc().startTrade()),
                ),
              );
            case InputPinState:
              return Center(
                child: SingleChildScrollView(
                  child: InputScreen("PIN", "SIGUIENTE", _bloc().pinPresenter,
                      () => _bloc().setPin()),
                ),
              );
            case ChooseAccountTypeState:
              return SafeArea(child: ChooseTypeAccountScreen(_addAccountType));
            case ErrorState:
              var error = (state as ErrorState).error;
              if (error == "DEVICE_RESET") {
                state = const InputAmountState();
                return Center(
                  child: SingleChildScrollView(
                    child: InputScreen(
                        "MONTO",
                        "COBRAR",
                        _bloc().amountPresenter,
                        _nextEvent(const InputIdDocEvent())),
                  ),
                );
              }
              return ErrorView(error);
            case ProcessingState:
              return Center(child: _processing());
            case InsertCardState:
              return Scaffold(
                backgroundColor: ColorUtil.primaryColor(),
                body: Center(
                  child: SingleChildScrollView(
                    child: InsertCardScreen(
                        _bloc().amountPresenter.valueStream(),
                        _bloc().idDocPresenter.valueStream(),
                        _bloc().displayMessageStream()),
                  ),
                ),
              );
            case PaymentSuccessState:
              var trx = (state as PaymentSuccessState).trx;
              return Receipt(trx);
          }

          return const Text("INVALID_STATE");
        });
  }

  Function _nextEvent(NewSaleEvent event) {
    return () => _bloc().add(event);
  }

  void _addAccountType(AccountType accountType) {
    _bloc().setAccountType(accountType);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitDialog();
        return false;
      },
      child: Scaffold(body: _body(context)),
    );
  }

  void _exit() {
    Navigator.of(context).pop();
  }

  Future<void> _exitDialog() async {
    if (_bloc().isProcessing) {
      return;
    }

    if (!_bloc().isCancelable) {
      _bloc().add(const ExitEvent());
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar'),
          content: const Text('¿Desea cancelar la venta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bloc().add(const ExitEvent());
              },
              child: const Text('Si'),
            ),
          ],
        );
      },
    );
  }

  Widget _processing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  color: ColorUtil.primaryColor(),
                  strokeWidth: 6,
                ))),
        const SizedBox(
          height: 10,
        ),
        Center(
            child: Text(
          'Procesando transacción',
          style: titleStyleText("", 20),
        )),
      ],
    );
  }

  @override
  void deactivate() {
    _bloc().cancelSubscription();
    super.deactivate();
  }
}
