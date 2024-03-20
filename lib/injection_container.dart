import 'package:get_it/get_it.dart';

import 'src/auth/presentation/cubit/user_cubit.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<UserCubit>(() => UserCubit(
        signInUseCase: sl.call(),
      ));
}
