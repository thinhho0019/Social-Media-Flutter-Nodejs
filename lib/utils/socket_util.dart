
import 'package:appchat_socket/api/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:appchat_socket/utils/key_shared.dart';
import 'package:appchat_socket/utils/sharedpreference.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketUtil {
  static IO.Socket? socket;

  static void   connect() {
    // Kiểm tra xem socket đã được khởi tạo hay chưa
    try {
      if (socket == null) {
        socket = IO.io('${api.ipServer}', <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
        socket?.connect();
        // Lắng nghe sự kiện 'connection'
        socket?.on("message-notify", ((data) {
          print("socket_id: " + data);
        }));
        socket?.onConnect((_) {
          print('socket_id: ' + socket!.id.toString());
          // socket?.emit('join',sharedPreferences.getString(keyShared.IDUSER));
        });
        socket?.on(
            'disconnect',
            (_) => socket?.emit(
                'join', sharedPreferences.getString(keyShared.IDUSER)));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static void disconnect() {
    // Kiểm tra xem socket đã được khởi tạo hay chưa
    if (socket != null) {
      // Ngắt kết nối với server
      socket?.close();
      socket = null;
    }
  }

  static void joinRoom(String data) {
    socket?.emit('join', data);
  }
  static void updateNotifiUser(String token,String iduser){
    final data = {
      "token":token,
      "iduser":iduser
    };
    socket?.emit('updateNotifiUser',data);
  }
  static void requestOnline(data){
    socket?.emit('request_user_online', data);
  }
  static void receiveOnline(Function(dynamic data) onData){
    socket?.on('receive_user_online', onData);
  }
  static void outRoom(String data) {
    socket?.emit('out', data);
  }
  static void receive_verify_message_seen(Function(dynamic data) onData){
    socket?.on('receive_verify_message_seen', onData);
  }
  static void receive_verify_message_received(Function(dynamic data) onData){
    socket?.on('receive_verify_message_received', onData);
  }
  static void sendMessage(data) {
    // Kiểm tra xem socket đã được khởi tạo hay chưa
    if (socket != null) {
      socket?.emit('send_message', data);
    }
  }
   
  static void receiverTyping(Function(dynamic data) onData) {
    if (socket != null) {
      socket?.on('receiver_typing', onData);
    }
  }

  static void sendTyping(data) {
    if (socket != null) {
      socket?.emit('send_typing', data);
    }
  }

  static void cancelEventReceiver() {
    if (socket != null) {
      socket?.off('receive_message');
      print("off receiver message event");
      socket?.off('receiver_typing');
      print("off receiver typing event");
      socket?.off('receive_user_online');
      socket?.off('receive_verify_message_seen');
      socket?.off('receive_verify_message_received');
    }
  }
  static void cancelEventListenConversation(){
    if (socket != null) {
      socket?.off('receive_conversation');
    }
  }
  static void listenToMessage(Function(dynamic data) onData) {
    // Kiểm tra xem socket đã được khởi tạo hay chưa
    if (socket != null) {
      // Lắng nghe dữ liệu từ server
      socket?.on('receive_message', onData);
    }
  }
  static void listenToConversation(Function(dynamic data) onData) {
    // Kiểm tra xem socket đã được khởi tạo hay chưa
    if (socket != null) {
      // Lắng nghe dữ liệu từ server
      socket?.on('receive_conversation', onData);
    }
  }
}
