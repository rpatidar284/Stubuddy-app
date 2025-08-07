import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    Key? key,
    required this.iconName,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (iconName) {
      case 'assignment':
        iconData = Icons.assignment;
        break;
      case 'add':
        iconData = Icons.add;
        break;
      case 'lightbulb':
        iconData = Icons.lightbulb_outline;
        break;
      case 'check':
        iconData = Icons.check;
        break;
      case 'clear':
        iconData = Icons.clear;
        break;
      case 'search':
        iconData = Icons.search;
        break;
      case 'filter_list':
        iconData = Icons.filter_list;
        break;
      case 'arrow_back':
        iconData = Icons.arrow_back;
        break;
      case 'close':
        iconData = Icons.close;
        break;
      case 'delete':
        iconData = Icons.delete;
        break;
      case 'radio_button_unchecked':
        iconData = Icons.radio_button_unchecked;
        break;
      case 'check_circle':
        iconData = Icons.check_circle;
        break;
      case 'priority_high':
        iconData = Icons.priority_high;
        break;
      case 'today':
        iconData = Icons.today;
        break;
      case 'warning':
        iconData = Icons.warning;
        break;
      case 'schedule':
        iconData = Icons.schedule;
        break;
      case 'flag':
        iconData = Icons.flag;
        break;
      case 'access_time':
        iconData = Icons.access_time;
        break;
      case 'sort_by_alpha':
        iconData = Icons.sort_by_alpha;
        break;
      case 'list':
        iconData = Icons.list;
        break;
      case 'calendar_today':
        iconData = Icons.calendar_today;
        break;
      case 'edit':
        iconData = Icons.edit;
        break;
      case 'copy':
        iconData = Icons.copy;
        break;
      case 'notifications_active':
        iconData = Icons.notifications_active;
        break;
      default:
        iconData = Icons.error; // Fallback icon
    }
    return Icon(iconData, color: color, size: size);
  }
}
