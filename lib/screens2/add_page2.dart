
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage2 extends StatefulWidget {
  final Map? todo;

  const AddTodoPage2({
    super.key,
    this.todo
    });

  @override
  State<AddTodoPage2> createState() => _AddTodoPage2State();
}

class _AddTodoPage2State extends State<AddTodoPage2> {
  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController fechaCracionController = TextEditingController();


  //PARA HACER UN EDIT
  bool isEdit2 = false;

  @override
  void initState() {
    super.initState();
    final todo2 = widget.todo;
    if (todo2 != null) {
      isEdit2 = true;
     
      final nombre2 = todo2['nombre'];
      
      nombreController.text = nombre2;
  
     


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit2 ? 'Editar Producto - api2' : 'Nuevo Producto-api2',
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          isEdit2 == false ? TextField(

            controller: idController,
            decoration: InputDecoration(hintText: 'id'),
            keyboardType: TextInputType.number,
          ) : Text("edit"),
          TextField(
            controller: nombreController,
            decoration: InputDecoration(hintText: 'nombre'),
          ),
          TextField(
            controller: imgController,
            decoration: InputDecoration(hintText: 'img'),
          ),
          TextField(
            controller: precioController,
            decoration: InputDecoration(hintText: 'precio'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: fechaCracionController,
            decoration: InputDecoration(hintText: 'fechaCreacion - Dia-Mes-Año'),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: isEdit2 ? updateData2 : submitData2, 
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  isEdit2 ? 'Editar' : 'Guardar'),
            ),
            ),
        ],
      ),
    );
  }



  //PUT
 //PUT
  Future <void> updateData2() async{
    //obtener los datos del formulario
    final todo = widget.todo;
    if(todo == null){
      print('error');
      return;
    }
    final idedit = todo['id'];
    

    //enviar los datos al server para actualizar
    final url = 'https://mi-api-rest.fly.dev/api/actualizar/$idedit';
    final uri = Uri.parse(url);

    
    final nombre3 = nombreController.text;
    final img3 = imgController.text;
    final precio3 = precioController.text;
    final fechaCracion3 = fechaCracionController.text;
    //enviamos un body con el modelo de la api :)
    final body = {
    "nombre": nombre3,
    "img": img3,
    "precio": precio3,
    "fechaCracion": fechaCracion3
    };
    print("Put");

    final response = await http.put(
      uri, 
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'});


    //mostrar si se envio o fallo, osea el estado
    if (response.statusCode == 200) {
      showSuccessMessage('Producto Editado');
      

    }else{
      showErrorMeesage('Error al editar');
    }

  }



  //POST

  Future <void> submitData2() async{
    //obtener los datos del formulario
    final id = idController.text;
    final nombre = nombreController.text;
    final img = imgController.text;
    final precio = precioController.text;
    final fechaCracion = fechaCracionController.text;
    //enviamos un body con el modelo de la api :)
    final body = {
        "id":id,
        "nombre":nombre,
        "img":img,
        "precio":precio, 
        "fechaCracion":fechaCracion
        };

      print(body);

    //enviar los datos al server
    const url = 'https://mi-api-rest.fly.dev/api/nuevo';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri, 
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'});
  

    //mostrar si se envio o fallo, osea el estado
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      showSuccessMessage('Producto guardado');
      idController.text = '';
      nombreController.text = '';
      imgController.text = '';
      precioController.text = '';
      fechaCracionController.text = '';


    }else{
      showErrorMeesage('Error al guardar producto');
    }
  }

  void showErrorMeesage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message){
    
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


