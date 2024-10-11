import 'package:cliff_pickleball/pages/new_sale/view/keyboard.dart';

abstract class InputPresenter {
  Stream<String> valueStream();

  Stream<bool> isValid();

  Stream<String> btnValueStream();

  void addKey(KeyboardKey key);
}
