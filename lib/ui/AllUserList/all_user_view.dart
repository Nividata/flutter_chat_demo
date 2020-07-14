import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/utility/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'all_user_view_model.dart';

class AllUserView extends StatefulWidget {
  @override
  _AllUserViewState createState() => _AllUserViewState();
}

class _AllUserViewState extends State<AllUserView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => AllUserViewModel(),
        builder: (context, AllUserViewModel model, child) => SafeArea(
              top: true,
              bottom: true,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Active Chat",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  backgroundColor: AppColors.secondaryLightest2,
                  elevation: 1,
                ),
                body: model.currentChatList.isNotEmpty
                    ? getChatList(model)
                    : Center(child: CircularProgressIndicator()),
              ),
            ));
  }

  Widget getChatList(AllUserViewModel model) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: model.currentChatList.length,
        itemBuilder: (context, indext) {
          return InkWell(
            onTap: () {
              model.onChatSelect(indext);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://i.imgur.com/BoN9kdC.png"))),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border:
                                    Border.all(width: 1, color: Colors.white))),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      model.currentChatList[indext].user.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    Text(
                                      model.currentChatList[indext].user.avatarUrl,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(color: Color(0xffB1B1B1)),
                                    ),
                                  ],
                                ),
                              ),
                              Text("now")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 26),
                                  child: Text(
                                    model.currentChatList[indext].key,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.lens,
                                size: 8,
                                color: Color(0xff7303C0),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
