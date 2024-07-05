import 'dart:math';

//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman/constants/consts.dart';
import 'package:hangman/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
 // final player = AudioPlayer();
  String word = wordList[Random().nextInt(wordList.length)];
  List guessdalphabets = [];
  int points = 0;
  int status = 0;
  bool soundOn = true;
  List images = [one,two,three,four,five,six,seven];

  // playSound(String sound) async{
  //   if(soundOn){
  //     await player.play(UrlSource(sound));
  //   }
  // }

  opendialog(String title){
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (context){
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: 180,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: gameStyle(25,Colors.black45,FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5,),
              Text('Your points: $points',style: gameStyle(20,Colors.black45,FontWeight.bold),textAlign: TextAlign.center,),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      status = 0;
                      guessdalphabets.clear();
                      points = 0;
                      word = wordList[Random().nextInt(wordList.length)];
                    });
                  },
                  child: Center(
                    child: Text('Play Again',style: gameStyle(20, Colors.greenAccent,FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  String handletext(){
    String displayword = '';
    for (var i = 0; i < word.length; i++) {
      String char =  word[i];
      if(guessdalphabets.contains(char)){
        displayword += '$char ';
      }else{
        displayword += '? ';
      }
    }
    return displayword;
  }

  checkLetter(String alphabet){
    if(word.contains(alphabet)){
      setState(() {
        guessdalphabets.add(alphabet);
        points += 5;
      }); 
      //playSound(correct);  
    }else if(status != 6){
      setState(() {
        status += 1;
        points -= 5;
        if(points <= 0){
          points = 0;
        }
      });
      //playSound(wrong);
    }else{
      opendialog('YOU LOST!');
      //playSound(ending);
    }
    bool isWon = true;
    for (var i = 0; i < word.length; i++) {
      String char =  word[i];
      if(!guessdalphabets.contains(char)){
        setState(() {
          isWon = false;
        });
        break;
      }
    }

    if(isWon){
      opendialog('YOU WON!');
      //playSound(ending);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black45,
        title: Text(
          'Hangman',
          style: gameStyle(30,Colors.white,FontWeight.w700),
        ),
        actions: [
          IconButton(
            iconSize: 40,
            onPressed: (){
              setState(() {
                soundOn = !soundOn;
              });
              
            },
            color: Colors.white, 
            icon:  Icon(
              soundOn ? Icons.volume_up_sharp : Icons.volume_off_sharp,
              )
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width /2.5,
                decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                height: 30,
                child: Center(
                  child: Text(
                    "$points points",
                    style: gameStyle(15, Colors.black,FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image(
                width: 155,
                height: 155,
                image: AssetImage(images[status]),
                fit: BoxFit.cover,
                
                ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${7 - status} lives left', style: gameStyle(18,Colors.grey,FontWeight.w700),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                handletext(),
                style: gameStyle(35, Colors.white,FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 10),
                childAspectRatio: 1.3,
                children: letters.map((alphabet){
                  return InkWell(
                    onTap: ()=> checkLetter(alphabet),
                    child: Center(
                      child: Text(
                        alphabet, style: gameStyle(20,Colors.white, FontWeight.w700),),
                    )
                    );
                }).toList(),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}