import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart' show Cubit;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late StreamSubscription<ConnectivityResult> _subscription;

  InternetCubit() : super(InternetInitial());
  Future<void> connected() async {
    late bool boolFuture;
    try {
      boolFuture = await booleanFuture();
    } catch (e) {
      print(e);
      boolFuture = false;
    }

    if (boolFuture) {
      emit(ConnectedState(message: "Connected"));
    } else {
      emit(NotConnectedState(message: "Not Connected"));
    }

    late StreamSubscription<Future<bool>> subscription;
    var variable = Stream.periodic(const Duration(seconds: 10), (_) async {
      late bool boolFuture;
      try {
        boolFuture = await booleanFuture();
      } catch (e) {
        print(e);
        boolFuture = false;
      }
      return boolFuture;
    });
    subscription = variable.listen((value) async {
      if ((await value)) {
        emit(ConnectedState(message: "Connected"));
      } else {
        emit(NotConnectedState(message: "Not Connected"));
      }
    });
  }

  void notConnected() {
    emit(NotConnectedState(message: "Not Connected"));
  }

  void checkConnection() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        await connected();
      } else {
        notConnected();
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

Future<bool> booleanFuture() async {
  var url = Uri.parse('https://www.google.com');

  await http.get(url).timeout(const Duration(seconds: 6), onTimeout: () {
    throw Exception();
  });

  return true;
}
