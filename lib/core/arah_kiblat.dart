import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/sun_function.dart';

class ArahKiblat {
  final julianDay = JulianDay();
  final dynamicalTime = DynamicalTime();
  final mf = MathFunction();
  final sn = SunFunction();

  double arahQiblatSpherical(double gLon, double gLat) {
    final gLatKabah = 21.0 + 25.0 / 60.0 + 21.02 / 3600.0;
    final gLonKabah = 39.0 + 49.0 / 60.0 + 34.27 / 3600.0;

    final a = (90.0 - gLat);
    final b = (90.0 - gLatKabah);
    final c = (gLon - gLonKabah);

    final sB = math.sin(mf.rad(b)) * math.sin(mf.rad(c));
    final cB =
        math.cos(mf.rad(b)) * math.sin(mf.rad(a)) -
        math.cos(mf.rad(a)) * math.sin(mf.rad(b)) * math.cos(mf.rad(c));
    final bB = mf.deg(math.atan2(sB, cB));
    final azQ = mf.mod((360.0 - bB), 360.0);
    return azQ;
  }

  double arahQiblaWithEllipsoidCorrection(double gLon, double gLat) {
    final gLatKabah = 21.0 + 25.0 / 60.0 + 21.02 / 3600.0;
    final gLonKabah = 39.0 + 49.0 / 60.0 + 34.27 / 3600.0;

    final e = 0.0066943800229;
    final gLatKprime = mf.deg(math.atan((1 - e) * math.tan(mf.rad(gLatKabah))));
    final gLatPprime = mf.deg(math.atan((1 - e) * math.tan(mf.rad(gLat))));

    final a = (90.0 - gLatPprime);
    final b = (90.0 - gLatKprime);
    final c = (gLon - gLonKabah);

    final sB = math.sin(mf.rad(b)) * math.sin(mf.rad(c));
    final cB =
        math.cos(mf.rad(b)) * math.sin(mf.rad(a)) -
        math.cos(mf.rad(a)) * math.sin(mf.rad(b)) * math.cos(mf.rad(c));
    final bB = mf.deg(math.atan2(sB, cB));
    final azQ = mf.mod((360.0 - bB), 360.0);
    return azQ;
  }

  double arahQiblaVincenty(double gLon, double gLat, String optResult) {
    final gLatKabah = 21 + 25 / 60.0 + 21.02 / 3600.0;
    final gLonKabah = 39 + 49 / 60.0 + 34.27 / 3600.0;

    final f = 1.0 / 298.257223563;
    final ae = 6378137.0;
    final be = 6356752.314245180;

    final u1 = math.atan((1 - f) * math.tan(mf.rad(gLatKabah)));
    final u2 = math.atan((1 - f) * math.tan(mf.rad(gLat)));
    final l0 = mf.rad(gLon - gLonKabah);

    var lambda = l0;
    var lambda0 = 0.0;
    var sigma = 0.0;
    var sAlpha = 0.0;
    var c2Alpha = 0.0;
    var c2SigmaM = 0.0;
    var cSigma = 0.0;
    var sSigma = 0.0;
    var iterlimit = 0;

    do {
      iterlimit++;
      lambda0 = lambda;
      cSigma =
          math.sin(u1) * math.sin(u2) +
          math.cos(u1) * math.cos(u2) * math.cos(lambda);
      sSigma = math.sqrt(
        math.pow(math.cos(u2) * math.sin(lambda), 2.0) +
            math.pow(
              math.cos(u1) * math.sin(u2) -
                  math.sin(u1) * math.cos(u2) * math.cos(lambda),
              2.0,
            ),
      );
      sigma = math.atan2(sSigma, cSigma);
      sAlpha = math.cos(u1) * math.cos(u2) * math.sin(lambda) / sSigma;
      c2Alpha = 1.0 - math.pow(sAlpha, 2.0);
      c2SigmaM = cSigma - 2.0 * math.sin(u1) * math.sin(u2) / c2Alpha;
      final c = f / 16.0 * c2Alpha * (4.0 + f * (4.0 - 3.0 * c2Alpha));
      lambda =
          l0 +
          (1.0 - c) *
              f *
              sAlpha *
              (sigma +
                  c *
                      sSigma *
                      (c2SigmaM +
                          c * cSigma * (-1.0 + 2.0 * math.pow(c2SigmaM, 2.0))));
    } while ((lambda - lambda0).abs() > 1e-12 && iterlimit < 100);

    final alpha1 = math.atan2(
      math.cos(u2) * math.sin(lambda),
      math.cos(u1) * math.sin(u2) -
          math.sin(u1) * math.cos(u2) * math.cos(lambda),
    );
    final alpha2 = math.atan2(
      math.cos(u1) * math.sin(lambda),
      -math.sin(u1) * math.cos(u2) +
          math.cos(u1) * math.sin(u2) * math.cos(lambda),
    );

    final up2 =
        c2Alpha * (math.pow(ae, 2.0) - math.pow(be, 2.0)) / math.pow(be, 2.0);
    final a = 1 + up2 / 16384 * (4096 + up2 * (-768 + up2 * (320 - 175 * up2)));
    final b = up2 / 1024 * (256 + up2 * (-128 + up2 * (74 - 47 * up2)));

    final dSigma =
        b *
        sSigma *
        (c2SigmaM +
            0.25 *
                b *
                (cSigma * (-1 + 2 * math.pow(c2SigmaM, 2.0)) -
                    1 /
                        6 *
                        b *
                        c2SigmaM *
                        (-3 + 4 * math.pow(sSigma, 2.0)) *
                        (-3 + 4 * math.pow(c2SigmaM, 2.0))));
    final s = be * a * (sigma - dSigma);

    switch (optResult) {
      case "PtoQ":
        return mf.mod(180 + mf.deg(alpha2), 360.0);
      case "QtoP":
        return mf.mod(mf.deg(alpha1), 360.0);
      case "Dist":
        return s;
      default:
        return mf.mod(180 + mf.deg(alpha2), 360.0);
    }
  }

