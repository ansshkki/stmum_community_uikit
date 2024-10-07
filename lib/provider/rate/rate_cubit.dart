import 'package:amity_uikit_beta_service/provider/rate/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  final RateRepository rateRepository;

  RateCubit({
    required this.rateRepository,
  }) : super(RateInitial());

  checkRate(String route) async {
    print("+++ in cubit");
    rateRepository.reviewRequest(route);
  }
}
