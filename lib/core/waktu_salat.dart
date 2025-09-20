import 'dart:math';
import 'julian_day.dart';
import 'math_utils.dart';
import 'dynamical_time.dart';
import 'sun_function.dart';

class WaktuSalat {
  final julianDay = JulianDay();
  final mf = MathFunction();
  final dt = DynamicalTime();
  final sn = SunFunction();

  double zuhur(int tglM, int blnM, int thnM, double gLon, double tmZn) {
    double jd, jde, kwd, eoT;
    double zhr = 12.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, zhr, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400);
      eoT = sn.equationOfTime(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;
      zhr = 12 - eoT - kwd;
    }
    return zhr;
  }

  double asar(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double tmZn,
  ) {
    double jd, jde, kwd, eoT, dec, zm, hm, tm;
    double asr = 15.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, asr, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400);
      eoT = sn.equationOfTime(jde, 0.0);
      dec = sn.sunGeocentricDeclination(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;

      zm = (gLat - dec).abs();
      hm = mf.deg(atan(1 / (tan(mf.rad(zm)) + 1)));
      tm = mf.deg(
        acos(
          -tan(mf.rad(gLat)) * tan(mf.rad(dec)) +
              sin(mf.rad(hm)) / cos(mf.rad(gLat)) / cos(mf.rad(dec)),
        ),
      );
      asr = (12 - eoT) + tm / 15.0 - kwd;
    }
    return asr;
  }

  double magrib(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double elev,
    double tmZn,
  ) {
    double jd, jde, kwd, eoT, dec, sd, dip, hm, tm;
    double mgr = 18.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, mgr, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400.0);
      eoT = sn.equationOfTime(jde, 0.0);
      dec = sn.sunGeocentricDeclination(jde, 0.0);
      sd = sn.sunGeocentricSemidiameter(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;

      dip = 1.76 / 60 * sqrt(elev);
      hm = -(sd + 34.5 / 60 + dip);
      tm = mf.deg(
        acos(
          -tan(mf.rad(gLat)) * tan(mf.rad(dec)) +
              sin(mf.rad(hm)) / cos(mf.rad(gLat)) / cos(mf.rad(dec)),
        ),
      );
      mgr = 12 - eoT + tm / 15.0 - kwd;
    }
    return mgr;
  }

  double isya(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double tmZn,
  ) {
    double jd, jde, kwd, eoT, dec, hm, tm;
    double isy = 19.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, isy, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400.0);
      eoT = sn.equationOfTime(jde, 0.0);
      dec = sn.sunGeocentricDeclination(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;

      hm = -18.0;
      tm = mf.deg(
        acos(
          -tan(mf.rad(gLat)) * tan(mf.rad(dec)) +
              sin(mf.rad(hm)) / cos(mf.rad(gLat)) / cos(mf.rad(dec)),
        ),
      );
      isy = 12 - eoT + tm / 15.0 - kwd;
    }
    return isy;
  }

  double subuh(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double tmZn,
  ) {
    double jd, jde, kwd, eoT, dec, hm, tm;
    double sbh = 4.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, sbh, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400.0);
      eoT = sn.equationOfTime(jde, 0.0);
      dec = sn.sunGeocentricDeclination(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;

      hm = -20.0;
      tm = mf.deg(
        acos(
          -tan(mf.rad(gLat)) * tan(mf.rad(dec)) +
              sin(mf.rad(hm)) / cos(mf.rad(gLat)) / cos(mf.rad(dec)),
        ),
      );
      sbh = 12 - eoT - tm / 15.0 - kwd;
    }
    return sbh;
  }

  double syuruk(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double elev,
    double tmZn,
  ) {
    double jd, jde, kwd, eoT, dec, sd, dip, hm, tm;
    double syk = 6.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, syk, tmZn);
      jde = jd + (dt.deltaT(jd) / 86400.0);
      eoT = sn.equationOfTime(jde, 0.0);
      dec = sn.sunGeocentricDeclination(jde, 0.0);
      sd = sn.sunGeocentricSemidiameter(jde, 0.0);
      kwd = (gLon - (tmZn * 15.0)) / 15.0;

      dip = 1.76 / 60.0 * sqrt(elev);
      hm = -(sd + 34.5 / 60.0 + dip);
      tm = mf.deg(
        acos(
          -tan(mf.rad(gLat)) * tan(mf.rad(dec)) +
              sin(mf.rad(hm)) / cos(mf.rad(gLat)) / cos(mf.rad(dec)),
        ),
      );
      syk = 12 - eoT - tm / 15.0 - kwd;
    }
    return syk;
  }

  double duha(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double elev,
    double tmZn,
  ) {
    double wSyk = syuruk(tglM, blnM, thnM, gLon, gLat, elev, tmZn);
    double duh = wSyk + 15 / 60.0;
    return duh;
  }

  double nisfuLail(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double elev,
    double tmZn,
  ) {
    double wMgb = magrib(tglM, blnM, thnM, gLon, gLat, elev, tmZn);
    double wSbh = subuh(tglM, blnM, thnM, gLon, gLat, tmZn);
    double intr = (mf.mod(wSbh - wMgb, 24.0)) / 2.0;
    double nisf = wMgb + intr;
    return nisf;
  }

  double ihtiyathShalat(double jamDesWs, int ihtiyath) {
    double uDHrs = jamDesWs;
    double uHrs = jamDesWs.floorToDouble();
    double uDMin = (uDHrs - uHrs) * 60.0;
    double uMin = uDMin.floorToDouble() + ihtiyath;

    if (uMin == 60.0) {
      uMin = 0.0;
      uHrs = uHrs + 1.0;
    }

    double iht = uHrs + uMin / 60;
    return iht;
  }
}
