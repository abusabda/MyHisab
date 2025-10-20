import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/service/calendar_service.dart';
import 'package:myhisab/service/lunar_eclipse_service.dart';
import 'package:myhisab/service/qibla_service.dart';
import 'package:myhisab/service/salat_service.dart';

void main() {
  final ss = SalatService();
  final qs = QiblaService();
  final cs = CalendarService();
  final le = LunarEclipseService();
  final jd = JulianDay();
  final mf = MathFunction();

  final waktuSalatHarian = ss.waktuSalatHarian(
    tglM: 1,
    blnM: 1,
    thnM: 2025,
    gLon: (107 + 36 / 60),
    gLat: -(7 + 5 / 60),
    elev: 0,
    tmZn: 7,
    ihty: 2,
  );

  print(waktuSalatHarian);

  final waktuSalatBulanan = ss.waktuSalatBulanan(
    tglM1: 1,
    blnM1: 1,
    thnM1: 2025,
    tglM2: 31,
    blnM2: 1,
    thnM2: 2025,
    gLon: 107 + 37 / 60.0,
    gLat: -(7 + 5 / 60.0),
    elev: 0,
    tmZn: 7,
    ihty: 2,
  );

  print(waktuSalatBulanan);

  final arahKiblat = qs.arahQiblat(
    tglM: 1,
    blnM: 1,
    thnM: 2025,
    gLon: 107 + 37 / 60.0,
    gLat: -(7 + 5 / 60.0),
    tmZn: 7,
    sdp: 2,
  );

  print(arahKiblat);

  final waktuKiblatBulanan = qs.waktuKiblatBulanan(
    tglM1: 1,
    blnM1: 1,
    thnM1: 2025,
    tglM2: 31,
    blnM2: 1,
    thnM2: 2025,
    gLon: 107 + 37 / 60.0,
    gLat: -(7 + 5 / 60.0),
    elev: 0,
    tmZn: 7,
  );

  print(waktuKiblatBulanan);

  final rashdulQiblatTahunan = qs.rashdulQiblatTahunan(
    thnM1: 2025,
    thnM2: 2026,
    tmZn: 7,
  );

  print(rashdulQiblatTahunan);

  final antipodaQiblatTahunan = qs.antipodaQiblatTahunan(
    thnM1: 2025,
    thnM2: 2026,
    tmZn: 7,
  );

  print(antipodaQiblatTahunan);

  final namaBulanHijriah = [
    "Al-Muharram",
    "Shafar",
    "Rabiul Awwal",
    "Rabiul Akhir",
    "Jumadal Ula",
    "Jumadal Akhirah",
    "Rajab",
    "Syaban",
    "Ramadhan",
    "Syawwal",
    "Zulqadah",
    "Zulhijjah",
  ];

  //input Bulan dan Tahun Hijri
  final blnH = 11;
  final thnH = 1439;

  final abqSesuaiLokasi = ab.hisabAwalBulanHijriahSesuaiLokasi(
    nmLokasi: "Pelabuhan Ratu",
    blnH: blnH,
    thnH: thnH,
    gLon: (106 + 33 / 60 + 27.8 / 3600),
    gLat: -(7 + 1 / 60 + 44.6 / 3600),
    elev: 52.685,
    tmZn: 7,
    pres: 1010,
    temp: 10,
    sdp: 2,
    tbhHari: 0,
    optKriteria: 1,
  );

  print(abqSesuaiLokasi); // tampilkan semua output sekaligus

  final namaBlnH = namaBulanHijriah[blnH - 1];

  final jdAbqMabims = cs.abqMabims(blnH, thnH);
  print("1 $namaBlnH $thnH H (MABIMS)      : ${jd.jdkm(jdAbqMabims)}");

  final jdAbqWH = cs.abqWujudulHilal(blnH, thnH);
  print("1 $namaBlnH $thnH H (Wujud Hilal) : ${jd.jdkm(jdAbqWH)}");

  final jdAbqTurki = cs.abqTurki(blnH, thnH);
  print("1 $namaBlnH $thnH H (TURKI/KHGT)  : ${jd.jdkm(jdAbqTurki)}");

  //input tanggal, bulan, tahun Masehi

  final tglM = 18;
  final blnM = 2;
  final thnM = 2026;

  final abqMabimsNow = cs.serviceKalenderHijriahMABIMS(tglM, blnM, thnM);
  print("MABIMS                          : $abqMabimsNow");

  final abqWHNow = cs.serviceKalenderHijriahWH(tglM, blnM, thnM);
  print("Wujudu Hilal                    : $abqWHNow");

  final abqTurkiNow = cs.serviceKalenderHijriahTURKI(tglM, blnM, thnM);
  print("Turki/KHGT                      : $abqTurkiNow");

  final List<String> keys = [
    "JDL",
    "DT",
    "x0",
    "x1",
    "x2",
    "x3",
    "x4",
    "y0",
    "y1",
    "y2",
    "y3",
    "y4",
    "d0",
    "d1",
    "d2",
    "d3",
    "d4",
    "f10",
    "f11",
    "f12",
    "f13",
    "f14",
    "f20",
    "f21",
    "f22",
    "f23",
    "f24",
    "HP0",
    "HP1",
    "HP2",
    "HP3",
    "HP4",
    "dm0",
    "dm1",
    "dm2",
    "dm3",
    "dm4",
    "Sm0",
    "Sm1",
    "Sm2",
    "Sm3",
    "Sm4",
  ];

  for (final key in keys) {
    double val = le.lBesselian(blnH, thnH, key);
    print('$key : ${val.toStringAsFixed(7)}');
  }
}
