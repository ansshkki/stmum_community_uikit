import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'rate_repository.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  final RateRepository rateRepository;

  RateCubit({
    required this.rateRepository,
  }) : super(RateInitial());

  Future<void> checkRate(String route) async {
    await rateRepository.reviewRequest(route);
  }
}
