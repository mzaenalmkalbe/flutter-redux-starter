import 'package:hillelcoren/ui/app/app_search.dart';
import 'package:hillelcoren/ui/app/app_search_button.dart';
import 'package:hillelcoren/utils/localization.dart';
import 'package:hillelcoren/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hillelcoren/data/models/models.dart';
import 'package:hillelcoren/ui/stub/stub_list_vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hillelcoren/redux/stub/stub_actions.dart';
import 'package:hillelcoren/ui/app/app_drawer_vm.dart';
import 'package:hillelcoren/ui/app/app_bottom_bar.dart';

class StubScreen extends StatelessWidget {
  static final String route = '/stub';

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var localization = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: AppSearch(
          entityType: EntityType.stub,
          onSearchChanged: (value) {
            store.dispatch(SearchStubs(value));
          },
        ),
        actions: [
          AppSearchButton(
            entityType: EntityType.stub,
            onSearchPressed: (value) {
              store.dispatch(SearchStubs(value));
            },
          ),
        ],
      ),
      drawer: AppDrawerBuilder(),
      body: StubListBuilder(),
      bottomNavigationBar: AppBottomBar(
        entityType: EntityType.stub,
        onSelectedSortField: (value) {
          store.dispatch(SortStubs(value));
        },
        sortFields: [
          StubFields.stubNumber,
          StubFields.stubDate,
        ],
        onSelectedState: (EntityState state, value) {
          store.dispatch(FilterStubsByState(state));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () {
          store.dispatch(EditStub(stub: StubEntity(), context: context));
        },
        child: Icon(Icons.add,color: Colors.white,),
        tooltip: localization.newStub,
      ),
    );
  }
}
