import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/dimensions.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({Key? key}) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _prescriptionFile;
  final List<ChatMessage> _messages = [];

  // Hardcoded patient details
  final Map<String, String> patientDetails = {
    'name': 'Anjali Mehta',
    'age': '28',
    'bloodGroup': 'B+',
    'lastVisit': '15 Dec 2024',
    'upcomingAppointment': '25 Jan 2025',
  };

  // Simulated chatbot response
  void _handleMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: true,
      ));
      
      // Simulate bot response
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          String botResponse = _getBotResponse(message.toLowerCase());
          _messages.add(ChatMessage(
            message: botResponse,
            isUser: false,
          ));
          _scrollToBottom();
        });
      });
    });
    _messageController.clear();
  }

  String _getBotResponse(String message) {
    if (message.contains('headache')) {
      return "Based on your symptoms, you might be experiencing tension headache. I recommend:\n\n1. Rest in a quiet, dark room\n2. Stay hydrated\n3. Try over-the-counter pain relievers\n\nIf symptoms persist for more than 48 hours, please schedule an appointment.";
    } else if (message.contains('fever')) {
      return "I understand you're having fever. Please:\n\n1. Monitor your temperature\n2. Stay hydrated\n3. Take rest\n\nIf temperature exceeds 102°F or persists for more than 24 hours, immediate medical attention is recommended.";
    }
    return "I'm here to help! Please describe your symptoms in detail so I can provide better assistance. For serious medical concerns, please schedule an appointment immediately.";
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickPrescriptionFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _prescriptionFile = File(result.files.single.path!);
      });
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription uploaded successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Diagnosis & Consultation', style: AppTextStyles.headline2),
        backgroundColor: AppColors.primary,
        elevation: AppDimensions.elevationSmall,
      ),
      body: Column(
        children: [
          // Patient Information Card
          Card(
            margin: EdgeInsets.all(AppDimensions.spacing16),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          patientDetails['name']!.substring(0, 2),
                          style: AppTextStyles.headline2.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientDetails['name']!,
                              style: AppTextStyles.subtitle1,
                            ),
                            SizedBox(height: AppDimensions.spacing4),
                            Text(
                              'Age: ${patientDetails['age']} • Blood Group: ${patientDetails['bloodGroup']}',
                              style: AppTextStyles.body2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        'Last Visit',
                        patientDetails['lastVisit']!,
                        Icons.history,
                      ),
                      _buildInfoCard(
                        'Next Appointment',
                        patientDetails['upcomingAppointment']!,
                        Icons.calendar_today,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Prescription Upload Section
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing8,
            ),
            child: ListTile(
              leading: Icon(Icons.upload_file, color: AppColors.primary),
              title: Text('Upload Prescription', style: AppTextStyles.body1),
              subtitle: Text(
                _prescriptionFile?.path.split('/').last ?? 'No file selected',
                style: AppTextStyles.body2,
              ),
              trailing: ElevatedButton(
                onPressed: _pickPrescriptionFile,
                child: Text('Upload'),
              ),
            ),
          ),

          // Chat Section
          Expanded(
            child: Card(
              margin: EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing8),
                    child: Text(
                      'AI Health Assistant',
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Divider(color: AppColors.divider),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _ChatBubble(message: message);
                      },
                    ),
                  ),
                  Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Describe your symptoms...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing16,
                                vertical: AppDimensions.spacing8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        IconButton(
                          icon: Icon(Icons.send),
                          color: AppColors.primary,
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              _handleMessage(_messageController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMedium,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(height: AppDimensions.spacing4),
          Text(title, style: AppTextStyles.caption),
          SizedBox(height: AppDimensions.spacing2),
          Text(value, style: AppTextStyles.body2),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({
    required this.message,
    required this.isUser,
  });
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppDimensions.spacing8,
          horizontal: AppDimensions.spacing4,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surfaceMedium,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.message,
          style: AppTextStyles.body1.copyWith(
            color: message.isUser ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}