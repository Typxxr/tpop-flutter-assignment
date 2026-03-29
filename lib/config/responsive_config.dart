class ResponsiveConfig {
  final int crossAxisCount;
  final double pagePadding;
  final double spacing;
  final double maxContentWidth;
  final double cardAspectRatio;
  final double cardPadding;
  final double cardRadius;
  final double titleFontSize;
  final double priceFontSize;
  final double labelFontSize;
  final double bodyFontSize;
  final double buttonFontSize;
  final double buttonHeight;
  final double buttonRadius;
  final double sectionGap;
  final double tinyGap;
  final double benefitGap;
  final double iconSize;
  final double iconTopPadding;
  final double iconTextGap;
  final double loaderSize;
  final int descriptionMaxLines;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const ResponsiveConfig({
    required this.crossAxisCount,
    required this.pagePadding,
    required this.spacing,
    required this.maxContentWidth,
    required this.cardAspectRatio,
    required this.cardPadding,
    required this.cardRadius,
    required this.titleFontSize,
    required this.priceFontSize,
    required this.labelFontSize,
    required this.bodyFontSize,
    required this.buttonFontSize,
    required this.buttonHeight,
    required this.buttonRadius,
    required this.sectionGap,
    required this.tinyGap,
    required this.benefitGap,
    required this.iconSize,
    required this.iconTopPadding,
    required this.iconTextGap,
    required this.loaderSize,
    required this.descriptionMaxLines,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  factory ResponsiveConfig.fromWidth(double width) {
    if (width >= 1100) {
      return const ResponsiveConfig(
        crossAxisCount: 3,
        pagePadding: 24,
        spacing: 20,
        maxContentWidth: 1200,
        cardAspectRatio: 0.92,
        cardPadding: 20,
        cardRadius: 20,
        titleFontSize: 22,
        priceFontSize: 28,
        labelFontSize: 16,
        bodyFontSize: 15,
        buttonFontSize: 16,
        buttonHeight: 50,
        buttonRadius: 14,
        sectionGap: 16,
        tinyGap: 6,
        benefitGap: 8,
        iconSize: 18,
        iconTopPadding: 2,
        iconTextGap: 8,
        loaderSize: 18,
        descriptionMaxLines: 3,
        isMobile: false,
        isTablet: false,
        isDesktop: true,
      );
    }

    if (width >= 768) {
      return const ResponsiveConfig(
        crossAxisCount: 2,
        pagePadding: 24,
        spacing: 20,
        maxContentWidth: 980,
        cardAspectRatio: 0.95,
        cardPadding: 20,
        cardRadius: 20,
        titleFontSize: 21,
        priceFontSize: 28,
        labelFontSize: 16,
        bodyFontSize: 15,
        buttonFontSize: 16,
        buttonHeight: 50,
        buttonRadius: 14,
        sectionGap: 16,
        tinyGap: 6,
        benefitGap: 8,
        iconSize: 18,
        iconTopPadding: 2,
        iconTextGap: 8,
        loaderSize: 18,
        descriptionMaxLines: 3,
        isMobile: false,
        isTablet: true,
        isDesktop: false,
      );
    }

    if (width >= 600) {
      return const ResponsiveConfig(
        crossAxisCount: 2,
        pagePadding: 16,
        spacing: 16,
        maxContentWidth: 760,
        cardAspectRatio: 0.84,
        cardPadding: 16,
        cardRadius: 18,
        titleFontSize: 18,
        priceFontSize: 24,
        labelFontSize: 15,
        bodyFontSize: 14,
        buttonFontSize: 15,
        buttonHeight: 46,
        buttonRadius: 12,
        sectionGap: 14,
        tinyGap: 6,
        benefitGap: 8,
        iconSize: 18,
        iconTopPadding: 2,
        iconTextGap: 8,
        loaderSize: 18,
        descriptionMaxLines: 3,
        isMobile: true,
        isTablet: false,
        isDesktop: false,
      );
    }

    return const ResponsiveConfig(
      crossAxisCount: 1,
      pagePadding: 16,
      spacing: 12,
      maxContentWidth: 560,
      cardAspectRatio: 0.98,
      cardPadding: 16,
      cardRadius: 18,
      titleFontSize: 18,
      priceFontSize: 24,
      labelFontSize: 15,
      bodyFontSize: 14,
      buttonFontSize: 15,
      buttonHeight: 46,
      buttonRadius: 12,
      sectionGap: 14,
      tinyGap: 6,
      benefitGap: 8,
      iconSize: 18,
      iconTopPadding: 2,
      iconTextGap: 8,
      loaderSize: 18,
      descriptionMaxLines: 4,
      isMobile: true,
      isTablet: false,
      isDesktop: false,
    );
  }
}