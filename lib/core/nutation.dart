import 'dart:math';
import 'math_utils.dart'; // sesuaikan dengan path file kamu

class NutationAndObliquity {
  final MathFunction mf = MathFunction();

  /// Nutation in longitude (Δψ dalam derajat)
  double nutationInLongitude(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = (jde - 2451545.0) / 36525.0;
    final t2 = t * t;
    final t3 = t * t2;
    final t4 = t * t3;

    // Fundamental Delaunay arguments
    var l =
        (485868.249036 +
            1717915923.2178 * t +
            31.8792 * t2 +
            0.051635 * t3 -
            0.00024470 * t4) /
        3600.0;
    var lp =
        (1287104.79305 +
            129596581.0481 * t -
            0.5532 * t2 +
            0.000136 * t3 -
            0.00001149 * t4) /
        3600.0;
    var f =
        (335779.526232 +
            1739527262.8478 * t -
            12.7512 * t2 -
            0.001037 * t3 +
            0.00000417 * t4) /
        3600.0;
    var d =
        (1072260.70369 +
            1602961601.2090 * t -
            6.3706 * t2 +
            0.006593 * t3 -
            0.00003169 * t4) /
        3600.0;
    var om =
        (450160.398036 -
            6962890.5431 * t +
            7.4722 * t2 +
            0.007702 * t3 -
            0.00005939 * t4) /
        3600.0;

    // Konversi ke radian
    l = mf.rad(mf.mod(l, 360.0));
    lp = mf.rad(mf.mod(lp, 360.0));
    f = mf.rad(mf.mod(f, 360.0));
    d = mf.rad(mf.mod(d, 360.0));
    om = mf.rad(mf.mod(om, 360.0));

    var s = 0.0;
    s +=
        (-172064161.0 + -174666.0 * t) *
            sin(0 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        33386.0 * cos(0 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-13170906.0 + -1675.0 * t) *
            sin(0 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -13696.0 * cos(0 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-2276413.0 + -234.0 * t) *
            sin(0 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        2796.0 * cos(0 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (2074554.0 + 207.0 * t) * sin(0 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        -698.0 * cos(0 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (1475877.0 + -3633.0 * t) *
            sin(0 * l + 1 * lp + 0 * f + 0 * d + 0 * om) +
        11817.0 * cos(0 * l + 1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-516821.0 + 1226.0 * t) *
            sin(0 * l + 1 * lp + 2 * f + -2 * d + 2 * om) +
        -524.0 * cos(0 * l + 1 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (711159.0 + 73.0 * t) * sin(1 * l + 0 * lp + 0 * f + 0 * d + 0 * om) +
        -872.0 * cos(1 * l + 0 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-387298.0 + -367.0 * t) *
            sin(0 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        380.0 * cos(0 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (-301461.0 + -36.0 * t) * sin(1 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        816.0 * cos(1 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (215829.0 + -494.0 * t) *
            sin(0 * l + -1 * lp + 2 * f + -2 * d + 2 * om) +
        111.0 * cos(0 * l + -1 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (128227.0 + 137.0 * t) * sin(0 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        181.0 * cos(0 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (123457.0 + 11.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        19.0 * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (156994.0 + 10.0 * t) * sin(-1 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        -168.0 * cos(-1 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (63110.0 + 63.0 * t) * sin(1 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        27.0 * cos(1 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-57976.0 + -63.0 * t) * sin(-1 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -189.0 * cos(-1 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-59641.0 + -11.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        149.0 * cos(-1 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-51613.0 + -42.0 * t) * sin(1 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        129.0 * cos(1 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (45893.0 + 50.0 * t) * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        31.0 * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (63384.0 + 11.0 * t) * sin(0 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        -150.0 * cos(0 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-38571.0 + -1.0 * t) * sin(0 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        158.0 * cos(0 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (32481.0 + 0.0 * t) * sin(0 * l + -2 * lp + 2 * f + -2 * d + 2 * om) +
        0.0 * cos(0 * l + -2 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-47722.0 + 0.0 * t) * sin(-2 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        -18.0 * cos(-2 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-31046.0 + -1.0 * t) * sin(2 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        131.0 * cos(2 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (28593.0 + 0.0 * t) * sin(1 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -1.0 * cos(1 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (20441.0 + 21.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        10.0 * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (29243.0 + 0.0 * t) * sin(2 * l + 0 * lp + 0 * f + 0 * d + 0 * om) +
        -74.0 * cos(2 * l + 0 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (25887.0 + 0.0 * t) * sin(0 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        -66.0 * cos(0 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (-14053.0 + -25.0 * t) * sin(0 * l + 1 * lp + 0 * f + 0 * d + 1 * om) +
        79.0 * cos(0 * l + 1 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (15164.0 + 10.0 * t) * sin(-1 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        11.0 * cos(-1 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (-15794.0 + 72.0 * t) * sin(0 * l + 2 * lp + 2 * f + -2 * d + 2 * om) +
        -16.0 * cos(0 * l + 2 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (21783.0 + 0.0 * t) * sin(0 * l + 0 * lp + -2 * f + 2 * d + 0 * om) +
        13.0 * cos(0 * l + 0 * lp + -2 * f + 2 * d + 0 * om);
    s +=
        (-12873.0 + -10.0 * t) * sin(1 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        -37.0 * cos(1 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (-12654.0 + 11.0 * t) * sin(0 * l + -1 * lp + 0 * f + 0 * d + 1 * om) +
        63.0 * cos(0 * l + -1 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-10204.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        25.0 * cos(-1 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (16707.0 + -85.0 * t) * sin(0 * l + 2 * lp + 0 * f + 0 * d + 0 * om) +
        -10.0 * cos(0 * l + 2 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-7691.0 + 0.0 * t) * sin(1 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        44.0 * cos(1 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-11024.0 + 0.0 * t) * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        -14.0 * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (7566.0 + -21.0 * t) * sin(0 * l + 1 * lp + 2 * f + 0 * d + 2 * om) +
        -11.0 * cos(0 * l + 1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-6637.0 + -11.0 * t) * sin(0 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        25.0 * cos(0 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (-7141.0 + 21.0 * t) * sin(0 * l + -1 * lp + 2 * f + 0 * d + 2 * om) +
        8.0 * cos(0 * l + -1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-6302.0 + -11.0 * t) * sin(0 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        2.0 * cos(0 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (5800.0 + 10.0 * t) * sin(1 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        2.0 * cos(1 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (6443.0 + 0.0 * t) * sin(2 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -7.0 * cos(2 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-5774.0 + -11.0 * t) * sin(-2 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        -15.0 * cos(-2 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (-5350.0 + 0.0 * t) * sin(2 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        21.0 * cos(2 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (-4752.0 + -11.0 * t) * sin(0 * l + -1 * lp + 2 * f + -2 * d + 1 * om) +
        -3.0 * cos(0 * l + -1 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-4940.0 + -11.0 * t) * sin(0 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        -21.0 * cos(0 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (7350.0 + 0.0 * t) * sin(-1 * l + -1 * lp + 0 * f + 2 * d + 0 * om) +
        -8.0 * cos(-1 * l + -1 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (4065.0 + 0.0 * t) * sin(2 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        6.0 * cos(2 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (6579.0 + 0.0 * t) * sin(1 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        -24.0 * cos(1 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (3579.0 + 0.0 * t) * sin(0 * l + 1 * lp + 2 * f + -2 * d + 1 * om) +
        5.0 * cos(0 * l + 1 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (4725.0 + 0.0 * t) * sin(1 * l + -1 * lp + 0 * f + 0 * d + 0 * om) +
        -6.0 * cos(1 * l + -1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-3075.0 + 0.0 * t) * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        -2.0 * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-2904.0 + 0.0 * t) * sin(3 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        15.0 * cos(3 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (4348.0 + 0.0 * t) * sin(0 * l + -1 * lp + 0 * f + 2 * d + 0 * om) +
        -10.0 * cos(0 * l + -1 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-2878.0 + 0.0 * t) * sin(1 * l + -1 * lp + 2 * f + 0 * d + 2 * om) +
        8.0 * cos(1 * l + -1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-4230.0 + 0.0 * t) * sin(0 * l + 0 * lp + 0 * f + 1 * d + 0 * om) +
        5.0 * cos(0 * l + 0 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (-2819.0 + 0.0 * t) * sin(-1 * l + -1 * lp + 2 * f + 2 * d + 2 * om) +
        7.0 * cos(-1 * l + -1 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-4056.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        5.0 * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (-2647.0 + 0.0 * t) * sin(0 * l + -1 * lp + 2 * f + 2 * d + 2 * om) +
        11.0 * cos(0 * l + -1 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-2294.0 + 0.0 * t) * sin(-2 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -10.0 * cos(-2 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (2481.0 + 0.0 * t) * sin(1 * l + 1 * lp + 2 * f + 0 * d + 2 * om) +
        -7.0 * cos(1 * l + 1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (2179.0 + 0.0 * t) * sin(2 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -2.0 * cos(2 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (3276.0 + 0.0 * t) * sin(-1 * l + 1 * lp + 0 * f + 1 * d + 0 * om) +
        1.0 * cos(-1 * l + 1 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (-3389.0 + 0.0 * t) * sin(1 * l + 1 * lp + 0 * f + 0 * d + 0 * om) +
        5.0 * cos(1 * l + 1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (3339.0 + 0.0 * t) * sin(1 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        -13.0 * cos(1 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (-1987.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        -6.0 * cos(-1 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-1981.0 + 0.0 * t) * sin(1 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        0.0 * cos(1 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (4026.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 0 * f + 1 * d + 0 * om) +
        -353.0 * cos(-1 * l + 0 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (1660.0 + 0.0 * t) * sin(0 * l + 0 * lp + 2 * f + 1 * d + 2 * om) +
        -5.0 * cos(0 * l + 0 * lp + 2 * f + 1 * d + 2 * om);
    s +=
        (-1521.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 2 * f + 4 * d + 2 * om) +
        9.0 * cos(-1 * l + 0 * lp + 2 * f + 4 * d + 2 * om);
    s +=
        (1314.0 + 0.0 * t) * sin(-1 * l + 1 * lp + 0 * f + 1 * d + 1 * om) +
        0.0 * cos(-1 * l + 1 * lp + 0 * f + 1 * d + 1 * om);
    s +=
        (-1283.0 + 0.0 * t) * sin(0 * l + -2 * lp + 2 * f + -2 * d + 1 * om) +
        0.0 * cos(0 * l + -2 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-1331.0 + 0.0 * t) * sin(1 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        8.0 * cos(1 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (1383.0 + 0.0 * t) * sin(-2 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        -2.0 * cos(-2 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (1405.0 + 0.0 * t) * sin(-1 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        4.0 * cos(-1 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (1290.0 + 0.0 * t) * sin(1 * l + 1 * lp + 2 * f + -2 * d + 2 * om) +
        0.0 * cos(1 * l + 1 * lp + 2 * f + -2 * d + 2 * om);
    final dPsiDeg = s / 36000000000.0;
    return dPsiDeg;
  }

  /// Nutation in obliquity (Δε dalam derajat)
  double nutationInObliquity(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = (jde - 2451545.0) / 36525.0;
    final t2 = t * t;
    final t3 = t * t2;
    final t4 = t * t3;

    // Fundamental Delaunay arguments
    var l =
        (485868.249036 +
            1717915923.2178 * t +
            31.8792 * t2 +
            0.051635 * t3 -
            0.00024470 * t4) /
        3600.0;
    var lp =
        (1287104.79305 +
            129596581.0481 * t -
            0.5532 * t2 +
            0.000136 * t3 -
            0.00001149 * t4) /
        3600.0;
    var f =
        (335779.526232 +
            1739527262.8478 * t -
            12.7512 * t2 -
            0.001037 * t3 +
            0.00000417 * t4) /
        3600.0;
    var d =
        (1072260.70369 +
            1602961601.2090 * t -
            6.3706 * t2 +
            0.006593 * t3 -
            0.00003169 * t4) /
        3600.0;
    var om =
        (450160.398036 -
            6962890.5431 * t +
            7.4722 * t2 +
            0.007702 * t3 -
            0.00005939 * t4) /
        3600.0;

    // Konversi ke radian
    l = mf.rad(mf.mod(l, 360.0));
    lp = mf.rad(mf.mod(lp, 360.0));
    f = mf.rad(mf.mod(f, 360.0));
    d = mf.rad(mf.mod(d, 360.0));
    om = mf.rad(mf.mod(om, 360.0));

    var s = 0.0;

    s +=
        (92052331.0 + 9086.0 * t) *
            cos(0 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        15377.0 * sin(0 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (5730336.0 + -3015.0 * t) *
            cos(0 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -4587.0 * sin(0 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (978459.0 + -485.0 * t) * cos(0 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        1374.0 * sin(0 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-897492.0 + 470.0 * t) * cos(0 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        -291.0 * sin(0 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (73871.0 + -184.0 * t) * cos(0 * l + 1 * lp + 0 * f + 0 * d + 0 * om) +
        -1924.0 * sin(0 * l + 1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (224386.0 + -677.0 * t) *
            cos(0 * l + 1 * lp + 2 * f + -2 * d + 2 * om) +
        -174.0 * sin(0 * l + 1 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-6750.0 + 0.0 * t) * cos(1 * l + 0 * lp + 0 * f + 0 * d + 0 * om) +
        358.0 * sin(1 * l + 0 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (200728.0 + 18.0 * t) * cos(0 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        318.0 * sin(0 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (129025.0 + -63.0 * t) * cos(1 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        367.0 * sin(1 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-95929.0 + 299.0 * t) *
            cos(0 * l + -1 * lp + 2 * f + -2 * d + 2 * om) +
        132.0 * sin(0 * l + -1 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-68982.0 + -9.0 * t) * cos(0 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        39.0 * sin(0 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-53311.0 + 32.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        -4.0 * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-1235.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        82.0 * sin(-1 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-33228.0 + 0.0 * t) * cos(1 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -9.0 * sin(1 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (31429.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -75.0 * sin(-1 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (25543.0 + -11.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        66.0 * sin(-1 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (26366.0 + 0.0 * t) * cos(1 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        78.0 * sin(1 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (-24236.0 + -10.0 * t) * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        20.0 * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (-1220.0 + 0.0 * t) * cos(0 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        29.0 * sin(0 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (16452.0 + -11.0 * t) * cos(0 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        68.0 * sin(0 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-13870.0 + 0.0 * t) * cos(0 * l + -2 * lp + 2 * f + -2 * d + 2 * om) +
        0.0 * sin(0 * l + -2 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (477.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        -25.0 * sin(-2 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (13238.0 + -11.0 * t) * cos(2 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        59.0 * sin(2 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-12338.0 + 10.0 * t) * cos(1 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -3.0 * sin(1 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-10758.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        -3.0 * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (-609.0 + 0.0 * t) * cos(2 * l + 0 * lp + 0 * f + 0 * d + 0 * om) +
        13.0 * sin(2 * l + 0 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-550.0 + 0.0 * t) * cos(0 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        11.0 * sin(0 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (8551.0 + -2.0 * t) * cos(0 * l + 1 * lp + 0 * f + 0 * d + 1 * om) +
        -45.0 * sin(0 * l + 1 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-8001.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        -1.0 * sin(-1 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (6850.0 + -42.0 * t) * cos(0 * l + 2 * lp + 2 * f + -2 * d + 2 * om) +
        -5.0 * sin(0 * l + 2 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (-167.0 + 0.0 * t) * cos(0 * l + 0 * lp + -2 * f + 2 * d + 0 * om) +
        13.0 * sin(0 * l + 0 * lp + -2 * f + 2 * d + 0 * om);
    s +=
        (6953.0 + 0.0 * t) * cos(1 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        -14.0 * sin(1 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (6415.0 + 0.0 * t) * cos(0 * l + -1 * lp + 0 * f + 0 * d + 1 * om) +
        26.0 * sin(0 * l + -1 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (5222.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        15.0 * sin(-1 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (168.0 + -1.0 * t) * cos(0 * l + 2 * lp + 0 * f + 0 * d + 0 * om) +
        10.0 * sin(0 * l + 2 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (3268.0 + 0.0 * t) * cos(1 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        19.0 * sin(1 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (104.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        2.0 * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (-3250.0 + 0.0 * t) * cos(0 * l + 1 * lp + 2 * f + 0 * d + 2 * om) +
        -5.0 * sin(0 * l + 1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (3353.0 + 0.0 * t) * cos(0 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        14.0 * sin(0 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (3070.0 + 0.0 * t) * cos(0 * l + -1 * lp + 2 * f + 0 * d + 2 * om) +
        4.0 * sin(0 * l + -1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (3272.0 + 0.0 * t) * cos(0 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        4.0 * sin(0 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (-3045.0 + 0.0 * t) * cos(1 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        -1.0 * sin(1 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-2768.0 + 0.0 * t) * cos(2 * l + 0 * lp + 2 * f + -2 * d + 2 * om) +
        -4.0 * sin(2 * l + 0 * lp + 2 * f + -2 * d + 2 * om);
    s +=
        (3041.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 0 * f + 2 * d + 1 * om) +
        -5.0 * sin(-2 * l + 0 * lp + 0 * f + 2 * d + 1 * om);
    s +=
        (2695.0 + 0.0 * t) * cos(2 * l + 0 * lp + 2 * f + 0 * d + 1 * om) +
        12.0 * sin(2 * l + 0 * lp + 2 * f + 0 * d + 1 * om);
    s +=
        (2719.0 + 0.0 * t) * cos(0 * l + -1 * lp + 2 * f + -2 * d + 1 * om) +
        -3.0 * sin(0 * l + -1 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (2720.0 + 0.0 * t) * cos(0 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        -9.0 * sin(0 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (-51.0 + 0.0 * t) * cos(-1 * l + -1 * lp + 0 * f + 2 * d + 0 * om) +
        4.0 * sin(-1 * l + -1 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-2206.0 + 0.0 * t) * cos(2 * l + 0 * lp + 0 * f + -2 * d + 1 * om) +
        1.0 * sin(2 * l + 0 * lp + 0 * f + -2 * d + 1 * om);
    s +=
        (-199.0 + 0.0 * t) * cos(1 * l + 0 * lp + 0 * f + 2 * d + 0 * om) +
        2.0 * sin(1 * l + 0 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (-1900.0 + 0.0 * t) * cos(0 * l + 1 * lp + 2 * f + -2 * d + 1 * om) +
        1.0 * sin(0 * l + 1 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (-41.0 + 0.0 * t) * cos(1 * l + -1 * lp + 0 * f + 0 * d + 0 * om) +
        3.0 * sin(1 * l + -1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (1313.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        -1.0 * sin(-2 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (1233.0 + 0.0 * t) * cos(3 * l + 0 * lp + 2 * f + 0 * d + 2 * om) +
        7.0 * sin(3 * l + 0 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-81.0 + 0.0 * t) * cos(0 * l + -1 * lp + 0 * f + 2 * d + 0 * om) +
        2.0 * sin(0 * l + -1 * lp + 0 * f + 2 * d + 0 * om);
    s +=
        (1232.0 + 0.0 * t) * cos(1 * l + -1 * lp + 2 * f + 0 * d + 2 * om) +
        4.0 * sin(1 * l + -1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-20.0 + 0.0 * t) * cos(0 * l + 0 * lp + 0 * f + 1 * d + 0 * om) +
        -2.0 * sin(0 * l + 0 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (1207.0 + 0.0 * t) * cos(-1 * l + -1 * lp + 2 * f + 2 * d + 2 * om) +
        3.0 * sin(-1 * l + -1 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (40.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        -2.0 * sin(-1 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (1129.0 + 0.0 * t) * cos(0 * l + -1 * lp + 2 * f + 2 * d + 2 * om) +
        5.0 * sin(0 * l + -1 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (1266.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -4.0 * sin(-2 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-1062.0 + 0.0 * t) * cos(1 * l + 1 * lp + 2 * f + 0 * d + 2 * om) +
        -3.0 * sin(1 * l + 1 * lp + 2 * f + 0 * d + 2 * om);
    s +=
        (-1129.0 + 0.0 * t) * cos(2 * l + 0 * lp + 0 * f + 0 * d + 1 * om) +
        -2.0 * sin(2 * l + 0 * lp + 0 * f + 0 * d + 1 * om);
    s +=
        (-9.0 + 0.0 * t) * cos(-1 * l + 1 * lp + 0 * f + 1 * d + 0 * om) +
        0.0 * sin(-1 * l + 1 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (35.0 + 0.0 * t) * cos(1 * l + 1 * lp + 0 * f + 0 * d + 0 * om) +
        -2.0 * sin(1 * l + 1 * lp + 0 * f + 0 * d + 0 * om);
    s +=
        (-107.0 + 0.0 * t) * cos(1 * l + 0 * lp + 2 * f + 0 * d + 0 * om) +
        1.0 * sin(1 * l + 0 * lp + 2 * f + 0 * d + 0 * om);
    s +=
        (1073.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 2 * f + -2 * d + 1 * om) +
        -2.0 * sin(-1 * l + 0 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (854.0 + 0.0 * t) * cos(1 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        0.0 * sin(1 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (-553.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 0 * f + 1 * d + 0 * om) +
        -139.0 * sin(-1 * l + 0 * lp + 0 * f + 1 * d + 0 * om);
    s +=
        (-710.0 + 0.0 * t) * cos(0 * l + 0 * lp + 2 * f + 1 * d + 2 * om) +
        -2.0 * sin(0 * l + 0 * lp + 2 * f + 1 * d + 2 * om);
    s +=
        (647.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 2 * f + 4 * d + 2 * om) +
        4.0 * sin(-1 * l + 0 * lp + 2 * f + 4 * d + 2 * om);
    s +=
        (-700.0 + 0.0 * t) * cos(-1 * l + 1 * lp + 0 * f + 1 * d + 1 * om) +
        0.0 * sin(-1 * l + 1 * lp + 0 * f + 1 * d + 1 * om);
    s +=
        (672.0 + 0.0 * t) * cos(0 * l + -2 * lp + 2 * f + -2 * d + 1 * om) +
        0.0 * sin(0 * l + -2 * lp + 2 * f + -2 * d + 1 * om);
    s +=
        (663.0 + 0.0 * t) * cos(1 * l + 0 * lp + 2 * f + 2 * d + 1 * om) +
        4.0 * sin(1 * l + 0 * lp + 2 * f + 2 * d + 1 * om);
    s +=
        (-594.0 + 0.0 * t) * cos(-2 * l + 0 * lp + 2 * f + 2 * d + 2 * om) +
        -2.0 * sin(-2 * l + 0 * lp + 2 * f + 2 * d + 2 * om);
    s +=
        (-610.0 + 0.0 * t) * cos(-1 * l + 0 * lp + 0 * f + 0 * d + 2 * om) +
        2.0 * sin(-1 * l + 0 * lp + 0 * f + 0 * d + 2 * om);
    s +=
        (-556.0 + 0.0 * t) * cos(1 * l + 1 * lp + 2 * f + -2 * d + 2 * om) +
        0.0 * sin(1 * l + 1 * lp + 2 * f + -2 * d + 2 * om);
    final dEpsDeg = s / 36000000000.0;
    return dEpsDeg;
  }

  /// Mean obliquity of the ecliptic (ε₀ dalam derajat)
  double meanObliquityOfEcliptic(double jd, double deltaT) {
    final jde = jd + deltaT / 86400.0;
    final t = (jde - 2451545.0) / 36525.0;
    final u = t / 100.0;

    final eps0 =
        23.0 +
        26.0 / 60.0 +
        21.448 / 3600.0 +
        (-4680.93 * u -
                1.55 * pow(u, 2) +
                1999.25 * pow(u, 3) -
                51.38 * pow(u, 4) -
                249.67 * pow(u, 5) -
                39.05 * pow(u, 6) +
                7.12 * pow(u, 7) +
                27.87 * pow(u, 8) +
                5.79 * pow(u, 9) +
                2.45 * pow(u, 10)) /
            3600.0;

    return eps0;
  }

  /// True obliquity of the ecliptic (ε = ε₀ + Δε)
  double trueObliquityOfEcliptic(double jd, double deltaT) {
    final eps0 = meanObliquityOfEcliptic(jd, deltaT);
    final dltEps = nutationInObliquity(jd, deltaT);
    final eps = eps0 + dltEps;
    return eps;
  }
}
