import 'dart:async';

import 'package:alienclock/alien_datetime.dart';
import 'package:alienclock/alien_datetime_picker.dart';
import 'package:flutter/material.dart';

import 'alien_time_picker.dart';

class AlienClock extends StatefulWidget {
  const AlienClock({super.key});

  @override
  State<AlienClock> createState() => _AlienClockState();
}

class _AlienClockState extends State<AlienClock> {
  AlienDateTime alienDateTime = AlienDateTime.fromDateTime(DateTime.now());
  DateTime dateTime = DateTime.now();
  DateTime dateTimeSet = DateTime.now();

  DateTime anchorDateTime = DateTime.now();

  late Timer clockTick;

  @override
  void initState() {
    super.initState();
    clockTick = Timer.periodic(
        const Duration(
          milliseconds: AlienDateTime.alienToEarthMilliSecondsRatio,
        ), (_) {
      if (mounted) {
        setState(() {
          dateTime = dateTimeSet.add(DateTime.now().difference(anchorDateTime));
          alienDateTime = AlienDateTime.fromDateTime(dateTime);
        });
      }
    });
  }

  @override
  void dispose() {
    clockTick.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    var selectedDate = await Navigator.push<AlienDateTime>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlienDateTimePicker(
                          initialDateTime: alienDateTime,
                        ),
                      ),
                    );
                    if (selectedDate != null && mounted) {
                      setState(() {
                        anchorDateTime = DateTime.now();
                        dateTimeSet = DateTime.fromMillisecondsSinceEpoch(
                            selectedDate
                                    .addTime(alienDateTime)
                                    .secondsSinceEpoch *
                                AlienDateTime.alienToEarthMilliSecondsRatio);
                      });
                    }
                  },
                  child: Text(
                    alienDateTime.formattedDate(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
                Text(' ' * 3),
                GestureDetector(
                  onTap: () async {
                    var selectedDate = await Navigator.push<AlienDateTime>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlienTimePicker(
                          initialDateTime: alienDateTime,
                        ),
                      ),
                    );
                    if (selectedDate != null && mounted) {
                      setState(() {
                        anchorDateTime = DateTime.now();
                        dateTimeSet = DateTime.fromMillisecondsSinceEpoch(
                            alienDateTime
                                    .addTime(selectedDate)
                                    .secondsSinceEpoch *
                                AlienDateTime.alienToEarthMilliSecondsRatio);
                      });
                    }
                  },
                  child: Text(
                    alienDateTime.formattedTime(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            Text(
              dateTime.toString().substring(0, dateTime.toString().length - 4),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
