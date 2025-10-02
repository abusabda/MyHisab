import 'dart:math' as math;

//import 'package:myhisab/service/sun_service.dart';

import 'moon_longitude.dart';
import 'moon_latitude.dart';
import 'moon_distance.dart';
import 'nutation.dart';
import 'julian_day.dart';
import 'dynamical_time.dart';
import 'math_utils.dart';
import 'sun_function.dart';

class MoonFunction {
  final ml = MoonLongitude();
  final mb = MoonLatitude();
  final md = MoonDistance();
  final mf = MathFunction();
  final nt = NutationAndObliquity();
  final jd = JulianDay();
  final dt = DynamicalTime();
  final sn = SunFunction();

  /// Moon Geocentric Right Ascension
  double moonGeocentricRightAscension(double jd, double deltaT) {
    final lmbd = ml.moonGeocentricLongitude(jd, deltaT, "Appa");
    final beta = mb.moonGeocentricLatitude(jd, deltaT);
    final epsln = nt.trueObliquityOfEcliptic(jd, deltaT);

    final alpha = mf.mod(
      mf.deg(
        math.atan2(
          math.sin(mf.rad(lmbd)) * math.cos(mf.rad(epsln)) -
              math.tan(mf.rad(beta)) * math.sin(mf.rad(epsln)),
          math.cos(mf.rad(lmbd)),
        ),
      ),
      360.0,
    );
    return alpha;
  }

  /// Moon Geocentric Declination
  double moonGeocentricDeclination(double jd, double deltaT) {
    final lmbd = ml.moonGeocentricLongitude(jd, deltaT, "Appa");
    final beta = mb.moonGeocentricLatitude(jd, deltaT);
    final epsln = nt.trueObliquityOfEcliptic(jd, deltaT);

    final delta = mf.deg(
      math.asin(
        math.sin(mf.rad(beta)) * math.cos(mf.rad(epsln)) +
            math.cos(mf.rad(beta)) *
                math.sin(mf.rad(epsln)) *
                math.sin(mf.rad(lmbd)),
      ),
    );
    return delta;
  }

  double moonGeocentricGreenwichHourAngle(double jd, double deltaT) {
    final gast = sn.greenwichApparentSiderialTime(jd, deltaT);
    final alpha = moonGeocentricRightAscension(jd, deltaT);
    final gha = mf.mod(gast - alpha, 360.0);
    return gha;
  }

  double moonGeocentricLocalHourAngel(double jd, double deltaT, double gLon) {
    final gast = sn.greenwichApparentSiderialTime(jd, deltaT);
    final alpha = moonGeocentricRightAscension(jd, deltaT);
    final lhaFK5 = mf.mod(gast + gLon - alpha, 360.0);
    return lhaFK5;
  }

  double moonGeocentricAzimuth(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
  ) {
    final lha = moonGeocentricLocalHourAngel(jd, deltaT, gLon);
    final dec = moonGeocentricDeclination(jd, deltaT);
    final azm = mf.mod(
      mf.deg(
            math.atan2(
              math.sin(mf.rad(lha)),
              math.cos(mf.rad(lha)) * math.sin(mf.rad(gLat)) -
                  math.tan(mf.rad(dec)) * math.cos(mf.rad(gLat)),
            ),
          ) +
          180.0,
      360.0,
    );
    return azm;
  }

