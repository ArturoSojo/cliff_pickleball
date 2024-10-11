import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/pages/new_sale/view/keyboard.dart';
import 'package:rxdart/rxdart.dart';

import 'input_presenter.dart';

@injectable
class InputPinPresenter implements InputPresenter {
  final _pinController = BehaviorSubject.seeded("");
  final _emptyController = BehaviorSubject.seeded("");

  Stream<String> get _pinStream => _pinController.stream.asBroadcastStream();

  Stream<bool> get _isValidStream =>
      _pinStream.map((s) => s.length == 4 || s.length == 6).asBroadcastStream();

  Stream<String> get _valueStream =>
      _pinStream.map((s) => "*" * s.length).asBroadcastStream();

  Stream<String> get _btnValueStream =>
      _emptyController.stream.asBroadcastStream();

  String pin() {
    return _pinController.value;
  }

  @override
  void addKey(KeyboardKey key) async {
    switch (key) {
      case KeyboardKey.CLEAR:
        var text = _pinController.value;

        if (text.isEmpty || text.length == 1) {
          _pinController.value = "";
        } else {
          var newText = text.substring(0, text.length - 1);
          _pinController.value = newText;
        }

        break;
      case KeyboardKey.CLEAR_ALL:
        _pinController.value = "";
        break;
      default:
        var oldText = _pinController.value;

        if (oldText.length < 6) {
          var text = oldText + key.name.substring(1);
          _pinController.value = text;
        }
        break;
    }
  }

  @override
  Stream<String> btnValueStream() {
    return _btnValueStream;
  }

  @override
  Stream<bool> isValid() {
    return _isValidStream;
  }

  @override
  Stream<String> valueStream() {
    return _valueStream;
  }

  void init() {
    _pinController.value = "";
    _emptyController.value = "";
  }
}
