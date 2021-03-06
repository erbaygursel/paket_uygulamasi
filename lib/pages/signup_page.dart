import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/database.dart';
import 'home_page.dart';
import '../widgets/styles.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late bool check;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.account_circle_outlined,size: 100),
          const SizedBox(height: 25),
          const Text(
            "Aramıza Hoşgeldiniz",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'E-posta:'),
                  onSaved: (newValue) => email = newValue!,
                  validator: (value) => value == null || value.isEmpty ? 'Mail adresiniz boş olamaz' : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Şifre:'),
                  onSaved: (value) => password = value!,
                  validator: (value) => value == null || value.isEmpty ? 'Şifreniz boş olamaz' : null,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              child: CheckboxListTileFormField(
                title: const Text('Bilgilerimin kayıt edilmesini onaylıyorum.'),
                onSaved: (bool? value) => check = value!,
                validator: (bool? value) => value == false || value == null ? 'Onay vermeniz gerekmektedir.' : null,
                autovalidateMode: AutovalidateMode.always,
                contentPadding: const EdgeInsets.all(1),
                initialValue: false,
              ),
            )
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButtonStyle(),
            child: const Text("Kayıt Ol"),
            onPressed: () async {
              // Form valid (geçerli/yazdığımız kurallara uyuyor ise) kontrolü yapıyoruz.
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                await signUp(context);
              }
            },
          ),
        ]),
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
      .then((UserCredential usercredential) {
        if (FirebaseAuth.instance.currentUser != null) {
          createUser();

          customSuccessAlert(context, "Başarıyla kayıt oldunuz!")
            .then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (context) => const HomePage()), (route) => false
              );
          });
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Üyelik oluşturulurken bir hatayla karşılaşıldı.')),
        );
      });
  }
}
