import 'package:flutter/material.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/bloc/auth_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';
import 'package:user_app/services/auth/bloc/auth_state.dart';
import 'package:user_app/services/auth/firebase_auth_provider.dart';
import 'package:user_app/view/email_view.dart';
import 'package:user_app/view/login_view.dart';
import 'package:user_app/view/note/create_update_note_view.dart';
import 'package:user_app/view/note/notes_view.dart';
import 'package:user_app/view/register_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//AuthService.firebase().initialize();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      noteRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const Email(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    //register: fer@unc.com pass=tester1
  ));
}

//final Future _data = AuthService.firebase().initialize();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsEmailVerification) {
          return const Email();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
    /* return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        final user = AuthService.firebase().currentUser;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const Email();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}  */
/* 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('testing'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text('current value is ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Invalid Value is >> $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter a number',
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              IncrementEvent(_controller.text),
                            );
                      },
                      child: const Text('+'),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber(
      {required this.invalidValue, required int previousValue})
      : super(previousValue);
}

abstract class CounterEvent {
  final String value;

  CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  IncrementEvent(super.value);
}

class DecrementEvent extends CounterEvent {
  DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(integer + state.value));
      }
    });
    on<DecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(
            CounterStateInvalidNumber(
                invalidValue: event.value, previousValue: state.value),
          );
        } else {
          emit(
            CounterStateValid(state.value - integer),
          );
        }
      },
    );
  }
}
 */