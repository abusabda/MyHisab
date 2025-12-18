import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_distance.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/sun_function.dart';

final julianDay = JulianDay();
final dynamicalTime = DynamicalTime();

final sn = SunFunction();
final mf = MathFunction();
final mo = MoonFunction();
final md = MoonDistance();

class SolarEclipseService {
  double sBesselian(int hijriMonth, int hijriYear, String optResult) {
    final jdeSolarEclipse1 = mo.jdeEclipseModified(hijriMonth, hijriYear, 1);

    if (jdeSolarEclipse1 <= 0) return double.nan;

    final jdeSolarEclipse2 =
        mf.floor(jdeSolarEclipse1) +
        (((jdeSolarEclipse1 - mf.floor(jdeSolarEclipse1)) * 24).round()) / 24.0;

    final t0 = mf.mod(
      (((jdeSolarEclipse2 - mf.floor(jdeSolarEclipse2)) * 24).round())
          .toDouble(),
      24.0,
    );

    final deltaT = dynamicalTime.deltaT(jdeSolarEclipse2);

    // === SUN ===
    final arSm2 = sn.sunGeocentricRightAscension(jdeSolarEclipse2 - 2 / 24, 0);
    final arSm1 = sn.sunGeocentricRightAscension(jdeSolarEclipse2 - 1 / 24, 0);
    final arS00 = sn.sunGeocentricRightAscension(jdeSolarEclipse2, 0);
    final arSp1 = sn.sunGeocentricRightAscension(jdeSolarEclipse2 + 1 / 24, 0);
    final arSp2 = sn.sunGeocentricRightAscension(jdeSolarEclipse2 + 2 / 24, 0);

    final dSm2 = sn.sunGeocentricDeclination(jdeSolarEclipse2 - 2 / 24, 0);
    final dSm1 = sn.sunGeocentricDeclination(jdeSolarEclipse2 - 1 / 24, 0);
    final dS00 = sn.sunGeocentricDeclination(jdeSolarEclipse2, 0);
    final dSp1 = sn.sunGeocentricDeclination(jdeSolarEclipse2 + 1 / 24, 0);
    final dSp2 = sn.sunGeocentricDeclination(jdeSolarEclipse2 + 2 / 24, 0);

    final rSm2 = sn.sunGeocentricDistance(jdeSolarEclipse2 - 2 / 24, 0, "AU");
    final rSm1 = sn.sunGeocentricDistance(jdeSolarEclipse2 - 1 / 24, 0, "AU");
    final rS00 = sn.sunGeocentricDistance(jdeSolarEclipse2, 0, "AU");
    final rSp1 = sn.sunGeocentricDistance(jdeSolarEclipse2 + 1 / 24, 0, "AU");
    final rSp2 = sn.sunGeocentricDistance(jdeSolarEclipse2 + 2 / 24, 0, "AU");

    final ghaSm2 = sn.sunGeocentricGreenwichHourAngle(
      jdeSolarEclipse2 - 2 / 24,
      0,
    );
    final ghaSm1 = sn.sunGeocentricGreenwichHourAngle(
      jdeSolarEclipse2 - 1 / 24,
      0,
    );
    final ghaS00 = sn.sunGeocentricGreenwichHourAngle(jdeSolarEclipse2, 0);
    final ghaSp1 = sn.sunGeocentricGreenwichHourAngle(
      jdeSolarEclipse2 + 1 / 24,
      0,
    );
    final ghaSp2 = sn.sunGeocentricGreenwichHourAngle(
      jdeSolarEclipse2 + 2 / 24,
      0,
    );

    // === MOON ===
    final arMm2 = mo.moonGeocentricRightAscension(jdeSolarEclipse2 - 2 / 24, 0);
    final arMm1 = mo.moonGeocentricRightAscension(jdeSolarEclipse2 - 1 / 24, 0);
    final arM00 = mo.moonGeocentricRightAscension(jdeSolarEclipse2, 0);
    final arMp1 = mo.moonGeocentricRightAscension(jdeSolarEclipse2 + 1 / 24, 0);
    final arMp2 = mo.moonGeocentricRightAscension(jdeSolarEclipse2 + 2 / 24, 0);

    final dMm2 = mo.moonGeocentricDeclination(jdeSolarEclipse2 - 2 / 24, 0);
    final dMm1 = mo.moonGeocentricDeclination(jdeSolarEclipse2 - 1 / 24, 0);
    final dM00 = mo.moonGeocentricDeclination(jdeSolarEclipse2, 0);
    final dMp1 = mo.moonGeocentricDeclination(jdeSolarEclipse2 + 1 / 24, 0);
    final dMp2 = mo.moonGeocentricDeclination(jdeSolarEclipse2 + 2 / 24, 0);

    final rMm2 = md.moonGeocentricDistance(jdeSolarEclipse2 - 2 / 24, 0, "AU");
    final rMm1 = md.moonGeocentricDistance(jdeSolarEclipse2 - 1 / 24, 0, "AU");
    final rM00 = md.moonGeocentricDistance(jdeSolarEclipse2, 0, "AU");
    final rMp1 = md.moonGeocentricDistance(jdeSolarEclipse2 + 1 / 24, 0, "AU");
    final rMp2 = md.moonGeocentricDistance(jdeSolarEclipse2 + 2 / 24, 0, "AU");

    final hpMm2 = mo.moonEquatorialHorizontalParallax(
      jdeSolarEclipse2 - 2 / 24,
      0,
    );
    final hpMm1 = mo.moonEquatorialHorizontalParallax(
      jdeSolarEclipse2 - 1 / 24,
      0,
    );
    final hpM00 = mo.moonEquatorialHorizontalParallax(jdeSolarEclipse2, 0);
    final hpMp1 = mo.moonEquatorialHorizontalParallax(
      jdeSolarEclipse2 + 1 / 24,
      0,
    );
    final hpMp2 = mo.moonEquatorialHorizontalParallax(
      jdeSolarEclipse2 + 2 / 24,
      0,
    );

    // === bm ===
    final bm2 =
        math.sin(mf.rad(8.794 / 3600.0)) / rSm2 / math.sin(mf.rad(hpMm2));
    final bm1 =
        math.sin(mf.rad(8.794 / 3600.0)) / rSm1 / math.sin(mf.rad(hpMm1));
    final b00 =
        math.sin(mf.rad(8.794 / 3600.0)) / rS00 / math.sin(mf.rad(hpM00));
    final bp1 =
        math.sin(mf.rad(8.794 / 3600.0)) / rSp1 / math.sin(mf.rad(hpMp1));
    final bp2 =
        math.sin(mf.rad(8.794 / 3600.0)) / rSp2 / math.sin(mf.rad(hpMp2));

    // === g1 ===
    final g1m2 =
        math.cos(mf.rad(dSm2)) * math.cos(mf.rad(arSm2)) -
        bm2 * math.cos(mf.rad(dMm2)) * math.cos(mf.rad(arMm2));
    final g1m1 =
        math.cos(mf.rad(dSm1)) * math.cos(mf.rad(arSm1)) -
        bm1 * math.cos(mf.rad(dMm1)) * math.cos(mf.rad(arMm1));
    final g100 =
        math.cos(mf.rad(dS00)) * math.cos(mf.rad(arS00)) -
        b00 * math.cos(mf.rad(dM00)) * math.cos(mf.rad(arM00));
    final g1p1 =
        math.cos(mf.rad(dSp1)) * math.cos(mf.rad(arSp1)) -
        bp1 * math.cos(mf.rad(dMp1)) * math.cos(mf.rad(arMp1));
    final g1p2 =
        math.cos(mf.rad(dSp2)) * math.cos(mf.rad(arSp2)) -
        bp2 * math.cos(mf.rad(dMp2)) * math.cos(mf.rad(arMp2));

    // === g2 ===
    final g2m2 =
        math.cos(mf.rad(dSm2)) * math.sin(mf.rad(arSm2)) -
        bm2 * math.cos(mf.rad(dMm2)) * math.sin(mf.rad(arMm2));
    final g2m1 =
        math.cos(mf.rad(dSm1)) * math.sin(mf.rad(arSm1)) -
        bm1 * math.cos(mf.rad(dMm1)) * math.sin(mf.rad(arMm1));
    final g200 =
        math.cos(mf.rad(dS00)) * math.sin(mf.rad(arS00)) -
        b00 * math.cos(mf.rad(dM00)) * math.sin(mf.rad(arM00));
    final g2p1 =
        math.cos(mf.rad(dSp1)) * math.sin(mf.rad(arSp1)) -
        bp1 * math.cos(mf.rad(dMp1)) * math.sin(mf.rad(arMp1));
    final g2p2 =
        math.cos(mf.rad(dSp2)) * math.sin(mf.rad(arSp2)) -
        bp2 * math.cos(mf.rad(dMp2)) * math.sin(mf.rad(arMp2));

    // === g3 ===
    final g3m2 = math.sin(mf.rad(dSm2)) - bm2 * math.sin(mf.rad(dMm2));
    final g3m1 = math.sin(mf.rad(dSm1)) - bm1 * math.sin(mf.rad(dMm1));
    final g300 = math.sin(mf.rad(dS00)) - b00 * math.sin(mf.rad(dM00));
    final g3p1 = math.sin(mf.rad(dSp1)) - bp1 * math.sin(mf.rad(dMp1));
    final g3p2 = math.sin(mf.rad(dSp2)) - bp2 * math.sin(mf.rad(dMp2));

    // === a ===
    final am2 = mf.mod(mf.deg(math.atan2(g2m2, g1m2)), 360.0);
    final am1 = mf.mod(mf.deg(math.atan2(g2m1, g1m1)), 360.0);
    final a00 = mf.mod(mf.deg(math.atan2(g200, g100)), 360.0);
    final ap1 = mf.mod(mf.deg(math.atan2(g2p1, g1p1)), 360.0);
    final ap2 = mf.mod(mf.deg(math.atan2(g2p2, g1p2)), 360.0);

    // === d ===
    double dm(double g3, double g1, double g2) =>
        mf.deg(math.atan(g3 / math.sqrt(g1 * g1 + g2 * g2)));

    final dm2 = dm(g3m2, g1m2, g2m2);
    final dm1 = dm(g3m1, g1m1, g2m1);
    final d00 = dm(g300, g100, g200);
    final dp1 = dm(g3p1, g1p1, g2p1);
    final dp2 = dm(g3p2, g1p2, g2p2);

    // === gm ===
    double gm(double g1, double g2, double g3) =>
        math.sqrt(g1 * g1 + g2 * g2 + g3 * g3);

    final gm2 = gm(g1m2, g2m2, g3m2);
    final gm1 = gm(g1m1, g2m1, g3m1);
    final g00 = gm(g100, g200, g300);
    final gp1 = gm(g1p1, g2p1, g3p1);
    final gp2 = gm(g1p2, g2p2, g3p2);

    // === xm ===
    double xm(double dM, double aM, double a, double hp) =>
        (math.cos(mf.rad(dM)) * math.sin(mf.rad(aM - a))) /
        math.sin(mf.rad(hp));

    final xm2 = xm(dMm2, arMm2, am2, hpMm2);
    final xm1 = xm(dMm1, arMm1, am1, hpMm1);
    final x00 = xm(dM00, arM00, a00, hpM00);
    final xp1 = xm(dMp1, arMp1, ap1, hpMp1);
    final xp2 = xm(dMp2, arMp2, ap2, hpMp2);

    // === ym ===
    double ym(double dM, double d, double aM, double a, double hp) =>
        (math.sin(mf.rad(dM)) * math.cos(mf.rad(d)) -
            math.cos(mf.rad(dM)) *
                math.sin(mf.rad(d)) *
                math.cos(mf.rad(aM - a))) /
        math.sin(mf.rad(hp));

    final ym2 = ym(dMm2, dm2, arMm2, am2, hpMm2);
    final ym1 = ym(dMm1, dm1, arMm1, am1, hpMm1);
    final y00 = ym(dM00, d00, arM00, a00, hpM00);
    final yp1 = ym(dMp1, dp1, arMp1, ap1, hpMp1);
    final yp2 = ym(dMp2, dp2, arMp2, ap2, hpMp2);

    // === zm ===
    double zm(double dM, double d, double aM, double a, double hp) =>
        (math.sin(mf.rad(dM)) * math.sin(mf.rad(d)) +
            math.cos(mf.rad(dM)) *
                math.cos(mf.rad(d)) *
                math.cos(mf.rad(aM - a))) /
        math.sin(mf.rad(hp));

    final zm2 = zm(dMm2, dm2, arMm2, am2, hpMm2);
    final zm1 = zm(dMm1, dm1, arMm1, am1, hpMm1);
    final z00 = zm(dM00, d00, arM00, a00, hpM00);
    final zp1 = zm(dMp1, dp1, arMp1, ap1, hpMp1);
    final zp2 = zm(dMp2, dp2, arMp2, ap2, hpMp2);

    // === sin(f1,f2) ===
    final sinf1m2 = 0.004664026 / (gm2 * rSm2);
    final sinf1m1 = 0.004664026 / (gm1 * rSm1);
    final sinf100 = 0.004664026 / (g00 * rS00);
    final sinf1p1 = 0.004664026 / (gp1 * rSp1);
    final sinf1p2 = 0.004664026 / (gp2 * rSp2);

    final sinf2m2 = 0.004640784 / (gm2 * rSm2);
    final sinf2m1 = 0.004640784 / (gm1 * rSm1);
    final sinf200 = 0.004640784 / (g00 * rS00);
    final sinf2p1 = 0.004640784 / (gp1 * rSp1);
    final sinf2p2 = 0.004640784 / (gp2 * rSp2);

    // === tan(f1,f2) ===
    final tanf1m2 = math.tan(math.asin(sinf1m2));
    final tanf1m1 = math.tan(math.asin(sinf1m1));
    final tanf100 = math.tan(math.asin(sinf100));
    final tanf1p1 = math.tan(math.asin(sinf1p1));
    final tanf1p2 = math.tan(math.asin(sinf1p2));

    final tanf2m2 = math.tan(math.asin(sinf2m2));
    final tanf2m1 = math.tan(math.asin(sinf2m1));
    final tanf200 = math.tan(math.asin(sinf200));
    final tanf2p1 = math.tan(math.asin(sinf2p1));
    final tanf2p2 = math.tan(math.asin(sinf2p2));

    // === C1 & C2 ===
    final c1m2 = zm2 + 0.2724880 / sinf1m2;
    final c1m1 = zm1 + 0.2724880 / sinf1m1;
    final c100 = z00 + 0.2724880 / sinf100;
    final c1p1 = zp1 + 0.2724880 / sinf1p1;
    final c1p2 = zp2 + 0.2724880 / sinf1p2;

    final c2m2 = zm2 - 0.2722810 / sinf2m2;
    final c2m1 = zm1 - 0.2722810 / sinf2m1;
    final c200 = z00 - 0.2722810 / sinf200;
    final c2p1 = zp1 - 0.2722810 / sinf2p1;
    final c2p2 = zp2 - 0.2722810 / sinf2p2;

    // === l1 l2 ===
    final l1m2 = c1m2 * tanf1m2;
    final l1m1 = c1m1 * tanf1m1;
    final l100 = c100 * tanf100;
    final l1p1 = c1p1 * tanf1p1;
    final l1p2 = c1p2 * tanf1p2;

    final l2m2 = c2m2 * tanf2m2;
    final l2m1 = c2m1 * tanf2m1;
    final l200 = c200 * tanf200;
    final l2p1 = c2p1 * tanf2p1;
    final l2p2 = c2p2 * tanf2p2;

    // === GAST → mu ===
    final gastm2 = sn.greenwichApparentSiderialTime(
      jdeSolarEclipse2 - 2 / 24,
      0,
    );
    final gastm1 = sn.greenwichApparentSiderialTime(
      jdeSolarEclipse2 - 1 / 24,
      0,
    );
    final gast00 = sn.greenwichApparentSiderialTime(jdeSolarEclipse2, 0);
    final gastp1 = sn.greenwichApparentSiderialTime(
      jdeSolarEclipse2 + 1 / 24,
      0,
    );
    final gastp2 = sn.greenwichApparentSiderialTime(
      jdeSolarEclipse2 + 2 / 24,
      0,
    );

    final mum2 = mf.mod(gastm2 - am2, 360.0);
    final mum1 = mf.mod(gastm1 - am1, 360.0);
    final mu00 = mf.mod(gast00 - a00, 360.0);
    final mup1 = mf.mod(gastp1 - ap1, 360.0);
    final mup2 = mf.mod(gastp2 - ap2, 360.0);

    // ---------------- Hasil Interpolasi ----------------

    switch (optResult) {
      case "JDS":
        return jdeSolarEclipse2;

      case "DT":
        return deltaT;

      // x
      case "x0":
        return mf.interp5(xm2, xm1, x00, xp1, xp2, 0);
      case "x1":
        return mf.interp5(xm2, xm1, x00, xp1, xp2, 1);
      case "x2":
        return mf.interp5(xm2, xm1, x00, xp1, xp2, 2);
      case "x3":
        return mf.interp5(xm2, xm1, x00, xp1, xp2, 3);
      case "x4":
        return mf.interp5(xm2, xm1, x00, xp1, xp2, 4);

      // y
      case "y0":
        return mf.interp5(ym2, ym1, y00, yp1, yp2, 0);
      case "y1":
        return mf.interp5(ym2, ym1, y00, yp1, yp2, 1);
      case "y2":
        return mf.interp5(ym2, ym1, y00, yp1, yp2, 2);
      case "y3":
        return mf.interp5(ym2, ym1, y00, yp1, yp2, 3);
      case "y4":
        return mf.interp5(ym2, ym1, y00, yp1, yp2, 4);

      // d
      case "d0":
        return mf.interp5(dm2, dm1, d00, dp1, dp2, 0);
      case "d1":
        return mf.interp5(dm2, dm1, d00, dp1, dp2, 1);
      case "d2":
        return mf.interp5(dm2, dm1, d00, dp1, dp2, 2);
      case "d3":
        return mf.interp5(dm2, dm1, d00, dp1, dp2, 3);
      case "d4":
        return mf.interp5(dm2, dm1, d00, dp1, dp2, 4);

      // l1
      case "l10":
        return mf.interp5(l1m2, l1m1, l100, l1p1, l1p2, 0);
      case "l11":
        return mf.interp5(l1m2, l1m1, l100, l1p1, l1p2, 1);
      case "l12":
        return mf.interp5(l1m2, l1m1, l100, l1p1, l1p2, 2);
      case "l13":
        return mf.interp5(l1m2, l1m1, l100, l1p1, l1p2, 3);
      case "l14":
        return mf.interp5(l1m2, l1m1, l100, l1p1, l1p2, 4);

      // l2
      case "l20":
        return mf.interp5(l2m2, l2m1, l200, l2p1, l2p2, 0);
      case "l21":
        return mf.interp5(l2m2, l2m1, l200, l2p1, l2p2, 1);
      case "l22":
        return mf.interp5(l2m2, l2m1, l200, l2p1, l2p2, 2);
      case "l23":
        return mf.interp5(l2m2, l2m1, l200, l2p1, l2p2, 3);
      case "l24":
        return mf.interp5(l2m2, l2m1, l200, l2p1, l2p2, 4);

      // mu
      case "mu0":
        return mf.interp5(mum2, mum1, mu00, mup1, mup2, 0);
      case "mu1":
        return mf.interp5(mum2, mum1, mu00, mup1, mup2, 1);
      case "mu2":
        return mf.interp5(mum2, mum1, mu00, mup1, mup2, 2);
      case "mu3":
        return mf.interp5(mum2, mum1, mu00, mup1, mup2, 3);
      case "mu4":
        return mf.interp5(mum2, mum1, mu00, mup1, mup2, 4);

      // f1,f2
      case "f1":
        return tanf100;
      case "f2":
        return tanf200;

      // SUN raw
      case "dSm2":
        return dSm2;
      case "dSm1":
        return dSm1;
      case "dS00":
        return dS00;
      case "dSp1":
        return dSp1;
      case "dSp2":
        return dSp2;

      case "arSm2":
        return arSm2;
      case "arSm1":
        return arSm1;
      case "arS00":
        return arS00;
      case "arSp1":
        return arSp1;
      case "arSp2":
        return arSp2;

      case "rSm2":
        return rSm2;
      case "rSm1":
        return rSm1;
      case "rS00":
        return rS00;
      case "rSp1":
        return rSp1;
      case "rSp2":
        return rSp2;

      case "ghaSm2":
        return ghaSm2;
      case "ghaSm1":
        return ghaSm1;
      case "ghaS00":
        return ghaS00;
      case "ghaSp1":
        return ghaSp1;
      case "ghaSp2":
        return ghaSp2;

      // MOON raw
      case "dMm2":
        return dMm2;
      case "dMm1":
        return dMm1;
      case "dM00":
        return dM00;
      case "dMp1":
        return dMp1;
      case "dMp2":
        return dMp2;

      case "arMm2":
        return arMm2;
      case "arMm1":
        return arMm1;
      case "arM00":
        return arM00;
      case "arMp1":
        return arMp1;
      case "arMp2":
        return arMp2;

      case "rMm2":
        return rMm2;
      case "rMm1":
        return rMm1;
      case "rM00":
        return rM00;
      case "rMp1":
        return rMp1;
      case "rMp2":
        return rMp2;

      case "hpMm2":
        return hpMm2;
      case "hpMm1":
        return hpMm1;
      case "hpM00":
        return hpM00;
      case "hpMp1":
        return hpMp1;
      case "hpMp2":
        return hpMp2;

      case "bm2":
        return bm2;
      case "bm1":
        return bm1;
      case "b00":
        return b00;
      case "bp1":
        return bp1;
      case "bp2":
        return bp2;

      case "g1m2":
        return g1m2;
      case "g1m1":
        return g1m1;
      case "g100":
        return g100;
      case "g1p1":
        return g1p1;
      case "g1p2":
        return g1p2;

      case "g2m2":
        return g2m2;
      case "g2m1":
        return g2m1;
      case "g200":
        return g200;
      case "g2p1":
        return g2p1;
      case "g2p2":
        return g2p2;

      case "g3m2":
        return g3m2;
      case "g3m1":
        return g3m1;
      case "g300":
        return g300;
      case "g3p1":
        return g3p1;
      case "g3p2":
        return g3p2;

      default:
        return mf.mod(t0 + 12, 24.0);
    }
  }

