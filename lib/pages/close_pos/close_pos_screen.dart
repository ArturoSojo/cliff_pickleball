import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/close_pos/close_pos_bloc.dart';

class ClosePosScreen extends BasePage {
  final Map<String, dynamic> data;

  ClosePosScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ClosePosScreen> createState() => _ClosePosScreenState();
}

class _ClosePosScreenState extends BaseState<ClosePosScreen> with BasicPage {
  late ClosePosBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<ClosePosBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.clear();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget rootWidget(BuildContext context) {
    return BlocConsumer<ClosePosBloc, ClosePosState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column();
        });
  }
}
