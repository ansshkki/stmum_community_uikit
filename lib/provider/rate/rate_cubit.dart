import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'rate_repository.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateInitial());

  RateRepository? rateRepository;

  Future<void> checkRate(String route) async {
    rateRepository ??= RateRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    await rateRepository!.reviewRequest(route);
  }
}
