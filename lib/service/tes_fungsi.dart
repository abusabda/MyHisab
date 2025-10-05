import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/service/calendar_service.dart';

void main() {
  final ab = CalendarService();
  final jd = JulianDay();

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

  final jdAbqMabims = ab.abqMabims(10, 1447);
  print("Awal Bulan Hijriah Mabims: ${jd.jdkm(jdAbqMabims)}");

  final abqMabimsNow = ab.serviceKalenderHijriahMABIMS(21, 3, 2026);
  print(abqMabimsNow);
}
