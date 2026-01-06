# Project Guidelines

This document outlines the architectural patterns, code organization principles, and best practices to be followed in this project. Adhering to these guidelines ensures consistency, readability, maintainability, and scalability of the codebase.

## 1. Clean Architecture Principles

This project follows the principles of Clean Architecture, separating concerns into distinct layers:

### A. Data Layer (Repositories, Models)
- **`lib/presentation/views/login/domain/repositories/login_repository.dart`**: Defines abstract contracts (interfaces) for data operations. These contracts live in the domain layer to ensure business rules are independent of implementation details.
  ```dart
  import 'package:student_management/core/utils/app_type_def.dart';
  import '../../data/models/request/login_request.dart' show LoginRequest;

  abstract class LoginRepository {

    DioResponse login({
      required LoginRequest payload
    });
    
    // Future<Either<Failure, void>> logout();
  }
  ```
- **`lib/presentation/views/login/data/repositories/login_repository_impl.dart`**: Provides concrete implementations of the repository interfaces. These implementations handle data fetching from various sources (APIs, databases, etc.) and map them to domain entities.
  ```dart
  import 'package:injectable/injectable.dart';
  import 'package:student_management/core/services/api_service/api_micro_dispatcher.dart';
  import 'package:student_management/core/utils/api_end_point.dart';
  import 'package:student_management/core/utils/app_enum.dart';
  import 'package:student_management/core/utils/app_type_def.dart';
  import 'package:student_management/presentation/views/login/domain/repositories/login_repository.dart';
  import '../models/request/login_request.dart' show LoginRequest;

  @LazySingleton(as: LoginRepository)
  class LoginRepositoryImpl implements LoginRepository {

    final ApiDispatcher apiDispatcher;

    LoginRepositoryImpl(this.apiDispatcher);

    @override
    DioResponse login({required LoginRequest payload}) async {
      return await apiDispatcher.dispatch(
        type: RequestType.post,
        endPoint: ApiEndPoint.login,
        body: payload.toJson()
      );
    }
  }
  ```

### B. Domain Layer (Use Cases/Interactors, Entities)
- **`lib/presentation/views/dashboard/domain/use_cases/profile_fetch_use_case.dart`**: Contains the application-specific business rules. Use cases orchestrate the flow of data to and from the entities.
  ```dart
  import 'package:dio/dio.dart';
  import 'package:injectable/injectable.dart';
  import 'package:student_management/core/base/base_use_case/use_case.dart';
  import 'package:student_management/presentation/views/dashboard/domain/repositories/profile_repo.dart';
  import '../../data/models/req/profile_fetch_req.dart';

  @LazySingleton(env: ['dev'])
  class ProfileFetchUseCase extends UseCase<Response, ProfileFetchRequest>{

    final ProfileRepo _repo;

    const ProfileFetchUseCase(this._repo);

    @override
    Future<Response> call({required ProfileFetchRequest params}) async {
      return await _repo.fetchProfile(params);
    }
  }
  ```

### C. Presentation Layer (Blocs, States, Events)
- **`lib/presentation/views/login/presentation/manager/login_bloc/login_bloc.dart`**: Manages the state for UI. It receives events from the UI, processes them using use cases (or repositories directly for simpler flows), and emits new states to update the UI.
  ```dart
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:injectable/injectable.dart';
  import 'package:student_management/core/base/bloc_base/bloc_event.dart';
  import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
  import 'package:student_management/core/base/logger/app_logger_impl.dart' show Log;
  import 'package:student_management/core/handler/state_request_handler.dart';
  import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
  import 'package:student_management/presentation/views/login/data/models/request/login_request.dart';
  import 'package:student_management/presentation/views/login/data/models/response/login_response.dart';
  import 'package:student_management/presentation/views/login/domain/repositories/login_repository.dart';

  part 'login_event.dart';
  part 'login_state.dart';

  @injectable
  class LoginBloc extends Bloc<LoginEvent, LoginState> {
    final StateRequestHandler _stateRequestHandler;
    final LoginRepository _loginRepository;
    final AuthStorageService _storageService;

    LoginBloc(
      this._stateRequestHandler,
      this._loginRepository,
      this._storageService,
    ) : super(const LoginState()) {
      on<LoginButtonPressed>(_onLoginButtonPressed);
    }

    FVoid _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
    ) async {
      await _stateRequestHandler(
        apiCall: () async {
          emit(state.copyWith(state: state.loading, event: event));
          var req = LoginRequest(
            password: event.password,
            username: event.email,
            rememberMe: event.rememberMe,
          );
          final result = await _loginRepository.login(payload: req);
          // ... handle success
          emit(state.copyWith(data: LoginResponse.fromJson(result.data), state: state.success));
        },
        error: (Exception e) {
          Log.e("Login error: ${e.toString()}");
          emit(state.copyWith(state: state.failed, error: e.toString()));
        },
      );
    }
  }
  ```
