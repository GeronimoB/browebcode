class Sizes {
  static double width = 0;
  static double height = 0;

  static double padding = 10;
  static double boxSeparation = 5;

  static double boxSize = 50;
  static double bigButtonSize = 70;
  static double tileSmall = 20;
  static double tileMini = 18;
  static double tileMicro = 15;
  static double tileNormal = 20;
  static double tileMedium = 25;
  static double avatarSide = 27;
  static double tileBig = 30;
  static double tileHuge = 40;
  static double iconSide = 16;
  static double radius = 7;
  static double bullet = 8;
  static double icon = 32;

  static double initialLogoSide = 70;
  static double navigationHeight = 120;

  static double font02 = 36;
  static double font04 = 28;
  static double font06 = 18;
  static double font08 = 16;
  static double font10 = 14;
  static double font12 = 12;
  static double font14 = 10;
  static double font16 = 8;

  static void initSizes(double newWidth, double newHeight) {
    width = newWidth;
    height = newHeight;
    padding = width / 12;
    boxSeparation = padding / 2;
    boxSize = width / 3.6;
    bigButtonSize = width / 2.8;
    tileMicro = width / 18;
    tileMini = width / 14;
    tileSmall = width / 12;
    tileNormal = width / 10;
    tileMedium = width / 5.5;
    tileBig = width / 4.8;
    tileHuge = width / 3.6;
    avatarSide = width / 5.8;
    iconSide = width / 16;
    radius = boxSeparation / 2;
    bullet = boxSeparation;
    initialLogoSide = width / 2;
    navigationHeight = height / 6;
    icon = width / 5.2;
  }
}
