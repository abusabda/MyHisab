import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/service/calendar_service.dart';
import 'package:myhisab/service/qibla_service.dart';
import 'package:myhisab/service/salat_service.dart';

void main() {
  final ss = SalatService();
  final qs = QiblaService();
  final cs = CalendarService();
  final jd = JulianDay();

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

  final abqSesuaiLokasi = ab.hisabAwalBulanHijriahSesuaiLokasi(
    nmLokasi: "Pelabuhan Ratu",
    blnH: 10,
    thnH: 1444,
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

  final jdAbqMabims = cs.abqMabims(5, 1452);
  print("Awal Bulan Hijriah Mabims: ${jd.jdkm(jdAbqMabims)}");

  final abqMabimsNow = cs.serviceKalenderHijriahMABIMS(30, 8, 2030);
  print(abqMabimsNow);
}
