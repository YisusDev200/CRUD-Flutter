import 'dart:convert';

import 'package:flutter/material.dart';

import '../screens/todo_list.dart';
import 'add_page2.dart';

import 'package:http/http.dart' as http;

class TodoListPage2 extends StatefulWidget {
  const TodoListPage2({super.key});

  @override
  State<TodoListPage2> createState() => _TodoListPage2State();
}

class _TodoListPage2State extends State<TodoListPage2> {
List items2 = [];
bool isLoading2 = true;
@override
  void initState() {
    super.initState();
    fetchTodo2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            /*Container(
              width: 100,
              height: 200,
              margin: const EdgeInsets.all(50),
              //child: Image.network("https://miro.medium.com/v2/resize:fit:640/0*L68utcHXnuEQwaf1."),
            ),*/
            const Text("My Api", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Api1"),
              onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TodoListPage(),
                    ))
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_link),
              title: const Text("Api - 2"),
              onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TodoListPage2(),
                    ))
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Api 2"),

      ),

      body: Visibility(
        
        visible: isLoading2,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo2,
          child: Visibility(
            visible: items2.isNotEmpty,
            replacement: Center(
            child: Text(
              'No hay productos almacenados',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
            child: ListView.builder(
              itemCount: items2.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item2 = items2[index] as Map;
                final id = item2['id'];
                print(id);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item2['nombre']),
                    subtitle: Text('Precio: ${item2['precio']} --- Fecha de creacion: ${item2['fechaCracion']}'),
                    trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit'){
                            navigateToEditPage2(item2);
                          }else if (value == 'delete'){
                            deleteById2(id);
                          }
                        },
                        itemBuilder: (context){
                          return[
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Editar"),
                              ),
                              const PopupMenuItem(
                              value: 'delete',
                              child: Text("Eliminar"),
                              )
                          ];
                        },
                        ),
                  ),
                );
                  
              }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:navigateToAddPage2,
         label: Text("Añadir dato")),
    );
  }



  //POST
  Future <void> navigateToAddPage2() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage2(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading2 = true;
    });
    fetchTodo2();

  }

  //PUT
  Future<void> navigateToEditPage2(Map item2) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage2(todo: item2),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading2 = true;
    });
    fetchTodo2();
  }

  //DETELE
  Future<void>deleteById2(id) async{
    //booralo en la base
    final url = 'https://mi-api-rest.fly.dev/api/eliminar/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    print(response.statusCode);

    if(response.statusCode == 200){
      final filtered = items2 = items2.where((element) => element['id'] != id).toList();
      setState(() {
        items2 = filtered;
        showSuccessMessage("dato borrado");
      }
      );
    }else{
        showErrorMeesage('error');
      }
  }

  //GETA ALL

 Future<void> fetchTodo2() async {
    
    const url = 'https://mi-api-rest.fly.dev/api';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      final jsonf = jsonDecode(response.body);
      setState(() {
        items2 = jsonf;
      });

      print("kjsnhikhniks");
      print(items2);
      setState(() {
      isLoading2 = false;
    });
    }else{//erroes}

    showErrorMeesage('error');
  }
}

void showErrorMeesage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 255, 17, 0),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message){
    
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}