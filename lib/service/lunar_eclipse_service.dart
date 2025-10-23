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

    // ---------------- Data Matahari ----------------
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

    // ---------------- Data Bulan ----------------
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

    // -----Transformasi Equatorial ke Rektangular/Kartesius 3d: (x,y,z)-----
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

  double lunarEclipse({
    required int hijriMonth,
    required int hijriYear,
    required double gLon,
    required double gLat,
    required double elev,
    required double tmZn,
    required String optResult,
  }) {
    // =======================================
    // Besselian elements for lunar eclipse
    // =======================================
    double t = 0.0, t2 = 0.0, t3 = 0.0, t4 = 0.0;
    double x = 0.0, y = 0.0, x_ = 0.0, y_ = 0.0;
    double n = 0.0, n2 = 0.0, tx = 0.0;

    double jdl = lBesselian(hijriMonth, hijriYear, "JDL");
    double dt = lBesselian(hijriMonth, hijriYear, "DT");

    double x0 = lBesselian(hijriMonth, hijriYear, "x0");
    double x1 = lBesselian(hijriMonth, hijriYear, "x1");
    double x2 = lBesselian(hijriMonth, hijriYear, "x2");
    double x3 = lBesselian(hijriMonth, hijriYear, "x3");
    double x4 = lBesselian(hijriMonth, hijriYear, "x4");

    double y0 = lBesselian(hijriMonth, hijriYear, "y0");
    double y1 = lBesselian(hijriMonth, hijriYear, "y1");
    double y2 = lBesselian(hijriMonth, hijriYear, "y2");
    double y3 = lBesselian(hijriMonth, hijriYear, "y3");
    double y4 = lBesselian(hijriMonth, hijriYear, "y4");

    double d0 = lBesselian(hijriMonth, hijriYear, "d0");
    double d1 = lBesselian(hijriMonth, hijriYear, "d1");
    double d2 = lBesselian(hijriMonth, hijriYear, "d2");
    double d3 = lBesselian(hijriMonth, hijriYear, "d3");
    double d4 = lBesselian(hijriMonth, hijriYear, "d4");

    double f10 = lBesselian(hijriMonth, hijriYear, "f10");
    double f11 = lBesselian(hijriMonth, hijriYear, "f11");
    double f12 = lBesselian(hijriMonth, hijriYear, "f12");
    double f13 = lBesselian(hijriMonth, hijriYear, "f13");
    double f14 = lBesselian(hijriMonth, hijriYear, "f14");

    double f20 = lBesselian(hijriMonth, hijriYear, "f20");
    double f21 = lBesselian(hijriMonth, hijriYear, "f21");
    double f22 = lBesselian(hijriMonth, hijriYear, "f22");
    double f23 = lBesselian(hijriMonth, hijriYear, "f23");
    double f24 = lBesselian(hijriMonth, hijriYear, "f24");

    double hp0 = lBesselian(hijriMonth, hijriYear, "HP0");
    double hp1 = lBesselian(hijriMonth, hijriYear, "HP1");
    double hp2 = lBesselian(hijriMonth, hijriYear, "HP2");
    double hp3 = lBesselian(hijriMonth, hijriYear, "HP3");
    double hp4 = lBesselian(hijriMonth, hijriYear, "HP4");

    double dm0 = lBesselian(hijriMonth, hijriYear, "dm0");
    double dm1 = lBesselian(hijriMonth, hijriYear, "dm1");
    double dm2 = lBesselian(hijriMonth, hijriYear, "dm2");
    double dm3 = lBesselian(hijriMonth, hijriYear, "dm3");
    double dm4 = lBesselian(hijriMonth, hijriYear, "dm4");

    double sm0 = lBesselian(hijriMonth, hijriYear, "Sm0");
    double sm1 = lBesselian(hijriMonth, hijriYear, "Sm1");
    double sm2 = lBesselian(hijriMonth, hijriYear, "Sm2");
    double sm3 = lBesselian(hijriMonth, hijriYear, "Sm3");
    double sm4 = lBesselian(hijriMonth, hijriYear, "Sm4");

    double jdE1 = mo.jdeEclipseModified(hijriMonth, hijriYear, 2);
    if (jdE1 <= 0) return 0.0;

    double jdE2 =
        (mf.floor(jdE1)) +
        (((jdE1 - mf.floor(jdE1)) * 24).roundToDouble()) / 24.0;

    double t0 =
        (((jdE2 + 0.5 + (0.0 / 24.0)) - mf.floor(jdE2 + 0.5 + (0.0 / 24.0))) *
                24)
            .roundToDouble();

    // =======================================
    // Iterasi koreksi T, X, Y
    // =======================================
    for (int i = 1; i <= 4; i++) {
      t += tx;
      t2 = t * t;
      t3 = t2 * t;
      t4 = t3 * t;

      x = x0 + x1 * t + x2 * t2 + x3 * t3 + x4 * t4;
      y = y0 + y1 * t + y2 * t2 + y3 * t3 + y4 * t4;

      x_ = x1 + 2 * x2 * t + 3 * x3 * t2 + 4 * x4 * t3;
      y_ = y1 + 2 * y2 * t + 3 * y3 * t2 + 4 * y4 * t3;

      n2 = x_ * x_ + y_ * y_;
      n = math.sqrt(n2);
      tx = -1 / n2 * (x * x_ + y * y_);
    }

    // =======================================
    // Besselian coefficients untuk f, sm
    // =======================================
    double f1 = f10 + f11 * t + f12 * t2 + f13 * t3 + f14 * t4;
    double f2 = f20 + f21 * t + f22 * t2 + f23 * t3 + f24 * t4;
    double sm = sm0 + sm1 * t + sm2 * t2 + sm3 * t3 + sm4 * t4;

    double d = math.sqrt(x * x + y * y);

    double l1 = f1 + sm;
    double l2 = f2 + sm;
    double l3 = f2 - sm;

    double radP = l1 - sm;
    double radU = l2 - sm;

    double magP = (1 / (2 * sm)) * (l1 - d);
    double magU = (1 / (2 * sm)) * (l2 - d);

    double tm1 = 1 / n * math.sqrt(l1 * l1 - d * d);
    double tm2 = 1 / n * math.sqrt(l2 * l2 - d * d);
    double tm3 = 1 / n * math.sqrt(l3 * l3 - d * d);

    double durP = tm1 * 2;
    double durU = tm2 * 2;
    double durT = tm3 * 2;

    // =======================================
    // Julian Day berbagai fase
    // =======================================
    double jdBase = mf.floor(jdE2 - 0.5) + 0.5;
    double p1 = jdBase + ((t0 + t - tm1) / 24.0) - dt / 86400.0;
    double u1 = jdBase + ((t0 + t - tm2) / 24.0) - dt / 86400.0;
    double u2 = jdBase + ((t0 + t - tm3) / 24.0) - dt / 86400.0;
    double mx = jdBase + ((t0 + t) / 24.0) - dt / 86400.0;
    double u3 = jdBase + ((t0 + t + tm3) / 24.0) - dt / 86400.0;
    double u4 = jdBase + ((t0 + t + tm2) / 24.0) - dt / 86400.0;
    double p4 = jdBase + ((t0 + t + tm1) / 24.0) - dt / 86400.0;

    // Menentukan jenis gerhana Bulan
    double lek;
    if (l3 * l3 - d * d > 0.0) {
      lek = 1; //"GERHANA BULAN TOTAL";
    } else if (l2 * l2 - d * d > 0.0 && l3 * l3 - d * d < 0.0) {
      lek = 2; //"GERHANA BULAN SEBAGIAN";
    } else if (l1 * l1 - d * d > 0.0 && l2 * l2 - d * d < 0.0) {
      lek = 3; //"GERHANA BULAN PENUMBRAL";
    } else {
      lek = 0; //"TIDAK ADA GERHANA";
    }

    // =======================================
    // Return berdasarkan OptResult
    // =======================================
    switch (optResult) {
      case "JenisGerhana":
        return lek;
      case "JDL":
        return jdl;
      case "DT":
        return dt;
      case "T0":
        return t0;

      case "x0":
        return x0;
      case "x1":
        return x1;
      case "x2":
        return x2;
      case "x3":
        return x3;
      case "x4":
        return x4;
      case "y0":
        return y0;
      case "y1":
        return y1;
      case "y2":
        return y2;
      case "y3":
        return y3;
      case "y4":
        return y4;
      case "d0":
        return d0;
      case "d1":
        return d1;
      case "d2":
        return d2;
      case "d3":
        return d3;
      case "d4":
        return d4;
      case "f10":
        return f10;
      case "f11":
        return f11;
      case "f12":
        return f12;
      case "f13":
        return f13;
      case "f14":
        return f14;
      case "f20":
        return f20;
      case "f21":
        return f21;
      case "f22":
        return f22;
      case "f23":
        return f23;
      case "f24":
        return f24;
      case "HP0":
        return hp0;
      case "HP1":
        return hp1;
      case "HP2":
        return hp2;
      case "HP3":
        return hp3;
      case "HP4":
        return hp4;
      case "dm0":
        return dm0;
      case "dm1":
        return dm1;
      case "dm2":
        return dm2;
      case "dm3":
        return dm3;
      case "dm4":
        return dm4;
      case "Sm0":
        return sm0;
      case "Sm1":
        return sm1;
      case "Sm2":
        return sm2;
      case "Sm3":
        return sm3;
      case "Sm4":
        return sm4;

      case "P1":
        return p1;
      case "P4":
        return p4;
      case "U1":
        return u1;
      case "U4":
        return u4;
      case "U2":
        return u2;
      case "U3":
        return u3;

      case "MagP":
        return magP;
      case "MagU":
        return magU;

      case "RadP":
        return radP;
      case "RadU":
        return radU;

      case "DurP":
        return durP;
      case "DurU":
        return durU;
      case "DurT":
        return durT;

      default:
        return mx;
    }
  }
}
