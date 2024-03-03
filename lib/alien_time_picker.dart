import 'package:flutter/material.dart';

import 'alien_datetime.dart';

class AlienTimePicker extends StatefulWidget {
  const AlienTimePicker({super.key, required this.initialDateTime});

  final AlienDateTime initialDateTime;

  @override
  State<AlienTimePicker> createState() => _AlienTimePickerState();
}

class _AlienTimePickerState extends State<AlienTimePicker> {
  late int currentHour = widget.initialDateTime.hour;
  late int currentMinutes = widget.initialDateTime.minute;

  final minuteController =
      PageController(viewportFraction: 0.44, initialPage: 4000);
  final hourController =
      PageController(viewportFraction: 0.44, initialPage: 4000);

  @override
  void dispose() {
    minuteController.dispose();
    hourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          IconButton(
            onPressed: () => Navigator.maybePop(context,
                AlienDateTime(1, 1, 1, currentHour, currentMinutes, 0)),
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                child: _buildSlider(
                  hourController,
                  widget.initialDateTime.hour,
                  AlienDateTime.hoursPerDay,
                  currentHour,
                  (hour) {
                    if (mounted) {
                      setState(() {
                        currentHour = hour;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: _buildSlider(
                  minuteController,
                  widget.initialDateTime.minute,
                  AlienDateTime.minutesPerHour,
                  currentMinutes,
                  (minute) {
                    if (mounted) {
                      setState(() {
                        currentMinutes = minute;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PageView _buildSlider(PageController controller, int initial, int max,
      int selected, void Function(int number) onSelected) {
    return PageView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        onSelected((index - 4000 + initial) % max);
      },
      itemBuilder: (context, index) {
        int minute = (index - 4000 + initial) % max;
        Color color = selected == minute
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor;
        return Container(
          alignment: Alignment.center,
          width: 50,
          child: Text(
            minute.toString().padLeft(2, '0'),
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: color),
          ),
        );
      },
    );
  }
}
