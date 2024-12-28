import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onTapAction;

  const SectionTitle({
    Key? key,
    required this.title,
    this.actionText,
    this.onTapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (actionText != null && onTapAction != null)
            GestureDetector(
              onTap: onTapAction,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 159, 191),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Color.fromARGB(255, 255, 176, 202)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const OrderStatusCard({super.key, 
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // This makes the card clickable
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
