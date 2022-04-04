import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController updateController = TextEditingController();
  Box? store;
  @override
  void initState() {
    store = Hive.box("User");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () async {
                        final inputName = controller.text;

                        await store?.add(inputName);
                      },
                      child: Text("Add user number"))),
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box("User").listenable(),
                      builder: (context, index, widget) {
                        return ListView.builder(
                            itemCount: store!.keys.toList().length,
                            itemBuilder: (ctx, index) {
                              return Card(
                                child: ListTile(
                                  dense: true,
                                  title: Text(store!.getAt(index).toString()),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Update"),
                                                      content: TextFormField(
                                                          controller:
                                                              updateController),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Cencle")),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              await store!.putAt(
                                                                  index,
                                                                  updateController
                                                                      .text);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Update"))
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                store!
                                                    .deleteAt(index)
                                                    .toString();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }))
            ],
          ),
        ));
  }
}
