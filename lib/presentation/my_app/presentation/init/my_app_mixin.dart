part of 'my_app.dart';

mixin _MyAppMixin<T extends StatefulWidget> on State<T> {
  late final StorageRepository _repository;

  FVoid init() async {
    _repository = StorageRepository(SecureStorageStrategy());
    await Future.delayed(const Duration(seconds: 2));
    var accessToken = await _repository.load(SecureStorageKeys.kAccessToken);
    Log.d("Received AccessToken is $accessToken");
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}
