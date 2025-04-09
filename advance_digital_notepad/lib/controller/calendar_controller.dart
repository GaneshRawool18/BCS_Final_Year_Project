import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var showCalendar = false.obs;
  // Use a Map with normalized DateTime keys and List of tasks as values.
  var events = <DateTime, List>{}.obs;

  // Define a common date format used across your app.
  final DateFormat dateFormat = DateFormat('MM/dd/yyyy');

  void toggleCalendar() {
    showCalendar.value = !showCalendar.value;
  }

  void loadEvents(List tasks) {
    final Map<DateTime, List> tempEvents = {};
    for (var task in tasks) {
      try {
        // Parse the task's date using the consistent format MM/dd/yyyy
        final taskDate = dateFormat.parse(task.date);
        // Normalize the date to only include year, month, and day.
        final normalized = DateTime(taskDate.year, taskDate.month, taskDate.day);
        if (tempEvents[normalized] == null) {
          tempEvents[normalized] = [];
        }
        tempEvents[normalized]!.add(task);
      } catch (e) {
        print("Date parse error: ${task.date} - $e");
      }
    }
    events.value = tempEvents;
  }

  List getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return events[normalized] ?? [];
  }
}
