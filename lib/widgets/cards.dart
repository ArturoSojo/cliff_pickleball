import "package:flutter/material.dart";

class Cards extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget icon;
  final Color rgbColor;

  const Cards(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.rgbColor});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 130,
                height: 130,
                child: icon,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [title, subtitle],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios)
        ]);
  }
}
