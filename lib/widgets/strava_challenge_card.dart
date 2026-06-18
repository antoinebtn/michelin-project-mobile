import 'package:flutter/material.dart';

class StravaChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge;

  const StravaChallengeCard({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isChallengeCompleted = challenge['isCompleted'] ?? false;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Icon(
            isChallengeCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isChallengeCompleted ? Colors.green : Colors.orange,
            size: 26,
          ),
          title: Text(
            challenge['title'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Text(
            challenge['statusText'] ?? '',
            style: TextStyle(
              fontSize: 11,
              color: isChallengeCompleted ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Text(
            "⭐ ${challenge['participantsCount']}\n RIDERS",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
