import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/waktu_salat.dart';

void main() {
  final ws = WaktuSalat();
  final mf = MathFunction();
  final julianDay = JulianDay();

  // Input
  int tglM = 15;
  int blnM = 9;
  int thnM = 2025;
  double gLon = 107.6576575; // (107+37/60.0+0/3600.0)
  double gLat = -6.9754746; // -(7+5/60.0+0/3600.0)
  double elev = 10.0;
  double tmZn = 7.0;
  int ihty = 2;

  print(
    "Zuhur      : ${mf.dhhms(ws.ihtiyathShalat(ws.zuhur(tglM, blnM, thnM, gLon, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Asar       : ${mf.dhhms(ws.ihtiyathShalat(ws.asar(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Magrib     : ${mf.dhhms(ws.ihtiyathShalat(ws.magrib(tglM, blnM, thnM, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Isya       : ${mf.dhhms(ws.ihtiyathShalat(ws.isya(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Akhir Isya : ${mf.dhhms(ws.ihtiyathShalat(ws.nisfuLail(tglM, blnM, thnM, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Subuh      : ${mf.dhhms(ws.ihtiyathShalat(ws.subuh(tglM, blnM, thnM, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Akhir Subuh: ${mf.dhhms(ws.ihtiyathShalat(ws.syuruk(tglM, blnM, thnM, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );
  print(
    "Duha       : ${mf.dhhms(ws.ihtiyathShalat(ws.duha(tglM, blnM, thnM, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
  );

  // Contoh Perbulan
  int tglM1 = 1;
  int blnM1 = 9;
  int thnM1 = 2025;

  int tglM2 = 15;
  int blnM2 = 9;
  int thnM2 = 2025;

  double jd1 = julianDay.kmjd(tglM1, blnM1, thnM1, 0.0, 0.0);
  double jd2 = julianDay.kmjd(tglM2, blnM2, thnM2, 0.0, 0.0);

  double diff = (jd2 - jd1) + 1;
  double jdh = jd1 - 1;

  for (int i = 1; i <= diff.toInt(); i++) {
    jdh += 1;
    final int tgl = int.parse(julianDay.jdkm(jdh, tmZn, "TglM").toString());
    final int bln = int.parse(julianDay.jdkm(jdh, tmZn, "BlnM").toString());
    final int thn = int.parse(julianDay.jdkm(jdh, tmZn, "ThnM").toString());

    String tglFull = julianDay.jdkm(jdh, tmZn);

    print(
      "$tglFull Zuhur: ${mf.dhhms(ws.ihtiyathShalat(ws.zuhur(tgl, bln, thn, gLon, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Asar: ${mf.dhhms(ws.ihtiyathShalat(ws.asar(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Magrib: ${mf.dhhms(ws.ihtiyathShalat(ws.magrib(tgl, bln, thn, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Isya: ${mf.dhhms(ws.ihtiyathShalat(ws.isya(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Akhir Isya: ${mf.dhhms(ws.ihtiyathShalat(ws.nisfuLail(tgl, bln, thn, gLon, gLat, elev, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Subuh: ${mf.dhhms(ws.ihtiyathShalat(ws.subuh(tgl, bln, thn, gLon, gLat, tmZn), ihty), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Akhir Subuh: ${mf.dhhms(ws.ihtiyathShalat(ws.syuruk(tgl, bln, thn, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
    print(
      "$tglFull Duha: ${mf.dhhms(ws.ihtiyathShalat(ws.duha(tgl, bln, thn, gLon, gLat, elev, tmZn), -2), optResult: 'HH:MM', secDecPlaces: 0, posNegSign: "")}",
    );
  }
}
