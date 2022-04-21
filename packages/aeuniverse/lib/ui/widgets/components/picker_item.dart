/// SPDX-License-Identifier: AGPL-3.0-or-later

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:aeuniverse/appstate_container.dart';
import 'package:aeuniverse/ui/util/styles.dart';
import 'package:core/util/get_it_instance.dart';
import 'package:core/util/haptic_util.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class PickerItem {
  String label;
  String? description;
  String? icon;
  Color? iconColor;
  Object value;
  bool enabled;
  bool displayed;

  PickerItem(this.label, this.description, this.icon, this.iconColor,
      this.value, this.enabled,
      {this.displayed = true});
}

class PickerWidget extends StatefulWidget {
  final ValueChanged<PickerItem>? onSelected;
  final List<PickerItem>? pickerItems;
  final int selectedIndex;

  const PickerWidget(
      {Key? key, this.pickerItems, this.onSelected, this.selectedIndex = -1})
      : super(key: key);

  @override
  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          PickerItem pickerItem = widget.pickerItems![index];
          bool isItemSelected;
          if (selectedIndex != -1) {
            isItemSelected = index == selectedIndex;
          } else {
            isItemSelected = index == widget.selectedIndex;
          }
          if (widget.pickerItems![index].displayed) {
            return InkWell(
              onTap: () {
                if (widget.pickerItems![index].enabled) {
                  sl.get<HapticUtil>().feedback(FeedbackType.light);
                  selectedIndex = index;
                  widget.onSelected!(widget.pickerItems![index]);
                  setState(() {});
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isItemSelected
                          ? Colors.green
                          : StateContainer.of(context).curTheme.primary30!),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          pickerItem.icon == null
                              ? const SizedBox(
                                  width: 0,
                                  height: 24,
                                )
                              : Container(
                                  height: 24,
                                  child: widget.pickerItems![index].iconColor ==
                                          null
                                      ? Image.asset(pickerItem.icon!)
                                      : Image.asset(pickerItem.icon!,
                                          color:
                                              widget.pickerItems![index].enabled
                                                  ? widget.pickerItems![index]
                                                      .iconColor
                                                  : StateContainer.of(context)
                                                      .curTheme
                                                      .icon60),
                                ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(pickerItem.label,
                                style: widget.pickerItems![index].enabled
                                    ? AppStyles.textStyleSize14W600Primary(
                                        context)
                                    : AppStyles
                                        .textStyleSize14W600PrimaryDisabled(
                                            context)),
                          ),
                          isItemSelected
                              ? Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                )
                              : Container(),
                        ],
                      ),
                      if (pickerItem.description != null) SizedBox(height: 5),
                      if (pickerItem.description != null)
                        Text(
                          pickerItem.description!,
                          style: AppStyles.textStyleSize12W100Primary(context),
                        ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
        itemCount: widget.pickerItems!.length,
      ),
    );
  }
}