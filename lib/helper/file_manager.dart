import 'package:shared_preferences/shared_preferences.dart';

// ========== Main parameters to save permanently =========
//        [NAME]          -->          [Unique ID]
// --------------------------------------------------------
// [Scanning delay]       -->          scan_delay
// [Supervisor Password]  -->          supervisor_password
// [Machine Line List]    -->          machine_line
// [Shift List]           -->          shift_list
// [Last Update]          -->          last_update
// [QNE IP Address]       -->          qne_ip_address
// [QNE Port Number]      -->          qne_port_number
// [Counter IP Address]   -->          counter_ip_address
// [Counter Port Number]  -->          counter_port_number
// [Company Name]         -->          company_name
// [Device Name]          -->          device_name
// [Location]             -->          location
// [Document Prefix]      -->          doc_prefix
// [Activation Status]    -->          my_activation_status
// [Stock Length]         -->          stock_length



class FileManager {
  static get context => null;
  // =============== Maintenance Settings ==================
  
  static Future saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future saveInteger(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future saveList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    if(value == null) {
      return '';
    }
    return value;
  }

  static Future<int> readInteger(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(key);
    if(value == null) {
      return 0;
    }
    return value;
  }

  static Future<List<String>> readStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? value = prefs.getStringList(key);
    if(value == null) {
      return [];
    }
    return value;
  }
}
