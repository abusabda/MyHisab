import 'package:myhisab/core/arah_kiblat.dart';
//import 'package:myhisab/core/dynamical_time.dart';
//import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
//import 'package:myhisab/core/moon_function.dart';
//import 'package:myhisab/core/sun_function.dart';

void main() {
  final mf = MathFunction();
  final aq = ArahKiblat();
  //final sn = SunFunction();
  //final mo = MoonFunction();
  // final julianDay = JulianDay();
  // final dynamicalTime = DynamicalTime();

  // input
  final int tglM = 3;
  final int blnM = 5;
  final int thnM = 2025;
  final double gLon = 107.6576575;
  final double gLat = -6.9754746;
  final double tmZn = 7.0;
  //final double JamD = (23 + 15 / 60.0 + 2.506819004 / 3600.0);
  //final int sdp = 2;

  //final double jd = julianDay.kmjd(tglM, blnM, thnM, JamD, tmZn);
  //final double dltT = dynamicalTime.deltaT(jd);

  // Cetak
  print(
    "Arah Kiblat Spherical      : ${mf.dddms(aq.arahQiblatSpherical(gLon, gLat))}",
  );
  print(
    "Arah Kiblat Ellipsoid      : ${mf.dddms(aq.arahQiblaWithEllipsoidCorrection(gLon, gLat))}",
  );
  print(
    "Arah Kiblat Vincenty       : ${mf.dddms(aq.arahQiblaVincenty(gLon, gLat, 'PtoQ'))}",
  );

  print(
    "Jarak Kiblat Spherical     : ${aq.jarakQiblatSpherical(gLon, gLat).toStringAsFixed(3)} KM",
  );
  print(
    "Jarak Kiblat Ellipsoid     : ${aq.jarakQiblatEllipsoid(gLon, gLat).toStringAsFixed(3)} KM",
  );
  print(
    "Jarak Kiblat Vincenty      : ${(aq.arahQiblaVincenty(gLon, gLat, 'Dist') / 1000.0).toStringAsFixed(3)} KM",
  );

  print(
    "Bayangan Kiblat 1          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 1), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
  );

  print(
    "Bayangan Kiblat 2          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 2), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
  );

  print("Rashdul Qiblat 1       : ${aq.rashdulQiblat(thnM, tmZn, 1)}");

  print("Rashdul Qiblat 2       : ${aq.rashdulQiblat(thnM, tmZn, 2)}");

  print("Antipoda Kabah 1       : ${aq.antipodaKabah(thnM, tmZn, 1)}");

  print("Antipoda Kabah 2       : ${aq.antipodaKabah(thnM, tmZn, 2)}");
}