  double jarakQiblatSpherical(double gLon, double gLat) {
    final double gLonK = (39.0 + 49.0 / 60.0 + 34.27 / 3600.0);
    final double gLatK = (21.0 + 25.0 / 60.0 + 21.02 / 3600.0);

    final double d = mf.deg(
      math.acos(
        math.sin(mf.rad(gLat)) * math.sin(mf.rad(gLatK)) +
            math.cos(mf.rad(gLat)) *
                math.cos(mf.rad(gLatK)) *
                math.cos(mf.rad(gLonK - gLon)),
      ),
    );

    final double s = 6378.137 * d / 57.2957795;
    return s;
  }

  double jarakQiblatEllipsoid(double gLon, double gLat) {
    const double pi2 = 3.14159265358979;

    final gLatK = (21.0 + 25.0 / 60.0 + 21.02 / 3600.0);
    final gLonK = (39.0 + 49.0 / 60.0 + 34.27 / 3600.0);

    final u = (gLatK + gLat) / 2.0;
    final g = (gLatK - gLat) / 2.0;
    final j = (gLonK - gLon) / 2.0;

    final m =
        math.pow(math.sin(mf.rad(g)), 2.0) *
            math.pow(math.cos(mf.rad(j)), 2.0) +
        math.pow(math.cos(mf.rad(u)), 2.0) * math.pow(math.sin(mf.rad(j)), 2.0);

    final n =
        math.pow(math.cos(mf.rad(g)), 2.0) *
            math.pow(math.cos(mf.rad(j)), 2.0) +
        math.pow(math.sin(mf.rad(u)), 2.0) * math.pow(math.sin(mf.rad(j)), 2.0);

    final w = math.atan(math.sqrt(m / n));
    final p = (math.sqrt(m * n)) / w;

    final d = mf.deg(((2 * w) * 6378.137) / (180.0 / pi2));

    final e1 = ((3 * p) - 1) / (2 * n);
    final e2 = ((3 * p) + 1) / (2 * m);

    const f = 1 / 298.25722;

    final s =
        d *
        (1 +
            f *
                e1 *
                math.pow(math.sin(mf.rad(u)), 2.0) *
                math.pow(math.cos(mf.rad(g)), 2.0) -
            f *
                e2 *
                math.pow(math.cos(mf.rad(u)), 2.0) *
                math.pow(math.sin(mf.rad(g)), 2.0));

    return s;
  }

