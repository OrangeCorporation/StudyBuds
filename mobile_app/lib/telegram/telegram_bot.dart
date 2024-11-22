import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot {
  static final String botToken = String.fromEnvironment('BOT_TOKEN', defaultValue: '7678057207:AAGLJ147MEXp2G8uujUnuPQQRoGRqvuKO70');

  static late final Telegram telegram = Telegram(botToken);

  static Future<void> getTelegramId() async {
    try {
      if (botToken.isEmpty) {
        print('------------------------------');
        throw Exception("Bot token not found in environment");
      }

      final me = await telegram.getMe();
      print('Bot info: $me');

      final username = me.username;

      var teledart = TeleDart(botToken, Event(username!));

      teledart.start();

      teledart.onCommand('start').listen((message) {
        final userId = message.from?.id;
        telegram.sendMessage(
          message.chat.id,
          'Welcome! Your Telegram ID is $userId.',
        );

        print('User ID: $userId');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> checkGroupExists(String groupLink) async {
    try {
      final groupUsername = groupLink.replaceAll('https://t.me/', '');
      print('------------------------------ $groupUsername');
      final chat = await telegram.getChat('@$groupUsername');
    } catch (e) {
      print('Error: Group does not exist or cannot be accessed error: $e');
    }
  }

  static Future<void> checkGroupMember(String groupLink) async {
    try {
      final groupUsername = groupLink.replaceAll('https://t.me/', '');
      print('------------------------------ $groupUsername');
      final chat = await telegram.getChatAdministrators('@$groupUsername');
      print('--------------$chat');
    } catch (e) {
      print('Error: Group does not exist or cannot be accessed error: $e');
    }
  }

  static Future<void> checkGroupMembetCnt(String groupLink) async {
    try {
      final groupUsername = groupLink.replaceAll('https://t.me/', '');
      print('------------------------------ $groupUsername');
      final chat = await telegram.getChatMemberCount('@$groupUsername');
      print('----------------------- $chat');
    } catch (e) {
      print('Error: Group does not exist or cannot be accessed error: $e');
    }
  }
}
