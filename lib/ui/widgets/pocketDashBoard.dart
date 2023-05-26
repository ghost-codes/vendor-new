import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/dashboardViewModel.dart';

class PocketDashBoard extends StatelessWidget {
  const PocketDashBoard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(builder: (context, model, child) {
      return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          color: LocalColors.white,
        ),
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text("Hello, ${Provider.of<UserModel>(context).username}",
                      style: LocalTextTheme.header),
                ],
              ),
              Text(
                "Welcome to your monthly highlights",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Montserrat",
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Highest Revenue",
                style: LocalTextTheme.header,
              ),
              SizedBox(height: 20),
              //highest revenue branch
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.highRevenueBranches[0]["branch_name"],
                      style: LocalTextTheme.body,
                    ),
                    Text(
                      "\$${model.highRevenueBranches[0]["revenue"]}",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "this month",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: LocalColors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Text(
                "High Revenue Branches",
                style: TextStyle(
                  color: LocalColors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              //List of high revenue branches
              Container(
                child: Column(
                  children: List.generate(
                    model.highRevenueBranches.length,
                    (index) => branch(model.highRevenueBranches[index]),
                  ),
                ),
              ),
              SizedBox(height: 15),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                    color: LocalColors.grey.withOpacity(0.3),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget branch(Map<String, dynamic> branch) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.5),
        child: Row(children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: LocalColors.secodaryColor.withOpacity(0.1),
            child: Center(
              child: Text(
                "L",
                style: TextStyle(
                  color: LocalColors.secodaryColor,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "${branch["branch_name"]}",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          Text(
            "\$${branch["revenue"]}",
            style: TextStyle(
              color: LocalColors.green,
              fontFamily: "Montserrat",
              fontSize: 13,
            ),
          ),
        ]),
      ),
    );
  }
}
