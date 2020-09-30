// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:foreshortening_calculator/model/Model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('foreshortening calculator'),
        ),
        body: Center(child: ModelList()),
      ),
    );
  }
}

class ModelList extends StatefulWidget {
  @override
  _ModelListState createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
          children: ModelsEnum.values
              .map((ModelsEnum e) => _buildItem(e, context))
              .toList()),
    );
  }

  Widget _buildItem(ModelsEnum e, BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
          child: new Text(
            ModelFactory.name(e),
            style: new TextStyle(fontSize: 24.0),
          ),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ModelWidget(e)))),
    );
  }
}
