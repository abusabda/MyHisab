import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_distance.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/moon_latitude.dart';
import 'package:myhisab/core/moon_longitude.dart';
import 'package:myhisab/core/sun_function.dart';
//import 'package:myhisab/service/moon_service.dart';

//final mf = MathFunction();
final julianDay = JulianDay();
final dynamicalTime = DynamicalTime();
final sn = SunFunction();
final mf = MathFunction();
final ml = MoonLongitude();
final mb = MoonLatitude();
final md = MoonDistance();
final mo = MoonFunction();

class Lokasi {
  final double gLat;
  final double gLon;
  final double tmZn;

  Lokasi(this.gLat, this.gLon, this.tmZn);
}

class Lokasi2 {
  final double gLat;
  final double gLon;
  final double tmZn;

  Lokasi2(this.gLat, this.gLon, this.tmZn);
}

final ab = CalendarService();

class CalendarService {
  // Fungsi Hisab Awal Bulan Hijriah Sesuai Lokasi

  String hisabAwalBulanHijriahSesuaiLokasi({
    required String nmLokasi,
    required int blnH,
    required int thnH,
    required double gLon,
    required double gLat,
    required double tmZn,
    required double elev,
    required double pres,
    required double temp,
    required int sdp,
    int tbhHari = 0,
    int optKriteria = 1, // 1 = Imkan Rukyat, 2 = Wujudul Hilal
  }) {
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
        sn.jdGhurubSyams(jd, gLat, gLon, elev, tmZn),
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
      jdMSet = julianDay.kmjd(tglM, blnM, thnM, 0.0, 0.0) + (mSet - tmZn) / 24;
    }

    final double bTime = jamGS + 4 / 9.0 * ((jdMSet - jd) * 24);

    final gCw =
        (mo.moonGeocentricSemidiameter(jd, dltT)) *
        (1 - math.cos(mf.rad(mo.moonSunGeocentricElongation(jd, dltT))));

