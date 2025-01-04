import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotDetailPage extends StatefulWidget {
  @override
  _ChatbotDetailPageState createState() => _ChatbotDetailPageState();
}

class _ChatbotDetailPageState extends State<ChatbotDetailPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = ''; // Store the response from the API

  // Function to call the chatbot API
  Future<void> _getChatbotResponse(String query) async {
    final url = Uri.parse('https://your-api-endpoint.com/chatbot'); // Replace with your API URL

    try {
      final response = await http.post(
        url,
        body: json.encode({'question': query}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _response = data['answer']; // Assuming the API returns the answer under 'answer' key
        });
      } else {
        setState(() {
          _response = 'Error: Unable to get response from the chatbot.';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chatbot Interface', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            // Text input field for the user to type their question
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ask me anything',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Button to submit the query
            ElevatedButton(
              onPressed: () {
                final query = _controller.text.trim();
                if (query.isNotEmpty) {
                  _getChatbotResponse(query);
                }
              },
              child: Text('Ask'),
            ),
            SizedBox(height: 20),
            // Display the chatbot's response
            Text(
              'Response: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _response.isEmpty
                ? Text('No response yet.')
                : Text(
                    _response,
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
