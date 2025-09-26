import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/sun_function.dart';

// pastikan import ke kelas-kelas Anda (sesuaikan path)

void main() {
  final julianDay = JulianDay();
  final dynamicalTime = DynamicalTime();

  final sn = SunFunction();
  final mf = MathFunction();
  final mo = MoonFunction();
  // final ml = MoonLongitude();
  // final mb = MoonLatitude();
  // final md = MoonDistance();
  // final mo = MoonOtherFunc();

  // ===================
  // INPUT
  // ===================
  final String nmL = "Pelabuhanratu";
  final int blnH = 10;
  final int thnH = 1444;
  final double gLon = (106 + 33 / 60.0 + 27.8 / 3600.0);
  final double gLat = -(7 + 1 / 60.0 + 44.6 / 3600.0);
  final double tmZn = 7.0;
  final double elev = 52.685;
  final double pres = 1010.0;
  final double temp = 10.0;
  final int sdp = 0;
  final int tbhHari = 0;
  final int optional = 1; // 1 = Imkan Rukyat, 2 = Wujudul Hilal

  // ===================
  // PROSES
  // ===================
  final double jdNM = mo.geocentricConjunction(blnH, thnH, 0.0, "Ijtima");
  final double jdGS = sn.jdGhurubSyams(jdNM, gLat, gLon, elev, tmZn);
  final double jd = sn.jdGhurubSyams(jdNM + tbhHari, gLat, gLon, elev, tmZn);

  final double jamGS = double.parse(
    julianDay.jdkm(
      sn.jdGhurubSyams(jdNM + tbhHari, gLat, gLon, elev, tmZn),
      tmZn,
      "JAMDES",
    ),
  );

  double dltT = dynamicalTime.deltaT(jdNM.floorToDouble() + 0.5);
  double jdNM2 = mo.geocentricConjunction(blnH, thnH, dltT, "Ijtima");
  double jdNM3 = mo.topocentricConjunction(
    blnH,
    thnH,
    dltT,
    gLon,
    gLat,
    elev,
    "Ijtima",
  );
  double jdNM4 = mo.geocentricConjunction(blnH, thnH, dltT, "Bujur");
  double jdNM5 = mo.topocentricConjunction(
    blnH,
    thnH,
    dltT,
    gLon,
    gLat,
    elev,
    "Bujur",
  );

  final int tglM = int.parse(julianDay.jdkm(jd, tmZn, "TglM").toString());
  final int blnM = int.parse(julianDay.jdkm(jd, tmZn, "BlnM").toString());
  final int thnM = int.parse(julianDay.jdkm(jd, tmZn, "ThnM").toString());

  var mSet = mo.moonTransitRiseSet(
    tglM,
    blnM,
    thnM,
    gLon,
    gLat,
    elev,
    tmZn,
    "SET",
    2,
  );

  // ===================
  // OUTPUT
  // ===================
  print("Bulan Hijriah              : $blnH-$thnH");
  print("Lokasi                     : $nmL");
  print(
    "Garis Bujur                : ${mf.dddms(gLon, optResult: "BBBT", sdp: sdp, posNegSign: "")}",
  );
  print(
    "Garis Lintang              : ${mf.dddms2(gLat, optResult: "LULS", sdp: sdp, posNegSign: "")}",
  );

  print(
    "Ijtimak Geosentris         : ${julianDay.jdkm(jdNM2)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM2, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")}",
  );
  print("Pada Bujur                 : ${mf.dddms(jdNM4)}");
  print(
    "Ijtimak Toposentris        : ${julianDay.jdkm(jdNM3)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM3, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")}",
  );
  print("Pada Bujur                 : ${mf.dddms(jdNM5)}");

  print(
    "Ghurub Matahari            : ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: 0, posNegSign: "")}",
  );

  print("Ghurub Bulan               : ${mf.dhhms(double.parse(mSet))}");
}
