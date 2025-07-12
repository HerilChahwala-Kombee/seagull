import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seagull/src/presentation/screens/booking_confirmation/state/booking_providers.dart';

class SpecialInstructionsSection extends ConsumerStatefulWidget {
  const SpecialInstructionsSection({super.key});

  @override
  ConsumerState<SpecialInstructionsSection> createState() => _SpecialInstructionsSectionState();
}

class _SpecialInstructionsSectionState extends ConsumerState<SpecialInstructionsSection> {
  final TextEditingController _controller = TextEditingController();
  static const int maxLength = 200;

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(bookingProvider).specialInstructions;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Instructions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2E5266)),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLines: 4,
                maxLength: maxLength,
                decoration: const InputDecoration(
                  hintText: 'Add any special requirements or notes for the service provider...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
                onChanged: (value) {
                  ref.read(bookingProvider.notifier).updateSpecialInstructions(value);
                },
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.visibility, size: 16, color: Color(0xFF666666)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Your cleaner will see these instructions before arrival',
                        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      ),
                    ),
                    Text(
                      '${_controller.text.length}/$maxLength',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