  double bayanganQiblatHarian(
    double gLon,
    double gLat,
    int tglM,
    int blnM,
    int thnM,
    double tmZn,
    String azQiblat,
    int opt,
  ) {
    double jd, jde, dm, e, azQ, b, p, ca, bq;

    bq = 12.0;

    for (int i = 1; i <= 3; i++) {
      jd = julianDay.kmjd(tglM, blnM, thnM, bq, tmZn);
      jde = jd + dynamicalTime.deltaT(jd) / 86400.0;
      dm = sn.sunGeocentricDeclination(jde, 0.0);
      e = sn.equationOfTime(jde, 0.0);

      // Pilih metode azimut kiblat
      switch (azQiblat.toLowerCase()) {
        case "ellipsoid":
          azQ = arahQiblaWithEllipsoidCorrection(gLon, gLat);
          break;
        case "vincenty":
          azQ = arahQiblaVincenty(gLon, gLat, "PtoQ");
          break;
        default: // spherical
          azQ = arahQiblatSpherical(gLon, gLat);
      }

      b = 90 - gLat;

      p = mf.deg(math.atan(1 / (math.cos(mf.rad(b)) * math.tan(mf.rad(azQ)))));
      ca = mf.deg(
        math.acos(
          math.tan(mf.rad(dm)) * math.tan(mf.rad(b)) * math.cos(mf.rad(p)),
        ),
      );

      switch (opt) {
        case 1:
          bq = mf.mod(
            (-(p - ca) / 15) + (12 - e) + ((tmZn * 15) - gLon) / 15,
            24.0,
          );
          break;
        case 2:
          bq = mf.mod(
            (-(p + ca) / 15) + (12 - e) + ((tmZn * 15) - gLon) / 15,
            24.0,
          );
          break;
        default:
          bq = 0.0;
      }
    }

    return mf.mod(bq, 24.0);
  }

  String rashdulQiblat(int thnM, double tmZn, int opt) {
    final double gLatK = 21.0 + 25.0 / 60.0 + 21.02 / 3600.0;
    final double gLonK = 39.0 + 49.0 / 60.0 + 34.27 / 3600.0;
    final double tmZnK = 3.0;

    double jd01, jd02, jd03;
    double jde1, jde2, jde3;
    double eoT1, eoT2, eoT3;
    double trs1 = 12.0;
    double trs2 = 12.0;
    double trs3 = 12.0;
    double jdResult = 0.0;

    // Loop bulan
    bulanLoop:
    for (int n = 1; n <= 12; n++) {
      // Loop tanggal
      for (int i = 1; i <= 31; i++) {
        for (int z = 1; z <= 3; z++) {
          jd01 = julianDay.kmjd(i, n, thnM, trs1, tmZnK);
          jde1 = jd01 + (dynamicalTime.deltaT(jd01) / 86400.0);
          eoT1 = sn.equationOfTime(jde1, 0.0);
          trs1 = 12 - eoT1 - (gLonK - (tmZnK * 15)) / 15;

          jd02 = julianDay.kmjd(i + 1, n, thnM, trs2, tmZnK);
          jde2 = jd02 + (dynamicalTime.deltaT(jd02) / 86400.0);
          eoT2 = sn.equationOfTime(jde2, 0.0);
          trs2 = 12 - eoT2 - (gLonK - (tmZnK * 15)) / 15;

          jd03 = julianDay.kmjd(i + 2, n, thnM, trs3, tmZnK);
          jde3 = jd03 + (dynamicalTime.deltaT(jd03) / 86400.0);
          eoT3 = sn.equationOfTime(jde3, 0.0);
          trs3 = 12 - eoT3 - (gLonK - (tmZnK * 15)) / 15;
        }

        final double jd1 = julianDay.kmjd(i, n, thnM, trs1, tmZnK);
        final double jd2 = julianDay.kmjd(i + 1, n, thnM, trs2, tmZnK);
        final double jd3 = julianDay.kmjd(i + 2, n, thnM, trs3, tmZnK);

        final double dS01 = sn.sunGeocentricDeclination(
          jd1 + dynamicalTime.deltaT(jd1) / 86400.0,
          0.0,
        );
        final double dS02 = sn.sunGeocentricDeclination(
          jd2 + dynamicalTime.deltaT(jd2) / 86400.0,
          0.0,
        );
        final double dS03 = sn.sunGeocentricDeclination(
          jd3 + dynamicalTime.deltaT(jd3) / 86400.0,
          0.0,
        );

        final double dlt1 = (gLatK - dS01).abs();
        final double dlt2 = (gLatK - dS02).abs();
        final double dlt3 = (gLatK - dS03).abs();

        if ((dlt1 > dlt2) && (dlt2 < dlt3)) {
          jdResult = jd2;

          switch (opt) {
            case 1:
              break bulanLoop; // keluar total
            case 2:
              continue bulanLoop; // lompat ke bulan berikutnya
          }
        }
      }
    }

    final double dm = sn.sunGeocentricDeclination(jdResult, 0.0);
    final double h = 90.0 - (gLatK - dm).abs();

    return "${julianDay.jdkm(jdResult, tmZn)}, "
        "Jam: ${mf.dhhm(double.parse(julianDay.jdkm(jdResult, tmZn, "JAM DES")), optResult: "HH:MM", minDecPlaces: 0, posNegSign: "")}, "
        "Tinggi: ${mf.roundTo(h, place: 2)}°, "
        "Deklinasi: ${mf.dddms(dm, optResult: "DDMMSS", sdp: 0)}";
  }