  double moonGeocentricAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
  ) {
    final lha = moonGeocentricLocalHourAngel(jd, deltaT, gLon);
    final dec = moonGeocentricDeclination(jd, deltaT);
    final alt = mf.deg(
      math.asin(
        math.sin(mf.rad(gLat)) * math.sin(mf.rad(dec)) +
            math.cos(mf.rad(gLat)) *
                math.cos(mf.rad(dec)) *
                math.cos(mf.rad(lha)),
      ),
    );
    return alt;
  }

  /// Moon Equatorial Horizontal Parallax
  double moonEquatorialHorizontalParallax(double jd, double deltaT) {
    final distance = md.moonGeocentricDistance(jd, deltaT, "KM");
    final pi = mf.deg(math.asin(6378.14 / distance));
    return pi;
  }

  double moonGeocentricSemidiameter(double jd, double deltaT) {
    const k = 0.272481;
    final pi = moonEquatorialHorizontalParallax(jd, deltaT);
    final s = mf.deg(math.asin(k * math.sin(mf.rad(pi))));
    return s;
  }

  double moonSunGeocentricElongation(double jd, double deltaT) {
    final deltaSun = sn.sunGeocentricDeclination(jd, deltaT);
    final alphaSun = sn.sunGeocentricRightAscension(jd, deltaT);
    final deltaMoon = moonGeocentricDeclination(jd, deltaT);
    final alphaMoon = moonGeocentricRightAscension(jd, deltaT);

    final d = mf.deg(
      math.acos(
        math.sin(mf.rad(deltaSun)) * math.sin(mf.rad(deltaMoon)) +
            math.cos(mf.rad(deltaSun)) *
                math.cos(mf.rad(deltaMoon)) *
                math.cos(mf.rad(alphaSun - alphaMoon)),
      ),
    );
    return d;
  }

  double moonGeocentricPhaseAngle(double jd, double deltaT) {
    final rSun = sn.sunGeocentricDistance(jd, deltaT, "KM");
    final rMoon = md.moonGeocentricDistance(jd, deltaT, "KM");
    final d = moonSunGeocentricElongation(jd, deltaT);
    final i = mf.deg(
      math.atan2(
        rSun * math.sin(mf.rad(d)),
        rMoon - rSun * math.cos(mf.rad(d)),
      ),
    );
    return i;
  }

  double moonGeocentricDiskIlluminatedFraction(double jd, double deltaT) {
    final rSun = sn.sunGeocentricDistance(jd, deltaT, "KM");
    final rMoon = md.moonGeocentricDistance(jd, deltaT, "KM");
    final d = moonSunGeocentricElongation(jd, deltaT);
    final i = mf.deg(
      math.atan2(
        rSun * math.sin(mf.rad(d)),
        rMoon - rSun * math.cos(mf.rad(d)),
      ),
    );
    final k = ((1 + math.cos(mf.rad(i))) / 2) * 100.0;
    return k;
  }

  double moonGeocentricBrightLimbAngle(double jd, double deltaT) {
    final deltaSun = sn.sunGeocentricDeclination(jd, deltaT);
    final alphaSun = sn.sunGeocentricRightAscension(jd, deltaT);
    final deltaMoon = moonGeocentricDeclination(jd, deltaT);
    final alphaMoon = moonGeocentricRightAscension(jd, deltaT);

    final x = mf.mod(
      mf.deg(
        math.atan2(
          math.cos(mf.rad(deltaSun)) * math.sin(mf.rad(alphaSun - alphaMoon)),
          math.sin(mf.rad(deltaSun)) * math.cos(mf.rad(deltaMoon)) -
              math.cos(mf.rad(deltaSun)) *
                  math.sin(mf.rad(deltaMoon)) *
                  math.cos(mf.rad(alphaSun - alphaMoon)),
        ),
      ),
      360.0,
    );
    return x;
  }

  double termN(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final lambda = ml.moonGeocentricLongitude(jd, deltaT, "Appa");
    final beta = mb.moonGeocentricLatitude(jd, deltaT);
    final thta = sn.localApparentSiderialTime(jd, deltaT, gLon);
    final x = sn.termX(gLat, elev);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);

    final n =
        math.cos(mf.rad(lambda)) * math.cos(mf.rad(beta)) -
        x * math.sin(mf.rad(phi)) * math.cos(mf.rad(thta));
    return n;
  }

  double parallaxInTheMoonRightAscension(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final x = sn.termX(gLat, elev);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);
    final ha = moonGeocentricLocalHourAngel(jd, deltaT, gLon);
    final dec = moonGeocentricDeclination(jd, deltaT);

    final dAlpha = mf.deg(
      math.atan2(
        -x * math.sin(mf.rad(phi)) * math.sin(mf.rad(ha)),
        math.cos(mf.rad(dec)) -
            x * math.sin(mf.rad(phi)) * math.cos(mf.rad(ha)),
      ),
    );
    return dAlpha;
  }

  double atmosphericRefractionFromApparentAltitude(
    double apparentAltitude,
    double pres,
    double temp,
  ) {
    final h = apparentAltitude;
    final P = pres;
    final T = temp;

    return (1.0 /
                math.tan(mf.rad(h + 7.31 / (h + 4.4))) *
                P /
                1010.0 *
                283.0 /
                (273.0 + T) +
            0.0013515216737560731) /
        60.0;
  }

  double parallaxInTheMoonAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final h = moonGeocentricAltitude(jd, deltaT, gLon, gLat);
    final y = sn.termY(gLat, elev);
    final x = sn.termX(gLat, elev);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);

    final par = mf.deg(
      math.asin(
        math.sqrt(y * y + x * x) * math.sin(mf.rad(phi)) * math.cos(mf.rad(h)),
      ),
    );
    return par;
  }

  double moonTopocentricLongitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final lmbd = ml.moonGeocentricLongitude(jd, deltaT, "Appa");
    final beta = mb.moonGeocentricLatitude(jd, deltaT);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);
    final thta = sn.localApparentSiderialTime(jd, deltaT, gLon);
    final eps = nt.trueObliquityOfEcliptic(jd, deltaT);
    final x = sn.termX(gLat, elev);
    final y = sn.termY(gLat, elev);
    final n = termN(jd, deltaT, gLon, gLat, elev);

    final lmbdP = mf.mod(
      mf.deg(
        math.atan2(
          (math.sin(mf.rad(lmbd)) * math.cos(mf.rad(beta)) -
              math.sin(mf.rad(phi)) *
                  (y * math.sin(mf.rad(eps)) +
                      x * math.cos(mf.rad(eps)) * math.sin(mf.rad(thta)))),
          n,
        ),
      ),
      360.0,
    );

    return lmbdP;
  }

  double moonTopocentricLatitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final lmbdP = moonTopocentricLongitude(jd, deltaT, gLon, gLat, elev);
    final beta = mb.moonGeocentricLatitude(jd, deltaT);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);
    final thta = sn.localApparentSiderialTime(jd, deltaT, gLon);
    final eps = nt.trueObliquityOfEcliptic(jd, deltaT);
    final x = sn.termX(gLat, elev);
    final y = sn.termY(gLat, elev);
    final n = termN(jd, deltaT, gLon, gLat, elev);

    final betaP = mf.deg(
      math.atan(
        math.cos(mf.rad(lmbdP)) *
            (math.sin(mf.rad(beta)) -
                math.sin(mf.rad(phi)) *
                    (y * math.cos(mf.rad(eps)) -
                        x * math.sin(mf.rad(eps)) * math.sin(mf.rad(thta)))) /
            n,
      ),
    );

    return betaP;
  }

  double moonTopocentricRightAscension(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final alpha = moonGeocentricRightAscension(jd, deltaT);
    final dAlph = parallaxInTheMoonRightAscension(jd, deltaT, gLon, gLat, elev);
    final alphP = alpha + dAlph;
    return alphP;
  }

  double moonTopocentricDeclination(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final dec = moonGeocentricDeclination(jd, deltaT);
    final y = sn.termY(gLat, elev);
    final x = sn.termX(gLat, elev);
    final phi = moonEquatorialHorizontalParallax(jd, deltaT);
    final dAlph = parallaxInTheMoonRightAscension(jd, deltaT, gLon, gLat, elev);
    final ha = moonGeocentricLocalHourAngel(jd, deltaT, gLon);

    final dltaP = mf.deg(
      math.atan2(
        (math.sin(mf.rad(dec)) - y * math.sin(mf.rad(phi))) *
            math.cos(mf.rad(dAlph)),
        math.cos(mf.rad(dec)) -
            x * math.sin(mf.rad(phi)) * math.cos(mf.rad(ha)),
      ),
    );
    return dltaP;
  }

  double moonTopocentricGreenwichHourAngle(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final gast = sn.greenwichApparentSiderialTime(jd, deltaT);
    final alph = moonTopocentricRightAscension(jd, deltaT, gLon, gLat, elev);
    final gha = mf.mod(gast - alph, 360.0);
    return gha;
  }

  double moonTopocentricLocalHourAngel(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final lha = moonGeocentricLocalHourAngel(jd, deltaT, gLon);
    final dAlph = parallaxInTheMoonRightAscension(jd, deltaT, gLon, gLat, elev);
    final lhaP = lha - dAlph;
    return lhaP;
  }

  double moonTopocentricSemidiameter(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lmbdP = moonTopocentricLongitude(jd, deltaT, gLon, gLat, elev);
    double betaP = moonTopocentricLatitude(jd, deltaT, gLon, gLat, elev);
    double s = moonGeocentricSemidiameter(jd, deltaT);
    double n = termN(jd, deltaT, gLon, gLat, elev);

    double sP = mf.deg(
      math.sin(
        math.cos(mf.rad(lmbdP)) *
            math.cos(mf.rad(betaP)) *
            math.sin(mf.rad(s)) /
            n,
      ),
    );
    return sP;
  }

  double moonTopocentricAzimuth(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final lhaP = moonTopocentricLocalHourAngel(jd, deltaT, gLon, gLat, elev);
    final dltP = moonTopocentricDeclination(jd, deltaT, gLon, gLat, elev);

    final azmP = mf.mod(
      mf.deg(
            math.atan2(
              math.sin(mf.rad(lhaP)),
              math.cos(mf.rad(lhaP)) * math.sin(mf.rad(gLat)) -
                  math.tan(mf.rad(dltP)) * math.cos(mf.rad(gLat)),
            ),
          ) +
          180.0,
      360.0,
    );

    return azmP;
  }

  double moonTopocentricAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
    double pres,
    double temp,
    String opt,
  ) {
    final dec = moonTopocentricDeclination(jd, deltaT, gLon, gLat, elev);
    final lHA = moonTopocentricLocalHourAngel(jd, deltaT, gLon, gLat, elev);

    final htc = mf.deg(
      math.asin(
        math.sin(mf.rad(gLat)) * math.sin(mf.rad(dec)) +
            math.cos(mf.rad(gLat)) *
                math.cos(mf.rad(dec)) *
                math.cos(mf.rad(lHA)),
      ),
    );

    final dip = 1.75 / 60 * math.sqrt(elev);
    final sdc = moonTopocentricSemidiameter(jd, deltaT, gLon, gLat, elev);

    final rhtc = sn.atmosphericRefractionFromAirlessAltitude(htc, pres, temp);
    final htac = htc + rhtc;
    final htoc = htac + dip;

    final htu = htc + sdc;
    final rhtu = sn.atmosphericRefractionFromAirlessAltitude(htu, pres, temp);
    final htau = htu + rhtu;
    final htou = htau + dip;

    final htl = htc - sdc;
    final rhtl = sn.atmosphericRefractionFromAirlessAltitude(htl, pres, temp);
    final htal = htl + rhtl;
    final htol = htal + dip;

    double ht;
    switch (opt) {
      case "htc":
        ht = htc;
        break;
      case "htac":
        ht = htac;
        break;
      case "htoc":
        ht = htoc;
        break;
      case "htu":
        ht = htu;
        break;
      case "htau":
        ht = htau;
        break;
      case "htou":
        ht = htou;
        break;
      case "htl":
        ht = htl;
        break;
      case "htal":
        ht = htal;
        break;
      case "htol":
        ht = htol;
        break;
      case "Rhtc":
        ht = rhtc;
        break;
      case "Rhtu":
        ht = rhtu;
        break;
      case "Rhtl":
        ht = rhtl;
        break;
      case "Dip":
        ht = dip;
        break;
      default:
        ht = htc;
    }

    return ht;
  }

  //Keterangan:
  //htc  = Airless topocentric altitude of The Moon’s Center Limb
  //htac = Apparent topocentric altitude of The Moon’s Center Limb
  //htoc = Observed altitude of The Moon’s Center Limb
  //htu  = Airles topocentric altitude of The Moon’s Upper Limb
  //htau = Apparent topocentric altitude of The Moon’s Upper Limb
  //htou = Observed altitude of The Moon’s Upper Limb
  //htl  = Airles topocentric altitude of The Moon’s Lower Limb
  //htal = Apparent topocentric altitude of The Moon’s Lower Limb
  //htol = Observed altitude of The Moon’s Lower Limb

  double moonSunTopocentricElongation(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    final double dltaS = sn.sunTopocentricDeclination(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );
    final double alphS = sn.sunTopocentricRightAscension(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );
    final double dltaM = moonTopocentricDeclination(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );
    final double alphM = moonTopocentricRightAscension(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );

    final double d = mf.deg(
      math.acos(
        math.sin(mf.rad(dltaS)) * math.sin(mf.rad(dltaM)) +
            math.cos(mf.rad(dltaS)) *
                math.cos(mf.rad(dltaM)) *
                math.cos(mf.rad(alphS - alphM)),
      ),
    );

    return d;
  }

  double moonTopocentricPhaseAngle(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double rSn = sn.sunGeocentricDistance(jd, deltaT, "KM");
    double rMn = md.moonGeocentricDistance(jd, deltaT, "KM");
    double d = moonSunTopocentricElongation(jd, deltaT, gLon, gLat, elev);

    double i = mf.deg(
      math.atan2(rSn * math.sin(mf.rad(d)), rMn - rSn * math.cos(mf.rad(d))),
    );
    return i;
  }

  double moonTopocentricDiskIlluminatedFraction(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double rSn = sn.sunGeocentricDistance(jd, deltaT, "KM");
    double rMn = md.moonGeocentricDistance(jd, deltaT, "KM");
    double d = moonSunTopocentricElongation(jd, deltaT, gLon, gLat, elev);

    double i = mf.deg(
      math.atan2(rSn * math.sin(mf.rad(d)), rMn - rSn * math.cos(mf.rad(d))),
    );
    double k = ((1 + math.cos(mf.rad(i))) / 2) * 100.0;
    return k;
  }

  double moonTopocentricBrightLimbAngle(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double dltaSn = sn.sunTopocentricDeclination(jd, deltaT, gLon, gLat, elev);
    double alphSn = sn.sunTopocentricRightAscension(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );
    double dltaMn = moonTopocentricDeclination(jd, deltaT, gLon, gLat, elev);
    double alphMn = moonTopocentricRightAscension(jd, deltaT, gLon, gLat, elev);

    double x = mf.mod(
      mf.deg(
        math.atan2(
          math.cos(mf.rad(dltaSn)) * math.sin(mf.rad(alphSn - alphMn)),
          math.sin(mf.rad(dltaSn)) * math.cos(mf.rad(dltaMn)) -
              math.cos(mf.rad(dltaSn)) *
                  math.sin(mf.rad(dltaMn)) *
                  math.cos(mf.rad(alphSn - alphMn)),
        ),
      ),
      360.0,
    );
    return x;
  }

  double moonPhasesModified(int hijriMonth, int hijriYear, int moonPhaseKind) {
    double k = hijriMonth.toDouble() + 12 * hijriYear.toDouble() - 17050;

    double kII;
    switch (moonPhaseKind) {
      case 1:
        kII = 0.0;
        break;
      case 2:
        kII = 0.25;
        break;
      case 3:
        kII = 0.5;
        break;
      case 4:
        kII = 0.75;
        break;
      default:
        kII = 0.0;
    }

    k = (k).floor() + kII;

    final t = k / 1236.85;

    final jdeMMP =
        2451550.09766 +
        29.530588861 * k +
        0.00015437 * math.pow(t, 2) -
        0.00000015 * math.pow(t, 3) +
        0.00000000073 * math.pow(t, 4);

    final e = 1 - 0.002516 * t - 0.0000074 * math.pow(t, 2);

    var m =
        2.5534 +
        29.1053567 * k -
        0.0000014 * math.pow(t, 2) -
        0.00000011 * math.pow(t, 3);
    m = mf.rad(mf.mod(m, 360.0));

    var mp =
        201.5643 +
        385.81693528 * k +
        0.0107582 * math.pow(t, 2) +
        0.00001238 * math.pow(t, 3) -
        0.000000058 * math.pow(t, 4);
    mp = mf.rad(mf.mod(mp, 360.0));

    var f =
        160.7108 +
        390.67050284 * k -
        0.0016118 * math.pow(t, 2) -
        0.00000227 * math.pow(t, 3) +
        0.000000011 * math.pow(t, 4);
    f = mf.rad(mf.mod(f, 360.0));

    var om =
        124.7746 -
        1.56375588 * k +
        0.0020672 * math.pow(t, 2) +
        0.00000215 * math.pow(t, 3);
    om = mf.rad(mf.mod(om, 360.0));

    final a1 = mf.rad(mf.mod(299.77 + 0.107408 * k - 0.009173 * t * t, 360.0));
    final a2 = mf.rad(mf.mod(251.88 + 0.016321 * k, 360.0));
    final a3 = mf.rad(mf.mod(251.83 + 26.651886 * k, 360.0));
    final a4 = mf.rad(mf.mod(349.42 + 36.412478 * k, 360.0));
    final a5 = mf.rad(mf.mod(84.66 + 18.206239 * k, 360.0));
    final a6 = mf.rad(mf.mod(141.74 + 53.303771 * k, 360.0));
    final a7 = mf.rad(mf.mod(207.14 + 2.453732 * k, 360.0));
    final a8 = mf.rad(mf.mod(154.84 + 7.30686 * k, 360.0));
    final a9 = mf.rad(mf.mod(34.52 + 27.261239 * k, 360.0));
    final a10 = mf.rad(mf.mod(207.19 + 0.121824 * k, 360.0));
    final a11 = mf.rad(mf.mod(291.34 + 1.844379 * k, 360.0));
    final a12 = mf.rad(mf.mod(161.72 + 24.198154 * k, 360.0));
    final a13 = mf.rad(mf.mod(239.56 + 25.513099 * k, 360.0));
    final a14 = mf.rad(mf.mod(331.55 + 3.592518 * k, 360.0));

    double jdeCorr1;
    switch (moonPhaseKind) {
      case 1:
        jdeCorr1 =
            -0.4072 * math.sin(mp) +
            0.17241 * e * math.sin(m) +
            0.01608 * math.sin(2 * mp) +
            0.01039 * math.sin(2 * f) +
            0.00739 * e * math.sin(mp - m) -
            0.00514 * e * math.sin(mp + m) +
            0.00208 * math.pow(e, 2) * math.sin(2 * m) -
            0.00111 * math.sin(mp - 2 * f) -
            0.00057 * math.sin(mp + 2 * f) +
            0.00056 * e * math.sin(2 * mp + m) -
            0.00042 * math.sin(3 * mp) +
            0.00042 * e * math.sin(m + 2 * f) +
            0.00038 * e * math.sin(m - 2 * f) -
            0.00024 * e * math.sin(2 * mp - m) -
            0.00017 * math.sin(om) -
            0.00007 * math.sin(mp + 2 * m) +
            0.00004 * math.sin(2 * mp - 2 * f) +
            0.00004 * math.sin(3 * m) +
            0.00003 * math.sin(mp + m - 2 * f) +
            0.00003 * math.sin(2 * mp + 2 * f) -
            0.00003 * math.sin(mp + m + 2 * f) +
            0.00003 * math.sin(mp - m + 2 * f) -
            0.00002 * math.sin(mp - m - 2 * f) -
            0.00002 * math.sin(3 * mp + m) +
            0.00002 * math.sin(4 * mp);
        break;

      case 3:
        jdeCorr1 =
            -0.40614 * math.sin(mp) +
            0.17302 * e * math.sin(m) +
            0.01614 * math.sin(2 * mp) +
            0.01043 * math.sin(2 * f) +
            0.00734 * e * math.sin(mp - m) -
            0.00514 * e * math.sin(mp + m) +
            0.00209 * math.pow(e, 2) * math.sin(2 * m) -
            0.00111 * math.sin(mp - 2 * f) -
            0.00057 * math.sin(mp + 2 * f) +
            0.00056 * e * math.sin(2 * mp + m) -
            0.00042 * math.sin(3 * mp) +
            0.00042 * e * math.sin(m + 2 * f) +
            0.00038 * e * math.sin(m - 2 * f) -
            0.00024 * e * math.sin(2 * mp - m) -
            0.00017 * math.sin(om) -
            0.00007 * math.sin(mp + 2 * m) +
            0.00004 * math.sin(2 * mp - 2 * f) +
            0.00004 * math.sin(3 * m) +
            0.00003 * math.sin(mp + m - 2 * f) +
            0.00003 * math.sin(2 * mp + 2 * f) -
            0.00003 * math.sin(mp + m + 2 * f) +
            0.00003 * math.sin(mp - m + 2 * f) -
            0.00002 * math.sin(mp - m - 2 * f) -
            0.00002 * math.sin(3 * mp + m) +
            0.00002 * math.sin(4 * mp);
        break;

      case 2:
      case 4:
        jdeCorr1 =
            -0.62801 * math.sin(mp) +
            0.17172 * e * math.sin(m) -
            0.01183 * e * math.sin(mp + m) +
            0.00862 * math.sin(2 * mp) +
            0.00804 * math.sin(2 * f) +
            0.00454 * e * math.sin(mp - m) +
            0.00204 * math.pow(e, 2) * math.sin(2 * m) -
            0.0018 * math.sin(mp - 2 * f) -
            0.0007 * math.sin(mp + 2 * f) -
            0.0004 * math.sin(3 * mp) -
            0.00034 * e * math.sin(2 * mp - m) +
            0.00032 * e * math.sin(m + 2 * f) +
            0.00032 * e * math.sin(m - 2 * f) -
            0.00028 * math.pow(e, 2) * math.sin(mp + 2 * m) +
            0.00027 * e * math.sin(2 * mp + m) -
            0.00017 * math.sin(om) -
            0.00005 * math.sin(mp - m - 2 * f) +
            0.00004 * math.sin(2.0 * mp + 2 * f) -
            0.00004 * math.sin(mp + m + 2 * f) +
            0.00004 * math.sin(mp - 2 * m) +
            0.00003 * math.sin(mp + m - 2 * f) +
            0.00003 * math.sin(3 * m) +
            0.00002 * math.sin(2 * mp - 2 * f) +
            0.00002 * math.sin(mp - m + 2 * f) -
            0.00002 * math.sin(3 * mp + m);
        break;

      default:
        jdeCorr1 = 0.0;
    }

    // Extra correction for Quarter phases
    if (moonPhaseKind == 2 || moonPhaseKind == 4) {
      final w =
          0.00306 -
          0.00038 * e * math.cos(m) +
          0.00026 * math.cos(mp) -
          0.00002 * math.cos(mp - m) +
          0.00002 * math.cos(mp + m) +
          0.00002 * math.cos(2 * f);
      if (moonPhaseKind == 2) {
        jdeCorr1 += w;
      } else if (moonPhaseKind == 4) {
        jdeCorr1 -= w;
      }
    }

    final jdeCorr2 =
        0.000325 * math.sin(a1) +
        0.000165 * math.sin(a2) +
        0.000164 * math.sin(a3) +
        0.000126 * math.sin(a4) +
        0.00011 * math.sin(a5) +
        0.000062 * math.sin(a6) +
        0.00006 * math.sin(a7) +
        0.000056 * math.sin(a8) +
        0.000047 * math.sin(a9) +
        0.000042 * math.sin(a10) +
        0.00004 * math.sin(a11) +
        0.000037 * math.sin(a12) +
        0.000035 * math.sin(a13) +
        0.000023 * math.sin(a14);

    final result = jdeMMP + jdeCorr1 + jdeCorr2;
    return result;
  }

  double jdeEclipseModified(int hijriMonth, int hijriYear, int eclipseKind) {
    double k;

    switch (eclipseKind) {
      case 1:
        k =
            (hijriMonth.toDouble() + 12 * hijriYear.toDouble() - 17048.5)
                .floorToDouble() +
            0.0;
        break;
      case 2:
        k =
            (hijriMonth.toDouble() + 12 * hijriYear.toDouble() - 17049.5)
                .floorToDouble() +
            0.5;
        break;
      default:
        k =
            (hijriMonth.toDouble() + 12 * hijriYear.toDouble() - 17048.5)
                .floorToDouble() +
            0.0;
        break;
    }

    double t = k / 1236.85;
    double jdeMMP =
        2451550.09766 +
        29.530588861 * k +
        0.00015437 * t * t -
        0.000000150 * t * t * t +
        0.00000000073 * t * t * t * t;

    double e = 1 - 0.002516 * t - 0.0000074 * t * t;

    double m =
        2.5534 + 29.1053567 * k - 0.0000014 * t * t - 0.00000011 * t * t * t;
    m = mf.rad(mf.mod(m, 360.0));

    double mp =
        201.5643 +
        385.81693528 * k +
        0.0107582 * t * t +
        0.00001238 * t * t * t -
        0.000000058 * t * t * t * t;
    mp = mf.rad(mf.mod(mp, 360.0));

    double f =
        160.7108 +
        390.67050284 * k -
        0.0016118 * t * t -
        0.00000227 * t * t * t +
        0.000000011 * t * t * t * t;
    f = mf.rad(mf.mod(f, 360.0));

    double omg =
        124.7746 - 1.56375588 * k + 0.0020672 * t * t + 0.00000215 * t * t * t;
    omg = mf.rad(mf.mod(omg, 360.0));

    if ((math.sin(f)).abs() > 0.36) {
      return 0.0;
    } else {
      double f1 = mf.deg(f) - 0.02665 * math.sin(omg);
      f1 = mf.rad(mf.mod(f1, 360.0));

      double a1 = 299.77 + 0.107408 * k - 0.009173 * t * t;
      a1 = mf.rad(mf.mod(a1, 360.0));

      double jdeCorr;
      switch (eclipseKind) {
        case 1:
          jdeCorr = -0.4075 * math.sin(mp) + 0.1721 * e * math.sin(m);
          break;
        case 2:
          jdeCorr = -0.4065 * math.sin(mp) + 0.1727 * e * math.sin(m);
          break;
        default:
          jdeCorr = -0.4075 * math.sin(mp) + 0.1721 * e * math.sin(m);
          break;
      }

      jdeCorr =
          jdeCorr +
          0.0161 * math.sin(2 * mp) -
          0.0097 * math.sin(2 * f1) +
          0.0073 * e * math.sin(mp - m) -
          0.0050 * e * math.sin(mp + m) -
          0.0023 * math.sin(mp - 2 * f1) +
          0.0021 * e * math.sin(2 * m) +
          0.0012 * math.sin(mp + 2 * f1) +
          0.0006 * e * math.sin(2 * mp + m) -
          0.0004 * math.sin(3 * mp) -
          0.0003 * e * math.sin(m + 2 * f1) +
          0.0003 * math.sin(a1) -
          0.0002 * e * math.sin(m - 2 * f1) -
          0.0002 * e * math.sin(2 * mp - m) -
          0.0002 * math.sin(omg);

      return jdeMMP + jdeCorr;
    }
  }

  double geocentricConjunction(
    int hijriMonth,
    int hijriYear,
    double deltaT,
    String optR,
  ) {
    double jdNMGeo = 0.0;
    double jdNM = moonPhasesModified(hijriMonth, hijriYear, 1);

    double x1 = jdNM - 1 / 24.0;
    double x2 = jdNM;
    double x3 = jdNM + 1 / 24.0;

    double y1 =
        sn.sunGeocentricLongitude(x1, deltaT, "appa") -
        ml.moonGeocentricLongitude(x1, deltaT, "appa");
    double y2 =
        sn.sunGeocentricLongitude(x2, deltaT, "appa") -
        ml.moonGeocentricLongitude(x2, deltaT, "appa");
    double y3 =
        sn.sunGeocentricLongitude(x3, deltaT, "appa") -
        ml.moonGeocentricLongitude(x3, deltaT, "appa");

    double a = y2 - y1;
    double b = y3 - y2;
    double c = b - a;

    double n0 = 0.0;

    for (int i = 1; i <= 2; i++) {
      n0 = -2 * y2 / (a + b + c * n0);
      jdNMGeo = jdNM + n0 / 24.0;
    }

    double lonG = sn.sunGeocentricLongitude(jdNMGeo, deltaT, "appa");

    switch (optR) {
      case "Ijtima":
        return jdNMGeo;
      case "Bujur":
        return lonG;
      default:
        return jdNMGeo;
    }
  }

  double topocentricConjunction(
    int hijriMonth,
    int hijriYear,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
    String optR,
  ) {
    var jdNMTopo = 0.0;
    double jdNM = moonPhasesModified(hijriMonth, hijriYear, 1);

    double x1 = jdNM - 1 / 24.0;
    double x2 = jdNM;
    double x3 = jdNM + 1 / 24.0;

    double y1 =
        sn.sunTopocentricLongitude(x1, deltaT, gLon, gLat, elev) -
        moonTopocentricLongitude(x1, deltaT, gLon, gLat, elev);
    double y2 =
        sn.sunTopocentricLongitude(x2, deltaT, gLon, gLat, elev) -
        moonTopocentricLongitude(x2, deltaT, gLon, gLat, elev);
    double y3 =
        sn.sunTopocentricLongitude(x3, deltaT, gLon, gLat, elev) -
        moonTopocentricLongitude(x3, deltaT, gLon, gLat, elev);

    double a = y2 - y1;
    double b = y3 - y2;
    double c = b - a;

    var n0 = 0.0;
    n0 = -2 * y2 / (a + b + c * n0);

    for (int i = 1; i <= 2; i++) {
      n0 = -2 * y2 / (a + b + c * n0);
      jdNMTopo = jdNM + n0 / 24.0;
    }

    double lonT = sn.sunTopocentricLongitude(
      jdNMTopo,
      deltaT,
      gLon,
      gLat,
      elev,
    );

    switch (optR) {
      case "Ijtima":
        return jdNMTopo;
      case "Bujur":
        return lonT;
      default:
        return jdNMTopo;
    }
  }

  double moonTransitRiseSet(
    int tglM,
    int blnM,
    int thnM,
    double gLon,
    double gLat,
    double elev,
    double tmZn,
    String trsType,
    int maxItr,
  ) {
    double jd00LT;
    double jd00UT;
    double jde00UT;
    double alphaMm1d = 0.0;
    double alphaM00d = 0.0;
    double alphaMp1d = 0.0;
    double deltaMm1d = 0.0;
    double deltaM00d = 0.0;
    double deltaMp1d = 0.0;
    double pi;
    double h0 = 0.0;
    double cosHA0;
    double ha0; // bisa double atau "circumpolar"
    double t;
    double theta0 = 0.0;
    double m = 0.0;
    double sTheta0 = 0.0;
    double nT = 0.0;
    double alphaM = 0.0;
    double deltaM = 0.0;
    double ha = 0.0;
    double h = 0.0;
    double dltm = 0.0;
    double jdTRS;
    double ttrs = 0.0;

    jd00UT = jd.kmjd(tglM, blnM, thnM, tmZn, tmZn) + -1;

    for (int dItr = 1; dItr <= 3; dItr++) {
      jde00UT = jd00UT + dt.deltaT(jd00UT) / 86400.0;
      alphaM00d = moonGeocentricRightAscension(jde00UT, 0.0);
      alphaMm1d = moonGeocentricRightAscension(jde00UT - 1, 0);
      alphaMp1d = moonGeocentricRightAscension(jde00UT + 1, 0);

      if (trsType == "TRANSIT") {
        deltaM00d = 0.0;
        deltaMm1d = 0.0;
        deltaMp1d = 0.0;
      } else {
        deltaM00d = moonGeocentricDeclination(jde00UT, 0.0);
        deltaMm1d = moonGeocentricDeclination(jde00UT - 1, 0);
        deltaMp1d = moonGeocentricDeclination(jde00UT + 1, 0);
      }

      pi = moonEquatorialHorizontalParallax(jde00UT, 0.0);

      h0 = -(34 / 60.0) + 0.7275 * pi - 0.0353 * math.sqrt(elev);
      cosHA0 =
          (math.sin(mf.rad(h0)) -
              math.sin(mf.rad(gLat)) * math.sin(mf.rad(deltaM00d))) /
          (math.cos(mf.rad(gLat)) * math.cos(mf.rad(deltaM00d)));

      if ((cosHA0).abs() <= 1) {
        ha0 = mf.deg(math.acos(cosHA0));
      } else {
        ha0 = 0.0;
      }

      t = (jde00UT - 2451545) / 36525.0;

      theta0 =
          (100.46061837) +
          (36000.770053608 * t) +
          (0.000387933 * t * t) -
          (math.pow(t, 3.0) / 38710000) +
          (nt.nutationInLongitude(jde00UT, 0.0) *
              math.cos(mf.rad(nt.trueObliquityOfEcliptic(jde00UT, 0.0))));

      theta0 = mf.mod(theta0, 360.0);

      m = (alphaM00d - gLon - theta0) / 360.0;

      switch (trsType) {
        case "TRANSIT":
          m = m;
          break;
        case "RISE":
          m = m - ha0 / 360.0;
          break;
        case "SET":
          m = m + ha0 / 360.0;
          break;
      }

      m = mf.mod(m, 1.0);

      for (int itr = 1; itr <= maxItr; itr++) {
        sTheta0 = theta0 + 360.985647 * m;
        sTheta0 = mf.mod(sTheta0, 360.0);
        nT = m;
        alphaM = mf.mod(
          alphaM00d +
              nT /
                  2.0 *
                  (mf.mod((alphaM00d - alphaMm1d), 360.0) +
                      mf.mod((alphaMp1d - alphaM00d), 360.0) +
                      nT *
                          (mf.mod((alphaMp1d - alphaM00d), 360.0) -
                              mf.mod((alphaM00d - alphaMm1d), 360.0))),
          360.0,
        );

        if (trsType == "TRANSIT") {
          deltaM = 0.0;
        } else {
          deltaM =
              deltaM00d +
              nT /
                  2.0 *
                  ((deltaM00d - deltaMm1d) +
                      (deltaMp1d - deltaM00d) +
                      nT * ((deltaMp1d - deltaM00d) - (deltaM00d - deltaMm1d)));
        }

        ha = sTheta0 + gLon - alphaM;

        if (mf.mod(ha, 360.0) > 180.0) {
          ha = mf.mod(ha, 360.0) - 360.0;
        } else {
          ha = mf.mod(ha, 360.0);
        }

        h = mf.deg(
          math.asin(
            math.sin(mf.rad(gLat)) * math.sin(mf.rad(deltaM)) +
                math.cos(mf.rad(gLat)) *
                    math.cos(mf.rad(deltaM)) *
                    math.cos(mf.rad(ha)),
          ),
        );

        switch (trsType) {
          case "TRANSIT":
            dltm = -ha / 360.0;
            break;
          case "RISE":
          case "SET":
            dltm =
                (h - h0) /
                (360.0 *
                    math.cos(mf.rad(deltaM)) *
                    math.cos(mf.rad(gLat)) *
                    math.sin(mf.rad(ha)));
            break;
        }

        m = mf.mod(m + dltm, 1.0);
      }

      jdTRS = jd00UT + m;
      jd00LT = jd.kmjd(tglM, blnM, thnM, 0.0, tmZn);
      ttrs = double.parse(jd.jdkm(jdTRS, tmZn, "JAMDES"));

      if ((jdTRS >= (jd00LT + 0)) && (jdTRS <= (jd00LT + 1))) {
        ttrs = double.parse(jd.jdkm(jdTRS, tmZn, "JAMDES"));
      } else {
        jd00UT = jd00UT + 1;
        ttrs = 0.0;
      }
    }
    return ttrs;
  }
}
