import 'package:flutter/cupertino.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class DeleteUserRole extends Modal {
  final Function onDelete;

  DeleteUserRole(this.onDelete);
  @override
  Widget build(BuildContext context) {
    return buildBackdropFilter(
      width: 400,
      header: "Delete User Role",
      confirmText: "Delete",
      child: Text("Are you sure you want to delete this user role?"),
      closeFunction: () {
        Navigator.pop(context);
      },
      submitFunction: () async {
        await onDelete(context);
      },
    );
  }
}
