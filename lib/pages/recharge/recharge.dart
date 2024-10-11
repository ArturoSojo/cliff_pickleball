import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/color_provider/color_provider.dart';
import '../../styles/text.dart';
import '../../styles/theme_provider.dart';
import '../../utils/error_message.dart';
import '../../utils/staticNamesRoutes.dart';
import '../../utils/translate.dart';
import '../../widgets/rich_text.dart';
import '../store/models/collect_channel_model.dart';
import 'bloc/recharge_bloc.dart';
import 'models/recharge_model.dart';

class RechageScreen extends StatefulWidget {
  RechargeBloc bloc;

  RechageScreen({Key? key, required this.bloc}) : super(key: key);

  @override
  State<RechageScreen> createState() => _RechageScreenState();
}

class _RechageScreenState extends State<RechageScreen> {
  final _formKey = GlobalKey<FormState>();
  final ColorProvider _colorProvider = getIt<ThemeProvider>().colorProvider();
  RechargeBloc _bloc(){
    return widget.bloc;
  }
  final _logger = Logger();

  @override
  void initState() {
    _bloc().setInit();
    super.initState();
  }

  Widget _buttonClean(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: Icon(Icons.restore_from_trash_sharp, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: !isLoading ? _bloc().clean : null,
          label: const Text("LIMPIAR", style: TitleTextStyle(color: ColorUtil.white))),
    );
  }

  Widget _buttonSend(bool isLoading) {
    return Expanded(
      child: TextButton.icon(
          icon: isLoading 
          ? const SizedBox() 
          : const Icon(Icons.payment_outlined, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor:  isLoading ? _colorProvider.primaryLight() : _colorProvider.primary(),
              padding: const EdgeInsets.all(20)),
          onPressed:() async => _formKey.currentState!.validate() && !isLoading ? await _bloc().sendRechage() : null,
          label: isLoading 
          ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: ColorUtil.white)) 
          : const Text("VALIDAR", style: TitleTextStyle(color: ColorUtil.white, fontSize: 14))),
    );
  }
  Widget _header(BankInfo? bank){
    var bankName = bank!.acronym != null ? "banks/${bank.acronym!.toLowerCase()}" : "not_found";
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Column(children: const [
            Icon(Icons.phone_iphone, size: 75),
            Text("Pago móvil", style: TitleTextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ]),
          bank!=null 
          ? Image.asset("assets/img/${bankName}.png", width: 250, height: 150) 
          : const SizedBox(),
          const SizedBox(height: 10),

        ],
      ),
    );
  }

  DropdownButtonFormField<CollectMethods> _banks(bool isLoading){
    var banks = _bloc().banks;
    return DropdownButtonFormField<CollectMethods>(
      value: _bloc().bankSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      onChanged: isLoading ? null : (bank) => _bloc().setBank(bank),
      validator: (bank) => _bloc().validateBank(bank),
      items: banks?.map<DropdownMenuItem<CollectMethods>>((CollectMethods bank) {
        return DropdownMenuItem<CollectMethods>(
          enabled: !isLoading,
          value: bank,
          child: MRichText.rich(title: "${bank.bankInfo?.acronym} - ", text: bank.bankInfo?.name ?? "", fontSize: 13)
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _typeDoc(bool isLoading){
    return DropdownButtonFormField<String>(
      value: _bloc().typeDniSelected,
      icon: const Icon(Icons.arrow_downward),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypeDni(type),
      onChanged:  isLoading ? null : (type) => _bloc().setTypeDoc(type),
      items: _bloc().types_docs.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
            enabled: !isLoading,
            value: type,
            child:Text(type, style: TitleTextStyle(color: ColorUtil.dark_gray))
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _typeService(bool isLoading){
    return DropdownButtonFormField<String>(
      value: _bloc().typeServiceSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypeService(type),
      onChanged: isLoading ? null : (type) => _bloc().setTypeService(type),
      items: _bloc().listTypes.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(translate(type), style: TitleTextStyle(color: ColorUtil.dark_gray)),
        );
    }).toList(),
    );
  }

  DropdownButtonFormField<String> _typePhone(bool isLoading){
    return DropdownButtonFormField<String>(
      value: _bloc().typePhoneSelected,
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(color: Colors.deepPurple),
      isExpanded: true,
      validator: (type) => _bloc().validateTypePhone(type),
      onChanged:  isLoading ? null : (type) => _bloc().setTypePhone(type),
      items: _bloc().types_phones.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
            value: type,
            child:Text(type, style: TitleTextStyle(color: ColorUtil.dark_gray))
        );
      }).toList(),
    );
  }

  Widget _rowInformation({required String title, required String text})
  => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          flex: 2,
          child: Text(title, style: TitleTextStyle(fontSize: 16, fontWeight: FontWeight.normal))),
      Expanded(
        flex: 3,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(text, textAlign: TextAlign.end, style: const TitleTextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(width: 4,),
              title == "Número de teléfono" 
              ? Expanded(
                  flex: 1,
                  child: IconButton(icon: Icon(Icons.paste), onPressed: () => Clipboard.setData(ClipboardData(text: text.substring(5,14))).then((value) =>  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${title} copiado con éxito")))))
              ) 
              : const SizedBox(),
              title == "Rif" ? Expanded(
                  flex: 1,
                  child: IconButton(icon: Icon(Icons.paste), onPressed: () => Clipboard.setData(ClipboardData(text: text.substring(1,text.length))).then((value) =>  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${title} copiado con éxito")))))
              ) 
              : const SizedBox(),
              title != "Banco" && title != "Número de teléfono" && title != "Rif" ?
              Expanded(
                  flex: 1,
                  child: IconButton(icon: Icon(Icons.paste), onPressed: () => Clipboard.setData(ClipboardData(text: text)).then((value) =>  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${title} copiado con éxito")))))
              ) : SizedBox(),
            ]),
      ),
    ],
  );

  Widget _informationRecharge(CollectMethods bank){
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("REALIZAR PAGO MÓVIL A:", style: TitleTextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
        //_rowInformation(title: "Monto mínimo de compra", text: "${_bloc().formattedRate} bs" ?? ""),
        // SizedBox(height: 5),
        // _rowInformation(title: "Tasa del día", text: "${_bloc().showRate} bs" ?? ""),
        SizedBox(height: 5),
        _rowInformation(title: "Número de teléfono", text: bank.formattedPhone ?? ""),
        SizedBox(height: 5),
        _rowInformation(title: "Rif", text: bank.idDoc ?? ""),
        SizedBox(height: 5),
        _rowInformation(title: "Banco", text: bank.bankInfo?.name ?? ""),
        SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _noteRechange(){
    return Column(
      children: [
        Row(
          children: [
            Text("Nota: ", style: TitleTextStyle(fontWeight: FontWeight.bold, color: ColorUtil.error, fontSize: 15)),
            Text("Los bancos Mercantil, Provincial y Tesoro ", textAlign: TextAlign.justify, style: TitleTextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
            ],
        ),
        Text("no poseen validación automática, si por error realizo un pago a uno de estos bancos, pase él capture con su RIF al siguiente correo:", textAlign: TextAlign.justify, style: TitleTextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
        Text("pagos@paguetodo.com", textAlign: TextAlign.justify, style: TextStyle(fontSize: 13,color: Color.fromARGB(255, 37, 33, 243))),
      ],
    );
  }

  TextFormField _amount(bool isLoading)  =>
      TextFormField(
        controller: _bloc().amountController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLength: 9,
        readOnly: false,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        inputFormatters: [_bloc().numFormat],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (amount) => _bloc().validateAmount(amount),
        onChanged: (amount) => _bloc().setAmount(amount),
        decoration: InputDecoration(
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

  TextFormField _phoneNumber(bool isLoading){
    return TextFormField(
      controller: _bloc().numberController,
      keyboardType: TextInputType.number,
      maxLength: 8,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [_bloc().maskFormatter],
      validator: (value) => _bloc().validateNumber(value),
      decoration: InputDecoration(

          labelText: "Número de teléfono",
          border: OutlineInputBorder(),
          hintText: ''),
    );
  }

  // TextFormField _datePayment(bool isLoading){
  //   return TextFormField(
  //     showCursor: false,
  //     mouseCursor: MouseCursor.uncontrolled,
  //     controller: _bloc().dateController,
  //     keyboardType: TextInputType.none,
  //     onTap: () =>
  //         Calendary.pickDateDialog(context, (date) => _bloc().setDate(date)),
  //     maxLength: 12,
  //     readOnly: false,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     enabled: !isLoading,
  //     validator: (value) => _bloc().validateDate(value),
  //     decoration: InputDecoration(
  //         labelText: "Fecha de pago",
  //         border: OutlineInputBorder(),
  //         hintText: ''),
  //   );
  // }
  //
  TextFormField _dni(bool isLoading){
    return TextFormField(
      controller: _bloc().dniController,
      keyboardType: TextInputType.number,
      maxLength: 9,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$'))],
      validator: (value) => _bloc().validateDni(value),
      decoration: InputDecoration(
          labelText: "Cédula",
          border: OutlineInputBorder(),
          hintText: ''),
    );
  }

  TextFormField _reference(bool isLoading){
    return TextFormField(
      controller: _bloc().referenceController,
      keyboardType: TextInputType.number,
      maxLength: 12,
      readOnly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: !isLoading,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$'))],
      validator: (value) => _bloc().validateReference(value),
      decoration: InputDecoration(
          labelText: "Referencia",
          border: OutlineInputBorder(),
          hintText: '000000'),
    );
  }

  Form _pay(bool isLoading){
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 15),
          _noteRechange(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Text("COLOCA LOS DATOS DEL PAGO MÓVIL REALIZADO", textAlign: TextAlign.center, style: TitleTextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
            ],
          ),
          SizedBox(height: 20),
          Row(children: [
            Expanded(child: _typeService(isLoading))
          ],),
          // SizedBox(height: 20),
          // Row(children: [
          //   Expanded(child: _banks(isLoading))
          // ],),
          SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 1,child: _typePhone(isLoading)),
              SizedBox(width: 5),
              Flexible(flex: 3,child: _phoneNumber(isLoading))
            ],),
          SizedBox(height: 10),
          Row(children: [
            Expanded(child: _amount(isLoading))
          ],),

          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Flexible(flex: 1,child: _typeDoc(isLoading)),
            SizedBox(width: 5),
            Flexible(flex: 3,child: _dni(isLoading))
          ],),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _reference(isLoading))
            ],),
          SizedBox(height: 10),
          Row(children: [
            _buttonClean(isLoading),
            SizedBox(width: 5),
            _buttonSend(isLoading)
          ],),
        ],
      ),
    );
  }

  void dialog(String errorMessage) =>
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
                title: Text(errorMessage, style: TitleTextStyle(fontSize: 16)),
                actions: [
                  TextButton(
                      child: Text('Regresar'),
                      onPressed: () => {
                        if(errorMessage == "Pago exitoso"){
                          context.go(StaticNames.store.path),
                          Navigator.of(context).pop(),
                        }else{
                          Navigator.of(context).pop(),
                        }
                      })
                  ]);
          });

  Widget _loadingCenter(){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text("Cargando información")
          ]),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "RECARGA",
          style: titleStyleText("white", 24),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RechargeBloc, RechargeState>(
        bloc: _bloc(),
        listener: (_, state){
          if(state is RechargeErrorPaymentState){
            var errorMessage = state.errorMessage;
            dialog(errorMessage);
          }
          if(state is RechargeSuccessState){
            dialog("Pago exitoso");
            _bloc().clean();

          }
        },
        builder: (_, state){
          bool isLoading = state is RechargeLoadingState;
          if(state is RechargeInitialState){
            _bloc().setInit();
            return _loadingCenter();
          }
          if(state is RechargeErrorState){
            return ShowErrorMessage(errorMessage: state.errorMessage, error: true);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _bloc().bankSelected!=null ? _header(_bloc().bankSelected!.bankInfo): SizedBox(),
                  _bloc().bankSelected!=null ? _informationRecharge(_bloc().bankSelected!): SizedBox(),
                  _pay(isLoading)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
