import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pack_mate/app/controllers/language_controller.dart';
import 'package:pack_mate/app/data/purchase_history_model.dart';
import 'package:pack_mate/app/modules/purchase_history/controllers/purchase_history_controller.dart';
import 'package:pack_mate/app/modules/purchase_history/views/widgets/card_components/purchase_history_formatters.dart';
import 'package:pack_mate/app/modules/purchase_history/views/widgets/card_components/purchase_history_info_row.dart';
import 'package:pack_mate/app/modules/purchase_history/views/widgets/card_components/purchase_history_pill.dart';
import 'package:pack_mate/app/modules/purchase_history/views/widgets/card_components/purchase_history_section_title.dart';
import 'package:pack_mate/app/modules/purchase_history/views/widgets/card_components/purchase_history_status_chip.dart';
import 'package:pack_mate/config/responsive_config.dart';

class PurchaseHistoryCard extends StatelessWidget {
  final PurchaseHistoryModel item;
  final ResponsiveConfig responsive;

  const PurchaseHistoryCard({
    super.key,
    required this.item,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    final controller = Get.find<PurchaseHistoryController>();

    return Obx(() {
      final langCode = languageController.currentLocale.value.languageCode;
      final snapshot = item.packageSnapshot;
      final isExpired = controller.isExpired(item);
      final isActive = controller.isCurrentlyActive(item);
      final isInactive = controller.isInactive(item);
      final isToggling = controller.togglingPurchaseId.value == item.purchaseId;
      final isExpanded = controller.expandedPurchaseIds.contains(
        item.purchaseId,
      );

      return Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.cardRadius),
          side: BorderSide(
            color: isActive
                ? Colors.green.shade300
                : isExpired
                    ? Colors.red.shade200
                    : Colors.grey.shade300,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (_) =>
                controller.toggleExpanded(item.purchaseId),
            tilePadding: EdgeInsets.symmetric(
              horizontal: responsive.cardPadding,
              vertical: 6,
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              responsive.cardPadding,
              0,
              responsive.cardPadding,
              responsive.cardPadding,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      snapshot?.nameByLocale(langCode) ?? item.packageId,
                      style: TextStyle(
                        fontSize: responsive.titleFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    PurchaseHistoryStatusChip(
                      isActive: isActive,
                      isInactive: isInactive,
                      isExpired: isExpired,
                      responsive: responsive,
                    ),
                  ],
                ),
                SizedBox(height: responsive.tinyGap),
                Text(
                  '${PurchaseHistoryFormatters.label(langCode, th: 'ราคา', en: 'Price')}: ${item.amount} ${item.currency}',
                  style: TextStyle(
                    fontSize: responsive.bodyFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: responsive.tinyGap),
                Text(
                  '${PurchaseHistoryFormatters.label(langCode, th: 'ซื้อเมื่อ', en: 'Purchased at')}: ${PurchaseHistoryFormatters.formatDateTime(item.purchasedAt, langCode)}',
                  style: TextStyle(fontSize: responsive.bodyFontSize),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                isExpanded
                    ? PurchaseHistoryFormatters.label(
                        langCode,
                        th: 'ซ่อนรายละเอียด',
                        en: 'Hide details',
                      )
                    : PurchaseHistoryFormatters.label(
                        langCode,
                        th: 'ดูรายละเอียดเพิ่มเติม',
                        en: 'View more details',
                      ),
                style: TextStyle(fontSize: responsive.bodyFontSize - 1),
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PurchaseHistoryPill(
                      text: isExpired
                          ? PurchaseHistoryFormatters.label(
                              langCode,
                              th: 'หมดอายุแล้ว',
                              en: 'Expired',
                            )
                          : isActive
                              ? PurchaseHistoryFormatters.label(
                                  langCode,
                                  th: 'กำลังใช้งาน',
                                  en: 'Currently active',
                                )
                              : PurchaseHistoryFormatters.label(
                                  langCode,
                                  th: 'ไม่ได้ใช้งาน',
                                  en: 'Inactive',
                                ),
                      color: isExpired
                          ? Colors.red.shade50
                          : isActive
                              ? Colors.green.shade50
                              : Colors.grey.shade200,
                    ),
                    PurchaseHistoryPill(
                      text:
                          '${PurchaseHistoryFormatters.label(langCode, th: 'วิธีชำระเงิน', en: 'Payment method')}: ${PurchaseHistoryFormatters.paymentMethodLabel(item.paymentMethod)}',
                      color: Colors.blue.shade50,
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.sectionGap),
              if ((snapshot?.descriptionByLocale(langCode) ?? '').isNotEmpty) ...[
                PurchaseHistorySectionTitle(
                  title: PurchaseHistoryFormatters.label(
                    langCode,
                    th: 'รายละเอียดแพ็กเกจ',
                    en: 'Package description',
                  ),
                  responsive: responsive,
                ),
                SizedBox(height: responsive.tinyGap),
                Text(
                  snapshot!.descriptionByLocale(langCode),
                  style: TextStyle(
                    fontSize: responsive.bodyFontSize,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: responsive.sectionGap),
              ],
              PurchaseHistorySectionTitle(
                title: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'ข้อมูลการชำระเงินและเวลา',
                  en: 'Payment and timeline details',
                ),
                responsive: responsive,
              ),
              SizedBox(height: responsive.tinyGap),
              PurchaseHistoryInfoRow(
                label: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'วันที่ซื้อ',
                  en: 'Purchased date/time',
                ),
                value: PurchaseHistoryFormatters.formatDateTime(
                  item.purchasedAt,
                  langCode,
                ),
                responsive: responsive,
              ),
              PurchaseHistoryInfoRow(
                label: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'วันที่ชำระเงิน',
                  en: 'Paid date/time',
                ),
                value: PurchaseHistoryFormatters.formatDateTime(
                  item.paidAt,
                  langCode,
                ),
                responsive: responsive,
              ),
              PurchaseHistoryInfoRow(
                label: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'ช่องทางชำระเงิน',
                  en: 'Payment channel',
                ),
                value: item.paymentChannel.isNotEmpty
                    ? PurchaseHistoryFormatters.paymentMethodLabel(
                        item.paymentChannel,
                      )
                    : item.paymentMethod.isNotEmpty
                        ? PurchaseHistoryFormatters.paymentMethodLabel(
                            item.paymentMethod,
                          )
                        : '-',
                responsive: responsive,
              ),
              PurchaseHistoryInfoRow(
                label: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'เลขอ้างอิง',
                  en: 'Payment reference',
                ),
                value:
                    item.paymentReference.isNotEmpty ? item.paymentReference : '-',
                responsive: responsive,
              ),
              PurchaseHistoryInfoRow(
                label: PurchaseHistoryFormatters.label(
                  langCode,
                  th: 'สถานะการชำระเงิน',
                  en: 'Payment status',
                ),
                value: item.paymentStatus.isNotEmpty
                    ? PurchaseHistoryFormatters.paymentStatusLabel(
                        item.paymentStatus,
                      )
                    : '-',
                responsive: responsive,
              ),
              if ((snapshot?.benefits ?? []).isNotEmpty) ...[
                SizedBox(height: responsive.sectionGap),
                PurchaseHistorySectionTitle(
                  title: PurchaseHistoryFormatters.label(
                    langCode,
                    th: 'สิทธิประโยชน์',
                    en: 'Benefits',
                  ),
                  responsive: responsive,
                ),
                SizedBox(height: responsive.tinyGap),
                ...snapshot!.benefits.map(
                  (benefit) => Padding(
                    padding: EdgeInsets.only(bottom: responsive.benefitGap),
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
                            color: Colors.green,
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
                  ),
                ),
              ],
              SizedBox(height: responsive.sectionGap),
              SizedBox(
                width: double.infinity,
                height: responsive.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: isExpired || isToggling
                      ? null
                      : () => controller.togglePackageStatus(item),
                  icon: isToggling
                      ? SizedBox(
                          width: responsive.loaderSize,
                          height: responsive.loaderSize,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          isActive
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                        ),
                  label: Text(
                    isExpired
                        ? 'package_expired'.tr
                        : isActive
                            ? 'set_inactive'.tr
                            : 'set_active'.tr,
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