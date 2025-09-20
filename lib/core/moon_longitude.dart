import 'dart:math' as math;
import 'math_utils.dart';
import 'julian_day.dart';
import 'nutation.dart';

import '../data/moon_data_l001.dart';
import '../data/moon_data_l002.dart';
import '../data/moon_data_l003.dart';
import '../data/moon_data_l004.dart';
import '../data/moon_data_l005.dart';
import '../data/moon_data_l006.dart';
import '../data/moon_data_l007.dart';
import '../data/moon_data_l008.dart';
import '../data/moon_data_l009.dart';
import '../data/moon_data_l010.dart';
import '../data/moon_data_l011.dart';
import '../data/moon_data_l012.dart';
import '../data/moon_data_l013.dart';
import '../data/moon_data_l101.dart';
import '../data/moon_data_l201.dart';
import '../data/moon_data_l301.dart';

class MoonLongitude {
  final l001 = MoonDataL001.elpMpp02MtL0;
  final l002 = MoonDataL002.elpMpp02MtL0;
  final l003 = MoonDataL003.elpMpp02MtL0;
  final l004 = MoonDataL004.elpMpp02MtL0;
  final l005 = MoonDataL005.elpMpp02MtL0;
  final l006 = MoonDataL006.elpMpp02MtL0;
  final l007 = MoonDataL007.elpMpp02MtL0;
  final l008 = MoonDataL008.elpMpp02MtL0;
  final l009 = MoonDataL009.elpMpp02MtL0;
  final l010 = MoonDataL010.elpMpp02MtL0;
  final l011 = MoonDataL011.elpMpp02MtL0;
  final l012 = MoonDataL012.elpMpp02MtL0;
  final l013 = MoonDataL013.elpMpp02MtL0;

  final l101 = MoonDataL101.elpMpp02MtL1;
  final l201 = MoonDataL201.elpMpp02MtL2;
  final l301 = MoonDataL301.elpMpp02MtL3;

  final mf = MathFunction();
  final nt = NutationAndObliquity();
  final julianDay = JulianDay();

