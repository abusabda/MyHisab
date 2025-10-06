import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/waktu_salat.dart';

class SalatService {
  String waktuSalatHarian({
    required int tglM,
    required int blnM,
    required int thnM,
    required double gLon,
    required double gLat,
    required double elev,
    required double tmZn,
    required int ihty,
  }) {
    final ws = WaktuSalat();
    final mf = MathFunction();
    final sb = StringBuffer();

    sb.writeln(
      "Zuhur      : ${mf.dhhms(ws.ihtiyathShalat(ws.zuhur(tglM, blnM, thnM, gLon, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Asar       : ${mf.dhhms(ws.ihtiyathShalat(ws.asar(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Magrib     : ${mf.dhhms(ws.ihtiyathShalat(ws.magrib(tglM, blnM, thnM, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Isya       : ${mf.dhhms(ws.ihtiyathShalat(ws.isya(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Akhir Isya : ${mf.dhhms(ws.ihtiyathShalat(ws.nisfuLail(tglM, blnM, thnM, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Subuh      : ${mf.dhhms(ws.ihtiyathShalat(ws.subuh(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Akhir Subuh: ${mf.dhhms(ws.ihtiyathShalat(ws.syuruk(tglM, blnM, thnM, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    sb.writeln(
      "Duha       : ${mf.dhhms(ws.ihtiyathShalat(ws.duha(tglM, blnM, thnM, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );

    return sb.toString();
  }

  String waktuSalatBulanan({
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
    required int ihty,
  }) {
    final ws = WaktuSalat();
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

      final tgl = int.parse(julianDay.jdkm(jdh, tmZn, "TglM").toString());
      final bln = int.parse(julianDay.jdkm(jdh, tmZn, "BlnM").toString());
      final thn = int.parse(julianDay.jdkm(jdh, tmZn, "ThnM").toString());
      final tglFull = julianDay.jdkm(jdh, tmZn);

      sb.writeln(
        "$tglFull Zuhur      : ${mf.dhhms(ws.ihtiyathShalat(ws.zuhur(tgl, bln, thn, gLon, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Asar       : ${mf.dhhms(ws.ihtiyathShalat(ws.asar(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Magrib     : ${mf.dhhms(ws.ihtiyathShalat(ws.magrib(tgl, bln, thn, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Isya       : ${mf.dhhms(ws.ihtiyathShalat(ws.isya(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Akhir Isya : ${mf.dhhms(ws.ihtiyathShalat(ws.nisfuLail(tgl, bln, thn, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Subuh      : ${mf.dhhms(ws.ihtiyathShalat(ws.subuh(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Akhir Subuh: ${mf.dhhms(ws.ihtiyathShalat(ws.syuruk(tgl, bln, thn, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(
        "$tglFull Duha       : ${mf.dhhms(ws.ihtiyathShalat(ws.duha(tgl, bln, thn, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
      );
      sb.writeln(""); // spasi antar hari
    }

    return sb.toString();
  }
}
