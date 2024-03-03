import 'package:alienclock/alien_datetime.dart';
import 'package:flutter/material.dart';

class AlienDateTimePicker extends StatefulWidget {
  const AlienDateTimePicker({super.key, required this.initialDateTime});

  final AlienDateTime initialDateTime;

  @override
  State<AlienDateTimePicker> createState() => _AlienDateTimePickerState();
}

class _AlienDateTimePickerState extends State<AlienDateTimePicker> {
  late int currentYear = widget.initialDateTime.year;
  late int currentMonth = widget.initialDateTime.month;
  late AlienDateTime selectedDateTime = widget.initialDateTime;

  //set high initialPage to enable scroll both direction
  final PageController controller = PageController(initialPage: 300);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const CloseButton(),
        title: Text('$currentYear-${currentMonth.toString().padLeft(2, '0')}'),
        actions: [
          IconButton(
            onPressed: () => Navigator.maybePop(context, selectedDateTime),
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: PageView.builder(
        controller: controller,
        onPageChanged: (_) => setState(() {}),
        itemBuilder: (context, index) {
          int realIndex = index - 300;
          currentMonth = (widget.initialDateTime.month + realIndex - 1) %
                  AlienDateTime.daysInMonth.length +
              1;

          int monthDiff = realIndex + widget.initialDateTime.month;
          int yearDiff = 0;
          if (monthDiff < 1) {
            yearDiff = monthDiff ~/ AlienDateTime.daysInMonth.length - 1;
          } else if (monthDiff > 18) {
            yearDiff = monthDiff ~/ AlienDateTime.daysInMonth.length;
          }
          currentYear = widget.initialDateTime.year + yearDiff;

          return _buildCalendar(context);
        },
      ),
    );
  }

  GridView _buildCalendar(BuildContext context) {
    AlienDateTime firstDayCurrentMonth =
        AlienDateTime(currentYear, currentMonth, 1, 0, 0, 0);
    int startingDayIndex =
        firstDayCurrentMonth.daysSinceEpoch % AlienDateTime.daysInWeek.length;

    return GridView.count(
      padding: const EdgeInsets.all(15),
      crossAxisCount: AlienDateTime.daysInWeek.length,
      children: [
        ...AlienDateTime.daysInWeek.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).disabledColor)),
          );
        }),
        ...List.generate(
          AlienDateTime.daysInMonth[currentMonth - 1] + startingDayIndex,
          (n) {
            if (n < startingDayIndex) return const SizedBox();
            int currentDay = n + 1 - startingDayIndex;
            AlienDateTime currentDate =
                AlienDateTime(currentYear, currentMonth, currentDay, 0, 0, 0);
            bool isSelected = currentDate.isSameDate(selectedDateTime);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDateTime = currentDate;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: isSelected ? Theme.of(context).primaryColor : null),
                child: Text(
                  '$currentDay',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColorLight
                          : null),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
