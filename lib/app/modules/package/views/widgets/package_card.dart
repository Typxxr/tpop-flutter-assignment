import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/app/data/package_model.dart';
import 'package:pack_mate/config/responsive_config.dart';

import '../../controllers/package_controller.dart';

class PackageCard extends StatelessWidget {
  final PackageModel item;
  final ResponsiveConfig responsive;

  const PackageCard({
    super.key,
    required this.item,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    final controller = Get.find<PackageController>();

    return Obx(() {
      final langCode = languageController.currentLocale.value.languageCode;
      final isBuying = controller.buyingPackageId.value == item.docId;

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.cardRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nameByLocale(langCode),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: responsive.titleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: responsive.sectionGap),
              Text(
                '${item.price} ${item.currency}',
                style: TextStyle(
                  fontSize: responsive.priceFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.tinyGap),
              Text(
                '${'duration'.tr}: ${item.durationDays} ${'days'.tr}',
                style: TextStyle(fontSize: responsive.bodyFontSize),
              ),
              SizedBox(height: responsive.sectionGap),
              Text(
                'description'.tr,
                style: TextStyle(
                  fontSize: responsive.labelFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.tinyGap),
              Text(
                item.descriptionByLocale(langCode),
                maxLines: responsive.descriptionMaxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: responsive.bodyFontSize,
                  height: 1.35,
                ),
              ),
              SizedBox(height: responsive.sectionGap),
              Text(
                'benefits'.tr,
                style: TextStyle(
                  fontSize: responsive.labelFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.tinyGap),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: item.benefits.map((benefit) {
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: responsive.benefitGap),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: responsive.iconTopPadding,
                              ),
                              child: Icon(
                                Icons.check_circle,
                                size: responsive.iconSize,
                              ),
                            ),
                            SizedBox(width: responsive.iconTextGap),
                            Expanded(
                              child: Text(
                                benefit.byLocale(langCode),
                                style: TextStyle(
                                  fontSize: responsive.bodyFontSize,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: responsive.sectionGap),
              SizedBox(
                width: double.infinity,
                height: responsive.buttonHeight,
                child: ElevatedButton(
                  onPressed: isBuying ? null : () => controller.onTapBuy(item),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(responsive.buttonRadius),
                    ),
                  ),
                  child: isBuying
                      ? SizedBox(
                          width: responsive.loaderSize,
                          height: responsive.loaderSize,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'buy_now'.tr,
                          style: TextStyle(
                            fontSize: responsive.buttonFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}