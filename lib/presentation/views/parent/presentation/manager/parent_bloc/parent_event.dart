part of 'parent_bloc.dart';

class ParentEvent extends BlocEvent {
  const ParentEvent();
}

class FetchParents extends ParentEvent {
  final int page;
  final int size;
  final bool loadMore;
  final String? parentType;
  final String? search;
  const FetchParents({
    this.page = 0,
    this.size = 20,
    this.loadMore = false,
    this.parentType,
    this.search,
  });
}

class FetchParentById extends ParentEvent {
  final String parentId;
  const FetchParentById(this.parentId);
}

class CreateParent extends ParentEvent {
  final CreateParentRequest request;
  const CreateParent(this.request);
}

class UpdateParent extends ParentEvent {
  final String parentId;
  final Map<String, dynamic> updates;
  const UpdateParent(this.parentId, this.updates);
}

class DeleteParent extends ParentEvent {
  final String parentId;
  const DeleteParent(this.parentId);
}

class FetchParentsByStudent extends ParentEvent {
  final String studentId;
  const FetchParentsByStudent(this.studentId);
}

class LinkParentToStudent extends ParentEvent {
  final String parentId;
  final String studentId;
  const LinkParentToStudent(this.parentId, this.studentId);
}

class SearchParents extends ParentEvent {
  final String query;
  const SearchParents(this.query);
}
