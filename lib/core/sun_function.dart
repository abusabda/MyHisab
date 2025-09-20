import 'dart:math' as math;
import 'math_utils.dart';
import 'julian_day.dart';
import 'dynamical_time.dart';
import 'nutation.dart';

import '../data/sun_data_l00.dart';
import '../data/sun_data_l01.dart';
import '../data/sun_data_l02.dart';
import '../data/sun_data_l03.dart';
import '../data/sun_data_l04.dart';
import '../data/sun_data_l05.dart';

import '../data/sun_data_b00.dart';
import '../data/sun_data_b01.dart';
import '../data/sun_data_b02.dart';
import '../data/sun_data_b03.dart';
import '../data/sun_data_b04.dart';

import '../data/sun_data_r00.dart';
import '../data/sun_data_r01.dart';
import '../data/sun_data_r02.dart';
import '../data/sun_data_r03.dart';
import '../data/sun_data_r04.dart';
import '../data/sun_data_r05.dart';

class SunFunction {
  final l00 = SunDataL00.vsop87MtL0;
  final l01 = SunDataL01.vsop87MtL1;
  final l02 = SunDataL02.vsop87MtL2;
  final l03 = SunDataL03.vsop87MtL3;
  final l04 = SunDataL04.vsop87MtL4;
  final l05 = SunDataL05.vsop87MtL5;

  final b00 = SunDataB00.vsop87MtB0;
  final b01 = SunDataB01.vsop87MtB1;
  final b02 = SunDataB02.vsop87MtB2;
  final b03 = SunDataB03.vsop87MtB3;
  final b04 = SunDataB04.vsop87MtB4;

  final r00 = SunDataR00.vsop87MtR0;
  final r01 = SunDataR01.vsop87MtR1;
  final r02 = SunDataR02.vsop87MtR2;
  final r03 = SunDataR03.vsop87MtR3;
  final r04 = SunDataR04.vsop87MtR4;
  final r05 = SunDataR05.vsop87MtR5;

  final mf = MathFunction();
  final julianDay = JulianDay();
  final nt = NutationAndObliquity();
  final dt = DynamicalTime();

  double earthHeliocentricLongitude(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0; // waktu dalam Dynamical Time (TD)
    final t = julianDay.jc(jde);
    final tau = julianDay.jm(t);

    // L0 = 559 terms
    var l000sum = 0.0;
    for (var i = 0; i < 559; i++) {
      l000sum += l00[i][0] * math.cos(l00[i][1] + l00[i][2] * tau);
    }

    // L1 = 341 terms
    var l001sum = 0.0;
    for (var i = 0; i < 341; i++) {
      l001sum += l01[i][0] * math.cos(l01[i][1] + l01[i][2] * tau);
    }

    // L2 = 142 terms
    var l002sum = 0.0;
    for (var i = 0; i < 142; i++) {
      l002sum += l02[i][0] * math.cos(l02[i][1] + l02[i][2] * tau);
    }

    // L3 = 22 terms
    var l003sum = 0.0;
    for (var i = 0; i < 22; i++) {
      l003sum += l03[i][0] * math.cos(l03[i][1] + l03[i][2] * tau);
    }

    // L4 = 11 terms
    var l004sum = 0.0;
    for (var i = 0; i < 11; i++) {
      l004sum += l04[i][0] * math.cos(l04[i][1] + l04[i][2] * tau);
    }

    // L5 = 5 terms
    var l005sum = 0.0;
    for (var i = 0; i < 5; i++) {
      l005sum += l05[i][0] * math.cos(l05[i][1] + l05[i][2] * tau);
    }

    final l = mf.mod(
      mf.deg(
        l000sum +
            l001sum * tau +
            l002sum * math.pow(tau, 2.0) +
            l003sum * math.pow(tau, 3.0) +
            l004sum * math.pow(tau, 4.0) +
            l005sum * math.pow(tau, 5.0),
      ),
      360.0,
    );

    return l;
  }

  double earthHeliocentricLatitude(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);
    final tau = julianDay.jm(t);

    // b0 = 184 terms
    var b00sum = 0.0;
    for (var i = 0; i < 184; i++) {
      b00sum += b00[i][0] * math.cos(b00[i][1] + b00[i][2] * tau);
    }

    // b1 = 99 terms
    var b01sum = 0.0;
    for (var i = 0; i < 99; i++) {
      b01sum += b01[i][0] * math.cos(b01[i][1] + b01[i][2] * tau);
    }

