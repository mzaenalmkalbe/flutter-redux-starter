import 'package:redux/redux.dart';
import 'package:hillelcoren/data/models/models.dart';
import 'package:hillelcoren/redux/company/company_actions.dart';
import 'package:hillelcoren/redux/ui/entity_ui_state.dart';
import 'package:hillelcoren/redux/ui/list_ui_state.dart';
import 'package:hillelcoren/redux/stub/stub_actions.dart';
import 'package:hillelcoren/redux/stub/stub_state.dart';

EntityUIState stubUIReducer(StubUIState state, action) {
  return state.rebuild((b) => b
    ..listUIState.replace(stubListReducer(state.listUIState, action))
    ..selected.replace(editingReducer(state.selected, action))
    ..dropdownFilter = dropdownFilterReducer(state.dropdownFilter, action)
  );
}

Reducer<String> dropdownFilterReducer = combineReducers([
  TypedReducer<String, FilterStubDropdown>(filterStubDropdownReducer),
]);

String filterStubDropdownReducer(String dropdownFilter, FilterStubDropdown action) {
  return action.filter;
}

final editingReducer = combineReducers<StubEntity>([
  TypedReducer<StubEntity, SaveStubSuccess>(_updateEditing),
  TypedReducer<StubEntity, AddStubSuccess>(_updateEditing),
  TypedReducer<StubEntity, ViewStub>(_updateEditing),
  TypedReducer<StubEntity, EditStub>(_updateEditing),
  TypedReducer<StubEntity, UpdateStub>(_updateEditing),
  TypedReducer<StubEntity, AddContact>(_addContact),
  TypedReducer<StubEntity, DeleteContact>(_removeContact),
  TypedReducer<StubEntity, UpdateContact>(_updateContact),
  TypedReducer<StubEntity, SelectCompany>(_clearEditing),
]);

StubEntity  _clearEditing(StubEntity stub, action) {
  return StubEntity();
}

StubEntity _updateEditing(StubEntity stub, action) {
  return action.stub;
}

StubEntity _addContact(StubEntity stub, AddContact action) {
  return stub.rebuild((b) => b
    ..contacts.add(ContactEntity())
  );
}

StubEntity _removeContact(StubEntity stub, DeleteContact action) {
  return stub.rebuild((b) => b
    ..contacts.removeAt(action.index)
  );
}

StubEntity _updateContact(StubEntity stub, UpdateContact action) {
  return stub.rebuild((b) => b
    ..contacts[action.index] = action.contact
  );
}

final stubListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortStubs>(_sortStubs),
  TypedReducer<ListUIState, FilterStubsByState>(_filterStubsByState),
  TypedReducer<ListUIState, SearchStubs>(_searchStubs),
]);

ListUIState _filterStubsByState(ListUIState stubListState, FilterStubsByState action) {
  if (stubListState.stateFilters.contains(action.state)) {
    return stubListState.rebuild((b) => b
        ..stateFilters.remove(action.state)
    );
  } else {
    return stubListState.rebuild((b) => b
        ..stateFilters.add(action.state)
    );
  }
}

ListUIState _searchStubs(ListUIState stubListState, SearchStubs action) {
  return stubListState.rebuild((b) => b
    ..search = action.search
  );
}

ListUIState _sortStubs(ListUIState stubListState, SortStubs action) {
  return stubListState.rebuild((b) => b
      ..sortAscending = b.sortField != action.field || ! b.sortAscending
      ..sortField = action.field
  );
}


final stubsReducer = combineReducers<StubState>([
  TypedReducer<StubState, SaveStubSuccess>(_updateStub),
  TypedReducer<StubState, AddStubSuccess>(_addStub),
  TypedReducer<StubState, LoadStubsSuccess>(_setLoadedStubs),
  TypedReducer<StubState, LoadStubsFailure>(_setNoStubs),

  TypedReducer<StubState, ArchiveStubRequest>(_archiveStubRequest),
  TypedReducer<StubState, ArchiveStubSuccess>(_archiveStubSuccess),
  TypedReducer<StubState, ArchiveStubFailure>(_archiveStubFailure),

  TypedReducer<StubState, DeleteStubRequest>(_deleteStubRequest),
  TypedReducer<StubState, DeleteStubSuccess>(_deleteStubSuccess),
  TypedReducer<StubState, DeleteStubFailure>(_deleteStubFailure),

  TypedReducer<StubState, RestoreStubRequest>(_restoreStubRequest),
  TypedReducer<StubState, RestoreStubSuccess>(_restoreStubSuccess),
  TypedReducer<StubState, RestoreStubFailure>(_restoreStubFailure),
]);

StubState _archiveStubRequest(StubState stubState, ArchiveStubRequest action) {
  var stub = stubState.map[action.stubId].rebuild((b) => b
    ..archivedAt = DateTime.now().millisecondsSinceEpoch
  );

  return stubState.rebuild((b) => b
    ..map[action.stubId] = stub
  );
}

StubState _archiveStubSuccess(StubState stubState, ArchiveStubSuccess action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}

StubState _archiveStubFailure(StubState stubState, ArchiveStubFailure action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}

StubState _deleteStubRequest(StubState stubState, DeleteStubRequest action) {
  var stub = stubState.map[action.stubId].rebuild((b) => b
    ..archivedAt = DateTime.now().millisecondsSinceEpoch
    ..isDeleted = true
  );

  return stubState.rebuild((b) => b
    ..map[action.stubId] = stub
  );
}

StubState _deleteStubSuccess(StubState stubState, DeleteStubSuccess action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}

StubState _deleteStubFailure(StubState stubState, DeleteStubFailure action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}


StubState _restoreStubRequest(StubState stubState, RestoreStubRequest action) {
  var stub = stubState.map[action.stubId].rebuild((b) => b
    ..archivedAt = null
    ..isDeleted = false
  );
  return stubState.rebuild((b) => b
    ..map[action.stubId] = stub
  );
}

StubState _restoreStubSuccess(StubState stubState, RestoreStubSuccess action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}

StubState _restoreStubFailure(StubState stubState, RestoreStubFailure action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
  );
}


StubState _addStub(
    StubState stubState, AddStubSuccess action) {
  return stubState.rebuild((b) => b
    ..map[action.stub.id] = action.stub
    ..list.add(action.stub.id)
  );
}

StubState _updateStub(
    StubState stubState, SaveStubSuccess action) {
  return stubState.rebuild((b) => b
      ..map[action.stub.id] = action.stub
  );
}

StubState _setNoStubs(
    StubState stubState, LoadStubsFailure action) {
  return stubState;
}

StubState _setLoadedStubs(
    StubState stubState, LoadStubsSuccess action) {
  return stubState.rebuild(
    (b) => b
      ..lastUpdated = DateTime.now().millisecondsSinceEpoch
      ..map.addAll(Map.fromIterable(
        action.stubs,
        key: (item) => item.id,
        value: (item) => item,
      ))
      ..list.replace(action.stubs.map(
              (stub) => stub.id).toList())
  );
}