- **`lib/presentation/views/login/presentation/manager/login_bloc/login_event.dart`**: Represents actions or intentions from the UI.
- **`lib/presentation/views/login/presentation/manager/login_bloc/login_state.dart`**: Represents the different states the UI can be in.

- **`lib/core/services/api_service/api_micro_dispatcher.dart`**: This file demonstrates how API calls are dispatched, encapsulating the details of network requests and handling different request types.
  ```dart
  @LazySingleton()
  class ApiDispatcher {
    // ... dependencies

    DioResponse dispatch({
      required RequestType type,
      required String endPoint,
      // ... other params
    }) async {
      // ... implementation
    }
  }
  ```

## 2. UI/Theming Guidelines

### A. Routes
- **`lib/core/services/route_service/app_routing.dart`**: Centralizes the application's routing logic using `GoRouter`. All routes should be defined here for easy management and navigation.
  ```dart
  @protected
  @immutable
  class RouteService extends BaseService<void, void> {
    static final RouteService routeService = RouteService();
    
    final GoRouter goRouter = GoRouter(
      initialLocation: RoutesName.splashScreen,
      routes: <RouteBase>[
        GoRoute(
          path: RoutesName.splashScreen,
          name: RoutesName.splashScreen,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SplashController()),
        ),
        GoRoute(
          path: RoutesName.loginScreen,
          name: RoutesName.loginScreen,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginController()),
        ),
        // ... other routes
      ],
    );
  }
  ```
- **`lib/core/services/route_service/route_names.dart`**: Defines all named routes as static constants for strong typing and preventing errors from hardcoded strings.
  ```dart
  abstract class RoutesName {
    static const String home = '/home';
    static const String splashScreen = '/';
    static const String loginScreen = '/login';
    static const String introScreen = '/introScreen';
    // ...
  }
  ```

### B. Colors
- **`lib/core/utils/app_colors.dart`**: Centralizes all color definitions as static constants, promoting consistency and easy theme management.
  ```dart
  class AppColors {
    static const Color whiteColor = Colors.white;
    static const Color blackColor = Colors.black;
    static const Color greenColor = Colors.green;
    static const Color blueColor = Colors.blue;
    // ...
    static const Color msuGreen = Color(0xFF144444);
    static const Color greenCyan = Color(0xFF068D62);
    // ...
  }
  ```

### C. Text Styles
- **`lib/core/utils/app_style.dart`**: Defines a consistent set of text styles using `GoogleFonts` or custom definitions.
  ```dart
  class AppStyles {
    static TextStyle get baseStyle => GoogleFonts.acme();
    
    static final TextStyle baseFont = baseStyle.copyWith(
      fontWeight: FontWeight.w400,
    );

    /// FontSize: 12
    static final small = TextStyleSet(baseFont.copyWith(fontSize: 12));

    /// FontSize: 14
    static final regular = TextStyleSet(baseFont.copyWith(fontSize: 14));

    /// FontSize: 16
    static final medium = TextStyleSet(baseFont.copyWith(fontSize: 16));
    
    // ...
  }
  ```

### D. Color Opacity
- **Avoid `withOpacity`**: The `withOpacity` method is deprecated and can lead to precision loss. Instead, use `.withValues(alpha: ...)` for setting opacity on colors.
  ```dart
  // Bad
  color: AppColors.primary.withOpacity(0.5);

  // Good
  color: AppColors.primary.withValues(alpha: 0.5);
  ```

## 3. Mixins for Code Organization

-   Utilize mixins to separate concerns and simplify code, enhancing readability and maintainability.
-   Mixins should be declared as private (e.g., `_MyMixin`) if they are only used in one file, or public if reusable.
-   Use `part` and `part of` directives for organizing mixins within files where appropriate.

Example:
- **`lib/presentation/views/splash/presentation/pages/controller/splash_mixin.dart`**: Demonstrates the use of a mixin for managing splash screen logic.
  ```dart
  part of 'splash_controller.dart';

  mixin _SplashMixin<T extends StatefulWidget> on State<T> {
    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getToken();
      });
    }

    Future _getToken() async {
      // ... implementation
    }

    void _navigateToHome() {
      context.goNamed(RoutesName.home);
    }
  }
  ```

## 4. File Structure and Length

-   Prefer making files private using `part` and `part of` directives where appropriate for better encapsulation and organization.
-   Strive to keep file lengths concise, ideally **not exceeding 250 lines**, to maintain readability and manageability.

## 5. Prefer Enums Over Strings

-   Whenever possible, use `enum` types instead of raw strings for representing a fixed set of values (e.g., `RequestType`, `AppTheme`). This improves type safety, readability, and reduces the chance of errors due to typos.
  ```dart
  // lib/core/utils/app_enum.dart

  enum RequestType {
    get("get"),
    post("post"),
    // ...
  }

  enum AppTheme {
    system("system"),
    dark("dark"),
    light("light");
    // ...
  }
  ```
