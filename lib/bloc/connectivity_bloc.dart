import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? _subscription;

  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) async {
      if (event is ConnectedEvent) {
        emit(ConnectedState(message: "Connected"));
      } else if (event is NotConnectedEvent) {
        emit(NotConnectedState(message: "Not Connected"));
      }
      if (event is InternetInitial) {}
    });
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if ((result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile)) {
        add(ConnectedEvent());
      } else {
        add(NotConnectedEvent());
      }
    });
  }
  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }

  Future<bool> checkInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
