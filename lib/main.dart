// ignore_for_file: use_key_in_widget_constructors
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // ignore: deprecated_member_use
        hintColor: Colors.amber,
        // errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
   // ignore: library_private_types_in_public_api
   _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          // ignore: prefer_const_constructors
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          // ignore: sort_child_properties_last
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  Widget _buildLandscapeContenet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // ignore: prefer_const_constructors
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProtentContenet(MediaQueryData ismediaQuery, AppBar appBar) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: (ismediaQuery.size.height -
              appBar.preferredSize.height -
              ismediaQuery.padding.top) *
          0.3,
      child: Chart(_recentTransactions),
    );
  }

  Widget _buildMethod() {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expenses',
            home: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: const Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context))
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final ismediaQuery = MediaQuery.of(context);

    final isLandscape = ismediaQuery.orientation == Orientation.landscape;

    // ignore: prefer_const_constructors
    final PreferredSizeWidget appBar = _buildMethod()as PreferredSizeWidget;
    // ignore: sized_box_for_whitespace
    final txListWidget = Container(
      height: (ismediaQuery.size.height -
              appBar.preferredSize.height -
              ismediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    // ignore: non_constant_identifier_names
    final Pagebode = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) _buildLandscapeContenet(),
          if (!isLandscape)
            _buildProtentContenet(ismediaQuery, appBar as AppBar),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                // ignore: sized_box_for_whitespace
                ? Container(
                    height: (ismediaQuery.size.height -
                            appBar.preferredSize.height -
                            ismediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions),
                  )
                : txListWidget
        ],
      ),
    ));
    // ignore: sort_child_properties_last
    return Platform.isIOS
        ? CupertinoPageScaffold(
            // ignore: sort_child_properties_last
            child: Pagebode,
            navigationBar: appBar as ObstructingPreferredSizeWidget)
        : Scaffold(
            appBar: appBar,
            body: Pagebode,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
