part of 'parent_bloc.dart';

class ParentState extends BlocEventState<List<ParentResponse>> {
  final List<ParentResponse> parents;
  final ParentResponse? selectedParent;
  final bool actionCompleted;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;

  const ParentState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.parents = const [],
    this.selectedParent,
    this.actionCompleted = false,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  ParentState copyWith({
    BlocState? state,
    List<ParentResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<ParentResponse>? parents,
    ParentResponse? selectedParent,
    bool? actionCompleted,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ParentState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      parents: parents ?? this.parents,
      selectedParent: selectedParent ?? this.selectedParent,
      actionCompleted: actionCompleted ?? false,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  ParentState clear({BlocState? state, BlocEvent? event}) =>
      ParentState(state: state ?? super.state, event: event);
}
