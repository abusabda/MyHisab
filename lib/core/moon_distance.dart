import 'dart:math' as math;
import 'julian_day.dart';
import 'math_utils.dart';

// import semua data R001..R013, R101, R201, R301
import '../data/moon_data_r001.dart';
import '../data/moon_data_r002.dart';
import '../data/moon_data_r003.dart';
import '../data/moon_data_r004.dart';
import '../data/moon_data_r005.dart';
import '../data/moon_data_r006.dart';
import '../data/moon_data_r007.dart';
import '../data/moon_data_r008.dart';
import '../data/moon_data_r009.dart';
import '../data/moon_data_r010.dart';
import '../data/moon_data_r011.dart';
import '../data/moon_data_r012.dart';
import '../data/moon_data_r013.dart';
import '../data/moon_data_r101.dart';
import '../data/moon_data_r201.dart';
import '../data/moon_data_r301.dart';

class MoonDistance {
  final r001 = MoonDataR001.elpMpp02MtR0;
  final r002 = MoonDataR002.elpMpp02MtR0;
  final r003 = MoonDataR003.elpMpp02MtR0;
  final r004 = MoonDataR004.elpMpp02MtR0;
  final r005 = MoonDataR005.elpMpp02MtR0;
  final r006 = MoonDataR006.elpMpp02MtR0;
  final r007 = MoonDataR007.elpMpp02MtR0;
  final r008 = MoonDataR008.elpMpp02MtR0;
  final r009 = MoonDataR009.elpMpp02MtR0;
  final r010 = MoonDataR010.elpMpp02MtR0;
  final r011 = MoonDataR011.elpMpp02MtR0;
  final r012 = MoonDataR012.elpMpp02MtR0;
  final r013 = MoonDataR013.elpMpp02MtR0;

  final r101 = MoonDataR101.elpMpp02MtR1;
  final r201 = MoonDataR201.elpMpp02MtR2;
  final r301 = MoonDataR301.elpMpp02MtR3;

  final mf = MathFunction();
  final julianDay = JulianDay();

  double moonGeocentricDistance(double jd, double deltaT, String opt) {
    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);
    final t1 = math.pow(t, 1.0);
    final t2 = math.pow(t, 2.0);
    final t3 = math.pow(t, 3.0);
    final t4 = math.pow(t, 4.0);