    // b2 = 49 terms
    var b02sum = 0.0;
    for (var i = 0; i < 49; i++) {
      b02sum += b02[i][0] * math.cos(b02[i][1] + b02[i][2] * tau);
    }

    // b3 = 11 terms
    var b03sum = 0.0;
    for (var i = 0; i < 11; i++) {
      b03sum += b03[i][0] * math.cos(b03[i][1] + b03[i][2] * tau);
    }

    // b4 = 5 terms
    var b04sum = 0.0;
    for (var i = 0; i < 5; i++) {
      b04sum += b04[i][0] * math.cos(b04[i][1] + b04[i][2] * tau);
    }

    final b = mf.deg(
      b00sum +
          b01sum * tau +
          b02sum * math.pow(tau, 2.0) +
          b03sum * math.pow(tau, 3.0) +
          b04sum * math.pow(tau, 4.0),
    );

    return b;
  }

  double earthRadiusVector(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);
    final tau = julianDay.jm(t);

    // R0 = 526 terms
    var r000sum = 0.0;
    for (var i = 0; i < 526; i++) {
      r000sum += r00[i][0] * math.cos(r00[i][1] + r00[i][2] * tau);
    }

    // R1 = 292 terms
    var r001sum = 0.0;
    for (var i = 0; i < 292; i++) {
      r001sum += r01[i][0] * math.cos(r01[i][1] + r01[i][2] * tau);
    }

    // R2 = 139 terms
    var r002sum = 0.0;
    for (var i = 0; i < 139; i++) {
      r002sum += r02[i][0] * math.cos(r02[i][1] + r02[i][2] * tau);
    }

    // R3 = 27 terms
    var r003sum = 0.0;
    for (var i = 0; i < 27; i++) {
      r003sum += r03[i][0] * math.cos(r03[i][1] + r03[i][2] * tau);
    }

    // R4 = 10 terms
    var r004sum = 0.0;
    for (var i = 0; i < 10; i++) {
      r004sum += r04[i][0] * math.cos(r04[i][1] + r04[i][2] * tau);
    }

    // R5 = 3 terms
    var r005sum = 0.0;
    for (var i = 0; i < 3; i++) {
      r005sum += r05[i][0] * math.cos(r05[i][1] + r05[i][2] * tau);
    }

    final r =
        r000sum +
        r001sum * tau +
        r002sum * math.pow(tau, 2.0) +
        r003sum * math.pow(tau, 3.0) +
        r004sum * math.pow(tau, 4.0) +
        r005sum * math.pow(tau, 5.0);

    return r;
  }

  double sunGeocentricLongitude(double jd, double deltaT, String optional) {
    final l = earthHeliocentricLongitude(jd, deltaT);
    final b = earthHeliocentricLatitude(jd, deltaT);
    final theta = mf.mod(l + 180.0, 360.0);
    final beta = -b;

    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);

    final lmbdP = mf.mod(theta - 1.397 * t - 0.00031 * t * t, 360.0);
    final dltTh =
        (-0.09033 +
            0.03916 *
                (math.cos(mf.rad(lmbdP)) + math.sin(mf.rad(lmbdP))) *
                math.tan(mf.rad(beta))) /
        3600.0;
    final thtaFK5 = theta + dltTh;

    final dltPsi = nt.nutationInLongitude(jd, deltaT);
    final aberr = sunAberration(jd, deltaT) / 3600.0;
    final lambd = mf.mod(thtaFK5 + dltPsi + aberr, 360.0);

    switch (optional) {
      case "True":
        return thtaFK5;
      case "Appa":
        return lambd;
      default:
        return lambd;
    }
  }

  double sunGeocentricLatitude(double jd, double deltaT) {
    final l = earthHeliocentricLongitude(jd, deltaT);
    final b = earthHeliocentricLatitude(jd, deltaT);
    final theta = mf.mod(l + 180.0, 360.0);
    final beta = -b;

    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jce(jde);

    final lambdP = theta - 1.397 * t - 0.00031 * t * t;
    final dltBta =
        (0.03916 * (math.cos(mf.rad(lambdP)) - math.sin(mf.rad(lambdP)))) /
        3600.0;

    final btaFk5 = beta + dltBta;
    return btaFk5;
  }

  double sunGeocentricDistance(double jd, double deltaT, String opt) {
    final r = earthRadiusVector(jd, deltaT);
    final rAU = r;
    final rKM = r * 149597870.7;
    final rER = r * 149597870.7 / 6371.0;

    switch (opt) {
      case "AU":
        return rAU;
      case "KM":
        return rKM;
      case "ER":
        return rER;
      default:
        return rAU;
    }
  }

  double sunAberration(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);
    final tau = julianDay.jm(t);

    // dL (Δλ) dari VSOP87D, satuan arcseconds
    final dL =
        3548.330 +
        118.568 * math.sin(mf.rad(87.5287 + 359993.7286 * tau)) +
        2.476 * math.sin(mf.rad(85.0561 + 719987.4571 * tau)) +
        1.376 * math.sin(mf.rad(27.8502 + 4452671.1152 * tau)) +
        0.119 * math.sin(mf.rad(73.1375 + 450368.8564 * tau)) +
        0.114 * math.sin(mf.rad(337.2264 + 329644.6718 * tau)) +
        0.086 * math.sin(mf.rad(222.5400 + 659289.3436 * tau)) +
        0.078 * math.sin(mf.rad(162.8136 + 9224659.7915 * tau)) +
        0.054 * math.sin(mf.rad(82.5823 + 1079981.1857 * tau)) +
        0.052 * math.sin(mf.rad(171.5189 + 225184.4282 * tau)) +
        0.034 * math.sin(mf.rad(30.3214 + 4092677.3866 * tau)) +
        0.033 * math.sin(mf.rad(119.8105 + 337181.4711 * tau)) +
        0.023 * math.sin(mf.rad(247.5418 + 299295.6151 * tau)) +
        0.023 * math.sin(mf.rad(325.1526 + 315559.5560 * tau)) +
        0.021 * math.sin(mf.rad(155.1241 + 675553.2846 * tau)) +
        7.311 * tau * math.sin(mf.rad(333.4515 + 359993.7286 * tau)) +
        0.305 * tau * math.sin(mf.rad(330.9814 + 719987.4571 * tau)) +
        0.010 * tau * math.sin(mf.rad(328.5170 + 1079981.1857 * tau)) +
        0.309 * tau * tau * math.sin(mf.rad(241.4518 + 359993.7286 * tau)) +
        0.021 * tau * tau * math.sin(mf.rad(205.0482 + 719987.4571 * tau)) +
        0.004 * tau * tau * math.sin(mf.rad(297.8610 + 4452671.1152 * tau)) +
        0.010 *
            tau *
            tau *
            tau *
            math.sin(mf.rad(154.7066 + 359993.7286 * tau));

    // jarak Matahari (dalam AU)
    final r = sunGeocentricDistance(jd, deltaT, "AU");

    // hasil dalam arcseconds
    final abr = -0.005775518 * r * dL;

    // kalau mau dijadikan derajat, tinggal abr / 3600
    return abr;
  }

  double sunGeocentricRightAscension(double jd, double deltaT) {
    final lambda = sunGeocentricLongitude(jd, deltaT, "Appa");
    final beta = sunGeocentricLatitude(jd, deltaT);
    final epsilon = nt.trueObliquityOfEcliptic(jd, deltaT);

    final alphaFK5 = mf.mod(
      mf.deg(
        math.atan2(
          math.sin(mf.rad(lambda)) * math.cos(mf.rad(epsilon)) -
              math.tan(mf.rad(beta)) * math.sin(mf.rad(epsilon)),
          math.cos(mf.rad(lambda)),
        ),
      ),
      360.0,
    );

    return alphaFK5;
  }

  double sunGeocentricDeclination(double jd, double deltaT) {
    final lambda = sunGeocentricLongitude(jd, deltaT, "Appa");
    final beta = sunGeocentricLatitude(jd, deltaT);
    final epsilon = nt.trueObliquityOfEcliptic(jd, deltaT);

    final deltaFK5 = mf.deg(
      math.asin(
        math.sin(mf.rad(beta)) * math.cos(mf.rad(epsilon)) +
            math.cos(mf.rad(beta)) *
                math.sin(mf.rad(epsilon)) *
                math.sin(mf.rad(lambda)),
      ),
    );

    return deltaFK5;
  }

  double greenwichMeanSiderialTime(double jd) {
    final t = julianDay.jc(jd);
    final gmst = mf.mod(
      280.46061837 +
          360.98564736629 * (jd - 2451545.0) +
          0.000387933 * math.pow(t, 2.0) -
          (math.pow(t, 3.0) / 38710000),
      360.0,
    );
    return gmst;
  }

  double greenwichApparentSiderialTime(double jd, double deltaT) {
    double gmst = greenwichMeanSiderialTime(jd);
    double dPsi = nt.nutationInLongitude(jd, deltaT);
    double eps = nt.trueObliquityOfEcliptic(jd, deltaT);
    double gast = mf.mod(gmst + dPsi * math.cos(mf.rad(eps)), 360.0);
    return gast;
  }

  double localApparentSiderialTime(double jd, double deltaT, double gLon) {
    double gast = greenwichApparentSiderialTime(jd, deltaT);
    double last = mf.mod(gast + gLon, 360.0);
    return last;
  }

  double sunGeocentricGreenwichHourAngle(double jd, double deltaT) {
    final gast = greenwichApparentSiderialTime(jd, deltaT);
    final alpha = sunGeocentricRightAscension(jd, deltaT);
    final gha = mf.mod(gast - alpha, 360.0);
    return gha;
  }

  double sunGeocentricLocalHourAngle(double jd, double deltaT, double gLon) {
    final gast = greenwichApparentSiderialTime(jd, deltaT);
    final alpha = sunGeocentricRightAscension(jd, deltaT);
    final lhaFK5 = mf.mod(gast + gLon - alpha, 360.0);
    return lhaFK5;
  }

  double sunGeocentricAzimuth(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
  ) {
    final lha = sunGeocentricLocalHourAngle(jd, deltaT, gLon);
    final dec = sunGeocentricDeclination(jd, deltaT);
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

  double sunGeocentricAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
  ) {
    final lha = sunGeocentricLocalHourAngle(jd, deltaT, gLon);
    final dec = sunGeocentricDeclination(jd, deltaT);
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

  double sunGeocentricSemidiameter(double jd, double deltaT) {
    double r = earthRadiusVector(jd, deltaT);
    double s0 = 15 + 59.63 / 60; // 15'59.63" dalam menit
    double s = (s0 / r) / 60.0; // hasil dalam derajat
    return s;
  }

  double sunEquatorialHorizontalParallax(double jd, double deltaT) {
    double er = earthRadiusVector(jd, deltaT);
    double phi = 8.794 / (er * 3600); // hasil dalam derajat
    return phi;
  }

  double termU(double gLat) {
    double u = math.atan(0.99664719 * math.tan(mf.rad(gLat)));
    return u;
  }

  double termX(double gLat, double elev) {
    double u = termU(gLat);
    double x = math.cos(u) + (elev / 6378140.0) * math.cos(mf.rad(gLat));
    return x;
  }

  double termY(double gLat, double elev) {
    double u = termU(gLat);
    double y =
        0.99664719 * math.sin(u) + (elev / 6378140.0) * math.sin(mf.rad(gLat));
    return y;
  }

  double termN(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lambda = sunGeocentricLongitude(jd, deltaT, "Appa");
    double beta = sunGeocentricLatitude(jd, deltaT);
    double theta = localApparentSiderialTime(jd, deltaT, gLon);
    double x = termX(gLat, elev);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double n =
        math.cos(mf.rad(lambda)) * math.cos(mf.rad(beta)) -
        x * math.sin(mf.rad(phi)) * math.cos(mf.rad(theta));
    return n;
  }

  double parallaxInTheSunRightAscension(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double x = termX(gLat, elev);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double ha = sunGeocentricLocalHourAngle(jd, deltaT, gLon);
    double dec = sunGeocentricDeclination(jd, deltaT);
    double dAlpha = mf.deg(
      math.atan2(
        -x * math.sin(mf.rad(phi)) * math.sin(mf.rad(ha)),
        math.cos(mf.rad(dec)) -
            x * math.sin(mf.rad(phi)) * math.cos(mf.rad(ha)),
      ),
    );
    return dAlpha;
  }

  double parallaxInTheSunAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double h = sunGeocentricAltitude(jd, deltaT, gLon, gLat);
    double y = termY(gLat, elev);
    double x = termX(gLat, elev);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double P = mf.deg(
      math.sin(
        math.sqrt(y * y + x * x) * math.sin(mf.rad(phi)) * math.cos(mf.rad(h)),
      ),
    );
    return P;
  }

  double atmosphericRefractionFromAirlessAltitude(
    double airlessAltitude,
    double pressure,
    double temperature,
  ) {
    double h = airlessAltitude;
    double P = pressure;
    double t = temperature;
    return (1.02 /
                math.tan(mf.rad(h + 10.3 / (h + 5.11))) *
                P /
                1010.0 *
                283.0 /
                (273.0 + t) +
            0.0019279204034639303) /
        60.0;
  }

  double sunTopocentricLongitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lambda = sunGeocentricLongitude(jd, deltaT, "Appa");
    double beta = sunGeocentricLatitude(jd, deltaT);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double theta = localApparentSiderialTime(jd, deltaT, gLon);
    double eps = nt.trueObliquityOfEcliptic(jd, deltaT);
    double x = termX(gLat, elev);
    double y = termY(gLat, elev);
    double n = termN(jd, deltaT, gLon, gLat, elev);

    double lmbdP = mf.mod(
      mf.deg(
        math.atan2(
          (math.sin(mf.rad(lambda)) * math.cos(mf.rad(beta)) -
              math.sin(mf.rad(phi)) *
                  (y * math.sin(mf.rad(eps)) +
                      x * math.cos(mf.rad(eps)) * math.sin(mf.rad(theta)))),
          n,
        ),
      ),
      360.0,
    );
    return lmbdP;
  }

  double sunTopocentricLatitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lmbdP = sunTopocentricLongitude(jd, deltaT, gLon, gLat, elev);
    double beta = sunGeocentricLatitude(jd, deltaT);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double theta = localApparentSiderialTime(jd, deltaT, gLon);
    double eps = nt.trueObliquityOfEcliptic(jd, deltaT);
    double x = termX(gLat, elev);
    double y = termY(gLat, elev);
    double n = termN(jd, deltaT, gLon, gLat, elev);

    double btaP = mf.deg(
      math.atan(
        math.cos(mf.rad(lmbdP)) *
            (math.sin(mf.rad(beta)) -
                math.sin(mf.rad(phi)) *
                    (y * math.cos(mf.rad(eps)) -
                        x * math.sin(mf.rad(eps)) * math.sin(mf.rad(theta)))) /
            n,
      ),
    );
    return btaP;
  }

  double sunTopocentricRightAscension(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double alpha = sunGeocentricRightAscension(jd, deltaT);
    double dAlpha = parallaxInTheSunRightAscension(
      jd,
      deltaT,
      gLon,
      gLat,
      elev,
    );
    double alphP = alpha + dAlpha;
    return alphP;
  }

  double sunTopocentricDeclination(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double dec = sunGeocentricDeclination(jd, deltaT);
    double y = termY(gLat, elev);
    double x = termX(gLat, elev);
    double phi = sunEquatorialHorizontalParallax(jd, deltaT);
    double dAlph = parallaxInTheSunRightAscension(jd, deltaT, gLon, gLat, elev);
    double ha = sunGeocentricLocalHourAngle(jd, deltaT, gLon);

    double dltP = mf.deg(
      math.atan2(
        (math.sin(mf.rad(dec)) - y * math.sin(mf.rad(phi))) *
            math.cos(mf.rad(dAlph)),
        math.cos(mf.rad(dec)) -
            x * math.sin(mf.rad(phi)) * math.cos(mf.rad(ha)),
      ),
    );

    return dltP;
  }

  double sunTopocentricGreenwichHourAngle(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double gast = greenwichApparentSiderialTime(jd, deltaT);
    double alpha = sunTopocentricRightAscension(jd, deltaT, gLon, gLat, elev);
    double gha = mf.mod(gast - alpha, 360.0);
    return gha;
  }

  double sunTopocentricLocalHourAngel(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lha = sunGeocentricLocalHourAngle(jd, deltaT, gLon);
    double dAlph = parallaxInTheSunRightAscension(jd, deltaT, gLon, gLat, elev);
    double lhaP = lha - dAlph;
    return lhaP;
  }

  double sunTopocentricAzimuth(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lhaP = sunTopocentricLocalHourAngel(jd, deltaT, gLon, gLat, elev);
    double dltP = sunTopocentricDeclination(jd, deltaT, gLon, gLat, elev);

    double azmP = mf.mod(
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

  double sunTopocentricAltitude(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
    double pres,
    double temp,
    String opt, // default sama dengan Kotlin else-case
  ) {
    double dec = sunTopocentricDeclination(jd, deltaT, gLon, gLat, elev);
    double lha = sunTopocentricLocalHourAngel(jd, deltaT, gLon, gLat, elev);
    double h = sunGeocentricAltitude(jd, deltaT, gLon, gLat);

    double rfr = atmosphericRefractionFromAirlessAltitude(h, pres, temp);
    double dip = 1.75 / 60 * math.sqrt(elev);

    double ht = mf.deg(
      math.asin(
        math.sin(mf.rad(gLat)) * math.sin(mf.rad(dec)) +
            math.cos(mf.rad(gLat)) *
                math.cos(mf.rad(dec)) *
                math.cos(mf.rad(lha)),
      ),
    ); // Airless Topo Altitude

    double hta = ht + rfr; // Apparent Topo Altitude
    double hto = hta + dip; // Observed Topo Altitude

    switch (opt) {
      case "ht":
        return ht;
      case "hta":
        return hta;
      case "hto":
        return hto;
      default:
        return ht;
    }
  }

  double sunTopocentricSemidiameter(
    double jd,
    double deltaT,
    double gLon,
    double gLat,
    double elev,
  ) {
    double lmbdP = sunTopocentricLongitude(jd, deltaT, gLon, gLat, elev);
    double betaP = sunTopocentricLatitude(jd, deltaT, gLon, gLat, elev);
    double s = sunGeocentricSemidiameter(jd, deltaT);
    double n = termN(jd, deltaT, gLon, gLat, elev);

    double sP = mf.deg(
      math.asin(
        math.cos(mf.rad(lmbdP)) *
            math.cos(mf.rad(betaP)) *
            math.sin(mf.rad(s)) /
            n,
      ),
    );

    return sP;
  }

  double equationOfTime(double jd, double deltaT) {
    double jde = jd + deltaT / 86400.0;
    double t = julianDay.jc(jde);
    double tau = julianDay.jm(t);

    double alpha = sunGeocentricRightAscension(jd, deltaT);
    double dPsi = nt.nutationInLongitude(jd, deltaT);
    double epsln = nt.trueObliquityOfEcliptic(jd, deltaT);

    double lo = mf.mod(
      280.4664567 +
          360007.6982779 * tau +
          0.03032028 * math.pow(tau, 2.0) +
          math.pow(tau, 3.0) / 49931 -
          math.pow(tau, 4.0) / 15300 -
          math.pow(tau, 5.0) / 2000000,
      360.0,
    );

    double e = lo - 0.0057183 - alpha + dPsi * math.cos(mf.rad(epsln));

    if ((e.abs() * 4) < 20) {
      e = e / 15;
    } else if ((e.abs() * 4 >= 20) && (e > 0)) {
      e = e / 15 - 24;
    } else if ((e.abs() * 4 >= 20) && (e < 0)) {
      e = e / 15 + 24;
    } else {
      e = e / 15;
    }

    return e;
  }

  double jdGhurubSyams(
    double jdNM,
    double gLat,
    double gLon,
    double elev,
    double tmZn,
  ) {
    double haS = 0.0;
    double kwd = 0.0;
    double jSunSet = 17.0;

    // Sama dengan math.floor
    double cJDN = (jdNM + 0.5 + (tmZn / 24.0)).floorToDouble();

    for (int i = 1; i <= 2; i++) {
      double jdGS = cJDN - 0.5 + (jSunSet - tmZn) / 24.0;
      double jdeGS = jdGS + dt.deltaT(jdGS) / 86400.0;
      double dltS = sunGeocentricDeclination(jdeGS, 0.0);
      double sdS = sunGeocentricSemidiameter(jdeGS, 0.0);
      double eoT = equationOfTime(jdeGS, 0.0);
      double rfS = 34.16 / 60.0;
      double dip = 2.1 * math.sqrt(elev) / 60.0;
      double altS = 0 - sdS - rfS - dip + 0.0024;

      double coshaS =
          (math.sin(mf.rad(altS)) -
              math.sin(mf.rad(gLat)) * math.sin(mf.rad(dltS))) /
          (math.cos(mf.rad(gLat)) * math.cos(mf.rad(dltS)));

      if (coshaS.abs() < 1) {
        haS = mf.deg(math.acos(coshaS));
        kwd = gLon / 15.0 - tmZn;
        jSunSet = haS / 15.0 + 12.0 - eoT - kwd;
      } else {
        jSunSet = double.nan;
      }
    }

    double jdGS = cJDN - 0.5 + (jSunSet - tmZn) / 24.0;
    return jdGS;
  }
}
