/* <!-- START LICENSE -->


Program Ini Di buat Oleh DEVELOPER Dari PERUSAHAAN GLOBAL CORPORATION 
Social Media: 

- Youtube: https://youtube.com/@Global_Corporation 
- Github: https://github.com/globalcorporation
- TELEGRAM: https://t.me/GLOBAL_CORP_ORG_BOT

Seluruh kode disini di buat 100% murni tanpa jiplak / mencuri kode lain jika ada akan ada link komment di baris code

Jika anda mau mengedit pastikan kredit ini tidak di hapus / di ganti!

Jika Program ini milik anda dari hasil beli jasa developer di (Global Corporation / apapun itu dari turunan itu jika ada kesalahan / bug / ingin update segera lapor ke sub)

Misal anda beli Beli source code di Slebew CORPORATION anda lapor dahulu di slebew jangan lapor di GLOBAL CORPORATION!

Jika ada kendala program ini (Pastikan sebelum deal project tidak ada negosiasi harga)
Karena jika ada negosiasi harga kemungkinan

1. Software Ada yang di kurangin
2. Informasi tidak lengkap
3. Bantuan Tidak Bisa remote / full time (Ada jeda)

Sebelum program ini sampai ke pembeli developer kami sudah melakukan testing

jadi sebelum nego kami sudah melakukan berbagai konsekuensi jika nego tidak sesuai ? 
Bukan maksud kami menipu itu karena harga yang sudah di kalkulasi + bantuan tiba tiba di potong akhirnya bantuan / software kadang tidak lengkap


<!-- END LICENSE --> */
// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';

import 'package:system_info_fetch/system_info_fetch.dart';
import 'package:whatsapp_client/whatsapp_client.dart';
import 'package:whatsapp_client/whatsapp_client/update_whatsapp_client.dart';

FutureOr<dynamic> updateMessage({
  required Map msg,
  required WhatsAppClient wa,
  required UpdateWhatsAppClient updateWhatsAppClient,
}) async {
  String caption = "";
  if (msg["caption"] is String) {
    caption = msg["caption"];
  }
  String text = "";
  if (msg["text"] is String) {
    text = msg["text"];
  }
  String caption_msg = "${text.trim()} ${caption.trim()}".trim();
  bool isOutgoing = false;
  if (msg["is_outgoing"] is bool) {
    isOutgoing = msg["is_outgoing"];
  }
  if (msg["chat"] is Map == false) {
    return null;
  }
  bool isAdmin = false;

  String chat_type = (msg["chat"]["type"] as String).replaceAll(RegExp(r"(super)", caseSensitive: false), "");
  if (chat_type.isEmpty) {
    return null;
  }
  Map msg_from = msg["from"];
  Map msg_chat = msg["chat"];

  String msg_id = (msg["id"] is String) ? (msg["id"] as String) : "";
  String from_id = msg["from"]["id"];
  String chat_id = msg["chat"]["id"];

  if (msg["chat"]["type"] is String == false) {
    msg["chat"]["type"] = "";
  }
  if (isOutgoing) {
    isAdmin = true;
  } else {}

  if (isAdmin == false) {
    return;
  } 

  if (RegExp(r"^((/)?start)", caseSensitive: false).hasMatch(caption_msg)) {
    return await wa.invoke(
      parameters: {"@type": "sendMessage", "chat_id": chat_id, "text": "Hai Saya robot"},
      whatsAppClientData: updateWhatsAppClient.whatsappClientData,
    );
  }
  if (RegExp(r"^((/)?ping)$", caseSensitive: false).hasMatch(caption_msg)) {
    Map res = await wa.invoke(
      parameters: {"@type": "sendMessage", "chat_id": chat_id, "text": "PONG"},
      whatsAppClientData: updateWhatsAppClient.whatsappClientData,
    );
 
    return res;
  }

  if (RegExp(r"^((/)?systeminfo|info|env|neofetch|pfetch)$", caseSensitive: false).hasMatch(caption_msg)) {
    return await wa.invoke(
      parameters: {
        "@type": "sendMessage",
        "chat_id": chat_id,
        "text": "SystemInfo: ${SystemInfoFetch.toMessage()}",
      },
      whatsAppClientData: updateWhatsAppClient.whatsappClientData,
    );
  }

  RegExp regExp_echo = RegExp(r"^((/)?(echo[ ]+)(.*))", caseSensitive: false);
  if (regExp_echo.hasMatch(caption_msg)) {
    return await wa.invoke(
      parameters: {
        "@type": "sendMessage",
        "chat_id": chat_id,
        "text": caption_msg.replaceAll(RegExp(r"^((/)?(echo[ ]+))", caseSensitive: false), ""),
      },
      whatsAppClientData: updateWhatsAppClient.whatsappClientData,
    );
  }
}
