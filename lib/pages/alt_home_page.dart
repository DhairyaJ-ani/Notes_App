import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesfinalapp/services/firestore.dart';

class AltHomePage extends StatefulWidget {
  const AltHomePage({super.key});

  @override
  State<AltHomePage> createState() => _AltHomePageState();
}

class _AltHomePageState extends State<AltHomePage> {

  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docId}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      
      content: TextField(
        controller: textController,
        maxLength: 20,
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
        
        child: Text("Add",
            selectionColor: Color.fromRGBO(211, 228, 244, 1),
          ),
        ),
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 228, 244, 1),
      appBar: AppBar(
        title: Text("Notes App",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          ),
        ),
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
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 100,
                      child: Card(
                        elevation: 8,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                               
                                child: Text(noteText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                  
                                ),),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            IconButton(onPressed: () =>openNoteBox(docId: docId),icon: Icon(Icons.settings)),
                            IconButton(onPressed: () => firestoreService.deleteNote(docId), icon: Icon(Icons.delete)),
                          ],
                        ),
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