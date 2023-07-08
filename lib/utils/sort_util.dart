

import 'package:appchat_socket/models/conversasion_model.dart';
import 'package:appchat_socket/utils/format_time.dart';

class sortUtil {
  static List<conversasionModel> sortCoversation(List<conversasionModel> listCon){
    for (int i = 1; i < listCon.length; i++) {
    conversasionModel key = listCon[i];
    int j = i - 1;
    while (j >= 0 && 
    formatTime.diffConvertUtcToMinutes(listCon[j].messages[0]['created_at'])  
    > formatTime.diffConvertUtcToMinutes(key.messages[0]['created_at'])) {
      listCon[j + 1] = listCon[j];
      j--;
    }
    listCon[j + 1] = key;
  }
  return listCon;
  }
}