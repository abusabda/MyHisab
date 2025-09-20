import 'dart:math' as math;
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/sun_function.dart';

class ArahKiblat {
  final jd = JulianDay();
  final mf = MathFunction();
  final dt = DynamicalTime();
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

    // testing
  }
}
