import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/utility/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ChatViewModel(),
      builder: (context, ChatViewModel model, child) => SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: model.onBackClick,
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.black,
                size: 24,
              ),
            ),
            title: Text(
              "Cvisitor1",
              style: Theme.of(context).textTheme.headline6,
            ),
            backgroundColor: AppColors.secondaryLightest2,
            elevation: 1,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: (model.currentChatList.isNotEmpty)
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: model.currentChatList.length,
                          itemBuilder: (context, index) {
                            return (model.currentChatList[index].type == 1)
                                ? senderChatMessage(
                                    context, model.currentChatList[index])
                                : myChatMessage(
                                    context, model.currentChatList[index]);
                          })
                      : Center(child: CircularProgressIndicator()),
                ),
                sendMessage(context, model)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myChatMessage(BuildContext context, Message message) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.pink, AppColors.purple]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget senderChatMessage(BuildContext context, Message message) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(message.image))),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.whiteLight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 10),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          message.message,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    Text(
                      "3:30Pm",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: AppColors.secondary, fontSize: 10),
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

  Widget sendMessage(BuildContext context, ChatViewModel model) {
    return Container(
      padding: EdgeInsets.all(8),
      color: AppColors.whiteLight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: null,
              onChanged: model.newMessage,
              style: TextStyle(fontSize: 18.0, color: AppColors.black),
              decoration: InputDecoration(
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                fillColor: AppColors.white,
                hintText: "Send a Message",
                hintStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: model.sendNewMessage,
            constraints: BoxConstraints(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      colors: [AppColors.pink, AppColors.purple])),
              child: Icon(Icons.send),
              padding: EdgeInsets.only(left: 12, top: 11, bottom: 11, right: 7),
            ),
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }
}
