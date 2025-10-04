import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/arah_kiblat.dart';

void main() {
  final mf = MathFunction();
  final aq = ArahKiblat();

  // input
  final int tglM = 3;
  final int blnM = 5;
  final int thnM = 2025;
  final double gLon = 107.6576575;
  final double gLat = -6.9754746;
  final double tmZn = 7;
  final int sdp = 2;

  // Cetak
  print(
    "Arah Kiblat Spherical      : ${mf.dddms(aq.arahQiblatSpherical(gLon, gLat), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
  );
  print(
    "Arah Kiblat Ellipsoid      : ${mf.dddms(aq.arahQiblaWithEllipsoidCorrection(gLon, gLat), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
  );
  print(
    "Arah Kiblat Vincenty       : ${mf.dddms(aq.arahQiblaVincenty(gLon, gLat, 'PtoQ'), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
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

  print("Rashdul Qiblat 1           : ${aq.rashdulQiblat(thnM, tmZn, 1)}");

  print("Rashdul Qiblat 2           : ${aq.rashdulQiblat(thnM, tmZn, 2)}");

  print("Antipoda Kabah 1           : ${aq.antipodaKabah(thnM, tmZn, 1)}");

  print("Antipoda Kabah 2           : ${aq.antipodaKabah(thnM, tmZn, 2)}");
}
