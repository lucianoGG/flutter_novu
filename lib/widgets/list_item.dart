import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novu/enums.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ListItem extends StatelessWidget {
  final bool disabled;
  final String title;
  final Function? onPress;
  final dynamic icon;
  final ListItemType? type;
  final String? subtitle;
  final EdgeInsets? padding;
  final dynamic value;
  final Function(dynamic)? onChange;
  final bool loading;
  final Widget? trailing;
  final Widget? leading;
  final TextStyle? titleStyle;
  final double iconSize;
  final Color? iconColor;
  final int subtitleMaxLines;
  //  contentPadding: EdgeInsets.symmetric(horizontal: 16),

  const ListItem(
      {super.key,
      this.disabled = false,
      required this.title,
      this.onPress,
      this.icon,
      this.type,
      this.subtitle,
      this.padding,
      this.trailing,
      this.leading,
      this.value,
      this.onChange,
      this.loading = false,
      this.titleStyle,
      this.iconColor,
      this.iconSize = 20.0,
      this.subtitleMaxLines = 1});

  Widget? buildTrailing(BuildContext context) {
    if (type == ListItemType.switching) {
      return SizedBox(
        height: 20,
        child: Transform.scale(
          scale: 0.7,
          child: Switch.adaptive(
            value: value == true,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (bool value) {
              if (onChange != null) {
                onChange!(value);
              }
            },
          ),
        ),
      );
    }
    if (type == ListItemType.navigation) {
      return Icon(
        Icons.adaptive.arrow_forward_sharp,
        color: Theme.of(context).colorScheme.secondary,
        size: iconSize,
      );
    }
    if (type == ListItemType.text && value != null) {
      return Text(value.toString());
    }
    return trailing;
  }

  Widget? buildLeading(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    }
    if (icon != null) {
      if (icon is Widget) {
        return icon;
      }
      // return ExtendedIcon(
      //     icon: icon,
      //     size: iconSize,
      //     color: iconColor ?? Theme.of(context).colorScheme.secondary);
    }
    if (type == ListItemType.color && value != null) {
      return Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(iconSize / 2),
          color: value,
        ),
      );
    }
    return leading;
  }

  void onTap(BuildContext context) {
    onPress!();
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      material: (context, _) => ListTile(
        onTap: () {
          onTap(context);
        },
        leading: buildLeading(context),
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: subtitleMaxLines,
              )
            : null,
        trailing: buildTrailing(context),
        contentPadding: padding,
      ),
      cupertino: (context, _) => CupertinoListTile(
        onTap: () {
          onTap(context);
        },
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: subtitleMaxLines)
            : null,
        leading: buildLeading(context),
        trailing: buildTrailing(context),
        padding: padding,
      ),
    );
  }
}
