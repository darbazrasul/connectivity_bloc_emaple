# Connectivity Bloc Example

A Flutter project demonstrating how to handle network connectivity changes using the BLoC pattern with a custom `ConnectivityCubit` base class.

## Overview

This project provides a reusable architecture for monitoring and responding to network connectivity changes in Flutter applications. It combines `connectivity_plus` package with `flutter_bloc` to create a robust solution for handling online/offline states.

## Features

- 🔌 Real-time network connectivity monitoring
- 🎯 Built-in debouncing to prevent rapid state changes
- 🧩 Reusable `ConnectivityCubit` base class
- 🏗️ Clean architecture with separation of concerns
- 📱 Support for multiple connectivity types (WiFi, Mobile, Ethernet, None)

## Architecture

The project follows a feature-based folder structure:

```
lib/
├── src/
│   ├── core/
│   │   ├── constants/
│   │   └── utils/
│   │       └── debouncer.dart
│   └── features/
│       ├── catView/
│       │   ├── cubit/
│       │   ├── models/
│       │   ├── repo/
│       │   ├── screen/
│       │   └── widget/
│       └── shared/
│           ├── service/
│           │   └── connectivity_cubit.dart
│           └── widget/
└── main.dart
```

## Key Components

### ConnectivityCubit

The `ConnectivityCubit` is an abstract base class that any cubit can extend to automatically gain connectivity monitoring capabilities:

```dart
abstract class ConnectivityCubit<State> extends BlocBase<State> {
  late final Connectivity _connectivity;
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  ConnectivityCubit(super.initialState) {
    _connectivity = Connectivity();
    final debouncer = Debouncer(duration: const Duration(milliseconds: 1500));
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      debouncer.run(() => onConnectivityChange.call(result));
    });
  }
  
  void onConnectivityChange(ConnectivityResult result);
  
  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
```

### Debouncer

The debouncer utility prevents excessive state updates when connectivity rapidly changes:

```dart
class Debouncer {
  final Duration duration;
  Timer? _timer;
  
  Debouncer({required this.duration});
  
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
```

## Usage

1. **Extend ConnectivityCubit in your feature cubits:**

```dart
class CatCubit extends ConnectivityCubit<CatState> {
  CatCubit() : super(CatInitial());
  
  @override
  void onConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      emit(CatOffline());
    } else {
      emit(CatOnline());
      // Fetch data or perform online operations
    }
  }
}
```

2. **Provide the cubit in your widget tree:**

```dart
BlocProvider(
  create: (context) => CatCubit(),
  child: CatScreen(),
)
```

3. **Listen to connectivity changes in your UI:**

```dart
BlocBuilder<CatCubit, CatState>(
  builder: (context, state) {
    if (state is CatOffline) {
      return OfflineWidget();
    }
    return OnlineWidget();
  },
)
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^5.0.2
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  http: ^1.6.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

## Getting Started

1. **Clone the repository:**
```bash
git clone https://github.com/darbazrasul/connectivity_bloc_emaple.git
cd connectivity_bloc_example
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

## Benefits

- **Automatic Cleanup**: Connectivity subscriptions are automatically cancelled when cubits are closed
- **Debouncing**: Prevents UI flickering from rapid connectivity changes
- **Reusability**: Any cubit can gain connectivity monitoring by extending `ConnectivityCubit`
- **Type Safety**: Strongly typed states using BLoC pattern
- **Testability**: Easy to mock and test connectivity scenarios

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

Darbaz Rasul - [@darbazrasul](https://github.com/darbazrasul)

## Acknowledgments

- [connectivity_plus](https://pub.dev/packages/connectivity_plus) - Network connectivity monitoring
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
- Flutter team for the amazing framework

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Note**: This is an example project for educational purposes. Feel free to use it as a starting point for your own applications!
