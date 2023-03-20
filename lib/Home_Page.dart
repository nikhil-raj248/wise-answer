import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:lottie/lottie.dart';
import 'message.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController controller = TextEditingController();
  final List<message_model> messages = [];
  OpenAI? chatGpt;
  StreamSubscription? subscription;
  bool isProcessingRequest = false;
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  double confidence = 1.0;
  String _text = "hello world!";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGpt = OpenAI.instance;
    speech = stt.SpeechToText();
    initSpeech();
  }

  initSpeech()async{
    bool isAvailable = await speech.initialize(
      onStatus: (val) => print("2223333onStatus : ${val}"),
      onError: (val) => print("22222onError : ${val}"),
    );
    print(isAvailable);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    subscription!.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if(controller.text.isEmpty)return;
    message_model UserMessage = message_model(controller.text, "user");

    setState(() {
      messages.insert(0, UserMessage);
      isProcessingRequest = true;
    });


    controller.clear();

    final openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(receiveTimeout: 60000),
        isLogger: true);

    final request = CompleteText(
        prompt: UserMessage.text, model: kTranslateModelV3, maxTokens: 200);

    print("22222222222222222222222222");
    bool isAddedBotMessage = false;
    openAI.onCompleteStream(request: request).listen((response) {
      // print(response!.choices[0].text)
      message_model BotMessage =
          message_model(response!.choices[0].text.trim(), "bot");
      if (!isAddedBotMessage) {
        setState(() {
          print("1111111111111111111111111");
          messages.insert(0, BotMessage);
          isProcessingRequest = false;
        });
        isAddedBotMessage = true;
      }
    });
  }

  Widget _bottomTextInputBar(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color.fromRGBO(154, 154, 154, 0.1),
        border: Border.all(
          color: Color.fromRGBO(154, 154, 154, 0.8),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (value) => _sendMessage(),
              controller: controller,
              enabled: (speech.isNotListening && !isProcessingRequest),
              style: TextStyle(
                  color: Color.fromRGBO(
                      223, 207, 207, 1.0)
              ),
              decoration: const InputDecoration.collapsed(
                  hintText: "Enter Your Query",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600, color: Color.fromRGBO(
                      150, 139, 139, 1.0))),
            ),
          ),
          IconButton(onPressed: (){
            FocusManager.instance.primaryFocus?.unfocus();
             _sendMessage();
            }, icon: Icon(Icons.send,color:
          Color.fromRGBO(200, 200, 200, 1.0),)),
        ],
      ),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {

    if(speech.isNotListening){
      _text = result.recognizedWords;
      controller.text=_text;
      _sendMessage();
      setState(() {

      });
    }
  }

  _solve() async{
    if(speech.isListening){
      print("1zzzzzzzzzzzzzzzzzzzzzzzzzzz");
      await speech.stop();
      setState(() {});
    }
    else{
      print("2zzzzzzzzzzzzzzzzzzzzzzzzzzz");
      await speech.listen(onResult: _onSpeechResult);
      setState(() {});
    }
  }

  Widget _messageListTile(int index,BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10,bottom: 10),
      child: Row(
        mainAxisAlignment: messages[index].sender == "bot"?MainAxisAlignment.start:MainAxisAlignment.end,
        children: [
          Container(
            width: size.width*0.75,
              decoration: BoxDecoration(
                border: Border.all(
                  color: (messages[index].sender == "bot")?
                  Color.fromRGBO(247, 3, 3, 1.0):
                  Color.fromRGBO(0, 126, 255, 1),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(messages[index].sender == "bot"?20:0),
                  bottomLeft: Radius.circular(messages[index].sender == "bot"?0:20),
                ),
                color: messages[index].sender == "bot"?Color.fromRGBO(
                    251, 85, 1, 0.8):Color.fromRGBO(
                    0, 126, 255, 0.8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                messages[index].text,
                style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16),
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(_text);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: size.height * 0.08,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: size.height * 0.09,
                child: (speech.isListening)?Lottie.asset("assets/animations/listening.json"):!isProcessingRequest?Lottie.asset("assets/animations/normal.json"):Lottie.asset("assets/animations/loading.json")

            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: (size.height * 0.5) - (size.width * 0.8),
                    left: size.width * 0.1,
                    child: Container(
                      width: size.width * 0.8,
                      height: size.width * 0.8,
                      child: Lottie.asset("assets/animations/rocket.json"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 15),
                    height: size.height * 0.88,
                    child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return _messageListTile(index,context);
                              }),
                        ),
                        Container(
                            child: _bottomTextInputBar(context)
                        ),
                        SizedBox(height: 15,),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: (){
                                        messages.clear();
                                        setState(() {

                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        side: BorderSide(
                                          width: 2.0,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete,color: Colors.white,),
                                          Text("Clear All",style: TextStyle(color: Colors.white,),),
                                        ],
                                      ))
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: (){
                                        _solve();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (speech.isListening)?Colors.yellow:Colors.black,
                                          side: BorderSide(
                                            width: 2.0,
                                            color: Colors.yellow,
                                          ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.mic,color: (speech.isListening)?Colors.deepOrange:Colors.white,),
                                          Text("Ask by voice",style: TextStyle(color: (speech.isListening)?Colors.deepOrange:Colors.white,),),
                                        ],
                                      ))
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