    final tCw =
        (mo.moonTopocentricSemidiameter(jd, dltT, gLon, gLat, elev)) *
        (1 -
            math.cos(
              mf.rad(
                mo.moonSunTopocentricElongation(jd, dltT, gLon, gLat, elev),
              ),
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
        (-0.1018 * math.pow((tCw * 60), 3) +
            0.7319 * math.pow((tCw * 60), 2) -
            6.3226 * (tCw * 60) +
            7.1651);

    //Tinggi Hilal dan Elongasi
    final double tHilal1 = mo.moonTopocentricAltitude(
      jdGS,
      dltT,
      gLon,
      gLat,
      elev,
      pres,
      temp,
      "htoc",
    ); // JD Ijtimak
    final double elong01 = mo.moonSunGeocentricElongation(jdGS, dltT);

    final double tHilal2 = mo.moonTopocentricAltitude(
      jd,
      dltT,
      gLon,
      gLat,
      elev,
      pres,
      temp,
      "htoc",
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

    iRP2 = (tHilal2 >= 3 && elong02 >= 6.4) ? "Visible" : "Not Visible";

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
    if (optKriteria == 1) {
      // pilihan imkan rukyat
      abq = ((jdNM2 + 0.5 + tmZn / 24).floor() - tmZn / 24.0) + iR01;
      kr = visb;
      kr1 = "Imkan Rukyat";
    } else {
      // pilihan wujudul hilal
      abq = ((jdNM2 + 0.5 + tmZn / 24).floor() - tmZn / 24.0) + wH01;
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

    final sb = StringBuffer();

    sb.writeln("Perhitungan Awal Bulan           : $nmBlnH $thnH H");
    sb.writeln("Lokasi                           : $nmLokasi");
    sb.writeln(
      "Koordinat                        : ${mf.dddms(gLon, optResult: "BBBT", sdp: sdp, posNegSign: "+-")} | ${mf.dddms2(gLat, optResult: "LULS", sdp: sdp, posNegSign: "")}",
    );
    sb.writeln(
      "Elevasi                          : ${elev.toStringAsFixed(3)} Mdpl",
    );
    sb.writeln("Time Zone                        : $tmZn jam");
    sb.writeln(
      "Saat perhitungan                 : ${julianDay.jdkm(jd)} | JD: $jd",
    );
    sb.writeln(
      "Delta T                          : ${dltT.toStringAsFixed(2)}s",
    );
    sb.writeln(
      "Algoritma                        : VSOP87D & ELP/MPP02 (38.326 suku koreksi)",
    );

    sb.writeln(
      "Ijtimak Geosentris               : ${julianDay.jdkm(jdNM2, tmZn)} | jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM2, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd | Bujur: ${mf.dddms(jdNM4)}",
    );

    sb.writeln(
      "Ijtimak Toposentris              : ${julianDay.jdkm(jdNM3, tmZn)} | jam: ${mf.dhhms(double.parse(julianDay.jdkm(jdNM3, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd | Bujur: ${mf.dddms(jdNM5)}",
    );

    sb.writeln(
      "Gurub Matahari                   : ${jamGS != 0.0 ? "${mf.dhhms(jamGS, optResult: "HH:MM:SS", secDecPlaces: 2, posNegSign: "")} $wd" : "sirkompular"}",
    );

    sb.writeln(
      "Gurub Bulan                      : ${mSet != 0.0 ? "${mf.dhhms(mSet, optResult: "HH:MM:SS", secDecPlaces: 2, posNegSign: "")} $wd" : "sirkompular"}",
    );

    sb.writeln("Kriteria                         : $kr1");
    sb.writeln("Status                           : $kr");
    sb.writeln(
      "Awal Bulan                       : ${julianDay.jdkm(abq, tmZn)}",
    );

    sb.writeln("=============================================================");
    sb.writeln(
      "Data Matahari ${julianDay.jdkm(jdNM2)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd",
    );
    sb.writeln("=============================================================");

    sb.writeln(
      "G.Longitude (True)               : ${mf.dddms(sn.sunGeocentricLongitude(jd, dltT, "True"))}",
    );
    sb.writeln(
      "G.Longitude (Appa)               : ${mf.dddms(sn.sunGeocentricLongitude(jd, dltT, "Appa"))}",
    );
    sb.writeln(
      "G.Latitude                       : ${mf.dddms(sn.sunGeocentricLatitude(jd, dltT))}",
    );
    sb.writeln(
      "G.Right Ascension                : ${mf.dddms(sn.sunGeocentricRightAscension(jd, dltT))}",
    );
    sb.writeln(
      "G.Declination                    : ${mf.dddms(sn.sunGeocentricDeclination(jd, dltT))}",
    );
    sb.writeln(
      "G.Azimuth                        : ${mf.dddms(sn.sunGeocentricAzimuth(jd, dltT, gLon, gLat))}",
    );
    sb.writeln(
      "G.Altitude                       : ${mf.dddms(sn.sunGeocentricAltitude(jd, dltT, gLon, gLat))}",
    );
    sb.writeln(
      "G.Semidiamater                   : ${mf.dddms(sn.sunGeocentricSemidiameter(jd, dltT))}",
    );
    sb.writeln(
      "G.eq Horizontal Parallax         : ${mf.dddms(sn.sunEquatorialHorizontalParallax(jd, dltT))}",
    );
    sb.writeln(
      "G.Distance (AU)                  : ${sn.sunGeocentricDistance(jd, dltT, "AU").toStringAsFixed(6)} AU",
    );
    sb.writeln(
      "G.Distance (KM)                  : ${sn.sunGeocentricDistance(jd, dltT, "KM").toStringAsFixed(6)} KM",
    );
    sb.writeln(
      "G.Distance (ER)                  : ${sn.sunGeocentricDistance(jd, dltT, "ER").toStringAsFixed(6)} ER",
    );
    sb.writeln(
      "G.Greenwich Hour Angle           : ${mf.dhhms(sn.sunGeocentricGreenwichHourAngle(jd, dltT) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "G.Local Hour Angle               : ${mf.dhhms(sn.sunGeocentricLocalHourAngle(jd, dltT, gLon) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "T.Longitude                      : ${mf.dddms(sn.sunTopocentricLongitude(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Latitude                       : ${mf.dddms(sn.sunTopocentricLatitude(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Right Ascension                : ${mf.dddms(sn.sunTopocentricRightAscension(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Declination                    : ${mf.dddms(sn.sunTopocentricDeclination(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Azimuth                        : ${mf.dddms(sn.sunTopocentricAzimuth(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Altitude (Airless)             : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "ht"))}",
    );
    sb.writeln(
      "T.Altitude (Apparent)            : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "hta"))}",
    );
    sb.writeln(
      "M.Altitude                       : ${mf.dddms(sn.sunTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "hto"))}",
    );
    sb.writeln(
      "T.Semidiameter                   : ${mf.dddms(sn.sunTopocentricSemidiameter(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Greenwich Hour Angle           : ${mf.dhhms(sn.sunTopocentricGreenwichHourAngle(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "T.Local Hour Angle               : ${mf.dhhms(sn.sunTopocentricLocalHourAngel(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "Equation of Time                 : ${mf.dhhms(sn.equationOfTime(jd, dltT), optResult: "MMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );

    sb.writeln("=============================================================");
    sb.writeln(
      "Data Bulan ${julianDay.jdkm(jdNM2)} jam: ${mf.dhhms(double.parse(julianDay.jdkm(jd, tmZn, "JamDes")), optResult: "HH:MM:SS", secDecPlaces: sdp, posNegSign: "")} $wd",
    );
    sb.writeln("=============================================================");
    sb.writeln("Julian Day                       : $jd");
    sb.writeln(
      "Delta T                          : ${dltT.toStringAsFixed(2)} s",
    );
    sb.writeln(
      "G.Longitude (True)               : ${mf.dddms(ml.moonGeocentricLongitude(jd, dltT, "True"))}",
    );
    sb.writeln(
      "G.Longitude (Appa)               : ${mf.dddms(ml.moonGeocentricLongitude(jd, dltT, "Appa"))}",
    );
    sb.writeln(
      "G.Latitude                       : ${mf.dddms(mb.moonGeocentricLatitude(jd, dltT))}",
    );
    sb.writeln(
      "G.Right Ascension                : ${mf.dddms(mo.moonGeocentricRightAscension(jd, dltT))}",
    );
    sb.writeln(
      "G.Declination                    : ${mf.dddms(mo.moonGeocentricDeclination(jd, dltT))}",
    );
    sb.writeln(
      "G.Azimuth                        : ${mf.dddms(mo.moonGeocentricAzimuth(jd, dltT, gLon, gLat))}",
    );
    sb.writeln(
      "G.Altitude                       : ${mf.dddms(mo.moonGeocentricAltitude(jd, dltT, gLon, gLat))}",
    );
    sb.writeln(
      "G.Eq Horizontal Parallax         : ${mf.dddms(mo.moonEquatorialHorizontalParallax(jd, dltT))}",
    );
    sb.writeln(
      "G.Semidiamater                   : ${mf.dddms(mo.moonGeocentricSemidiameter(jd, dltT))}",
    );
    sb.writeln(
      "G.Elongation                     : ${mf.dddms(mo.moonSunGeocentricElongation(jd, dltT))}",
    );
    sb.writeln(
      "G.Phase Angle                    : ${mf.dddms(mo.moonGeocentricPhaseAngle(jd, dltT))}",
    );
    sb.writeln(
      "G.Disk Illuminated fraction      : ${mo.moonGeocentricDiskIlluminatedFraction(jd, dltT).toStringAsFixed(17)}",
    );
    sb.writeln(
      "G.Bright Limb Angle              : ${mf.dddms(mo.moonGeocentricBrightLimbAngle(jd, dltT))}",
    );
    sb.writeln(
      "G.Greenwich Hour Angle           : ${mf.dhhms(mo.moonGeocentricGreenwichHourAngle(jd, dltT) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "G.Local Hour Angle               : ${mf.dhhms(mo.moonGeocentricLocalHourAngel(jd, dltT, gLon) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "G.Distance (KM)                  : ${md.moonGeocentricDistance(jd, dltT, "KM").toStringAsFixed(5)} KM",
    );
    sb.writeln(
      "G.Distance (AU)                  : ${md.moonGeocentricDistance(jd, dltT, "AU").toStringAsFixed(5)} AU",
    );
    sb.writeln(
      "G.Distance (ER)                  : ${md.moonGeocentricDistance(jd, dltT, "ER").toStringAsFixed(5)} ER",
    );
    sb.writeln("G.Relative Altitude              : ${mf.dddms(relAltGeo)}");
    sb.writeln("G.Crescent Width                 : ${mf.dddms(gCw)}");
    sb.writeln(
      "T.Longitude                      : ${mf.dddms(mo.moonTopocentricLongitude(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Latitude                       : ${mf.dddms(mo.moonTopocentricLatitude(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Right Ascension                : ${mf.dddms(mo.moonTopocentricRightAscension(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Declination                    : ${mf.dddms(mo.moonTopocentricDeclination(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Semidiamater                   : ${mf.dddms(mo.moonTopocentricSemidiameter(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Elongation                     : ${mf.dddms(mo.moonSunTopocentricElongation(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Phase Angle                    : ${mf.dddms(mo.moonTopocentricPhaseAngle(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Disk Illuminated fraction      : ${mo.moonTopocentricDiskIlluminatedFraction(jd, dltT, gLon, gLat, elev).toStringAsFixed(17)}",
    );
    sb.writeln(
      "T.Bright Limb Angle              : ${mf.dddms(mo.moonTopocentricBrightLimbAngle(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Greenwich Hour Angle           : ${mf.dhhms(mo.moonTopocentricGreenwichHourAngle(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "T.Local Hour Angle               : ${mf.dhhms(mo.moonTopocentricLocalHourAngel(jd, dltT, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: sdp, posNegSign: "+/-")}",
    );
    sb.writeln(
      "T.Azimuth                        : ${mf.dddms(mo.moonTopocentricAzimuth(jd, dltT, gLon, gLat, elev))}",
    );
    sb.writeln(
      "T.Altitude (Airless) Center      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htc"))}",
    );
    sb.writeln(
      "T.Altitude (Apparent) Center     : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htac"))}",
    );
    sb.writeln(
      "M.Altitude Center                : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htoc"))}",
    );
    sb.writeln(
      "T.Altitude (Airless) Upper       : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htu"))}",
    );
    sb.writeln(
      "T.Altitude (Apparent) Upper      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htau"))}",
    );
    sb.writeln(
      "M.Altitude Upper                 : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htou"))}",
    );
    sb.writeln(
      "T.Altitude (Airless) Lower       : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htl"))}",
    );
    sb.writeln(
      "T.Altitude (Apparent) Lower      : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htal"))}",
    );
    sb.writeln(
      "M.Altitude Lower Limb            : ${mf.dddms(mo.moonTopocentricAltitude(jd, dltT, gLon, gLat, elev, pres, temp, "htol"))}",
    );
    sb.writeln("T.Relative Altitude              : ${mf.dddms(relAltTop)}");
    sb.writeln(
      "T.Arah Terbenam Bulan            : ${mf.dddms(mo.moonTopocentricAzimuth(jdMSet, dltT, gLon, gLat, elev) + 180)}",
    );
    sb.writeln("T.Crescent Width                 : ${mf.dddms(tCw)}");
    sb.writeln(
      "Best Time                        : ${mf.dhhms(bTime, optResult: "HH:MM:SS", secDecPlaces: 2, posNegSign: "")} $wd",
    );
    sb.writeln(
      "Range q Odeh                     : ${mf.roundTo(qOdeh, place: 2)}",
    );
    return sb.toString();
  }

  // Fungsi Hisab Awal Bulan Hijriah Menurut MABIMS

  double abqMabims(int blnH, int thnH) {
    final lokasi = [
      //A. Empat Titik Paling Barat (Utara-Selatan)
      Lokasi(
        5 + 54 / 60 + 26.32 / 3600,
        95 + 13 / 60 + 1.01 / 3600,
        7,
      ), // 1. Sabang, Banda Aceh

      Lokasi(
        -(5 + 22 / 60 + 28.80 / 3600),
        102 + 13 / 60 + 54.86 / 3600,
        7,
      ), // 2. Enggano, Bengkulu Utara

      Lokasi(
        4 + 47 / 60 + 45.14 / 3600,
        108 + 1 / 60 + 16.46 / 3600,
        7,
      ), // 3. Natuna, Kepulauan Riau

      Lokasi(
        -(7 + 4 / 60 + 26.1 / 3600),
        106 + 31 / 60 + 53.71 / 3600,
        7,
      ), // 4. Cibeas, Jawa Barat
      //B. Poros Tengah (Selatan-Utara)
      Lokasi(
        -(8 + 50 / 60 + 59.7 / 3600),
        115 + 9 / 60 + 41.73 / 3600,
        8,
      ), // 5. Pecatu, Bali

      Lokasi(
        4 + 9 / 60 + 9.62 / 3600,
        117 + 42 / 60 + 3.47 / 3600,
        8,
      ), // 6. Sebatik, Kalimantan Utara
    ];

    final sn = SunFunction();
    final mo = MoonFunction();

    final jdNM = mo.geocentricConjunction(blnH, thnH, 0.0, "Ijtimak");
    final delT = dynamicalTime.deltaT(jdNM);
    final jdNM2 = mo.geocentricConjunction(blnH, thnH, delT, "Ijtimak");

    int irMabims = 2; // Default, akan diganti jika syarat terpenuhi

    for (final loc in lokasi) {
      final jdGS = sn.jdGhurubSyams(jdNM, loc.gLat, loc.gLon, 10.0, loc.tmZn);
      final tHlal00 = mo.moonTopocentricAltitude(
        jdGS,
        delT,
        loc.gLon,
        loc.gLat,
        10.0,
        1010.0,
        10.0,
        "htoc",
      );
      final elong00 = mo.moonSunGeocentricElongation(jdGS, delT);

      if (elong00 >= 6.4 && tHlal00 >= 3) {
        irMabims = 1;
        break;
      }
    }

    final jdAbqMabims =
        ((mf.floor(jdNM2 + 0.5 + 0.0 / 24.0)) - 0.0 / 24.0) + irMabims;

    return jdAbqMabims.ceilToDouble();
  }

  double abqWujudulHilal(int blnH, int thnH) {
    double gLon = 110 + 21 / 60;
    double gLat = -(7 + 48 / 60);
    double tmZn = 7;
    double elev = 30;

    final jdNM = mo.geocentricConjunction(blnH, thnH, 0.0, "Ijtimak");
    final delT = dynamicalTime.deltaT(jdNM);
    final jdNM2 = mo.geocentricConjunction(blnH, thnH, delT, "Ijtimak");

    final jdGS = sn.jdGhurubSyams(jdNM2, gLat, gLon, elev, tmZn);
    final tHlal00 = mo.moonTopocentricAltitude(
      jdGS,
      delT,
      gLon,
      gLat,
      10.0,
      1010.0,
      10.0,
      "htou",
    );

    int wh = 2;

    if (tHlal00 > 0 && jdNM2 < jdGS) {
      wh = 1;
    }

    final jdAbqWH = ((mf.floor(jdNM2 + 0.5 + 0.0 / 24.0)) - 0.0 / 24.0) + wh;

    return jdAbqWH.ceilToDouble();
  }

  // Fungsi Hisab Awal Bulan Hijriah Menurut IR TURKI/KHGT

  double abqTurki(int blnH, int thnH) {
    final lokasi = [
      Lokasi2(65, -166.7, -9),
      Lokasi2(54.47, -164.91, -9),
      Lokasi2(60, -139.6304, -9),
      Lokasi2(55.9182, -133.8442, -8),
      Lokasi2(50, -127.45, -8),
      Lokasi2(47, -124.21, -8),
      Lokasi2(34, -118.92, -8),
      Lokasi2(33, -117.33, -8),
      Lokasi2(20, -105.5555, -6),
      Lokasi2(14, -91.557, -6),
      Lokasi2(13, -87.62, -6),
      Lokasi2(9, -83.65, -6),
      Lokasi2(7.25, -80.9333, -5),
      Lokasi2(7, -77.692, -5),
      Lokasi2(3, -77.674, -5),
      Lokasi2(0, -80.1, -5),
      Lokasi2(-3, -79.83, -5),
      Lokasi2(-8, -79.235, -5),
      Lokasi2(-16, -74.0254, -4),
      Lokasi2(-24, -70.5235, -4),
      Lokasi2(-32, -71.5397, -4),
      Lokasi2(-40, -73.726, -4),
      Lokasi2(-44, -73.2683, -3),
      Lokasi2(-49, -75.6755, -3),
      Lokasi2(-55.9385, -67.2877, -3),
    ];

    final jdNM = mo.geocentricConjunction(blnH, thnH, 0.0, "Ijtimak");
    final dT = dynamicalTime.deltaT(jdNM);
    final jdNM2 = mo.geocentricConjunction(blnH, thnH, dT, "Ijtimak");

    int irTurki = 2;

    bool isBefore00UT = false;
    bool isAfter00UT = false;

    for (final loc in lokasi) {
      final jdGS = sn.jdGhurubSyams(jdNM, loc.gLat, loc.gLon, 0, loc.tmZn);
      final tHlal00 = mo.moonGeocentricAltitude(jdGS, dT, loc.gLon, loc.gLat);
      final elong00 = mo.moonSunGeocentricElongation(jdGS, dT);
      final grb00 =
          double.tryParse(
            julianDay.jdkm(jdGS, loc.tmZn, "Jam Des").toString(),
          ) ??
          0.0;

      final jSunSUT0 = grb00 - loc.tmZn;

      if (elong00 >= 8 && tHlal00 >= 5) {
        if (jSunSUT0 < 24) {
          isBefore00UT = true;
          irTurki = 1;
          break;
        } else {
          isAfter00UT = true;
        }
      }
    }

    if (!isBefore00UT && isAfter00UT) {
      final jdFP = (jdNM2 + 0.5).floorToDouble() - 0.5 + 17 / 24.0;
      final lonNZ = 174 + 48 / 60.0;
      final latNZ = -(41 + 19 / 60.0);
      final tzNZ = 12.0;
      final kwd = (lonNZ - (tzNZ * 15)) / 15.0;
      final dek = sn.sunGeocentricDeclination(jdFP, 0);
      final eqt = sn.equationOfTime(jdFP, 0);
      final hmF = -18.0; // default untuk fajar -18 derajat
      final hAm = mf.deg(
        math.acos(
          (math.sin(mf.rad(hmF)) -
                  math.sin(mf.rad(latNZ)) * math.sin(mf.rad(dek))) /
              (math.cos(mf.rad(latNZ)) * math.cos(mf.rad(dek))),
        ),
      );
      final awf = 12 - eqt - hAm / 15 - kwd;
      final awfUTC = mf.mod((awf - 12), 24);
      final jdFUTC = mf.floor(jdNM2 + 0.5) - 0.5 + awfUTC / 24.0;

      final wIjtimak =
          double.tryParse(julianDay.jdkm(jdNM2, 0, "Jam Des").toString()) ??
          0.0;
      final wFajarNZ =
          double.tryParse(julianDay.jdkm(jdFUTC, 0, "Jam Des").toString()) ??
          0.0;

      if (wIjtimak < wFajarNZ) {
        irTurki = 1; // Ijtimak sebelum fajar
      } else {
        irTurki = 2; // Ijtimak setelah fajar
      }
    }

    final abq = ((mf.floor(jdNM2 + 0.5 + 0.0 / 24.0)) - 0.0 / 24.0) + irTurki;

    return abq;
  }

  final namaBulanHijriah = [
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

  String serviceKalenderHijriahMABIMS(int tglM, int blnM, int thnM) {
    final jd = julianDay.kmjd(tglM, blnM, thnM);
    final cjdnM = (jd + 0.5).floorToDouble();
    final jd2 = jd.ceilToDouble();

    final thnH = int.parse(
      julianDay
          .cjdnKH(cjdnM.toInt(), hCalE: 2, hCalL: 2, optResult: "THNH")
          .toString(),
    );

    // Kumpulkan semua ABQ
    final abqList = <double>[];
    abqList.add(ab.abqMabims(12, thnH - 1)); // Zulhijjah tahun sebelumnya
    for (var blnH = 1; blnH <= 12; blnH++) {
      abqList.add(ab.abqMabims(blnH, thnH));
    }
    abqList.add(ab.abqMabims(1, thnH + 1)); // Muharram tahun berikutnya

    // Loop hari dari tiap ABQ ke ABQ berikutnya
    for (var i = 0; i < abqList.length - 1; i++) {
      final jdStart = abqList[i].toInt();
      final jdEnd = abqList[i + 1].toInt();

      final blnH = (i == 0)
          ? 12
          : (i == 13)
          ? 12
          : i;
      final thnHij = (i == 0)
          ? thnH - 1
          : (i >= 1 && i <= 12)
          ? thnH
          : thnH + 1;

      final namaBlnH = namaBulanHijriah[blnH - 1];

      var nomorUrut = 1;
      for (var jdHari = jdStart; jdHari < jdEnd; jdHari++) {
        if (jdHari == jd2.toInt()) {
          return "${julianDay.jdkm(jdHari.toDouble())} M | $nomorUrut $namaBlnH $thnHij H";
        }
        nomorUrut++;
      }
    }

    return "Tidak ditemukan";
  }

  String serviceKalenderHijriahWH(int tglM, int blnM, int thnM) {
    final jd = julianDay.kmjd(tglM, blnM, thnM);
    final cjdnM = (jd + 0.5).floorToDouble();
    final jd2 = jd.ceilToDouble();

    final thnH = int.parse(
      julianDay
          .cjdnKH(cjdnM.toInt(), hCalE: 2, hCalL: 2, optResult: "THNH")
          .toString(),
    );

    // Kumpulkan semua ABQ
    final abqList = <double>[];
    abqList.add(ab.abqWujudulHilal(12, thnH - 1)); // Zulhijjah tahun sebelumnya
    for (var blnH = 1; blnH <= 12; blnH++) {
      abqList.add(ab.abqWujudulHilal(blnH, thnH));
    }
    abqList.add(ab.abqWujudulHilal(1, thnH + 1)); // Muharram tahun berikutnya

    // Loop hari dari tiap ABQ ke ABQ berikutnya
    for (var i = 0; i < abqList.length - 1; i++) {
      final jdStart = abqList[i].toInt();
      final jdEnd = abqList[i + 1].toInt();

      final blnH = (i == 0)
          ? 12
          : (i == 13)
          ? 12
          : i;
      final thnHij = (i == 0)
          ? thnH - 1
          : (i >= 1 && i <= 12)
          ? thnH
          : thnH + 1;

      final namaBlnH = namaBulanHijriah[blnH - 1];

      var nomorUrut = 1;
      for (var jdHari = jdStart; jdHari < jdEnd; jdHari++) {
        if (jdHari == jd2.toInt()) {
          return "${julianDay.jdkm(jdHari.toDouble())} M | $nomorUrut $namaBlnH $thnHij H";
        }
        nomorUrut++;
      }
    }

    return "Tidak ditemukan";
  }

  String serviceKalenderHijriahTURKI(int tglM, int blnM, int thnM) {
    final jd = julianDay.kmjd(tglM, blnM, thnM);
    final cjdnM = (jd + 0.5).floorToDouble();
    final jd2 = jd.ceilToDouble();

    final thnH = int.parse(
      julianDay
          .cjdnKH(cjdnM.toInt(), hCalE: 2, hCalL: 2, optResult: "THNH")
          .toString(),
    );

    // Kumpulkan semua ABQ
    final abqList = <double>[];
    abqList.add(ab.abqTurki(12, thnH - 1)); // Zulhijjah tahun sebelumnya
    for (var blnH = 1; blnH <= 12; blnH++) {
      abqList.add(ab.abqTurki(blnH, thnH));
    }
    abqList.add(ab.abqTurki(1, thnH + 1)); // Muharram tahun berikutnya

    // Loop hari dari tiap ABQ ke ABQ berikutnya
    for (var i = 0; i < abqList.length - 1; i++) {
      final jdStart = abqList[i].toInt();
      final jdEnd = abqList[i + 1].toInt();

      final blnH = (i == 0)
          ? 12
          : (i == 13)
          ? 12
          : i;
      final thnHij = (i == 0)
          ? thnH - 1
          : (i >= 1 && i <= 12)
          ? thnH
          : thnH + 1;

      final namaBlnH = namaBulanHijriah[blnH - 1];

      var nomorUrut = 1;
      for (var jdHari = jdStart; jdHari < jdEnd; jdHari++) {
        if (jdHari == jd2.toInt()) {
          return "${julianDay.jdkm(jdHari.toDouble())} M | $nomorUrut $namaBlnH $thnHij H";
        }
        nomorUrut++;
      }
    }

    return "Tidak ditemukan";
  }
}
