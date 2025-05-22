import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(RohstoffApp());

class RohstoffApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rohstoffpreise',
      theme: ThemeData.dark(),
      home: RohstoffListPage(),
    );
  }
}

class RohstoffListPage extends StatefulWidget {
  @override
  _RohstoffListPageState createState() => _RohstoffListPageState();
}

class _RohstoffListPageState extends State<RohstoffListPage> {
  Map<String, dynamic>? prices;

  @override
  void initState() {
    super.initState();
    fetchPrices();
  }

  Future<void> fetchPrices() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/rohstoffe'));
    if (response.statusCode == 200) {
      setState(() {
        prices = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rohstoffpreise')),
      body: prices == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: prices!.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value} USD'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChartPage(rohstoff: entry.key),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }
}

class ChartPage extends StatefulWidget {
  final String rohstoff;

  ChartPage({required this.rohstoff});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<Map<String, dynamic>> verlauf = [];

  @override
  void initState() {
    super.initState();
    fetchVerlauf();
  }

  Future<void> fetchVerlauf() async {
    final url = 'http://127.0.0.1:8000/api/rohstoffe/${widget.rohstoff}/verlauf?zeitraum=1y';
    final response = await http.get(Uri.parse('http://localhost:8000/api/rohstoffe'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        verlauf = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.rohstoff)),
      body: verlauf.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Chart kommt gleich – Daten sind da!"),
              // Hier später fl_chart integrieren
            ),
    );
  }
}