import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/sun_function.dart';

final julianDay = JulianDay();
final dynamicalTime = DynamicalTime();
final sn = SunFunction();
final mf = MathFunction();
// final ml = MoonLongitude();
// final mb = MoonLatitude();
// final md = MoonDistance();
final mo = MoonFunction();

class LunarEclipseService {
  double lBesselian(int blnH, int thnH, String optResult) {
    final jdEclipse1 = mo.jdeEclipseModified(blnH, thnH, 2);
    if (jdEclipse1 <= 0) return double.nan;

    final jdEclipse2 =
        mf.floor(jdEclipse1) +
        (((jdEclipse1 - mf.floor(jdEclipse1)) * 24).roundToDouble() / 24.0);
    final t0 = mf.mod(
      (((jdEclipse2 - mf.floor(jdEclipse2)) * 24).roundToDouble()),
      24.0,
    );

    final dT = dynamicalTime.deltaT(jdEclipse2);

    // ---------------- Matahari ----------------
    final aRsM2 = sn.sunGeocentricRightAscension(jdEclipse2 - 2 / 24, 0);
    final aRsM1 = sn.sunGeocentricRightAscension(jdEclipse2 - 1 / 24, 0);
    final aRs00 = sn.sunGeocentricRightAscension(jdEclipse2, 0);
    final aRsP1 = sn.sunGeocentricRightAscension(jdEclipse2 + 1 / 24, 0);
    final aRsP2 = sn.sunGeocentricRightAscension(jdEclipse2 + 2 / 24, 0);

    final dsM2 = sn.sunGeocentricDeclination(jdEclipse2 - 2 / 24, 0);
    final dsM1 = sn.sunGeocentricDeclination(jdEclipse2 - 1 / 24, 0);
    final ds00 = sn.sunGeocentricDeclination(jdEclipse2, 0);
    final dsP1 = sn.sunGeocentricDeclination(jdEclipse2 + 1 / 24, 0);
    final dsP2 = sn.sunGeocentricDeclination(jdEclipse2 + 2 / 24, 0);

    final ssM2 = sn.sunGeocentricSemidiameter(jdEclipse2 - 2 / 24, 0);
    final ssM1 = sn.sunGeocentricSemidiameter(jdEclipse2 - 1 / 24, 0);
    final ss00 = sn.sunGeocentricSemidiameter(jdEclipse2, 0);
    final ssP1 = sn.sunGeocentricSemidiameter(jdEclipse2 + 1 / 24, 0);
    final ssP2 = sn.sunGeocentricSemidiameter(jdEclipse2 + 2 / 24, 0);

    final hpsM2 = sn.sunEquatorialHorizontalParallax(jdEclipse2 - 2 / 24, 0);
    final hpsM1 = sn.sunEquatorialHorizontalParallax(jdEclipse2 - 1 / 24, 0);
    final hps00 = sn.sunEquatorialHorizontalParallax(jdEclipse2, 0);
    final hpsP1 = sn.sunEquatorialHorizontalParallax(jdEclipse2 + 1 / 24, 0);
    final hpsP2 = sn.sunEquatorialHorizontalParallax(jdEclipse2 + 2 / 24, 0);

    // ---------------- Bulan ----------------
    final aRmM2 = mo.moonGeocentricRightAscension(jdEclipse2 - 2 / 24, 0);
    final aRmM1 = mo.moonGeocentricRightAscension(jdEclipse2 - 1 / 24, 0);
    final aRm00 = mo.moonGeocentricRightAscension(jdEclipse2, 0);
    final aRmP1 = mo.moonGeocentricRightAscension(jdEclipse2 + 1 / 24, 0);
    final aRmP2 = mo.moonGeocentricRightAscension(jdEclipse2 + 2 / 24, 0);

    final dmM2 = mo.moonGeocentricDeclination(jdEclipse2 - 2 / 24, 0);
    final dmM1 = mo.moonGeocentricDeclination(jdEclipse2 - 1 / 24, 0);
    final dm00 = mo.moonGeocentricDeclination(jdEclipse2, 0);
    final dmP1 = mo.moonGeocentricDeclination(jdEclipse2 + 1 / 24, 0);
    final dmP2 = mo.moonGeocentricDeclination(jdEclipse2 + 2 / 24, 0);

    final smM2 = mo.moonGeocentricSemidiameter(jdEclipse2 - 2 / 24, 0);
    final smM1 = mo.moonGeocentricSemidiameter(jdEclipse2 - 1 / 24, 0);
    final sm00 = mo.moonGeocentricSemidiameter(jdEclipse2, 0);
    final smP1 = mo.moonGeocentricSemidiameter(jdEclipse2 + 1 / 24, 0);
    final smP2 = mo.moonGeocentricSemidiameter(jdEclipse2 + 2 / 24, 0);

    final hpmM2 = mo
        .moonEquatorialHorizontalParallax(jdEclipse2 - 2 / 24, 0)
        .toDouble();
    final hpmM1 = mo
        .moonEquatorialHorizontalParallax(jdEclipse2 - 1 / 24, 0)
        .toDouble();
    final hpm00 = mo.moonEquatorialHorizontalParallax(jdEclipse2, 0).toDouble();
    final hpmP1 = mo
        .moonEquatorialHorizontalParallax(jdEclipse2 + 1 / 24, 0)
        .toDouble();
    final hpmP2 = mo
        .moonEquatorialHorizontalParallax(jdEclipse2 + 2 / 24, 0)
        .toDouble();

    // ---------------- Transformasi ----------------
    final aM2 = mf.mod(aRsM2 + 180, 360);
    final aM1 = mf.mod(aRsM1 + 180, 360);
    final a00 = mf.mod(aRs00 + 180, 360);
    final aP1 = mf.mod(aRsP1 + 180, 360);
    final aP2 = mf.mod(aRsP2 + 180, 360);

    final dM2 = -dsM2;
    final dM1 = -dsM1;
    final d00 = -ds00;
    final dP1 = -dsP1;
    final dP2 = -dsP2;

    double e(double aRm, double a, double d) =>
        0.25 * (aRm - a) * math.sin(mf.rad(2 * d)) * math.sin(mf.rad(aRm - a));

    final eM2 = e(aRmM2, aM2, dM2);
    final eM1 = e(aRmM1, aM1, dM1);
    final e00 = e(aRm00, a00, d00);
    final eP1 = e(aRmP1, aP1, dP1);
    final eP2 = e(aRmP2, aP2, dP2);

    double f1(double hpm, double hps, double ss) => 1.01 * hpm + hps + ss;
    double f2(double hpm, double hps, double ss) => 1.01 * hpm + hps - ss;

    final f1M2 = f1(hpmM2, hpsM2, ssM2);
    final f1M1 = f1(hpmM1, hpsM1, ssM1);
    final f100 = f1(hpm00, hps00, ss00);
    final f1P1 = f1(hpmP1, hpsP1, ssP1);
    final f1P2 = f1(hpmP2, hpsP2, ssP2);

    final f2M2 = f2(hpmM2, hpsM2, ssM2);
    final f2M1 = f2(hpmM1, hpsM1, ssM1);
    final f200 = f2(hpm00, hps00, ss00);
    final f2P1 = f2(hpmP1, hpsP1, ssP1);
    final f2P2 = f2(hpmP2, hpsP2, ssP2);

    double x(double aRm, double a, double dm) =>
        (aRm - a) * math.cos(mf.rad(dm));
    double y(double dm, double d, double e) => dm - d + e;

    final xM2 = x(aRmM2, aM2, dmM2);
    final xM1 = x(aRmM1, aM1, dmM1);
    final x00 = x(aRm00, a00, dm00);
    final xP1 = x(aRmP1, aP1, dmP1);
    final xP2 = x(aRmP2, aP2, dmP2);

    final yM2 = y(dmM2, dM2, eM2);
    final yM1 = y(dmM1, dM1, eM1);
    final y00 = y(dm00, d00, e00);
    final yP1 = y(dmP1, dP1, eP1);
    final yP2 = y(dmP2, dP2, eP2);

    // ---------------- Hasil Interpolasi ----------------
    switch (optResult) {
      case "JDL":
        return jdEclipse2;
      case "DT":
        return dT;

      // x interpolation
      case "x0":
        return mf.interp5(xM2, xM1, x00, xP1, xP2, 0);
      case "x1":
        return mf.interp5(xM2, xM1, x00, xP1, xP2, 1);
      case "x2":
        return mf.interp5(xM2, xM1, x00, xP1, xP2, 2);
      case "x3":
        return mf.interp5(xM2, xM1, x00, xP1, xP2, 3);
      case "x4":
        return mf.interp5(xM2, xM1, x00, xP1, xP2, 4);

      // y interpolation
      case "y0":
        return mf.interp5(yM2, yM1, y00, yP1, yP2, 0);
      case "y1":
        return mf.interp5(yM2, yM1, y00, yP1, yP2, 1);
      case "y2":
        return mf.interp5(yM2, yM1, y00, yP1, yP2, 2);
      case "y3":
        return mf.interp5(yM2, yM1, y00, yP1, yP2, 3);
      case "y4":
        return mf.interp5(yM2, yM1, y00, yP1, yP2, 4);

      // d interpolation
      case "d0":
        return mf.interp5(dM2, dM1, d00, dP1, dP2, 0);
      case "d1":
        return mf.interp5(dM2, dM1, d00, dP1, dP2, 1);
      case "d2":
        return mf.interp5(dM2, dM1, d00, dP1, dP2, 2);
      case "d3":
        return mf.interp5(dM2, dM1, d00, dP1, dP2, 3);
      case "d4":
        return mf.interp5(dM2, dM1, d00, dP1, dP2, 4);

      // f1 interpolation
      case "f10":
        return mf.interp5(f1M2, f1M1, f100, f1P1, f1P2, 0);
      case "f11":
        return mf.interp5(f1M2, f1M1, f100, f1P1, f1P2, 1);
      case "f12":
        return mf.interp5(f1M2, f1M1, f100, f1P1, f1P2, 2);
      case "f13":
        return mf.interp5(f1M2, f1M1, f100, f1P1, f1P2, 3);
      case "f14":
        return mf.interp5(f1M2, f1M1, f100, f1P1, f1P2, 4);

      // f2 interpolation
      case "f20":
        return mf.interp5(f2M2, f2M1, f200, f2P1, f2P2, 0);
      case "f21":
        return mf.interp5(f2M2, f2M1, f200, f2P1, f2P2, 1);
      case "f22":
        return mf.interp5(f2M2, f2M1, f200, f2P1, f2P2, 2);
      case "f23":
        return mf.interp5(f2M2, f2M1, f200, f2P1, f2P2, 3);
      case "f24":
        return mf.interp5(f2M2, f2M1, f200, f2P1, f2P2, 4);

      // HPm interpolation
      case "HP0":
        return mf.interp5(hpmM2, hpmM1, hpm00, hpmP1, hpmP2, 0);
      case "HP1":
        return mf.interp5(hpmM2, hpmM1, hpm00, hpmP1, hpmP2, 1);
      case "HP2":
        return mf.interp5(hpmM2, hpmM1, hpm00, hpmP1, hpmP2, 2);
      case "HP3":
        return mf.interp5(hpmM2, hpmM1, hpm00, hpmP1, hpmP2, 3);
      case "HP4":
        return mf.interp5(hpmM2, hpmM1, hpm00, hpmP1, hpmP2, 4);

      // dm interpolation
      case "dm0":
        return mf.interp5(dmM2, dmM1, dm00, dmP1, dmP2, 0);
      case "dm1":
        return mf.interp5(dmM2, dmM1, dm00, dmP1, dmP2, 1);
      case "dm2":
        return mf.interp5(dmM2, dmM1, dm00, dmP1, dmP2, 2);
      case "dm3":
        return mf.interp5(dmM2, dmM1, dm00, dmP1, dmP2, 3);
      case "dm4":
        return mf.interp5(dmM2, dmM1, dm00, dmP1, dmP2, 4);

      // Sm interpolation
      case "Sm0":
        return mf.interp5(smM2, smM1, sm00, smP1, smP2, 0);
      case "Sm1":
        return mf.interp5(smM2, smM1, sm00, smP1, smP2, 1);
      case "Sm2":
        return mf.interp5(smM2, smM1, sm00, smP1, smP2, 2);
      case "Sm3":
        return mf.interp5(smM2, smM1, sm00, smP1, smP2, 3);
      case "Sm4":
        return mf.interp5(smM2, smM1, sm00, smP1, smP2, 4);

      default:
        return mf.mod(t0 + 12, 24);
    }
  }
}
