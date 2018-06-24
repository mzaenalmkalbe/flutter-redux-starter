import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hillelcoren/redux/client/client_actions.dart';
import 'package:hillelcoren/utils/localization.dart';
import 'package:hillelcoren/redux/stub/stub_actions.dart';
import 'package:hillelcoren/data/models/models.dart';
import 'package:hillelcoren/ui/stub/view/stub_view.dart';
import 'package:hillelcoren/redux/app/app_state.dart';
import 'package:hillelcoren/ui/app/snackbar_row.dart';

class StubViewScreen extends StatelessWidget {
  static final String route = '/stub/view';
  StubViewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StubViewVM>(
      converter: (Store<AppState> store) {
        return StubViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return StubView(
          viewModel: vm,
        );
      },
    );
  }
}

class StubViewVM {
  final StubEntity stub;
  final ClientEntity client;
  final Function(BuildContext, EntityAction) onActionSelected;
  final Function(BuildContext) onEditPressed;
  final Function(BuildContext) onClientPressed;
  final bool isLoading;
  final bool isDirty;

  StubViewVM({
    @required this.stub,
    @required this.client,
    @required this.onActionSelected,
    @required this.onEditPressed,
    @required this.onClientPressed,
    @required this.isLoading,
    @required this.isDirty,
  });

  factory StubViewVM.fromStore(Store<AppState> store) {
    final stub = store.state.stubUIState.selected;
    final client = store.state.clientState.map[stub.clientId];

    Future<Null> _viewPdf(BuildContext context) async {
      var localization = AppLocalization.of(context);
      var url;
      var useWebView;

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        url = stub.invitationSilentLink;
        useWebView = true;
      } else {
        url = 'https://docs.google.com/viewer?url=' +  stub.invitationDownloadLink;
        useWebView = false;
      }

      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: useWebView, forceWebView: useWebView);
      } else {
        throw '${localization.anErrorOccurred}';
      }
    }

    return StubViewVM(
        isLoading: store.state.isLoading,
        isDirty: stub.isNew(),
        stub: stub,
        client: client,
        onEditPressed: (BuildContext context) {
          store.dispatch(EditStub(stub: stub, context: context));
        },
        onClientPressed: (BuildContext context) {
          store.dispatch(ViewClient(client: client, context: context));
        },
        onActionSelected: (BuildContext context, EntityAction action) {
          final Completer<Null> completer = new Completer<Null>();
          var message;
          switch (action) {
            case EntityAction.pdf:
              _viewPdf(context);
              break;
            case EntityAction.email:
              store.dispatch(EmailStubRequest(completer, stub.id));
              message = AppLocalization.of(context).successfullyEmailedStub;
              break;
            case EntityAction.archive:
              store.dispatch(ArchiveStubRequest(completer, stub.id));
              message = AppLocalization.of(context).successfullyArchivedStub;
              break;
            case EntityAction.delete:
              store.dispatch(DeleteStubRequest(completer, stub.id));
              message = AppLocalization.of(context).successfullyDeletedStub;
              break;
            case EntityAction.restore:
              store.dispatch(RestoreStubRequest(completer, stub.id));
              message = AppLocalization.of(context).successfullyRestoredStub;
              break;
          }
          if (message != null) {
            return completer.future.then((_) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: SnackBarRow(
                    message: message,
                  ),
                  duration: Duration(seconds: 3)));
            });
          }
        }
    );
  }
}