  Map<String, dynamic> solarEclipseLocal({
    required int blnH,
    required int thnH,
    required double gLon,
    required double gLat,
    required double elev,
    required double tmZn,
  }) {
    // ===================== Variabel =====================
    double tMx = 0.0;
    double pi = 0.0;
    double S = 0.0;
    double C = 0.0;
    double xMx = 0.0;
    double yMx = 0.0;
    double dMx = 0.0;
    double muMx = 0.0;
    double l1Mx = 0.0;
    double l2Mx = 0.0;
    double xpMx = 0.0;
    double ypMx = 0.0;
    double hMx = 0.0;
    double pMx = 0.0;
    double qMx = 0.0;
    double rMx = 0.0;
    double prMx = 0.0;
    double qpMx = 0.0;
    double uMx = 0.0;
    double vMx = 0.0;
    double aMx = 0.0;
    double bMx = 0.0;
    double nMx = 0.0;
    double ppMx = 0.0;
    double aaMx = 0.0;

    // ===================== Data Besselian =====================
    final x0 = sBesselian(blnH, thnH, "x0");
    final x1 = sBesselian(blnH, thnH, "x1");
    final x2 = sBesselian(blnH, thnH, "x2");
    final x3 = sBesselian(blnH, thnH, "x3");
    final x4 = sBesselian(blnH, thnH, "x4");

    final y0 = sBesselian(blnH, thnH, "y0");
    final y1 = sBesselian(blnH, thnH, "y1");
    final y2 = sBesselian(blnH, thnH, "y2");
    final y3 = sBesselian(blnH, thnH, "y3");
    final y4 = sBesselian(blnH, thnH, "y4");

    final d0 = sBesselian(blnH, thnH, "d0");
    final d1 = sBesselian(blnH, thnH, "d1");
    final d2 = sBesselian(blnH, thnH, "d2");
    final d3 = sBesselian(blnH, thnH, "d3");
    final d4 = sBesselian(blnH, thnH, "d4");

    final mu0 = sBesselian(blnH, thnH, "mu0");
    final mu1 = sBesselian(blnH, thnH, "mu1");
    final mu2 = sBesselian(blnH, thnH, "mu2");
    final mu3 = sBesselian(blnH, thnH, "mu3");
    final mu4 = sBesselian(blnH, thnH, "mu4");

    final l10 = sBesselian(blnH, thnH, "l10");
    final l11 = sBesselian(blnH, thnH, "l11");
    final l12 = sBesselian(blnH, thnH, "l12");
    final l13 = sBesselian(blnH, thnH, "l13");
    final l14 = sBesselian(blnH, thnH, "l14");

    final l20 = sBesselian(blnH, thnH, "l20");
    final l21 = sBesselian(blnH, thnH, "l21");
    final l22 = sBesselian(blnH, thnH, "l22");
    final l23 = sBesselian(blnH, thnH, "l23");
    final l24 = sBesselian(blnH, thnH, "l24");

    final tanf1 = sBesselian(blnH, thnH, "f1");
    final tanf2 = sBesselian(blnH, thnH, "f2");

    // ===================== Waktu Gerhana =====================
    final jde1 = mo.jdeEclipseModified(blnH, thnH, 1);
    final jde2 =
        (jde1.floor()) + (((jde1 - jde1.floor()) * 24).roundToDouble()) / 24.0;

    final deltaT = dynamicalTime.deltaT(jde2);
    final t0 = (((jde2 + 0.5) - (jde2 + 0.5).floor()) * 24).roundToDouble();

    tMx += ppMx;

    // ===================== Iterasi 5 kali =====================
    for (int i = 1; i <= 5; i++) {
      pi = math.atan(0.99664719 * math.tan(mf.rad(gLat)));

      S = 0.99664719 * math.sin(pi) + (elev / 6378140) * math.sin(mf.rad(gLat));
      C = math.cos(pi) + (elev / 6378140) * math.cos(mf.rad(gLat));

      xMx =
          x0 +
          x1 * tMx +
          x2 * tMx * tMx +
          x3 * tMx * tMx * tMx +
          x4 * tMx * tMx * tMx * tMx;
      yMx =
          y0 +
          y1 * tMx +
          y2 * tMx * tMx +
          y3 * tMx * tMx * tMx +
          y4 * tMx * tMx * tMx * tMx;
      dMx =
          d0 +
          d1 * tMx +
          d2 * tMx * tMx +
          d3 * tMx * tMx * tMx +
          d4 * tMx * tMx * tMx * tMx;

      muMx =
          mu0 +
          mu1 * tMx +
          mu2 * tMx * tMx +
          mu3 * tMx * tMx * tMx +
          mu4 * tMx * tMx * tMx * tMx;

      l1Mx =
          l10 +
          l11 * tMx +
          l12 * tMx * tMx +
          l13 * tMx * tMx * tMx +
          l14 * tMx * tMx * tMx * tMx;
      l2Mx =
          l20 +
          l21 * tMx +
          l22 * tMx * tMx +
          l23 * tMx * tMx * tMx +
          l24 * tMx * tMx * tMx * tMx;

      xpMx = x1 + 2 * x2 * tMx + 3 * x3 * tMx * tMx + 4 * x4 * tMx * tMx * tMx;
      ypMx = y1 + 2 * y2 * tMx + 3 * y3 * tMx * tMx + 4 * y4 * tMx * tMx * tMx;

      hMx = mf.rad(muMx + gLon - 0.00417807 * deltaT);

      pMx = C * math.sin(hMx);
      qMx =
          S * math.cos(mf.rad(dMx)) - C * math.cos(hMx) * math.sin(mf.rad(dMx));
      rMx =
          S * math.sin(mf.rad(dMx)) + C * math.cos(hMx) * math.cos(mf.rad(dMx));

      prMx = 0.01745329 * mu1 * C * math.cos(hMx);
      qpMx = 0.01745329 * (mu1 * pMx * math.sin(mf.rad(dMx)) - rMx * d1);

      uMx = xMx - pMx;
      vMx = yMx - qMx;

      aMx = xpMx - prMx;
      bMx = ypMx - qpMx;

      nMx = aMx * aMx + bMx * bMx;

      ppMx = -(uMx * aMx + vMx * bMx) / nMx;
      tMx += ppMx;
    }

    // ===================== Waktu maksimum gerhana =====================
    aaMx = t0 + tMx - deltaT / 3600.0;
    final jdSolarMx = mf.floor(jde2 + 0.5) - 0.5 + (aaMx / 24.0);

    // ===================== Magnitude & Obskurasi =====================
    final mm = math.sqrt(uMx * uMx + vMx * vMx);
    final l1p = l1Mx - rMx * tanf1;
    final l2p = l2Mx - rMx * tanf2;
    final nn = math.sqrt(nMx);

    final zz = (aMx * vMx - uMx * bMx) / (nn * l1p);
    final tau = (l1p / nn) * math.sqrt(1 - zz * zz);

    final mag = (l1p - mm) / (l1p + l2p);

    final rpMx = 2 * mm / (l1p + l2p);
    final spMx = (l1p - l2p) / (l1p + l2p);

    final yy = (spMx * spMx + rpMx * rpMx - 1) / (2 * rpMx * spMx);
    final zp = (rpMx * rpMx - spMx * spMx + 1) / (2 * rpMx);

    final bb = (yy < -1)
        ? math.pi
        : (yy > 1)
        ? 0.0
        : math.acos(yy);

    final cc = (zp < -1)
        ? math.pi
        : (zp > 1)
        ? 0.0
        : math.acos(zp);

    final obs =
        ((spMx * spMx * (bb - math.sin(2 * bb) / 2) +
                (cc - math.sin(2 * cc) / 2)) /
            math.pi) *
        100.0;

    // ===================== Jenis Gerhana =====================
    String jSE;

    if (mag > 0.0 && mm > l2p.abs()) {
      jSE = "GERHANA MATAHARI SEBAGIAN";
    } else if (mag > 0.0 && mm < l2p.abs() && l2p < 0.0) {
      jSE = "GERHANA MATAHARI TOTAL";
    } else if (mag > 0.0 && mm < l2p.abs() && l2p > 0.0) {
      jSE = "GERHANA MATAHARI CINCIN";
    } else {
      jSE = "TIDAK TERJADI GERHANA";
    }

    final double mag3 = (jSE == "GERHANA MATAHARI SEBAGIAN") ? mag : spMx;

    // Hisab Kontak U2 dan U3
    final double qq = (aMx * vMx - uMx * bMx) / (nn * l2p);
    final double t2 = ((l2p / nn) * math.sqrt(1 - qq * qq)).abs();
    final double aU2 = aaMx - t2;
    final double aU3 = aaMx + t2;
    final double jdSolarU2 = (jde2 + 0.5).floorToDouble() - 0.5 + (aU2 / 24.0);
    final double jdSolarU3 = (jde2 + 0.5).floorToDouble() - 0.5 + (aU3 / 24.0);

    // =======================
    // Hisab Kontak U1
    // =======================

    late double jdSolarU1;

    double t = 0.0;
    double aaU1;
    double tU1;

    double xU1 = 0.0;
    double yU1 = 0.0;
    double dU1 = 0.0;
    double muU1 = 0.0;
    double l1U1 = 0.0;
    double xpU1 = 0.0;
    double ypU1 = 0.0;
    double hU1 = 0.0;
    double pU1 = 0.0;
    double qU1 = 0.0;
    double rU1 = 0.0;
    double prU1 = 0.0;
    double qpU1 = 0.0;
    double uU1 = 0.0;
    double vU1 = 0.0;
    double aU1 = 0.0;
    double bU1 = 0.0;
    double nU1 = 0.0;
    double nnU1 = 0.0;
    double l1pU1 = 0.0;
    double mmU1 = 0.0;
    double ppU1 = 0.0;

    tU1 = t - tau;

    for (int i = 0; i < 5; i++) {
      final pi = math.atan(0.99664719 * math.tan(mf.rad(gLat)));
      final s =
          0.99664719 * math.sin(pi) + (elev / 6378140) * math.sin(mf.rad(gLat));
      final c = math.cos(pi) + (elev / 6378140) * math.cos(mf.rad(gLat));

      xU1 =
          x0 +
          x1 * tU1 +
          x2 * tU1 * tU1 +
          x3 * math.pow(tU1, 3) +
          x4 * math.pow(tU1, 4);
      yU1 =
          y0 +
          y1 * tU1 +
          y2 * tU1 * tU1 +
          y3 * math.pow(tU1, 3) +
          y4 * math.pow(tU1, 4);
      dU1 =
          d0 +
          d1 * tU1 +
          d2 * tU1 * tU1 +
          d3 * math.pow(tU1, 3) +
          d4 * math.pow(tU1, 4);
      muU1 =
          mu0 +
          mu1 * tU1 +
          mu2 * tU1 * tU1 +
          mu3 * math.pow(tU1, 3) +
          mu4 * math.pow(tU1, 4);
      l1U1 =
          l10 +
          l11 * tU1 +
          l12 * tU1 * tU1 +
          l13 * math.pow(tU1, 3) +
          l14 * math.pow(tU1, 4);

      xpU1 = x1 + 2 * x2 * tU1 + 3 * x3 * tU1 * tU1 + 4 * x4 * math.pow(tU1, 3);
      ypU1 = y1 + 2 * y2 * tU1 + 3 * y3 * tU1 * tU1 + 4 * y4 * math.pow(tU1, 3);

      hU1 = mf.rad(muU1 + gLon - 0.00417807 * deltaT);
      pU1 = c * math.sin(hU1);
      qU1 =
          s * math.cos(mf.rad(dU1)) - c * math.cos(hU1) * math.sin(mf.rad(dU1));
      rU1 =
          s * math.sin(mf.rad(dU1)) + c * math.cos(hU1) * math.cos(mf.rad(dU1));

      prU1 = 0.01745329 * mu1 * c * math.cos(hU1);
      qpU1 = 0.01745329 * (mu1 * pU1 * math.sin(mf.rad(dU1)) - rU1 * d1);

      uU1 = xU1 - pU1;
      vU1 = yU1 - qU1;
      aU1 = xpU1 - prU1;
      bU1 = ypU1 - qpU1;

      nU1 = aU1 * aU1 + bU1 * bU1;
      nnU1 = math.sqrt(nU1);

      l1pU1 = l1U1 - rU1 * tanf1;
      mmU1 = (aU1 * vU1 - uU1 * bU1) / (nnU1 * l1pU1);
      ppU1 =
          -(uU1 * aU1 + vU1 * bU1) / nU1 -
          (l1pU1 / nnU1) * math.sqrt(1 - mmU1 * mmU1);

      tU1 += ppU1;
    }

    aaU1 = tU1 + ppU1 - deltaT / 3600.0;
    jdSolarU1 = (jde2 + 0.5).floorToDouble() - 0.5 + ((t0 + aaU1) / 24.0);

    // =======================
    // Hisab Kontak U4
    // =======================

    double jdSolarU4;
    double aaU4;
    double tU4;

    double xU4 = 0.0;
    double yU4 = 0.0;
    double dU4 = 0.0;
    double muU4 = 0.0;
    double l1U4 = 0.0;
    double xpU4 = 0.0;
    double ypU4 = 0.0;
    double hU4 = 0.0;
    double pU4 = 0.0;
    double qU4 = 0.0;
    double rU4 = 0.0;
    double prU4 = 0.0;
    double qpU4 = 0.0;
    double uU4 = 0.0;
    double vU4 = 0.0;
    double aU4 = 0.0;
    double bU4 = 0.0;
    double nU4 = 0.0;
    double nnU4 = 0.0;
    double l1pU4 = 0.0;
    double mmU4 = 0.0;
    double ppU4 = 0.0;

    tU4 = t + tau;

    for (int i = 0; i < 5; i++) {
      final pi = math.atan(0.99664719 * math.tan(mf.rad(gLat)));
      final s =
          0.99664719 * math.sin(pi) + (elev / 6378140) * math.sin(mf.rad(gLat));
      final c = math.cos(pi) + (elev / 6378140) * math.cos(mf.rad(gLat));

      xU4 =
          x0 +
          x1 * tU4 +
          x2 * tU4 * tU4 +
          x3 * math.pow(tU4, 3) +
          x4 * math.pow(tU4, 4);
      yU4 =
          y0 +
          y1 * tU4 +
          y2 * tU4 * tU4 +
          y3 * math.pow(tU4, 3) +
          y4 * math.pow(tU4, 4);
      dU4 =
          d0 +
          d1 * tU4 +
          d2 * tU4 * tU4 +
          d3 * math.pow(tU4, 3) +
          d4 * math.pow(tU4, 4);
      muU4 =
          mu0 +
          mu1 * tU4 +
          mu2 * tU4 * tU4 +
          mu3 * math.pow(tU4, 3) +
          mu4 * math.pow(tU4, 4);
      l1U4 =
          l10 +
          l11 * tU4 +
          l12 * tU4 * tU4 +
          l13 * math.pow(tU4, 3) +
          l14 * math.pow(tU4, 4);

      xpU4 = x1 + 2 * x2 * tU4 + 3 * x3 * tU4 * tU4 + 4 * x4 * math.pow(tU4, 3);
      ypU4 = y1 + 2 * y2 * tU4 + 3 * y3 * tU4 * tU4 + 4 * y4 * math.pow(tU4, 3);

      hU4 = mf.rad(muU4 + gLon - 0.00417807 * deltaT);
      pU4 = c * math.sin(hU4);
      qU4 =
          s * math.cos(mf.rad(dU4)) - c * math.cos(hU4) * math.sin(mf.rad(dU4));
      rU4 =
          s * math.sin(mf.rad(dU4)) + c * math.cos(hU4) * math.cos(mf.rad(dU4));

      prU4 = 0.01745329 * mu1 * c * math.cos(hU4);
      qpU4 = 0.01745329 * (mu1 * pU4 * math.sin(mf.rad(dU4)) - rU4 * d1);

      uU4 = xU4 - pU4;
      vU4 = yU4 - qU4;
      aU4 = xpU4 - prU4;
      bU4 = ypU4 - qpU4;

      nU4 = aU4 * aU4 + bU4 * bU4;
      nnU4 = math.sqrt(nU4);
      l1pU4 = l1U4 - rU4 * tanf1;
      mmU4 = (aU4 * vU4 - uU4 * bU4) / (nnU4 * l1pU4);

      ppU4 =
          -(uU4 * aU4 + vU4 * bU4) / nU4 +
          (l1pU4 / nnU4) * math.sqrt(1 - mmU4 * mmU4);

      tU4 += ppU4;
    }

    aaU4 = tU4 + ppU4 - deltaT / 3600.0;
    jdSolarU4 = (jde2 + 0.5).floorToDouble() - 0.5 + ((t0 + aaU4) / 24.0);

    double durG = (jdSolarU4 - jdSolarU1) * 24.0;
    double durT = (jdSolarU3 - jdSolarU2) * 24.0;

    // ================== Data matahari saat maximum=====================
    double RAS = sn.sunGeocentricRightAscension(jdSolarMx, 0);
    double DCS = sn.sunGeocentricDeclination(jdSolarMx, 0);
    double SDS = sn.sunGeocentricSemidiameter(jdSolarMx, 0);
    double HPS = sn.sunEquatorialHorizontalParallax(jdSolarMx, 0);

    // ================== Data bulan saat maximum=====================
    double RAM = mo.moonGeocentricRightAscension(jdSolarMx, 0);
    double DCM = mo.moonGeocentricDeclination(jdSolarMx, 0);
    double SDM = mo.moonGeocentricSemidiameter(jdSolarMx, 0);
    double HPM = mo.moonEquatorialHorizontalParallax(jdSolarMx, 0);

    return {
      "JDU1": jdSolarU1,
      "JDU2": jdSolarU2,
      "JDMX": jdSolarMx,
      "JDU3": jdSolarU3,
      "JDU4": jdSolarU4,
      "DeltaT": deltaT,
      "MAG": mag3,
      "OBS": obs,
      "JSE": jSE,
      "DURG": durG,
      "DURT": durT,
      "RAS": RAS,
      "DCS": DCS,
      "SDS": SDS,
      "HPS": HPS,
      "RAM": RAM,
      "DCM": DCM,
      "SDM": SDM,
      "HPM": HPM,
    };
  }
}
