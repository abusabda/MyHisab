import 'julian_day.dart';

class DynamicalTime {
  // Delta T
  double deltaT(double jd) {
    final julianDay = JulianDay();

    // Rumus Desimal Years 2
    final thnM = int.parse(julianDay.jdkm(jd, 0.0, "ThnM"));
    final jdTlMAw = julianDay.kmjd(1, 1, thnM);
    final jdTlMAk = julianDay.kmjd(31, 12, thnM, 24, 0.0);
    final jHrlTlM = jd - jdTlMAw;
    final jHrTlM = jdTlMAk - jdTlMAw;

    final dY = thnM + jHrlTlM / jHrTlM;
    double ku;
    double dltT = 0.0;

    if (dY <= -500) {
      ku = (dY - 1820) / 100;
      dltT = -20 + 32 * (ku * ku);
    } else if (dY > -500 && dY <= 500) {
      ku = dY / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;

      dltT =
          10583.6 -
          1014.41 * ku +
          33.78311 * ku2 -
          5.952053 * ku3 -
          0.1798452 * ku4 +
          0.022174192 * ku5 +
          0.0090316521 * ku6;
    } else if (dY > 500 && dY <= 1600) {
      ku = (dY - 1000) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;

      dltT =
          1574.2 -
          556.01 * ku +
          71.23472 * ku2 +
          0.319781 * ku3 -
          0.8503463 * ku4 -
          0.005050998 * ku5 +
          0.0083572073 * ku6;
    } else if (dY > 1600 && dY <= 1700) {
      ku = (dY - 1600) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 120 - 98.08 * ku - 153.2 * ku2 + ku3 / 0.007129;
    } else if (dY > 1700 && dY <= 1800) {
      ku = (dY - 1700) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;

      dltT = 8.83 + 16.03 * ku - 59.285 * ku2 + 133.36 * ku3 - ku4 / 0.01174;
    } else if (dY > 1800 && dY <= 1860) {
      ku = (dY - 1800) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;
      final ku7 = ku6 * ku;

      dltT =
          13.72 -
          33.2447 * ku +
          68.612 * ku2 +
          4111.6 * ku3 -
          37436 * ku4 +
          121272 * ku5 -
          1699000 * ku6 +
          87500 * ku7;
    } else if (dY > 1860 && dY <= 1900) {
      ku = (dY - 1860) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;

      dltT =
          7.62 +
          57.37 * ku -
          2517.54 * ku2 +
          16806.68 * ku3 -
          44736.24 * ku4 +
          ku5 / 0.00000233174;
    } else if (dY > 1900 && dY <= 1920) {
      ku = (dY - 1900) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = -2.79 + 149.4119 * ku - 598.939 * ku2 + 6196.6 * ku3;
    } else if (dY > 1920 && dY <= 1941) {
      ku = (dY - 1920) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 21.20 + 84.493 * ku - 761.00 * ku2 + 2093.6 * ku3;
    } else if (dY > 1941 && dY <= 1961) {
      ku = (dY - 1950) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 29.07 + 40.7 * ku - ku2 / 0.0233 + ku3 / 0.002547;
    } else if (dY > 1961 && dY <= 1986) {
      ku = (dY - 1975) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 45.45 + 106.7 * ku - ku2 / 0.026 - ku3 / 0.000718;
    } else if (dY > 1986 && dY <= 2005) {
      ku = (dY - 2000) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;

      dltT =
          63.86 +
          33.45 * ku -
          603.74 * ku2 +
          1727.5 * ku3 +
          65181.4 * ku4 +
          237359.9 * ku5;
    } else if (dY > 2005 && dY <= 2015) {
      ku = dY - 2005;
      dltT = 64.69 + 0.293 * ku;
    } else if (dY > 2015 && dY <= 3000) {
      ku = dY - 2015;
      final ku2 = ku * ku;

      dltT = 67.62 + 0.3645 * ku + 0.0039755 * ku2;
    } else {
      dltT = 0.0;
    }

    if (dY < 1955 || dY > 2005) {
      final diff = dY - 1955;
      dltT += -0.000012932 * (diff * diff);
    }

    return dltT;
  }

