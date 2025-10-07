import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/arah_kiblat.dart';

class QiblaService {
  String arahQiblat({
    required int tglM,
    required int blnM,
    required int thnM,
    required double gLon,
    required double gLat,
    required double tmZn,
    required int sdp,
  }) {
    final mf = MathFunction();
    final aq = ArahKiblat();

    final sb = StringBuffer();

    sb.writeln(
      "Arah Kiblat Spherical      : ${mf.dddms(aq.arahQiblatSpherical(gLon, gLat), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
    );
    sb.writeln(
      "Arah Kiblat Ellipsoid      : ${mf.dddms(aq.arahQiblaWithEllipsoidCorrection(gLon, gLat), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
    );
    sb.writeln(
      "Arah Kiblat Vincenty       : ${mf.dddms(aq.arahQiblaVincenty(gLon, gLat, 'PtoQ'), optResult: "DDMMSS", sdp: sdp, posNegSign: "")}",
    );

    sb.writeln(
      "Jarak Kiblat Spherical     : ${aq.jarakQiblatSpherical(gLon, gLat).toStringAsFixed(3)} KM",
    );
    sb.writeln(
      "Jarak Kiblat Ellipsoid     : ${aq.jarakQiblatEllipsoid(gLon, gLat).toStringAsFixed(3)} KM",
    );
    sb.writeln(
      "Jarak Kiblat Vincenty      : ${(aq.arahQiblaVincenty(gLon, gLat, 'Dist') / 1000.0).toStringAsFixed(3)} KM",
    );

    sb.writeln(
      "Bayangan Kiblat 1          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 1), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
    );

    sb.writeln(
      "Bayangan Kiblat 2          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 2), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
    );

    sb.writeln(
      "Rashdul Qiblat 1           : ${aq.rashdulQiblat(thnM, tmZn, 1)}",
    );

    sb.writeln(
      "Rashdul Qiblat 2           : ${aq.rashdulQiblat(thnM, tmZn, 2)}",
    );

    sb.writeln(
      "Antipoda Kabah 1           : ${aq.antipodaKabah(thnM, tmZn, 1)}",
    );

    sb.writeln(
      "Antipoda Kabah 2           : ${aq.antipodaKabah(thnM, tmZn, 2)}",
    );

    return sb.toString();
  }

  String waktuKiblatBulanan({
    required int tglM1,
    required int blnM1,
    required int thnM1,
    required int tglM2,
    required int blnM2,
    required int thnM2,
    required double gLon,
    required double gLat,
    required double elev,
    required double tmZn,
  }) {
    final aq = ArahKiblat();
    final mf = MathFunction();
    final julianDay = JulianDay();
    final sb = StringBuffer();

    // Hitung JD awal & akhir
    final jd1 = julianDay.kmjd(tglM1, blnM1, thnM1, 0, 0);
    final jd2 = julianDay.kmjd(tglM2, blnM2, thnM2, 0, 0);
    final diff = (jd2 - jd1) + 1;
    var jdh = jd1 - 1;

    for (int i = 1; i <= diff.toInt(); i++) {
      jdh += 1;

      final tglM = int.parse(julianDay.jdkm(jdh, tmZn, "TglM").toString());
      final blnM = int.parse(julianDay.jdkm(jdh, tmZn, "BlnM").toString());
      final thnM = int.parse(julianDay.jdkm(jdh, tmZn, "ThnM").toString());
      final tglFull = julianDay.jdkm(jdh, tmZn);

      sb.writeln(
        "$tglFull Bayangan Kiblat 1          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 1), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
      );

      sb.writeln(
        "$tglFull Bayangan Kiblat 2          : ${mf.dhhms(aq.bayanganQiblatHarian(gLon, gLat, tglM, blnM, thnM, tmZn, "spherical", 2), optResult: 'HH:MM:SS', secDecPlaces: 0, posNegSign: "")}",
      );

      sb.writeln(""); // spasi antar hari
    }

    return sb.toString();
  }

  String rashdulQiblatTahunan({
    required int thnM1,
    required int thnM2,
    required double tmZn,
  }) {
    final aq = ArahKiblat();
    final sb = StringBuffer();

    var intv = thnM2 - thnM1;
    var thnM = thnM1 - 1;

    for (int i = 0; i <= intv; i++) {
      thnM = thnM + 1;
      sb.writeln(
        "Rashdul Qiblat 1           : ${aq.rashdulQiblat(thnM, tmZn, 1)}",
      );
      sb.writeln(
        "Rashdul Qiblat 2           : ${aq.rashdulQiblat(thnM, tmZn, 2)}",
      );
    }
    return sb.toString();
  }

  String antipodaQiblatTahunan({
    required int thnM1,
    required int thnM2,
    required double tmZn,
  }) {
    final aq = ArahKiblat();
    final sb = StringBuffer();

    var intv = thnM2 - thnM1;
    var thnM = thnM1 - 1;

    for (int i = 0; i <= intv; i++) {
      thnM = thnM + 1;
      sb.writeln(
        "Antipoda Qiblat 1           : ${aq.antipodaKabah(thnM, tmZn, 1)}",
      );
      sb.writeln(
        "Antipoda Qiblat 2           : ${aq.antipodaKabah(thnM, tmZn, 2)}",
      );
    }
    return sb.toString();
  }
}
