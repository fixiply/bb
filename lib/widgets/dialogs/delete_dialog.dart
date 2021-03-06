import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Internal package
import 'package:bb/utils/app_localizations.dart';
import 'package:bb/helpers/class_helper.dart';
import 'package:bb/utils/constants.dart';
import 'package:bb/utils/database.dart';
import 'package:bb/widgets/dialogs/confirm_dialog.dart';

class DeleteDialog extends StatefulWidget {
  final String? title;
  final bool? displayBody;
  final String? okText;
  final String? cancelText;
  DeleteDialog({this.title, this.okText, this.cancelText, this.displayBody = true});

  @override
  State<StatefulWidget> createState() {
    return _DeleteDialogState();
  }

  static Future<bool> model(BuildContext context, dynamic model, {bool forced = false}) async {
    bool archive = ClassHelper.hasStatus(model) && model.status != Status.disabled;
    String title = archive ? AppLocalizations.of(context)!.text('archive_title') : AppLocalizations.of(context)!.text('delete_item_title');
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          title: title,
          displayBody: archive != true,
          okText: archive ? AppLocalizations.of(context)!.text('archive') : null
        );
      }
    );
    if (confirm) {
      bool deleted = true;
      await Database().delete(model, forced: forced).onError((e, s) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 10)
          )
        );
        deleted = false;
      });
      return deleted;
    }
    return false;
  }
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: widget.title ?? AppLocalizations.of(context)!.text('delete_item_title'),
      content: SingleChildScrollView(
        child: widget.displayBody == true ? ListBody(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.text('remove_body')),
          ]
        ) : null
      ),
    );
  }
}
