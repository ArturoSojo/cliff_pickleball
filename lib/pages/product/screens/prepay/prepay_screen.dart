import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:logger/logger.dart';

import '../../../../di/injection.dart';
import '../../../../services/http/api_services.dart';
import '../../../../services/http/domain/productModel.dart';
import '../../../../styles/bg.dart';
import '../../../../styles/text.dart';
import '../../../../styles/theme_provider.dart';
import '../../../../utils/utils.dart';
import '../../services/payment_service.dart';
import '../voucher/vourcher.dart';
import 'models/payment_model.dart';

class Prepay extends StatefulWidget {
  final ProductModel product;
  Prepay({Key? key, required this.product}) : super(key: key);

  @override
  State<Prepay> createState() => _PrepayState();
}

class _PrepayState extends State<Prepay> {

  final _formKey = GlobalKey<FormState>();
  var numFormat = CurrencyTextInputFormatter(
      locale: 'es_VE',
      decimalDigits: 2,
      symbol: ""
  );
  var currency = 'VE';
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _phoneNumberControllerTwo = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  PaymentModel? paymentModel = null;
  final _apiServices = getIt<ApiServices>();
  bool isLoading = false;
  final _logger = Logger();


  var maskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
  var maskFormatterTwo = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );


  final _colorProvider = getIt<ThemeProvider>().colorProvider();

  @override
  void initState() {
    super.initState();
  }

  void _showModalError(String errorMessage) =>
      showDialog(context: context, builder: (_) =>
          AlertDialog(
        icon: const Icon(Icons.error_outline, size: 30),
        iconColor: ColorUtil.error,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: Text(
              "Regresar",
              style: subtitleStyleText("", 16),
            ),
          )
        ],
        content: Text(errorMessage,
            style: TitleTextStyle(fontSize: 18), textAlign: TextAlign.center),
      )
    );

  TextFormField get _phoneNumber {
    var hintText = MyUtils.operadorNumber[widget.product.company ?? "DEFAULT"];
    return TextFormField(
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      maxLength: 14,
      readOnly: false,
      enabled: !isLoading,
      validator: phoneNumberValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [maskFormatter],
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_iphone_outlined),
          labelText: "Número de teléfono",
          border: OutlineInputBorder(),
          hintText: hintText),
    );
  }

  TextFormField get _phoneNumberTwo {
    var hintText = MyUtils.operadorNumber[widget.product.company ?? "DEFAULT"];
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _phoneNumberControllerTwo,
      keyboardType: TextInputType.phone,
      maxLength: 14,
      readOnly: false,
      enabled: !isLoading,
      validator: phoneNumberValidatorTwo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [maskFormatterTwo],
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_iphone_outlined),
          labelText: "Confirmar número de teléfono",
          border: OutlineInputBorder(),
          hintText: hintText),
    );
  }



  TextFormField get _amount  =>
      TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLength: 8,
              readOnly: false,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              inputFormatters: [numFormat],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (price) {
                if (price == null || price.isEmpty) {
                  return 'El monto no puede estar vacio';
                }
                if(!isMultiple(numFormat.getUnformattedValue(), widget.product.features?.MULTIPLE)){
                  return 'El monto ingresado no es multiplo de bs. ${widget.product.features?.MULTIPLE?.toStringAsFixed(2) ?? ""}';
                }
                if(numFormat.getUnformattedValue() > (widget.product.features?.MAX ?? 1)){
                  return 'El monto ingresado no puede ser mayor de bs. ${widget.product.features?.MAX}';
                }
                if(numFormat.getUnformattedValue() < (widget.product.features?.MIN ?? 1)){
                  return 'El monto ingresado no puede ser menor de bs. ${widget.product.features?.MIN}';
                }
                return null;
              },
              // onChanged: (price) {
              //   if(price!=null && price.trim()!=""){
              //
              //     _amountController.value = TextEditingValue(
              //       text: formattedPrice,
              //       selection: TextSelection.collapsed(offset: price.length),
              //     );
              //   }
              //   },
              decoration: InputDecoration(
                  // prefixIcon: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //   const Text("Bs."),
                  //   SizedBox(height: 4)
                  // ],),
                  labelText: "Monto",
                  border: OutlineInputBorder(),
                  hintText: ''),
            );

  Widget _prepayheader(){
    var company = widget.product.company?.toLowerCase();
    List<String> listCompanies = ["movistar", "digitel", "simpletv", "cantv", "movilnet"];
    int isExistsImage = listCompanies.indexOf(company ?? "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isExistsImage != -1 ?
            Image.asset("assets/img/${company}.png", width: 150, height: 80):
            Image.asset("assets/img/not_found.png", width: 80, height: 40)
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(widget.product.formattedName ?? "", style: TitleTextStyle(fontSize: 16,fontWeight: FontWeight.normal)),],),

        !(widget.product.isCancelable ?? false) ?
        Text("El servicio no es anulable, por favor verifique el número de teléfono a pagar ya que el pago no puede ser reversado",
            style: TitleTextStyle(color: ColorUtil.error, fontSize: 14,fontWeight: FontWeight.normal)) :
        SizedBox(),
        SizedBox(height: 10),
        _features(),
        Divider(height: 20)
      ],
    );
  }

  Widget _features() =>
    Row(
      children: [
        Expanded(
          child: Card(
            color: ColorUtil.gray,
            child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Debe ingresar un número MIN de Bs. ${widget.product.features?.MIN_FORMAT} MAX de Bs. ${widget.product.features?.MAX_FORMAT} que a su vez sea MÚLTIPLO de Bs. ${widget.product.features?.MULTIPLE_FORMAT}", style: TitleTextStyle(fontSize: 12, color: ColorUtil.dark_gray)),
            ),
          ),
        ),
      ],
    );

  void _confirmRecharge(String amount, String phone) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("¿Está seguro que desea recargar Bs.$amount al $phone?", style: TitleTextStyle(fontSize: 17, color: ColorUtil.black)),
            actions: <Widget>[
              TextButton(
                  child: const Text("SÍ"),
                  onPressed: () => {
                    _payment(),
                    Navigator.of(context).pop(),
                  }),
              TextButton(
                  child: const Text("NO"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        }
    );
  }


  Widget _buttonClean() {
    return Expanded(
      child: TextButton.icon(
          icon: Icon(Icons.restore_from_trash_sharp, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor:  ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: () => isLoading ? null :  _clean,
          label: Text("LIMPIAR", style: TitleTextStyle(color: ColorUtil.white),)),
    );
  }

  Widget _buttonSend() {
    return Expanded(
      child: TextButton.icon(

          icon: isLoading ? SizedBox() : Icon(Icons.payment, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: !(_formKey.currentState?.validate()!=null ? _formKey.currentState!.validate(): false) || isLoading ? _colorProvider.primary() : _colorProvider.primary() ,
              padding: const EdgeInsets.all(20)),
          onPressed: ()=> !(_formKey.currentState?.validate()!=null ? _formKey.currentState!.validate(): false) || isLoading ? null : _confirmRecharge(_amountController.text, _phoneNumberController.text),
          label: isLoading ? SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: ColorUtil.white)) : Text("RECARGAR", style: TitleTextStyle(color: ColorUtil.white),)),
    );
  }

  void get _handleState => setState(() {
    isLoading = !isLoading;
  });

  void get _clean => setState(() {
    isLoading = false;
    _phoneNumberController.text = "";
    _phoneNumberControllerTwo.text = "";
    _amountController.text = "";
  });

  Future<void> _payment() async {
    _handleState;
    if((_formKey.currentState?.validate()!=null ? _formKey.currentState!.validate(): false)){
      var amount = numFormat.getUnformattedValue().toDouble();
      var phone = maskFormatter.unmaskText(_phoneNumberController.text);

      var result = await sendPayment(amount: amount, phone: phone, product: widget.product);
      if(result.success){
        _handleState;
        if(result.obj!=null){
          _setModel(model: result.obj);
        }
      }else{
        _handleState;
        _showModalError(result.errorMessage ?? "Error al realizar la recarga");
        _logger.i(result.errorMessage);
      }
    }else{
      _handleState;
    }

  }
  bool isMultiple(val, multiple){
    if(val!=null || val!=""){
      if(val!=0){
        if(val == widget.product.features?.MAX){
          return true;
        }
        var result = (val % (multiple ?? 0) == 0 ? true : false);
        return result;
      }
    }
    return false;
  }

  String? phoneNumberValidator(String? phone) {
    var t = MyUtils.operador[widget.product.company] ?? r'\([0-9]{3}\)\s+[0-9]{3}\-[0-9]{4}';
    if (phone == null || phone.isEmpty) {
      return 'El número de teléfono no puede estar vacio';
    }
    String pattern = t;
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(phone)){
      return 'Ingrese un número de teléfono válido';
    }else{
      return null;
    }
  }

  String? phoneNumberValidatorTwo(String? phone) {
    var t = MyUtils.operador[widget.product.company] ?? r'\([0-9]{3}\)\s+[0-9]{3}\-[0-9]{4}';
    if (phone == null || phone.isEmpty) {
      return 'El número de teléfono no puede estar vacio';
    }
    String pattern = t;
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(phone)){
      return 'Ingrese un número de teléfono válido';
    }
    if(_phoneNumberControllerTwo.text != _phoneNumberController.text){
      return 'El número de confirmación no concuerda';
    }
    return null;

  }

  void _setModel({PaymentModel? model}){
    setState(() {
      paymentModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(paymentModel!=null){
      return Voucher(payment: paymentModel!, product: widget.product);
    }
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              _prepayheader(),
              Expanded(child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 10),
                  _phoneNumber,
                  SizedBox(height: 5),
                  _phoneNumberTwo,
                  SizedBox(height: 5),
                  _amount,
                  SizedBox(height: 5),
                  Row(children: [
                    _buttonClean(),
                    SizedBox(width: 5),
                    _buttonSend()
                  ],),
                ],),
              )),
            ],
          ),
        ),
      );
  }
}

