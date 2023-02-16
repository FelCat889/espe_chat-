import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:espe_chat/common/widgets/error.dart';
import 'package:espe_chat/common/widgets/loader.dart';
import 'package:espe_chat/features/select_contacts/controller/select_contact_controller.dart';
class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }
 
    
    // print();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Contacto'),
        actions: [
          IconButton(
            onPressed: ()async {
            
            // print(await contactos());
              showSearch(context: context, delegate: MySearchDelegate(ref));
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.more_vert,
          //   ),
          // ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30,
                              ),
                      ),
                    ),
                  );
                }),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

class MySearchDelegate extends SearchDelegate  {
  
  List<dynamic> listaContacto = [];
  List<dynamic> listaAllData = [];
  final WidgetRef ref;
  MySearchDelegate(this.ref);

  void selectContact(
        WidgetRef ref, Contact selectedContact, BuildContext context) {
      ref
          .read(selectContactControllerProvider)
          .selectContact(selectedContact, context);
    }


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: (){
          query = "";
        }, 
        icon: const Icon(Icons.clear)
      )
    ];
    
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (() => close(context, null)), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
     List<String> matchQuery = [];
        for(var nombre in listaContacto){
          if(nombre.toLowerCase().contains(query.toLowerCase())){
            matchQuery.add(nombre);
          }
        }
      
      return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index){
          var suggestion = matchQuery[index];
          return ListTile(
            title: Text(suggestion),
          );
        }
      );
  }

  @override
  Widget buildSuggestions(BuildContext context){
            if (listaContacto.isEmpty){
              FlutterContacts.getContacts(withProperties: true).then((value) =>value.map((e) =>{
                //CONTACTO ALL
                 listaAllData.add(e),
                //NAME
                listaContacto.add( e.displayName)
              }).toList());
              
            }
             List<String> matchQuery = [];
        for(var nombre in listaContacto){
          if(nombre.toLowerCase().contains(query.toLowerCase())){
            matchQuery.add(nombre);
          }
        }
      
      return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index){
          var suggestion = matchQuery[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              print(listaAllData[index]);
              selectContact(ref, listaAllData[index], context);
              query = suggestion;
            }
          );
        }
      );

  }

}
