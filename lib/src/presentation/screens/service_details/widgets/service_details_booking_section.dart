import 'package:flutter/material.dart';

class ServiceDetailsBookingSection extends StatelessWidget {
  final int selectedDateIndex;
  final ValueChanged<int> onDateSelected;
  final String selectedTime;
  final ValueChanged<String> onTimeSelected;
  final List<String> timeSlots;
  final int numberOfSessions;
  final ValueChanged<int> onSessionChanged;

  const ServiceDetailsBookingSection({
    super.key,
    required this.selectedDateIndex,
    required this.onDateSelected,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.timeSlots,
    required this.numberOfSessions,
    required this.onSessionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Your Cleaning',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _DateSelector(
            selectedDateIndex: selectedDateIndex,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 24),
          _TimeSelector(
            selectedTime: selectedTime,
            onTimeSelected: onTimeSelected,
            timeSlots: timeSlots,
          ),
          const SizedBox(height: 24),
          _SessionCounter(
            numberOfSessions: numberOfSessions,
            onSessionChanged: onSessionChanged,
          ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final int selectedDateIndex;
  final ValueChanged<int> onDateSelected;
  const _DateSelector({
    required this.selectedDateIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Color(0xFF6366F1),
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              'June 2025',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Calendar(
          selectedDateIndex: selectedDateIndex,
          onDateSelected: onDateSelected,
        ),
      ],
    );
  }
}

class _Calendar extends StatelessWidget {
  final int selectedDateIndex;
  final ValueChanged<int> onDateSelected;
  const _Calendar({
    required this.selectedDateIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (day) => SizedBox(
                    width: 30,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            5,
            (weekIndex) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (dayIndex) {
                  int day = (weekIndex * 7) + dayIndex + 1;
                  if (day > 31) return const SizedBox(width: 30);

                  bool isSelected = day == (selectedDateIndex + 1);
                  bool isToday = day == 14;

                  return GestureDetector(
                    onTap: () => onDateSelected(day - 1),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : isToday
                            ? Colors.grey[200]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String> onTimeSelected;
  final List<String> timeSlots;
  const _TimeSelector({
    required this.selectedTime,
    required this.onTimeSelected,
    required this.timeSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.access_time,
                color: Color(0xFF6366F1),
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: timeSlots.map((time) {
            bool isSelected = time == selectedTime;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTimeSelected(time),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SessionCounter extends StatelessWidget {
  final int numberOfSessions;
  final ValueChanged<int> onSessionChanged;
  const _SessionCounter({
    required this.numberOfSessions,
    required this.onSessionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of sessions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (numberOfSessions > 1) {
                  onSessionChanged(numberOfSessions - 1);
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Icon(Icons.remove, color: Colors.grey, size: 20),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              numberOfSessions.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                onSessionChanged(numberOfSessions + 1);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
