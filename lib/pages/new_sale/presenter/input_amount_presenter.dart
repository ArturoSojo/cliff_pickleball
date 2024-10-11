import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../view/keyboard.dart';
import 'input_presenter.dart';

@injectable
class InputAmountPresenter implements InputPresenter {
  final NumberFormat _formatter = NumberFormat.currency(
      locale: "es_VE",
      name: "VED",
      symbol: "Bs.",
      decimalDigits: 2,
      customPattern: "¤#,##0.00;¤-#,##0.00");

  late BehaviorSubject<String> _amountController = BehaviorSubject.seeded("0");

  Stream<double> get _dStream => _amountController.stream
      .map(double.parse)
      .map((d) => d / 100)
      .asBroadcastStream();

  Stream<String> get _amountStream =>
      _dStream.map(_formatter.format).asBroadcastStream();

  Stream<bool> get _isValidStream =>
      _dStream.map((d) => d >= 1.00).asBroadcastStream();

  String amount() {
    return _amountController.value;
  }

  @override
  void addKey(KeyboardKey key) async {
    switch (key) {
      case KeyboardKey.CLEAR:
        var text = _amountController.value;

        var newText = text.substring(0, text.length - 1);

        if (newText.isEmpty) {
          newText = "0";
        }

        _amountController.value = newText;
        break;
      case KeyboardKey.CLEAR_ALL:
        _amountController.value = "0";
        break;
      default:
        var oldText = _amountController.value;

        if (oldText.length <= 15) {
          var text = oldText + key.name.substring(1);
          _amountController.value = int.parse(text).toString();
        }
        break;
    }
  }

  @override
  Stream<String> btnValueStream() {
    return _amountStream;
  }

  @override
  Stream<bool> isValid() {
    return _isValidStream;
  }

  @override
  Stream<String> valueStream() {
    return _amountStream;
  }

  void init() {
    _amountController.value = "0";
  }
}
