import 'dart:math' as math;
import 'math_utils.dart';
import 'julian_day.dart';

import '../data/moon_data_b001.dart';
import '../data/moon_data_b002.dart';
import '../data/moon_data_b003.dart';
import '../data/moon_data_b004.dart';
import '../data/moon_data_b005.dart';
import '../data/moon_data_b006.dart';
import '../data/moon_data_b007.dart';
import '../data/moon_data_b008.dart';
import '../data/moon_data_b101.dart';
import '../data/moon_data_b201.dart';

class MoonLatitude {
  final julianDay = JulianDay();
  final b001 = MoonDataB001.elpMpp02MtB0;
  final b002 = MoonDataB002.elpMpp02MtB0;
  final b003 = MoonDataB003.elpMpp02MtB0;
  final b004 = MoonDataB004.elpMpp02MtB0;
  final b005 = MoonDataB005.elpMpp02MtB0;
  final b006 = MoonDataB006.elpMpp02MtB0;
  final b007 = MoonDataB007.elpMpp02MtB0;
  final b008 = MoonDataB008.elpMpp02MtB0;

  final b101 = MoonDataB101.elpMpp02MtB1;
  final b201 = MoonDataB201.elpMpp02MtB2;

  final mf = MathFunction();
  final jd = JulianDay();

  double moonGeocentricLatitude(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;

    // waktu Julian Century
    final t = julianDay.jc(jde);
    final t1 = math.pow(t, 1.0);
    final t2 = math.pow(t, 2.0);
    final t3 = math.pow(t, 3.0);
    final t4 = math.pow(t, 4.0);

    double b001sum = 0.0;
    for (var aa = 0; aa < 1000; aa++) {
      b001sum +=
          b001[aa][0] *
          math.sin(
            b001[aa][1] +
                b001[aa][2] * t1 +
                b001[aa][3] * t2 +
                b001[aa][4] * t3 +
                b001[aa][5] * t4,
          );
    }

    double b002sum = 0.0;
    for (var bb = 0; bb < 1000; bb++) {
      b002sum +=
          b002[bb][0] *
          math.sin(
            b002[bb][1] +
                b002[bb][2] * t1 +
                b002[bb][3] * t2 +
                b002[bb][4] * t3 +
                b002[bb][5] * t4,
          );
    }

    double b003sum = 0.0;
    for (var cc = 0; cc < 1000; cc++) {
      b003sum +=
          b003[cc][0] *
          math.sin(
            b003[cc][1] +
                b003[cc][2] * t1 +
                b003[cc][3] * t2 +
                b003[cc][4] * t3 +
                b003[cc][5] * t4,
          );
    }

    double b004sum = 0.0;
    for (var dd = 0; dd < 1000; dd++) {
      b004sum +=
          b004[dd][0] *
          math.sin(
            b004[dd][1] +
                b004[dd][2] * t1 +
                b004[dd][3] * t2 +
                b004[dd][4] * t3 +
                b004[dd][5] * t4,
          );
    }

    double b005sum = 0.0;
    for (var ee = 0; ee < 1000; ee++) {
      b005sum +=
          b005[ee][0] *
          math.sin(
            b005[ee][1] +
                b005[ee][2] * t1 +
                b005[ee][3] * t2 +
                b005[ee][4] * t3 +
                b005[ee][5] * t4,
          );
    }

    double b006sum = 0.0;
    for (var ff = 0; ff < 1000; ff++) {
      b006sum +=
          b006[ff][0] *
          math.sin(
            b006[ff][1] +
                b006[ff][2] * t1 +
                b006[ff][3] * t2 +
                b006[ff][4] * t3 +
                b006[ff][5] * t4,
          );
    }

    double b007sum = 0.0;
    for (var gg = 0; gg < 1000; gg++) {
      b007sum +=
          b007[gg][0] *
          math.sin(
            b007[gg][1] +
                b007[gg][2] * t1 +
                b007[gg][3] * t2 +
                b007[gg][4] * t3 +
                b007[gg][5] * t4,
          );
    }

    double b008sum = 0.0;
    for (var hh = 0; hh < 380; hh++) {
      b008sum +=
          b008[hh][0] *
          math.sin(
            b008[hh][1] +
                b008[hh][2] * t1 +
                b008[hh][3] * t2 +
                b008[hh][4] * t3 +
                b008[hh][5] * t4,
          );
    }

    double b101sum = 0.0;
    for (var ii = 0; ii < 516; ii++) {
      b101sum +=
          b101[ii][0] *
          math.sin(
            b101[ii][1] +
                b101[ii][2] * t1 +
                b101[ii][3] * t2 +
                b101[ii][4] * t3 +
                b101[ii][5] * t4,
          );
    }

    double b201sum = 0.0;
    for (var jj = 0; jj < 52; jj++) {
      b201sum +=
          b201[jj][0] *
          math.sin(
            b201[jj][1] +
                b201[jj][2] * t1 +
                b201[jj][3] * t2 +
                b201[jj][4] * t3 +
                b201[jj][5] * t4,
          );
    }

    final b0 =
        b001sum +
        b002sum +
        b003sum +
        b004sum +
        b005sum +
        b006sum +
        b007sum +
        b008sum;
    final b1 = b101sum;
    final b2 = b201sum;

    final b = b0 + b1 * t1 + b2 * t2;

    final abr = -0.00001754 * math.sin(mf.rad(183.3 + 483202.0 * t));

    final moonLat = b / 3600.0 + abr;

    return moonLat;
  }
}
