import 'dart:convert';
import 'package:cha_shing/screens/code-input.dart';
import 'package:cha_shing/widgets/button.dart';
import 'package:cha_shing/widgets/textbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class Verify extends StatelessWidget {

  final String email;

  TextEditingController phone = TextEditingController();

  String verifyId;
  FirebaseAuth auth = FirebaseAuth.instance;

  Verify({Key key, this.email}) : super(key: key);







  @override
  Widget build(BuildContext context) {
    PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout (String verID){

      this.verifyId = verID;
      print(verID);
    }


    PhoneCodeSent   _smsCodeSent(String verificationId,[Int]) {

      this.verifyId = verificationId;
      print('Sms send code called and $verificationId');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => VerificationCodeInput(verId: verificationId,email: email,)),
      );
    }

    // let me check
    //run app ok


    verifyPhone(String phone) async {
      try {
        await auth.verifyPhoneNumber(
            phoneNumber: phone, // PHONE NUMBER TO SEND OTP
            timeout: const Duration(seconds: 120),
            codeSent: _smsCodeSent,
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
            verificationFailed: (AuthException exceptio) {
              //print('${exceptio.message}');
            },
            verificationCompleted: (AuthCredential credential){
              print('completed');
        }
        );
      } catch (e) {
        print(e);
      }
    }




    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        elevation: 0,
        centerTitle: true,
      ),

      body: Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/verify_back.png')),//todo: add image
              //color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: double.infinity,height: 50,),
              Container(
                  height: 100,
                  child: Image(image: AssetImage('images/verification.png'))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text('Verify Your Number',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Padding(
                padding:  EdgeInsets.all(40),
                child: Text('Please Enter Your Mobile Number to Recieve One Time Password',style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 40),
                child: InputBox(hint: '+1',type: TextInputType.phone,controller: phone,),
              ),
              Padding(
                padding:  EdgeInsets.fromLTRB(80,40,80,0),
                child: Button(color: Colors.white,textColor: Theme.of(context).accentColor,onclick: ()=>verifyPhone(phone.text),text: 'SEND OTP',),
              )
            ],
          ),
          ),
      ),
    );
  }
}