  double moonGeocentricLongitude(double jd, double deltaT, String opt) {
    final jde = jd + deltaT / 86400.0;
    final t = julianDay.jc(jde);
    final t1 = math.pow(t, 1.0);
    final t2 = math.pow(t, 2.0);
    final t3 = math.pow(t, 3.0);
    final t4 = math.pow(t, 4.0);

    var l001sum = 0.0;
    for (var aa = 0; aa < 1000; aa++) {
      l001sum +=
          l001[aa][0] *
          math.sin(
            l001[aa][1] +
                l001[aa][2] * t1 +
                l001[aa][3] * t2 +
                l001[aa][4] * t3 +
                l001[aa][5] * t4,
          );
    }

    var l002sum = 0.0;
    for (var bb = 0; bb < 1000; bb++) {
      l002sum +=
          l002[bb][0] *
          math.sin(
            l002[bb][1] +
                l002[bb][2] * t1 +
                l002[bb][3] * t2 +
                l002[bb][4] * t3 +
                l002[bb][5] * t4,
          );
    }

    var l003sum = 0.0;
    for (var cc = 0; cc < 1000; cc++) {
      l003sum +=
          l003[cc][0] *
          math.sin(
            l003[cc][1] +
                l003[cc][2] * t1 +
                l003[cc][3] * t2 +
                l003[cc][4] * t3 +
                l003[cc][5] * t4,
          );
    }

    var l004sum = 0.0;
    for (var dd = 0; dd < 1000; dd++) {
      l004sum +=
          l004[dd][0] *
          math.sin(
            l004[dd][1] +
                l004[dd][2] * t1 +
                l004[dd][3] * t2 +
                l004[dd][4] * t3 +
                l004[dd][5] * t4,
          );
    }

    var l005sum = 0.0;
    for (var ee = 0; ee < 1000; ee++) {
      l005sum +=
          l005[ee][0] *
          math.sin(
            l005[ee][1] +
                l005[ee][2] * t1 +
                l005[ee][3] * t2 +
                l005[ee][4] * t3 +
                l005[ee][5] * t4,
          );
    }

    var l006sum = 0.0;
    for (var ff = 0; ff < 1000; ff++) {
      l006sum +=
          l006[ff][0] *
          math.sin(
            l006[ff][1] +
                l006[ff][2] * t1 +
                l006[ff][3] * t2 +
                l006[ff][4] * t3 +
                l006[ff][5] * t4,
          );
    }

    var l007sum = 0.0;
    for (var gg = 0; gg < 1000; gg++) {
      l007sum +=
          l007[gg][0] *
          math.sin(
            l007[gg][1] +
                l007[gg][2] * t1 +
                l007[gg][3] * t2 +
                l007[gg][4] * t3 +
                l007[gg][5] * t4,
          );
    }

    var l008sum = 0.0;
    for (var hh = 0; hh < 1000; hh++) {
      l008sum +=
          l008[hh][0] *
          math.sin(
            l008[hh][1] +
                l008[hh][2] * t1 +
                l008[hh][3] * t2 +
                l008[hh][4] * t3 +
                l008[hh][5] * t4,
          );
    }

    var l009sum = 0.0;
    for (var ii = 0; ii < 1000; ii++) {
      l009sum +=
          l009[ii][0] *
          math.sin(
            l009[ii][1] +
                l009[ii][2] * t1 +
                l009[ii][3] * t2 +
                l009[ii][4] * t3 +
                l009[ii][5] * t4,
          );
    }

    var l010sum = 0.0;
    for (var jj = 0; jj < 1000; jj++) {
      l010sum +=
          l010[jj][0] *
          math.sin(
            l010[jj][1] +
                l010[jj][2] * t1 +
                l010[jj][3] * t2 +
                l010[jj][4] * t3 +
                l010[jj][5] * t4,
          );
    }

    var l011sum = 0.0;
    for (var kk = 0; kk < 1000; kk++) {
      l011sum +=
          l011[kk][0] *
          math.sin(
            l011[kk][1] +
                l011[kk][2] * t1 +
                l011[kk][3] * t2 +
                l011[kk][4] * t3 +
                l011[kk][5] * t4,
          );
    }

    var l012sum = 0.0;
    for (var ll = 0; ll < 1000; ll++) {
      l012sum +=
          l012[ll][0] *
          math.sin(
            l012[ll][1] +
                l012[ll][2] * t1 +
                l012[ll][3] * t2 +
                l012[ll][4] * t3 +
                l012[ll][5] * t4,
          );
    }

    var l013sum = 0.0;
    for (var mm = 0; mm < 337; mm++) {
      l013sum +=
          l013[mm][0] *
          math.sin(
            l013[mm][1] +
                l013[mm][2] * t1 +
                l013[mm][3] * t2 +
                l013[mm][4] * t3 +
                l013[mm][5] * t4,
          );
    }

    var l101sum = 0.0;
    for (var nn = 0; nn < 1199; nn++) {
      l101sum +=
          l101[nn][0] *
          math.sin(
            l101[nn][1] +
                l101[nn][2] * t1 +
                l101[nn][3] * t2 +
                l101[nn][4] * t3 +
                l101[nn][5] * t4,
          );
    }

    var l201sum = 0.0;
    for (var qq = 0; qq < 219; qq++) {
      l201sum +=
          l201[qq][0] *
          math.sin(
            l201[qq][1] +
                l201[qq][2] * t1 +
                l201[qq][3] * t2 +
                l201[qq][4] * t3 +
                l201[qq][5] * t4,
          );
    }

    var l301sum = 0.0;
    for (var rr = 0; rr < 2; rr++) {
      l301sum +=
          l301[rr][0] *
          math.sin(
            l301[rr][1] +
                l301[rr][2] * t1 +
                l301[rr][3] * t2 +
                l301[rr][4] * t3 +
                l301[rr][5] * t4,
          );
    }

    final l0 =
        l001sum +
        l002sum +
        l003sum +
        l004sum +
        l005sum +
        l006sum +
        l007sum +
        l008sum +
        l009sum +
        l010sum +
        l011sum +
        l012sum +
        l013sum;
    final l1 = l101sum;
    final l2 = l201sum;
    final l3 = l301sum;
    final l = l0 + l1 * t1 + l2 * t2 + l3 * t3;

    // MoonMeanLongitude
    final w0 = 3.81034409083088;
    final w1 = 8399.68473007193;
    final w2 = -0.0000331895204255009;
    final w3 = 3.11024944910606E-08;
    final w4 = -2.03282376489228E-10;
    final w = w0 + w1 * t1 + w2 * t2 + w3 * t3 + w4 * t4;

    // Presesi
    final p1 = 5029.0966 - 0.29965;
    final p2 = 1.112;
    final p3 = 0.000077;
    final p4 = -0.00002353;
    final p = p1 * t1 + p2 * t2 + p3 * t3 + p4 * t4;

    // TrueGeocentricEclipticLongitude
    final moonTrueLon = mf.mod(mf.deg(w) + l / 3600.0 + p / 3600.0, 360.0);
    final nutation = nt.nutationInLongitude(jd, deltaT);

    // Aberasi
    final abr = -0.00019524 - 0.00001059 * math.sin(mf.rad(225 + 477198.9 * t));

    // ApparentGeocentricEclipticLongitude
    final moonAppaLon = moonTrueLon + nutation + abr;

    switch (opt) {
      case "L0":
        return l0;
      case "L1":
        return l1;
      case "L2":
        return l2;
      case "L3":
        return l3;
      case "L":
        return l;
      case "True":
        return moonTrueLon;
      case "Appa":
        return moonAppaLon;
      default:
        return moonAppaLon;
    }
  }
}
