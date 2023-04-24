import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();

    // Connect to the socket server
    socket = IO.io('http://10.0.2.2:6001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Subscribe to the message event to receive messages from the socket server
    socket.on('message', (data) {
      setState(() {
        _messages.add(data);
      });
    });

    // Connect to the socket server
    socket.connect();
  }

  @override
  void dispose() {
    // Disconnect from the socket server
    socket.disconnect();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      // Send the message to the socket server
      socket.emit('message', message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage(_textController.text);
                    _textController.clear();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}