import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'allergy_section.dart';

class AllergyInfoDialog extends StatelessWidget {
  const AllergyInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * kDialogMaxHeightFactor,
        ),
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: kBorderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(kDialogPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._buildAllergySections(),
                      const SizedBox(height: kSpacing),
                      _buildNote(),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(kDialogPadding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange[400],
            size: kDialogIconSize,
          ),
          const SizedBox(width: kSmallSpacing),
          const Text(
            '알레르기 정보',
            style: TextStyle(
              color: Colors.white,
              fontSize: kDialogTitleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllergySections() {
    return kAllergyCategories.entries.map((entry) {
      return Column(
        children: [
          AllergySection(
            title: entry.key,
            items: entry.value,
            color: kAllergyCategoryColors[entry.key]![400]!,
          ),
          const SizedBox(height: kSpacing),
        ],
      );
    }).toList();
  }

  Widget _buildNote() {
    return Text(
      '* 조개류는 굴, 전복, 홍합을 포함합니다.',
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDialogPadding,
        vertical: kSmallSpacing,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
