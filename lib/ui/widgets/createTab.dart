import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/createTabViewModel.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

import '../baseView.dart';

class CreateTabView extends Modal {
  final String branchId;

  CreateTabView({this.branchId});
  @override
  Widget build(BuildContext contexct) {
    return BaseView<CreateTabViewModel>(
      builder: (context, model, _) {
        return buildBackdropFilter(
          width: 400,
          header: "New Tab",
          confirmText: "Create Tab",
          loader: Loaders.fadinCubeWhiteSmall,
          isLoading: model.isLoading,
          submitFunction: () async {
            await model.onCreateTab(branchId, context);
          },
          child: mainContent(),
          closeFunction: () {
            Navigator.of(context).pop(false);
          },
        );
      },
    );
  }

  Widget mainContent() {
    return Consumer<CreateTabViewModel>(builder: (context, model, _) {
      return Material(
        child: Column(
          children: [
            TextField(
              controller: model.name,
              decoration: inputDecoration(hintText: "Name"),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            TextField(
              controller: model.description,
              decoration: inputDecoration(hintText: "Description"),
              maxLines: 5,
            )
          ],
        ),
      );
    });
  }
}
