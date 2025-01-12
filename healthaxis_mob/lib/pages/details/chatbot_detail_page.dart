import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

enum MessageType {
  text,
  prescription,
  medicalReport,
  appointment
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final String? attachmentUrl;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.attachmentUrl,
    this.metadata,
  });
}

class MedicalChatbotPage extends StatefulWidget {
  @override
  _MedicalChatbotPageState createState() => _MedicalChatbotPageState();
}

class _MedicalChatbotPageState extends State<MedicalChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isAttachmentMenuOpen = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _uploadPrescription() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: Implement actual file upload to your server
        setState(() {
          _messages.add(ChatMessage(
            text: 'Prescription uploaded: ${image.path.split('/').last}',
            isUser: true,
            timestamp: DateTime.now(),
            type: MessageType.prescription,
            attachmentUrl: image.path,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading prescription: $e')),
      );
    }
  }

  Future<void> _uploadMedicalReport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        // TODO: Implement actual file upload to your server
        setState(() {
          _messages.add(ChatMessage(
            text: 'Medical report uploaded: ${result.files.first.name}',
            isUser: true,
            timestamp: DateTime.now(),
            type: MessageType.medicalReport,
            attachmentUrl: result.files.first.path,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading medical report: $e')),
      );
    }
  }

  Future<void> _scheduleAppointment() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Appointment requested for ${DateFormat('MMM d, yyyy').format(picked)} at ${time.format(context)}',
            isUser: true,
            timestamp: DateTime.now(),
            type: MessageType.appointment,
            metadata: {
              'appointmentDate': picked.toIso8601String(),
              'appointmentTime': '${time.hour}:${time.minute}',
            },
          ));
        });
        _scrollToBottom();
        // TODO: Implement appointment scheduling logic
      }
    }
  }

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
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
    _scrollToBottom();
  }

  void _handleError() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Sorry, I encountered an error. Please try again or contact support.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isLoading = false;
    });
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
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medical Assistant', style: TextStyle(color: Colors.white)),
          Text(
            'Online',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
      backgroundColor: Colors.blue[800],
      elevation: 2,
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.white),
          onPressed: _scheduleAppointment,
          tooltip: 'Schedule Appointment',
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              _messages.clear();
            });
          },
          tooltip: 'Clear Chat',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
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
        if (_isLoading) _buildLoadingIndicator(),
        if (_isAttachmentMenuOpen) _buildAttachmentMenu(),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Processing...'),
        ],
      ),
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentButton(
            icon: Icons.medical_services,
            label: 'Prescription',
            onTap: _uploadPrescription,
          ),
          _buildAttachmentButton(
            icon: Icons.description,
            label: 'Medical Report',
            onTap: _uploadMedicalReport,
          ),
          _buildAttachmentButton(
            icon: Icons.calendar_today,
            label: 'Schedule',
            onTap: _scheduleAppointment,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue[800]),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildBotAvatar(),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(message),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.type != MessageType.text)
                        _buildAttachmentIcon(message),
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue[800],
      child: Icon(Icons.medical_services, color: Colors.white, size: 20),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      child: Icon(Icons.person, color: Colors.grey[700], size: 20),
    );
  }

  Color _getBubbleColor(ChatMessage message) {
    if (message.isUser) {
      return Colors.blue[800]!;
    }
    switch (message.type) {
      case MessageType.prescription:
        return Colors.green[100]!;
      case MessageType.medicalReport:
        return Colors.orange[100]!;
      case MessageType.appointment:
        return Colors.purple[100]!;
      default:
        return Colors.white;
    }
  }

  Widget _buildAttachmentIcon(ChatMessage message) {
    IconData icon;
    String label;
    switch (message.type) {
      case MessageType.prescription:
        icon = Icons.medical_services;
        label = 'Prescription';
        break;
      case MessageType.medicalReport:
        icon = Icons.description;
        label = 'Medical Report';
        break;
      case MessageType.appointment:
        icon = Icons.calendar_today;
        label = 'Appointment';
        break;
      default:
        return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
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
          IconButton(
            icon: Icon(Icons.attach_file,
                color: _isAttachmentMenuOpen ? Colors.blue[800] : Colors.grey[600]),
            onPressed: () {
              setState(() {
                _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
              });
            },
          ),
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
            color: Colors.blue[800],
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}