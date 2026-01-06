//Here R stands for the Response we want to send and P stands for the params that is send as arguments
//in the function.....

abstract class UseCase<R, P> {
  const UseCase();
  Future<R> call({required P params});
}

abstract class AsyncUseCase<R, P> {
  const AsyncUseCase();
  R call({required P params});
}
