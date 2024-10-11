import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/product/screens/pospay/pospay_bloc.dart';
import 'package:cliff_pickleball/utils/showErrorMessage.dart';

import '../../../../di/injection.dart';
import '../../../../services/http/domain/productModel.dart';
import '../../../../styles/bg.dart';
import '../../../../styles/domain/app_theme.dart';
import '../../../../styles/text.dart';
import '../../../../styles/theme_provider.dart';
import '../../../../widgets/rich_text.dart';
import '../../../product_card/product_card_screen.dart';
import '../voucher/vourcher.dart';
import 'models/account_model.dart';

class Pospay extends StatefulWidget {
  final ProductModel product;
  final PospayBloc bloc;
  Pospay({Key? key, required this.product, required this.bloc})
      : super(key: key);

  @override
  State<Pospay> createState() => _PospayState();
}

class _PospayState extends State<Pospay> {
  bool reading = false;
  late AccountModel account;
  final _formKey = GlobalKey<FormState>();
  List<String> listCompanies = [
    "movistar",
    "digitel",
    "simpletv",
    "cantv",
    "movilnet"
  ];
  PospayBloc get _bloc => widget.bloc;
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  NumberFormat numFormat = NumberFormat('###,###.00', 'es_VE');

  bool isLoading = false;
  final _logger = Logger();

  @override
  void initState() {
    reading = false;
    super.initState();
  }

  sendProduct(String paymentMethod) async {
    reading = false;
    return isLoading
        ? null
        : await _bloc.sendpayment(widget.product, paymentMethod);
  }

  AppTheme appTheme() {
    return getIt<ThemeProvider>().appTheme();
  }

