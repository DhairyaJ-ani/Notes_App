import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesfinalapp/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docId}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(onPressed: () {
           
        if (docId == null) {
          firestoreService.addNote(textController.text);
        }
        else{
          firestoreService.updateNote(docId, textController.text);
        }

        textController.clear();
        Navigator.pop(context);

        }, 
        child: Text("Add")),
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 228, 244, 1),
      appBar: AppBar(
        title: Text("Notes App"),
        backgroundColor: Color.fromRGBO(92, 106, 126, 0.773),),
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Color.fromRGBO(92, 106, 126, 0.773),
        hoverColor: Color.fromRGBO(0, 0, 0, 1),
        onPressed: openNoteBox,
        child: Icon(
          Icons.add,
          color: Color.fromRGBO(211, 228, 244, 1),
          ),
          
        ),

        body: StreamBuilder<QuerySnapshot> (
          stream: firestoreService.getNoteStream(), 
          builder: (context,snapshot) {

            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                
                itemCount: notesList.length,
                
                itemBuilder: (context,index) {
                  DocumentSnapshot document = notesList[index];
                  String docId = document.id;

                  Map<String,dynamic> data = document.data() as  Map<String,dynamic>;

                  String noteText = data['note'];

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      
                      minTileHeight: 100,
                      tileColor: Color.fromRGBO(255, 255, 255, 1),
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => firestoreService.deleteNote(docId), 
                            icon: Icon(Icons.delete)),
                          IconButton(
                            onPressed: () => openNoteBox(docId: docId), 
                          icon: Icon(Icons.settings)),
                        ],
                      ),
                    ),
                  );

                },
              );
            }
            
            else{
              return Text("Nothing");
            }
            
          },
        )
    );
    
  }
}