  String antipodaKabah(int thnM, double tmZn, int opt) {
    final double gLatK = -(21.0 + 25.0 / 60.0 + 21.02 / 3600.0);
    final double gLonK = 39.0 + 49.0 / 60.0 + 34.27 / 3600.0;
    final double tmZnK = 3.0;

    double jd01, jd02, jd03;
    double jde1, jde2, jde3;
    double eoT1, eoT2, eoT3;
    double trs1 = 24.0;
    double trs2 = 24.0;
    double trs3 = 24.0;
    double jdResult = 0.0;

    // Loop bulan
    bulanLoop:
    for (int n = 1; n <= 12; n++) {
      // Loop tanggal
      for (int i = 1; i <= 31; i++) {
        for (int z = 1; z <= 3; z++) {
          jd01 = julianDay.kmjd(i, n, thnM, trs1, tmZnK);
          jde1 = jd01 + (dynamicalTime.deltaT(jd01) / 86400.0);
          eoT1 = sn.equationOfTime(jde1, 0.0);
          trs1 = 24 - eoT1 - (gLonK - (tmZnK * 15)) / 15;

          jd02 = julianDay.kmjd(i + 1, n, thnM, trs2, tmZnK);
          jde2 = jd02 + (dynamicalTime.deltaT(jd02) / 86400.0);
          eoT2 = sn.equationOfTime(jde2, 0.0);
          trs2 = 24 - eoT2 - (gLonK - (tmZnK * 15)) / 15;

          jd03 = julianDay.kmjd(i + 2, n, thnM, trs3, tmZnK);
          jde3 = jd03 + (dynamicalTime.deltaT(jd03) / 86400.0);
          eoT3 = sn.equationOfTime(jde3, 0.0);
          trs3 = 24 - eoT3 - (gLonK - (tmZnK * 15)) / 15;
        }

        final double jd1 = julianDay.kmjd(i, n, thnM, trs1, tmZnK);
        final double jd2 = julianDay.kmjd(i + 1, n, thnM, trs2, tmZnK);
        final double jd3 = julianDay.kmjd(i + 2, n, thnM, trs3, tmZnK);

        final double dS01 = sn.sunGeocentricDeclination(
          jd1 + dynamicalTime.deltaT(jd1) / 86400.0,
          0.0,
        );
        final double dS02 = sn.sunGeocentricDeclination(
          jd2 + dynamicalTime.deltaT(jd2) / 86400.0,
          0.0,
        );
        final double dS03 = sn.sunGeocentricDeclination(
          jd3 + dynamicalTime.deltaT(jd3) / 86400.0,
          0.0,
        );

        final double dlt1 = (gLatK - dS01).abs();
        final double dlt2 = (gLatK - dS02).abs();
        final double dlt3 = (gLatK - dS03).abs();

        if ((dlt1 > dlt2) && (dlt2 < dlt3)) {
          jdResult = jd2;

          switch (opt) {
            case 1:
              break bulanLoop; // keluar total
            case 2:
              continue bulanLoop; // lompat ke bulan berikutnya
          }
        }
      }
    }

    final double dm = sn.sunGeocentricDeclination(jdResult, 0.0);
    final double h = 90.0 - (gLatK - dm).abs();

    return "${julianDay.jdkm(jdResult, tmZn)}, "
        "Jam: ${mf.dhhm(double.parse(julianDay.jdkm(jdResult, tmZn, "JAM DES")), optResult: "HH:MM", minDecPlaces: 0, posNegSign: "")}, "
        "Tinggi: ${mf.roundTo(h, place: 2)}°, "
        "Deklinasi: ${mf.dddms(dm, optResult: "DDMMSS", sdp: 0)}";
  }
}
