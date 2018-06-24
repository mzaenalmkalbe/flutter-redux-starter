import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hillelcoren/ui/app/loading_indicator.dart';
import 'package:hillelcoren/ui/stub/stub_item.dart';
import 'package:hillelcoren/ui/stub/stub_list_vm.dart';

class StubList extends StatelessWidget {
  final StubListVM viewModel;

  StubList({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (! viewModel.isLoaded) {
      if (! viewModel.isLoading) {
        viewModel.onRefreshed(context);
      }
      return LoadingIndicator();
    }

    return _buildListView(context);
  }

  Widget _buildListView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => viewModel.onRefreshed(context),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: viewModel.stubList.length,
          itemBuilder: (BuildContext context, index) {
            var stubId = viewModel.stubList[index];
            var stub = viewModel.stubMap[stubId];
            return Column(children: <Widget>[
              StubItem(
                stub: stub,
                client: viewModel.clientMap[stub.clientId],
                onDismissed: (DismissDirection direction) =>
                    viewModel.onDismissed(context, stub, direction),
                onTap: () => viewModel.onStubTap(context, stub),
              ),
              Divider(
                height: 1.0,
              ),
            ]);
          }),
    );
  }
}
