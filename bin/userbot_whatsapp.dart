// ignore_for_file: non_constant_identifier_names

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
// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';

import 'package:alfred/alfred.dart';
import 'package:userbot_whatsapp/logger/logger.dart';
import 'package:userbot_whatsapp/userbot_whatsapp.dart';
import 'package:userbot_whatsapp/utils/qr.dart';
import 'package:whatsapp_client/whatsapp_client.dart';
import 'package:whatsapp_client/whatsapp_client/update_whatsapp_client.dart';
import 'package:whatsapp_client/whatsapp_client/whatsapp_client_data.dart';
import "package:path/path.dart" as path;

void main(List<String> args) async {
  logger.info("""
GENERAL FOSS USERBOT WHATSaPP

SCRIPT BY generalfoss
GITHUB: https://github.com/generalfoss/userbot_whatsapp
"""
      .trim());

  Alfred app = Alfred(
    logLevel: LogType.error,
  );

  int port = int.tryParse(Platform.environment["PORT"] ?? "") ?? 3000;
  String host = Platform.environment["HOST"] ?? "0.0.0.0";
  WhatsAppBotApiServer whatsAppBotApiServer = WhatsAppBotApiServer();

  await whatsAppBotApiServer.runWaBotApi(
    host: "0.0.0.0",
    is_print: false,
    wa_bot_api_port: 9990,
    force_install_script: false,
    is_delete_script_after_run: false,
  );

  WhatsAppClient wa = WhatsAppClient();
  wa.ensureInitialized(
    whatsAppClientBotApiOption: WhatsAppClientBotApiOption(
      tokenBot: "",
      whatsAppUrlWebhook: Uri.parse("http://$host:$port"),
      // urlWaBotApi: Uri.parse("http://0.0.0.0:9990"),
      alfred: app,
    ),
  );
  Directory directory_temp = Directory(path.join(Directory.current.path, "temp"));

  if (directory_temp.existsSync()) {
    await directory_temp.delete(
      recursive: true,
    );
  }

  await directory_temp.create(
    recursive: true,
  );

  wa.on(
    event_name: wa.event_update,
    onUpdate: (UpdateWhatsAppClient updateWhatsAppClient) async {
      Map update = updateWhatsAppClient.rawData;

      WhatsAppClientData whatsAppClientData = updateWhatsAppClient.whatsappClientData;

      if (update["@type"] == "updateAuthorizationState") {
        if (update["authorization_state"] is Map == false) {
          return;
        }
        if (update["authorization_state"]["@type"] == "authorizationStateWaitScanQr") {
          if (update["authorization_state"]["qr"] is String == false) {
            return;
          }
          String qr_data = update["authorization_state"]["qr"];
          Uint8List bytes = await qrEncodeToBytes(qr_data);

          if (directory_temp.existsSync() == false) {
            await directory_temp.create(
              recursive: true,
            );
          }
          File file = File(path.join(directory_temp.path, "auth.png"));
          await file.writeAsBytes(bytes);
          logger.info("Auth Qr Berhasil Di Buat Silahkan Scan Ya: ${path.relative(file.path, from: Directory.current.path)}");
        }
      }
      if (update["@type"] == "updateNewMessage") {
        if (update["message"] is Map == false) {
          return;
        }
        await updateMessage(
          msg: update["message"],
          wa: wa,
          updateWhatsAppClient: updateWhatsAppClient,
        );
      }
    },
    onError: (error, stackTrace) {},
  );

  var res = await wa.whatsAppBotApi.initIsolate(
    idClient: "user",
    isCreateclient: true,
  );

  var server = await app.listen(port, host);

  logger.success("SERVER ON: http://${server.address.host}:${server.port}");
}
