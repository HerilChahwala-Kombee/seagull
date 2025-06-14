import 'dart:async';

import 'package:flutter/material.dart';

class CircularProgressTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onComplete;

  const CircularProgressTimer({Key? key, required this.duration, required this.onComplete}) : super(key: key);

  @override
  _CircularProgressTimerState createState() => _CircularProgressTimerState();
}

class _CircularProgressTimerState extends State<CircularProgressTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _startTimer();
    _controller.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _controller.value,
                  strokeWidth: 3,
                  backgroundColor: Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                );
              },
            ),
          ),
          Text(
            '${_remainingSeconds}s',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
          ),
        ],
      ),
    );
  }
}
