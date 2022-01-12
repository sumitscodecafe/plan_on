import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Center(
        child: Text('No task added yet!'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(15.0),
            height: 250,
            color: Colors.blue[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add task',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                Divider(thickness: 2.0),
                SizedBox(height: 20.0),
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter task',
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //width: (MediaQuery.of(context).size.width/2) - 17,
                  child: Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width/2) - 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: Text('RESET',
                            style: TextStyle(
                            color: Colors.black,
                            ),
                          ),
                          onPressed: ()=> _taskController.text = '',
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width/2) - 20,
                        child: ElevatedButton(
                          child: Text('ADD',
                            style: TextStyle(
                            color: Colors.black,
                            ),
                          ),
                          onPressed: ()=> saveData(),
                        ),
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveData() {

  }
}