import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void viewSavedQuotes(BuildContext context, quotesList, param2 ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedQuotes = prefs.getStringList('savedQuotes');
  if (savedQuotes != null && savedQuotes.isNotEmpty) {
    SnackBar snackBar = SnackBar(
      content: Text('You have saved ${savedQuotes.length} quotes.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  } else {
    print('No saved quotes');


    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You have not saved any quotes yet.'),
          duration: const Duration(seconds: 3), // Optional: Adjust the duration
        ),
      );
    }
  }
}