  // Delta T alternatif
  double deltaT2(double jd) {
    final julianDay = JulianDay();

    final thnM = int.parse(julianDay.jdkm(jd, 0.0, "ThnM"));
    final blnM = int.parse(julianDay.jdkm(jd, 0.0, "BlnM"));
    final dY = thnM + (blnM - 0.5) / 12;

    double ku;
    double dltT = 0.0;

    if (dY <= -500) {
      ku = (dY - 1820) / 100;
      dltT = -20 + 32 * (ku * ku);
    } else if (dY > -500 && dY <= 500) {
      ku = dY / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;

      dltT =
          10583.6 -
          1014.41 * ku +
          33.78311 * ku2 -
          5.952053 * ku3 -
          0.1798452 * ku4 +
          0.022174192 * ku5 +
          0.0090316521 * ku6;
    } else if (dY > 500 && dY <= 1600) {
      ku = (dY - 1000) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;

      dltT =
          1574.2 -
          556.01 * ku +
          71.23472 * ku2 +
          0.319781 * ku3 -
          0.8503463 * ku4 -
          0.005050998 * ku5 +
          0.0083572073 * ku6;
    } else if (dY > 1600 && dY <= 1700) {
      ku = (dY - 1600) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 120 - 98.08 * ku - 153.2 * ku2 + ku3 / 0.007129;
    } else if (dY > 1700 && dY <= 1800) {
      ku = (dY - 1700) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;

      dltT = 8.83 + 16.03 * ku - 59.285 * ku2 + 133.36 * ku3 - ku4 / 0.01174;
    } else if (dY > 1800 && dY <= 1860) {
      ku = (dY - 1800) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;
      final ku6 = ku5 * ku;
      final ku7 = ku6 * ku;

      dltT =
          13.72 -
          33.2447 * ku +
          68.612 * ku2 +
          4111.6 * ku3 -
          37436 * ku4 +
          121272 * ku5 -
          1699000 * ku6 +
          87500 * ku7;
    } else if (dY > 1860 && dY <= 1900) {
      ku = (dY - 1860) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;

      dltT =
          7.62 +
          57.37 * ku -
          2517.54 * ku2 +
          16806.68 * ku3 -
          44736.24 * ku4 +
          ku5 / 0.00000233174;
    } else if (dY > 1900 && dY <= 1920) {
      ku = (dY - 1900) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = -2.79 + 149.4119 * ku - 598.939 * ku2 + 6196.6 * ku3;
    } else if (dY > 1920 && dY <= 1941) {
      ku = (dY - 1920) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 21.20 + 84.493 * ku - 761.00 * ku2 + 2093.6 * ku3;
    } else if (dY > 1941 && dY <= 1961) {
      ku = (dY - 1950) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 29.07 + 40.7 * ku - ku2 / 0.0233 + ku3 / 0.002547;
    } else if (dY > 1961 && dY <= 1986) {
      ku = (dY - 1975) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;

      dltT = 45.45 + 106.7 * ku - ku2 / 0.026 - ku3 / 0.000718;
    } else if (dY > 1986 && dY <= 2005) {
      ku = (dY - 2000) / 100;
      final ku2 = ku * ku;
      final ku3 = ku2 * ku;
      final ku4 = ku3 * ku;
      final ku5 = ku4 * ku;

      dltT =
          63.86 +
          33.45 * ku -
          603.74 * ku2 +
          1727.5 * ku3 +
          65181.4 * ku4 +
          237359.9 * ku5;
    } else if (dY > 2005 && dY <= 2015) {
      ku = dY - 2005;
      dltT = 64.69 + 0.293 * ku;
    } else if (dY > 2015 && dY <= 3000) {
      ku = dY - 2015;
      final ku2 = ku * ku;

      dltT = 67.62 + 0.3645 * ku + 0.0039755 * ku2;
    } else {
      dltT = 0.0;
    }

    return dltT;
  }

  double jde(double jd, [double deltaT = 0.0]) {
    return jd + deltaT / 86400.0;
  }

  double jc(double jd) {
    return (jd - 2451545) / 36525;
  }

  double jce(double jde) {
    return (jde - 2451545) / 36525;
  }

  double jm(double jc) {
    return jc / 10.0;
  }

  double jme(double jce) {
    return jce / 10.0;
  }
}
