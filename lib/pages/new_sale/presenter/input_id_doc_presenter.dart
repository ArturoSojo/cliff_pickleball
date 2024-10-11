import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/pages/new_sale/view/keyboard.dart';
import 'package:rxdart/rxdart.dart';

import 'input_presenter.dart';

@injectable
class InputIdDocPresenter implements InputPresenter {
  final _idDocController = BehaviorSubject.seeded("");
  final _emptyController = BehaviorSubject.seeded("");

  Stream<String> get _idDocStream =>
      _idDocController.stream.asBroadcastStream();

  Stream<bool> get _isValidStream => _idDocStream
      .map((s) => s.length > 4 && int.parse(s) != 0)
      .asBroadcastStream();

  Stream<String> get _btnValueStream =>
      _emptyController.stream.asBroadcastStream();

  String idDoc() {
    return _idDocController.value;
  }

  @override
  void addKey(KeyboardKey key) async {
    switch (key) {
      case KeyboardKey.CLEAR:
        var text = _idDocController.value;

        if (text.isEmpty || text.length == 1) {
          _idDocController.value = "";
        } else {
          var newText = text.substring(0, text.length - 1);
          _idDocController.value = newText;
        }

        break;
      case KeyboardKey.CLEAR_ALL:
        _idDocController.value = "";
        break;
      default:
        var oldText = _idDocController.value;

        if (oldText.length < 9) {
          var text = oldText + key.name.substring(1);
          _idDocController.value = text;
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
    return _idDocStream;
  }

  void init() {
    _idDocController.value = "";
    _emptyController.value = "";
  }
}
