part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {
  @override
  List<Object> get props => [];
}