  TextFormField contactNumber(bool isLoading, bool isLoaded) {
    return TextFormField(
      controller: _bloc.controllerContract,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ],
      maxLength: 12,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading && !isLoaded,
      validator: (value) => _bloc.accountValidate(
          value, widget.product.company == "CANTV" ? "contrato" : "cuenta"),
      decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: isLoading
                  ? SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator())
                  : Icon(Icons.search),
              onPressed: _consultation),
          labelText: widget.product.company == "CANTV"
              ? "Número de contrato"
              : "Número de cuenta",
          border: OutlineInputBorder(),
          hintText: ''),
    );
  }

  Widget _pospayheader(ProductModel product) {
    var company = product.company?.toLowerCase();
    int isExistsImage = listCompanies.indexOf(company ?? "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text(widget.product.company ?? "", textAlign: TextAlign.center, style: TitleTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: isExistsImage != -1
                      ? Image.asset("assets/img/$company.png",
                          width: 100, height: 60)
                      : Image.asset("assets/img/not_found.png",
                          width: 100, height: 60)),
              const SizedBox(height: 5),
              Text(widget.product.formattedName ?? "",
                  textAlign: TextAlign.center,
                  style: TitleTextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal)),
              !(widget.product.isCancelable ?? false)
                  ? const Text(
                      "El servicio no es anulable, por favor verifique el número de cuenta a pagar ya que el pago no puede ser reversado",
                      style: TitleTextStyle(
                          color: ColorUtil.error,
                          fontSize: 14,
                          fontWeight: FontWeight.normal))
                  : const SizedBox(),
              const Divider(height: 20)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonClean(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.restore_from_trash_sharp,
              color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: isLoading ? null : _bloc.clean,
          label:
              Text("LIMPIAR", style: TitleTextStyle(color: ColorUtil.white))),
    );
  }

  Widget _buttonSend(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: isLoading
              ? const SizedBox()
              : const Icon(Icons.payment_outlined, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: _colorProvider.primary(),
              padding: const EdgeInsets.all(20)),
          onPressed: () {
            sendProduct("CASH");
            FocusScope.of(context).unfocus();
            /* reading = true; */
          },
          label: isLoading
              ? const SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(color: ColorUtil.white))
              : const Text("PAGAR",
                  style: TitleTextStyle(color: ColorUtil.white))),
    );
  }

  Future<void> _consultation() async {
    bool stateForm = _formKey.currentState?.validate() ?? false;
    if (stateForm) {
      await _bloc.getAccount(product: widget.product, fix: true);
    }
  }

  Widget _cantvWidget(AccountModel acc, bool isLoading) {
    return Column(children: [
      acc.expiredDebt != null
          ? ListTile(
              enabled: !isLoading,
              title: Text("Deuda vencida ${acc.formattedExpiredDebt}"),
              leading: Radio(
                value: acc.expiredDebt,
                groupValue: _bloc.debt,
                onChanged: (value) => _bloc.setDebt(value),
              ),
            )
          : const SizedBox(),
      acc.currentDebt != null
          ? ListTile(
              enabled: !isLoading,
              title: Text("Deuda actual ${acc.formattedCurrentDebt}"),
              leading: Radio(
                value: acc.currentDebt,
                groupValue: _bloc.debt,
                onChanged: (value) => _bloc.setDebt(value),
              ),
            )
          : const SizedBox(),
      acc.totalDebt != null
          ? ListTile(
              enabled: !isLoading,
              title: Text("Deuda total ${acc.formattedTotalDebt}"),
              leading: Radio(
                value: acc.totalDebt,
                groupValue: _bloc.debt,
                onChanged: (value) => _bloc.setDebt(value),
              ),
            )
          : const SizedBox(),
    ]);
  }

  TextFormField _amount(bool isLoading, double? total) => TextFormField(
        controller: _bloc.amountController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLength: 8,
        readOnly: false,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        inputFormatters: [_bloc.numFormat],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (price) => _bloc.amountValidate(price, total!),
        onChanged: (price) => _bloc.setAmount(price),
        decoration: const InputDecoration(
            // prefixIcon: Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Bs."),
            //     SizedBox(height: 4)
            //   ],),
            labelText: "Monto",
            border: OutlineInputBorder(),
            hintText: ''),
      );
  Widget _posWidget(AccountModel acc, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MRichText.rich(title: "Cliente: ", text: acc.name?.toUpperCase() ?? ""),
        const SizedBox(height: 10),
        acc.daysLeftOfService != null
            ? MRichText.rich(
                title: "Días restantes del servicio: ",
                text: acc.daysLeftOfService?.toStringAsFixed(0) ?? "")
            : const SizedBox(),
        const SizedBox(height: 10),
        MRichText.rich(title: "Saldo: ", text: acc.formattedBalance ?? ""),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: ListTile(
              enabled: !isLoading,
              title: const Text("Monto total"),
              leading: Radio(
                value: true,
                groupValue: _bloc.isTotal,
                onChanged: (value) =>
                    _bloc.setTotal(value!, value: acc.balance),
              ),
            ),
          ),
          const SizedBox(),
          Expanded(
            child: ListTile(
              enabled: !isLoading,
              title: const Text("Otro monto"),
              leading: Radio(
                value: false,
                groupValue: _bloc.isTotal,
                onChanged: (value) => _bloc.setTotal(value!),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buttons(bool isLoading) => Row(
        children: [
          _buttonClean(isLoading),
          SizedBox(width: 5),
          _buttonSend(isLoading),
        ],
      );

  Widget _account(AccountModel acc, String company, bool isLoading) {
    if (company == "CANTV") {
      return _cantvWidget(acc, isLoading);
    } else {
      return _posWidget(acc, isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = this.appTheme();
    /* var servicepayMethods = Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/img/sales.png", width: 80, height: 80),
                    ),
                    const Text("TIENDA",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            onTap: (){
              sendProduct("CASH");
            },
          ),
          InkWell(
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image(
                        image: AssetImage(
                          "${appTheme.assetsImg.uri}${appTheme.assetsImg.pos}"
                        ),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const Text("TARJETA",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            onTap: (){
              
            },
          ),
        ],
      ),
    ); */
    return Form(
        key: _formKey,
        child: BlocConsumer<PospayBloc, PospayState>(
          bloc: _bloc,
          listener: (context, state) {},
          builder: (context, state) {
            bool showError = state is PospayErrorState;
            bool isLoading = showError ? false : state is PospayLoadingState;
            bool isLoadingPayment =
                showError ? false : state is PospayLoadingPaymentState;
            bool isLoaded = showError ? false : state is PospayLoadedState;

            _logger.i(isLoading);
            if (state.account != null) {
              account = state.account!;
            }

            if (state is PospaySuccessState) {
              if (state.payment != null) {
                return Voucher(
                    payment: state.payment!, product: widget.product);
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  _pospayheader(widget.product),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        contactNumber(isLoading || isLoadingPayment,
                            isLoaded || isLoadingPayment),
                        showError
                            ? showErrorMessage(state.errorMessage ?? "")
                            : const SizedBox(),
                        (isLoaded && state.account != null) || isLoadingPayment
                            ? _account(state.account!,
                                widget.product.company ?? "", isLoadingPayment)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        (!_bloc.isTotal && state.account != null)
                            ? _amount(isLoading || isLoadingPayment,
                                state.account?.balance)
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        (isLoaded && state.account != null) || isLoadingPayment
                            ? _buttons(isLoadingPayment)
                            : const SizedBox(),
                        /* reading == true
                              ? servicepayMethods
                              : const SizedBox() */
                      ],
                    ),
                  ))
                ],
              ),
            );
          },
        ));
    //return Container(child: Text("IS PRODUCT MODEL POSPAY: ${widget.product.name}"),);
  }
}
