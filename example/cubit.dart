import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment([int value = 1]) => emit(state + value);
  void decrement([int value = 1]) => emit(state - value);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
  }
}

Future<void> main() async {
  final cubit = CounterCubit();
  final subscription = cubit.stream.listen(print); // 1
  cubit.increment();
  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await cubit.close();
}
