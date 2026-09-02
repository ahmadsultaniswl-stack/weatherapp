// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:weatherapp/api_services.dart';
// class LoginApi extends StatefulWidget {
//   const LoginApi({super.key});
//
//   @override
//   State<LoginApi> createState() => _LoginApiState();
// }
//
// class _LoginApiState extends State<LoginApi> {
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   WeatherApi loginApi = WeatherApi();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        body: Column(
//          children: [
//            Padding(padding: const EdgeInsets.all(8.0),
//            child: TextField(
//              controller: emailController,
//              decoration: InputDecoration(
//                border: OutlineInputBorder(),
//                hintText: "enter email"
//              ),
//              ),
//            ),
//
//            Padding(padding: const EdgeInsets.all(8.0),
//              child: TextField(
//                controller: passwordController,
//                decoration: InputDecoration(
//                    border: OutlineInputBorder(),
//                    hintText: "enter password"
//                ),
//              ),
//            ),
//
//            ElevatedButton(onPressed: (){
//              loginApi.postApi(context,
//                  emailController.text,
//                  passwordController.text);
//            }, child: Text("Login"))
//
//
//          ],
//        ),
//
//     );
//   }
// }
