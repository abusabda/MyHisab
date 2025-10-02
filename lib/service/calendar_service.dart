import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_distance.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/moon_latitude.dart';
import 'package:myhisab/core/moon_longitude.dart';
import 'package:myhisab/core/sun_function.dart';

void main() {
  final julianDay = JulianDay();
  final dynamicalTime = DynamicalTime();

  final sn = SunFunction();
  final mf = MathFunction();
  final ml = MoonLongitude();
  final mb = MoonLatitude();
  final md = MoonDistance();
  final mo = MoonFunction();

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
  final int sdp = 2;
  final int tbhHari = 0;
  final int optional = 1; // 1 = Imkan Rukyat, 2 = Wujudul Hilal

  String getZonaWaktu(double tmZn) {
    switch (tmZn) {
      case 7:
        return "WIB";
      case 8:
        return "WITA";
      case 9:
        return "WIT";
      default:
        return "LCT";
    }
  }

  final wd = getZonaWaktu(tmZn);

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

  double jdMSet;

  if (mSet == 0.0) {
    jdMSet = 0.0;
  } else {
    jdMSet = julianDay.kmjd(tglM, blnM, thnM, 0.0, 0.0) + (mSet - tmZn) / 24.0;
  }

  final double bTime = jamGS + 4 / 9.0 * ((jdMSet - jd) * 24.0);

  final gCw =
      (mo.moonGeocentricSemidiameter(jd, dltT)) *
      (1 - math.cos(mf.rad(mo.moonSunGeocentricElongation(jd, dltT))));

  final tCw =
      (mo.moonTopocentricSemidiameter(jd, dltT, gLon, gLat, elev)) *
      (1 -
          math.cos(
            mf.rad(mo.moonSunTopocentricElongation(jd, dltT, gLon, gLat, elev)),
          ));

  final relAltGeo =
      mo.moonGeocentricAltitude(jd, dltT, gLon, gLat) +
      (sn.sunGeocentricAltitude(jd, dltT, gLon, gLat)).abs();

  final sunAltTopo = sn.sunTopocentricAltitude(
    jd,
    dltT,
    gLon,
    gLat,
    elev,
    pres,
    temp,
    "ht",
  );

  final moonAltTopo = mo.moonTopocentricAltitude(
    jd,
    dltT,
    gLon,
    gLat,
    elev,
    pres,
    temp,
    "htc",
  );

  final relAltTop = moonAltTopo + sunAltTopo.abs();

  final qOdeh =
      relAltTop -
      (-0.1018 * math.pow((tCw * 60), 3.0) +
          0.7319 * math.pow((tCw * 60), 2.0) -
          6.3226 * (tCw * 60) +
          7.1651);

  //Tinggi Hilal dan Elongasi
  final double tHilal1 = mo.moonGeocentricAltitude(jdGS, dltT, gLon, gLat);
  final double elong01 = mo.moonSunGeocentricElongation(jdGS, dltT);

  final double tHilal2 = mo.moonGeocentricAltitude(
    jd,
    dltT,
    gLon,
    gLat,
  ); // JD Ijtimak Tambah hari

  final double elong02 = mo.moonSunGeocentricElongation(
    jd,
    dltT,
  ); // JD Ijtimak Tambah hari

  // Kesimpulan Kriteria awal Bulan
  late double abq;
  late int iR01;
  late String iRP1;
  late String iRP2;
  late int wH01;
  late String wHM1;
  late String wHM2;
  late String visb;
  late String wh;
  late String kr;
  late String kr1;

  // Imkan Rukyat PERSIS & Pemerintah
  if (tHilal1 >= 3.0 && elong01 >= 6.4) {
    iR01 = 1; // masuk awal bulan
    iRP1 = "Visible"; // Bisa terlihat
  } else {
    iR01 = 2; // Belum masuk awal bulan
    iRP1 = "Not Visible"; // belum bisa terlihat
  }

  iRP2 = (tHilal2 >= 3.0 && elong02 >= 6.4) ? "Visible" : "Not Visible";

  // Wujudul Hilal Muhammadiyah
  if (tHilal1 > 0.0) {
    wH01 = 1; // masuk awal bulan
    wHM1 = "Wujud"; // sudah wujud
  } else {
    wH01 = 2; // belum masuk awal bulan
    wHM1 = "Belum Wujud"; // belum wujud
  }

  wHM2 = (tHilal2 > 0.0) ? "Wujud" : "Belum Wujud";

  // Tambah Hari
  if (tbhHari == 0) {
    visb = iRP1;
    wh = wHM1;
  } else {
    visb = iRP2;
    wh = wHM2;
  }

  // Tampilkan pilihan Kriteria dan hasil akhir kriteria
  if (optional == 1) {
    // pilihan imkan rukyat
    abq = ((jdNM2 + 0.5 + tmZn / 24.0).floor() - tmZn / 24.0) + iR01;
    kr = visb;
    kr1 = "Imkan Rukyat";
  } else {
    // pilihan wujudul hilal
    abq = ((jdNM2 + 0.5 + tmZn / 24.0).floor() - tmZn / 24.0) + wH01;
    kr = wh;
    kr1 = "Wujudul Hilal";
  }

  // Nama Bulan Hijriyah
  final nmBlnHDt = [
    "Al-Muharram",
    "Shafar",
    "Rabiul Awwal",
    "Rabiul Akhir",
    "Jumadal Ula",
    "Jumadal Akhirah",
    "Rajab",
    "Syaban",
    "Ramadhan",
    "Syawwal",
    "Zulqadah",
    "Zulhijjah",
  ];
  final nmBlnH = nmBlnHDt[blnH - 1];

  // ===================
  // OUTPUT
  // ===================
  print("Perhitungan Awal Bulan           : $nmBlnH $thnH H");
  print("Lokasi                           : $nmL");
  print(
    "Koordinat                        : ${mf.dddms(gLon, optResult: "BBBT", sdp: sdp, posNegSign: "+-")} | ${mf.dddms2(gLat, optResult: "LULS", sdp: sdp, posNegSign: "")}",
  );
  print("Elevasi                          : ${elev.toStringAsFixed(3)} Mdpl");

  print(
    "Ijtimak Geosentris               : ${julianDay.jdkm(jdNM2)} | jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM2, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd | Bujur: ${mf.dddms(jdNM4)}",
  );

  print(
    "Ijtimak Toposentris              : ${julianDay.jdkm(jdNM3)} | jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM3, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd | Bujur: ${mf.dddms(jdNM5)}",
  );

  print(
    "Gurub Matahari                   : ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: 0, posNegSign: "")}",
  );

  print(
    "Gurub Bulan                      : ${mf.dhhms(double.parse(julianDay.jdkm(jdMSet, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: 0, posNegSign: "")}",
  );

  print("Kriteria                         : $kr1");
  print("Status                           : $kr");
  print("Awal Bulan                       : ${julianDay.jdkm(abq, tmZn)}");

  print("=============================================================");
  print(
    "Data Matahari ${julianDay.jdkm(jdNM2)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd",
  );
  print("=============================================================");
  print("Julian Day                       : $jd");
  print("Delta T                          : ${dltT.toStringAsFixed(2)}s");
  print(
    "G.Longitude (True)               : ${mf.dddms(sn.sunGeocentricLongitude(jd, dltT, "True"))}",
  );
  print(
    "G.Longitude (Appa)               : ${mf.dddms(sn.sunGeocentricLongitude(jd, dltT, "Appa"))}",
  );
  print(
    "G.Latitude                       : ${mf.dddms(sn.sunGeocentricLatitude(jd, dltT))}",
  );
  print(
    "G.Right Ascension                : ${mf.dddms(sn.sunGeocentricRightAscension(jd, dltT))}",
  );
  print(
    "G.Declination                    : ${mf.dddms(sn.sunGeocentricDeclination(jd, dltT))}",
  );
  print(
    "G.Azimuth                        : ${mf.dddms(sn.sunGeocentricAzimuth(jd, dltT, gLon, gLat))}",
  );
  print(
    "G.Altitude                       : ${mf.dddms(sn.sunGeocentricAltitude(jd, dltT, gLon, gLat))}",
  );
  print(
    "G.Semidiamater                   : ${mf.dddms(sn.sunGeocentricSemidiameter(jd, dltT))}",
  );
  print(
    "G.eq Horizontal Parallax         : ${mf.dddms(sn.sunEquatorialHorizontalParallax(jd, dltT))}",
  );
  print(
    "G.Distance (AU)                  : ${sn.sunGeocentricDistance(jd, dltT, "AU").toStringAsFixed(6)} AU",
  );
  print(
    "G.Distance (KM)                  : ${sn.sunGeocentricDistance(jd, dltT, "KM").toStringAsFixed(6)} KM",
  );
  print(
    "G.Distance (ER)                  : ${sn.sunGeocentricDistance(jd, dltT, "ER").toStringAsFixed(6)} ER",
  );
  print(
    "G.Greenwich Hour Angle           : ${mf.dhhms(sn.sunGeocentricGreenwichHourAngle(jd, dltT) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "G.Local Hour Angle               : ${mf.dhhms(sn.sunGeocentricLocalHourAngle(jd, dltT, gLon) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "T.Longitude                      : ${mf.dddms(sn.sunTopocentricLongitude(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Latitude                       : ${mf.dddms(sn.sunTopocentricLatitude(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Right Ascension                : ${mf.dddms(sn.sunTopocentricRightAscension(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Declination                    : ${mf.dddms(sn.sunTopocentricDeclination(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Azimuth                        : ${mf.dddms(sn.sunTopocentricAzimuth(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Altitude (Airless)             : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "ht"))}",
  );
  print(
    "T.Altitude (Apparent)            : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "hta"))}",
  );
  print(
    "M.Altitude                       : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "hto"))}",
  );
  print(
    "T.Semidiameter                   : ${mf.dddms(sn.sunTopocentricSemidiameter(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Greenwich Hour Angle           : ${mf.dhhms(sn.sunTopocentricGreenwichHourAngle(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "T.Local Hour Angle               : ${mf.dhhms(sn.sunTopocentricLocalHourAngel(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "Equation of Time                 : ${mf.dhhms(sn.equationOfTime(jd, dltT), optResult: "MMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );

  print("=============================================================");
  print(
    "Data Bulan ${julianDay.jdkm(jdNM2)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd",
  );
  print("=============================================================");
  print("Julian Day                       : $jd");
  print("Delta T                          : ${dltT.toStringAsFixed(2)} s");
  print(
    "G.Longitude (True)               : ${mf.dddms(ml.moonGeocentricLongitude(jd, dltT, "True"))}",
  );
  print(
    "G.Longitude (Appa)               : ${mf.dddms(ml.moonGeocentricLongitude(jd, dltT, "Appa"))}",
  );
  print(
    "G.Latitude                       : ${mf.dddms(mb.moonGeocentricLatitude(jd, dltT))}",
  );
  print(
    "G.Right Ascension                : ${mf.dddms(mo.moonGeocentricRightAscension(jd, dltT))}",
  );
  print(
    "G.Declination                    : ${mf.dddms(mo.moonGeocentricDeclination(jd, dltT))}",
  );
  print(
    "G.Azimuth                        : ${mf.dddms(mo.moonGeocentricAzimuth(jd, dltT, gLon, gLat))}",
  );
  print(
    "G.Altitude                       : ${mf.dddms(mo.moonGeocentricAltitude(jd, dltT, gLon, gLat))}",
  );
  print(
    "G.Eq Horizontal Parallax         : ${mf.dddms(mo.moonEquatorialHorizontalParallax(jd, dltT))}",
  );
  print(
    "G.Semidiamater                   : ${mf.dddms(mo.moonGeocentricSemidiameter(jd, dltT))}",
  );
  print(
    "G.Elongation                     : ${mf.dddms(mo.moonSunGeocentricElongation(jd, dltT))}",
  );
  print(
    "G.Phase Angle                    : ${mf.dddms(mo.moonGeocentricPhaseAngle(jd, dltT))}",
  );
  print(
    "G.Disk Illuminated fraction      : ${mo.moonGeocentricDiskIlluminatedFraction(jd, dltT).toStringAsFixed(17)}",
  );
  print(
    "G.Bright Limb Angle              : ${mf.dddms(mo.moonGeocentricBrightLimbAngle(jd, dltT))}",
  );
  print(
    "G.Greenwich Hour Angle           : ${mf.dhhms(mo.moonGeocentricGreenwichHourAngle(jd, dltT) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "G.Local Hour Angle               : ${mf.dhhms(mo.moonGeocentricLocalHourAngel(jd, dltT, gLon) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "G.Distance (KM)                  : ${md.moonGeocentricDistance(jd, dltT, "KM").toStringAsFixed(5)} KM",
  );
  print(
    "G.Distance (AU)                  : ${md.moonGeocentricDistance(jd, dltT, "AU").toStringAsFixed(5)} AU",
  );
  print(
    "G.Distance (ER)                  : ${md.moonGeocentricDistance(jd, dltT, "ER").toStringAsFixed(5)} ER",
  );
  print("G.Relative Altitude              : ${mf.dddms(relAltGeo)}");
  print("G.Crescent Width                 : ${mf.dddms(gCw)}");
  print(
    "T.Longitude                      : ${mf.dddms(mo.moonTopocentricLongitude(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Latitude                       : ${mf.dddms(mo.moonTopocentricLatitude(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Right Ascension                : ${mf.dddms(mo.moonTopocentricRightAscension(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Declination                    : ${mf.dddms(mo.moonTopocentricDeclination(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Semidiamater                   : ${mf.dddms(mo.moonTopocentricSemidiameter(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Elongation                     : ${mf.dddms(mo.moonSunTopocentricElongation(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Phase Angle                    : ${mf.dddms(mo.moonTopocentricPhaseAngle(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Disk Illuminated fraction      : ${mo.moonTopocentricDiskIlluminatedFraction(jd, dltT, gLon, gLat, elev).toStringAsFixed(17)}",
  );
  print(
    "T.Bright Limb Angle              : ${mf.dddms(mo.moonTopocentricBrightLimbAngle(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Greenwich Hour Angle           : ${mf.dhhms(mo.moonTopocentricGreenwichHourAngle(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "T.Local Hour Angle               : ${mf.dhhms(mo.moonTopocentricLocalHourAngel(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
  );
  print(
    "T.Azimuth                        : ${mf.dddms(mo.moonTopocentricAzimuth(jd, dltT, gLon, gLat, elev))}",
  );
  print(
    "T.Altitude (Airless) Center      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htc"))}",
  );
  print(
    "T.Altitude (Apparent) Center     : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htac"))}",
  );
  print(
    "M.Altitude Center                : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htoc"))}",
  );
  print(
    "T.Altitude (Airless) Upper       : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htu"))}",
  );
  print(
    "T.Altitude (Apparent) Upper      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htau"))}",
  );
  print(
    "M.Altitude Upper                 : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htou"))}",
  );
  print(
    "T.Altitude (Airless) Lower       : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htl"))}",
  );
  print(
    "T.Altitude (Apparent) Lower      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htal"))}",
  );
  print(
    "M.Altitude Lower Limb            : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htol"))}",
  );
  print("T.Relative Altitude              : ${mf.dddms(relAltTop)}");
  print(
    "T.Arah Terbenam Bulan            : ${mf.dddms(mo.moonTopocentricAzimuth(jdMSet, dltT, gLon, gLat, elev) + 180)}",
  );
  print("T.Crescent Width                 : ${mf.dddms(tCw)}");
  print(
    "Best Time                        : ${mf.dhhms(bTime, optResult: "HH:MM:SS", secDecPlaces: 2, posNegSign: "")}",
  );
  print("Range q Odeh                     : ${mf.roundTo(qOdeh, place: 2)}");

  print(
    "Terbenam Bulan                   : ${mf.dhhms(mSet, optResult: "HH:MM:SS", secDecPlaces: 2, posNegSign: "")} ",
  );

  // print(
  //   "tglM : $tglM, blnM : $blnM, thnM : $thnM, gLon : $gLon, gLat : $gLat, elev : $elev, tmZn : $tmZn",
  // );
}