    var r001sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r001sum +=
          r001[i][0] *
          math.sin(
            r001[i][1] +
                r001[i][2] * t1 +
                r001[i][3] * t2 +
                r001[i][4] * t3 +
                r001[i][5] * t4,
          );
    }

    var r002sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r002sum +=
          r002[i][0] *
          math.sin(
            r002[i][1] +
                r002[i][2] * t1 +
                r002[i][3] * t2 +
                r002[i][4] * t3 +
                r002[i][5] * t4,
          );
    }

    var r003sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r003sum +=
          r003[i][0] *
          math.sin(
            r003[i][1] +
                r003[i][2] * t1 +
                r003[i][3] * t2 +
                r003[i][4] * t3 +
                r003[i][5] * t4,
          );
    }

    var r004sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r004sum +=
          r004[i][0] *
          math.sin(
            r004[i][1] +
                r004[i][2] * t1 +
                r004[i][3] * t2 +
                r004[i][4] * t3 +
                r004[i][5] * t4,
          );
    }

    var r005sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r005sum +=
          r005[i][0] *
          math.sin(
            r005[i][1] +
                r005[i][2] * t1 +
                r005[i][3] * t2 +
                r005[i][4] * t3 +
                r005[i][5] * t4,
          );
    }

    var r006sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r006sum +=
          r006[i][0] *
          math.sin(
            r006[i][1] +
                r006[i][2] * t1 +
                r006[i][3] * t2 +
                r006[i][4] * t3 +
                r006[i][5] * t4,
          );
    }

    var r007sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r007sum +=
          r007[i][0] *
          math.sin(
            r007[i][1] +
                r007[i][2] * t1 +
                r007[i][3] * t2 +
                r007[i][4] * t3 +
                r007[i][5] * t4,
          );
    }

    var r008sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r008sum +=
          r008[i][0] *
          math.sin(
            r008[i][1] +
                r008[i][2] * t1 +
                r008[i][3] * t2 +
                r008[i][4] * t3 +
                r008[i][5] * t4,
          );
    }

    var r009sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r009sum +=
          r009[i][0] *
          math.sin(
            r009[i][1] +
                r009[i][2] * t1 +
                r009[i][3] * t2 +
                r009[i][4] * t3 +
                r009[i][5] * t4,
          );
    }

    var r010sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r010sum +=
          r010[i][0] *
          math.sin(
            r010[i][1] +
                r010[i][2] * t1 +
                r010[i][3] * t2 +
                r010[i][4] * t3 +
                r010[i][5] * t4,
          );
    }

    var r011sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r011sum +=
          r011[i][0] *
          math.sin(
            r011[i][1] +
                r011[i][2] * t1 +
                r011[i][3] * t2 +
                r011[i][4] * t3 +
                r011[i][5] * t4,
          );
    }

    var r012sum = 0.0;
    for (var i = 0; i < 1000; i++) {
      r012sum +=
          r012[i][0] *
          math.sin(
            r012[i][1] +
                r012[i][2] * t1 +
                r012[i][3] * t2 +
                r012[i][4] * t3 +
                r012[i][5] * t4,
          );
    }

    var r013sum = 0.0;
    for (var i = 0; i < 819; i++) {
      r013sum +=
          r013[i][0] *
          math.sin(
            r013[i][1] +
                r013[i][2] * t1 +
                r013[i][3] * t2 +
                r013[i][4] * t3 +
                r013[i][5] * t4,
          );
    }

    var r101sum = 0.0;
    for (var i = 0; i < 1165; i++) {
      r101sum +=
          r101[i][0] *
          math.sin(
            r101[i][1] +
                r101[i][2] * t1 +
                r101[i][3] * t2 +
                r101[i][4] * t3 +
                r101[i][5] * t4,
          );
    }

    var r201sum = 0.0;
    for (var i = 0; i < 210; i++) {
      r201sum +=
          r201[i][0] *
          math.sin(
            r201[i][1] +
                r201[i][2] * t1 +
                r201[i][3] * t2 +
                r201[i][4] * t3 +
                r201[i][5] * t4,
          );
    }

    var r301sum = 0.0;
    for (var i = 0; i < 2; i++) {
      r301sum +=
          r301[i][0] *
          math.sin(
            r301[i][1] +
                r301[i][2] * t1 +
                r301[i][3] * t2 +
                r301[i][4] * t3 +
                r301[i][5] * t4,
          );
    }

    final r0 =
        r001sum +
        r002sum +
        r003sum +
        r004sum +
        r005sum +
        r006sum +
        r007sum +
        r008sum +
        r009sum +
        r010sum +
        r011sum +
        r012sum +
        r013sum;

    final r1 = r101sum;
    final r2 = r201sum;
    final r3 = r301sum;

    final rp = r0 + r1 * t1 + r2 * t2 + r3 * t3;
    final abr = 0.0708 * math.cos(mf.rad(225.0 + 477198.9 * t));

    final r = r0 + r1 * t1 + r2 * t2 + r3 * t3 + abr;

    final rKM = r;
    final rAU = r / 149597870.7;
    final rER = r / 6371.0;

    switch (opt) {
      case "R0":
        return r0;
      case "R1":
        return r1;
      case "R2":
        return r2;
      case "R3":
        return r3;
      case "Rp":
        return rp;
      case "R":
        return r;
      case "KM":
        return rKM;
      case "AU":
        return rAU;
      case "ER":
        return rER;
      default:
        return rKM;
    }
  }
}
