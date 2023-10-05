import 'package:connectivity_checker/cubit/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {},
            child: (state is ConnectedState)
                ? const CircleAvatar(
                    backgroundColor: Colors.green,
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is NotConnectedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ConnectedState) {
            return _buildTextWidget(state.message);
          } else {
            return _buildTextWidget('Not Connected');
          }
        },
      ),
    );
  }
}

Widget _buildTextWidget(String message) {
  return Center(
    child: Text(
      message,
      style: const TextStyle(fontSize: 20),
    ),
  );
}
