import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotDetailPage extends StatefulWidget {
  @override
  _ChatbotDetailPageState createState() => _ChatbotDetailPageState();
}

class _ChatbotDetailPageState extends State<ChatbotDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  Future<void> _getChatbotResponse(String query) async {
    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(
        text: query,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    final url = Uri.parse('https://your-api-endpoint.com/chatbot');
    try {
      final response = await http.post(
        url,
        body: json.encode({'question': query}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add(ChatMessage(
            text: data['answer'],
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Sorry, I encountered an error. Please try again.',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Thinking...'),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.android, color: Colors.white),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[700]),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          SizedBox(width: 8),
          MaterialButton(
            onPressed: () {
              final query = _controller.text.trim();
              if (query.isNotEmpty) {
                _getChatbotResponse(query);
                _controller.clear();
              }
            },
            color: Theme.of(context).primaryColor,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}