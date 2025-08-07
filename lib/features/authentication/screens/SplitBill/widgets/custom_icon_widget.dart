import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData;

    switch (iconName) {
      case 'restaurant':
        iconData = Icons.restaurant;
        break;
      case 'directions_car':
        iconData = Icons.directions_car;
        break;
      case 'home':
        iconData = Icons.home;
        break;
      case 'movie':
        iconData = Icons.movie;
        break;
      case 'shopping_bag':
        iconData = Icons.shopping_bag;
        break;
      case 'receipt_long':
        iconData = Icons.receipt_long;
        break;
      case 'attach_money':
        iconData = Icons.attach_money;
        break;
      case 'currency_rupee':
        iconData = Icons.currency_rupee;
        break;
      case 'camera_alt':
        iconData = Icons.camera_alt;
        break;
      case 'send':
        iconData = Icons.send;
        break;
      case 'account_balance_wallet':
        iconData = Icons.account_balance_wallet;
        break;
      case 'check_circle':
        iconData = Icons.check_circle;
        break;
      case 'trending_up':
        iconData = Icons.trending_up;
        break;
      case 'trending_down':
        iconData = Icons.trending_down;
        break;
      case 'done_all':
        iconData = Icons.done_all;
        break;
      case 'edit':
        iconData = Icons.edit;
        break;
      case 'note_add':
        iconData = Icons.note_add;
        break;
      case 'info_outline':
        iconData = Icons.info_outline;
        break;
      case 'delete_outline':
        iconData = Icons.delete_outline;
        break;
      case 'cancel':
        iconData = Icons.cancel;
        break;
      case 'photo_library':
        iconData = Icons.photo_library;
        break;
      case 'close':
        iconData = Icons.close;
        break;
      case 'analytics':
        iconData = Icons.analytics;
        break;
      case 'calendar_today':
        iconData = Icons.calendar_today;
        break;
      case 'download':
        iconData = Icons.download;
        break;
      default:
        iconData = Icons.error;
    }

    return Icon(iconData, color: color, size: size);
  }
}
