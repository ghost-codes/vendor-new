import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/activityModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/avtivityViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';

class ActivitiesView extends StatelessWidget {
  final String branchId;
  ScrollController _controller = ScrollController();

  ActivitiesView({Key key, this.branchId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ActivitiesViewModel>(
      onModelReady: (model) {
        model.getActivities(branchId);
      },
      builder: (context, model, _) {
        _controller.addListener(
          () async {
            if (_controller.position.maxScrollExtent == _controller.offset &&
                model.isBottom) {
              model.isBottom = false;
              _controller.animateTo(
                _controller.offset - 20,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              await model.loadMore();
            }
          },
        );

        if (model.state == ViewState.Busy)
          return Center(
            child: Loaders.fadinCubePrimSmall,
          );
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: model.activities.length + 1,
                itemBuilder: (context, index) {
                  if (index == model.activities.length) {
                    if (model.nextUrl == null) {
                      return Center(
                        child: Text(
                          "No more Activities to load",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              color: LocalColors.black),
                        ),
                      );
                    } else {
                      return model.isLoadingMore
                          ? Loaders.fadingCube
                          : SizedBox.shrink();
                    }
                  }
                  return ActivityTile(activity: model.activities[index]);
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        );
      },
    );
  }
}

class ActivityTile extends StatelessWidget {
  final ActivityDataModel activity;

  const ActivityTile({Key key, this.activity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ConstantValues.PadWide),
        constraints: BoxConstraints(maxHeight: 150),
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      color: LocalColors.grey.withOpacity(0.6),
                      width: 3,
                      height: double.infinity,
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: LocalColors.grey.withOpacity(0.15),
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: LocalColors.secodaryColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: LocalColors.white,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: LocalColors.black.withOpacity(0.07),
                        offset: Offset(4, 5),
                        blurRadius: 8,
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: activity.user,
                            style: TextStyle(
                              color: LocalColors.primaryColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: " ${activity.description}",
                            style: TextStyle(
                              color: LocalColors.black,
                              fontFamily: "Montserrat",
                            ),
                          )
                        ]),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(height: 15),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Device Name:",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " ${activity.deviceInfo.name}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Activity Type:",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " ${activity.activityType}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Reference:",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " ${activity.reference}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        activity.modified.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: LocalColors.black,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
