import 'package:myhisab/service/calendar_service.dart';

void main() {
  final hasil = hisabAwalBulanHijriahSesuaiLokasi(
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

  print(hasil); // tampilkan semua output sekaligus
}
