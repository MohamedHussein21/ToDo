import 'package:database/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget buildPadding(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
        padding: const EdgeInsets.all(10),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 45,
  
              child: Text('${model['time']}'),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            Expanded(
  
              child: Column(
  
                crossAxisAlignment: CrossAxisAlignment.start,
  
                mainAxisSize: MainAxisSize.min,
  
                children: [
  
                  Text(
  
                    '${model['title']}',
  
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  
                  ),
  
                  Text(
  
                    '${model['data']}',
  
                    style: TextStyle(fontSize: 10),
  
                  ),
  
                ],
  
              ),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            IconButton(
  
                color: Colors.teal,
  
                onPressed: () {
  
                  AppCubit.get(context)
  
                      .updateData(status: 'Archive', id: model['id']);
  
                },
  
                icon: Icon(Icons.check_box)),
  
            IconButton(
  
              onPressed: () {
  
                AppCubit.get(context)
  
                    .updateData(status: 'Done', id: model['id']);
  
              },
  
              icon: Icon(Icons.archive_outlined),
  
              color: Colors.black54,
  
            ),
  
          ],
  
        ),
  
      ),
  onDismissed: (direction){
AppCubit.get(context).deleteData(id: model['id']);
  },
);
