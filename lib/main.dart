import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart' as validator;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    )
  );
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final controller =  TextEditingController();
  final formKey = GlobalKey<FormState>();
  var user = UserModel();
  var cachePassword = '';
  var cachePasswordConfirm = '';
  bool obscureTextPassword = false;

  @override
  void initState() {
    super.initState();
/* 
    controller.addListener(() { 
      print(controller.text);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nome Completo', 
                hint: 'Digite seu Nome',
                icon: Icons.person,
                onSaved: (text) => user = user.copyWith(name: text),
                validator: (text) {
                  if(text == null || text.isEmpty){
                    return 'Esse campo não foi preenchido! :(';
                  }
                  if(text.length < 5){
                    return 'O campo deve ter no mínimo 5 caracateres, (tem: ${text.length})';
                  }
                },
              ),
              SizedBox(height: 15,),
              CustomTextField(
                label: 'Email', 
                hint: 'Digite seu Email',
                icon: Icons.mail,
                onSaved: (text) => user = user.copyWith(email: text),
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Esse campo não foi preenchido! :(';
                  }
                  if(!validator.isEmail(text)){
                    return 'O valor deve ser do tipo Email';
                  }
                }
              ),
              SizedBox(height: 15,),
              CustomTextField(
                label: 'Senha',
                hint: 'Digite sua senha', 
                icon: Icons.vpn_key,
                obscureText: obscureTextPassword,
                suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      obscureTextPassword = !obscureTextPassword;
                    });
                  }, 
                  icon: Icon(obscureTextPassword ? Icons.visibility : Icons.visibility_off)
                ),
                onChanged: (text) => cachePassword = text!,  
                onSaved: (text) => user = user.copyWith(password: text),
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Esse campo não foi preenchido! :(';
                  }
                  if(cachePasswordConfirm != cachePassword){
                    return 'As senhas não coincidem';
                  }
                }, 
              ),
              SizedBox(height: 15,),
              CustomTextField(
                label: 'Confirme sua senha', 
                hint: 'Confirme sua senha',
                icon: Icons.vpn_key,
                obscureText: obscureTextPassword,
                onSaved: (text) => user = user.copyWith(password: text),
                suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      obscureTextPassword = !obscureTextPassword;
                    });
                  }, 
                  icon: Icon(obscureTextPassword ? Icons.visibility : Icons.visibility_off)
                ),
                onChanged: (text) => cachePasswordConfirm = text!,
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Esse campo não foi preenchido! :(';
                  }
                  if(cachePasswordConfirm != cachePassword){
                    return 'As senhas não coincidem';
                  }
                },
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: (){
                    if(formKey.currentState!.validate()){ //Retorna o validator //Valida se campo foi preenchido
                      formKey.currentState!.save();
                      print('''

                      Form

                      Nome: ${user.name}
                      Email: ${user.email}
                      Senha: ${user.password}

                      ''');
                    } 
                  }, 
                  icon: Icon(Icons.save), 
                  label: Text("Salvar")
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    formKey.currentState?.reset();//Reseta os campos de texto
                  }, 
                  icon: Icon(Icons.save), 
                  label: Text("Refazer")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {

  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String? text)? validator; 
  final void Function(String? text)? onSaved; 
  final void Function(String? text)? onChanged; 

  const CustomTextField({Key? key, 
    required this.label, 
    this.hint,
    this.icon, 
    this.obscureText = false,
    this.suffix,
    this.validator, 
    this.onSaved, 
    this.onChanged, 
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction, //Marcar como erro (email sem @)
      validator: validator,
      onSaved: onSaved, //Vai ser chamado quando tiver um save()
      onChanged: onChanged,
      obscureText: obscureText, //Deixar o texto para senha com pontinhos
      decoration: InputDecoration(
        labelText: label, //Nomeia o Input
        hintText: hint, //Explicação do Input
        border: const OutlineInputBorder(), //Ícone Esquerda
        prefixIcon: icon == null ? null : Icon(icon), //Ícone Direita
        suffixIcon: suffix, //Botão de habilitar ver senha
      ),
    );
  }
}

@immutable
class UserModel {

  final String name;
  final String email;
  final String password;
  
  UserModel({
    this.name = '',
    this.email = '',
    this.password = '',
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
