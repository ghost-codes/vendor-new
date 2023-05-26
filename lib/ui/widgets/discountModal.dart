import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/discountModalViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class EditOrderModal extends Modal {
  final OrderModel order;

  EditOrderModal({this.order});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return BaseView<DiscountModalViewModel>(onModelReady: (model) {
      model.init(order);
    }, builder: (context, model, _) {
      return buildBackdropFilter(
        closeFunction: () {
          Navigator.of(context).pop();
        },
        width: 400,
        header: "Edit Order",
        bottomButtons: model.isDelete
            ? PrimaryLongButton(
                text: "Delete",
                loader: Loaders.fadinCubeWhiteSmall,
                isLoading: model.isLoading,
                color: LocalColors.error,
                onPressed: () {
                  model.deleteOrder(order.id, context);
                },
              )
            : Row(
                children: [
                  Expanded(
                    child: PrimaryLongButton(
                      text: "Update",
                      loader: Loaders.fadinCubeWhiteSmall,
                      isLoading: model.isLoading,
                      onPressed: () {
                        final state = _formkey.currentState;
                        if (state.validate())
                          model.onSubmitDiscount(context, order.id);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: PrimaryLongButton(
                      text: "Delete",
                      color: LocalColors.error,
                      onPressed: () {
                        model.onSetDelete();
                      },
                    ),
                  ),
                ],
              ),
        loader: Loaders.fadinCubeWhiteSmall,
        child: model.isDelete
            ? Center(child: Text("Do you want to DELETE order."))
            : Material(
                color: LocalColors.white,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: model.name,
                        decoration: inputDecoration(hintText: "Order name"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: model.clientPhone,
                        validator: (String val) {
                          if (val != null && val.length == 9) return null;
                          return "Number must be of 9 characters";
                        },
                        decoration: inputDecoration(
                            hintText: "Client Phone",
                            prefix: Text("+233 ",
                                style: TextStyle(color: LocalColors.grey))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: model.isDiscountPercentage,
                            onChanged: model.onIsDiscountPercentageChanged,
                            activeColor: LocalColors.primaryColor,
                          ),
                          Text("Is Percentage"),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      NumberInputField(
                        controller: model.discount,
                        hintText: 'Discount',
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
