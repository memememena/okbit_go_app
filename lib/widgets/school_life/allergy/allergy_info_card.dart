import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class AllergyInfoCard extends StatelessWidget {
  final VoidCallback onTap;

  const AllergyInfoCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kSpacing),
        margin: const EdgeInsets.only(bottom: kSpacing),
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '알레르기 정보',
              style: TextStyle(
                color: Colors.orange[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.info_outline,
              color: Colors.orange[400],
              size: kIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
