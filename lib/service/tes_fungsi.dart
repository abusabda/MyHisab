import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/sun_function.dart';
//import 'package:myhisab/core/math_utils.dart';
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
  final mo = MoonFunction();
  final sn = SunFunction();
  final dt = DynamicalTime();

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

  print(" ");

  // INPUT GERHANA BULAN
  final blnH2 = 11;
  final thnH2 = 1439;
  final gLon = 107 + 36 / 60.0 + 0 / 3600.0;
  final gLat = -(7 + 5 / 60.0 + 0 / 3600.0);
  final elev = 730.0;
  double tmZn = 7;

  print("========================================");
  print("        DATA GERHANA BULAN");
  print("========================================");
  print("Bulan Hijriah : $blnH2");
  print("Tahun Hijriah : $thnH2");
  print("");

  // ================================
  // CETAK ELEMEN BESSELIAN
  // ================================
  print("Elemen Besselian:");
  final elements = [
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
    "Sm0",
    "Sm1",
    "Sm2",
    "Sm3",
    "Sm4",
    "HP0",
    "HP1",
    "HP2",
    "HP3",
    "HP4",
    "DT",
    "T0",
  ];

  for (var e in elements) {
    final val = le.lBesselian(blnH2, thnH2, e);

    String valStr;

    if (val.isNaN) {
      valStr = "-";
    } else {
      // Atur jumlah desimal berdasarkan jenis elemen
      if (e == "T0") {
        // T0 = jam bulat (tanpa desimal)
        valStr = val.toStringAsFixed(0);
      } else if (e == "DT") {
        // DT = DeltaT (2 desimal)
        valStr = val.toStringAsFixed(2);
      } else {
        // Elemen lain = 7 desimal
        valStr = val.toStringAsFixed(7);
      }

      // Tambahkan 1 spasi di depan untuk nilai positif agar sejajar dengan negatif
      if (val > 0) valStr = " $valStr";
    }

    print("${e.padRight(5)} : $valStr");
  }

  // ================================
  // CETAK JENIS GERHANA
  // ================================
  print("\nJenis Gerhana:");
  final jenisVal = le
      .lunarEclipse(
        hijriMonth: blnH2,
        hijriYear: thnH2,
        gLon: gLon,
        gLat: gLat,
        elev: elev,
        tmZn: tmZn,
        optResult: "JenisGerhana",
      )
      .toInt();

  String jenisText = switch (jenisVal) {
    1 => "GERHANA BULAN TOTAL",
    2 => "GERHANA BULAN SEBAGIAN",
    3 => "GERHANA BULAN PENUMBRAL",
    _ => "TIDAK ADA GERHANA",
  };

  print("=> $jenisText");

  // ================================
  // CETAK KONTAK GERHANA
  // ================================
  print("\nKontak Gerhana (Waktu Lokal):");

  double? jdMax; // simpan JD maksimum (puncak gerhana)

  final kontak = [
    ["P1", "Awal Penumbra"],
    ["U1", "Awal Sebagian"],
    ["U2", "Awal Total"],
    ["Mx", "Puncak Gerhana"],
    ["U3", "Akhir Total"],
    ["U4", "Akhir Sebagian"],
    ["P4", "Akhir Penumbra"],
  ];

  for (var k in kontak) {
    final fase = k[0];
    final label = k[1];

    // Ambil JD hasil kontak
    final jdVal = le.lunarEclipse(
      hijriMonth: blnH2,
      hijriYear: thnH2,
      gLon: gLon,
      gLat: gLat,
      elev: elev,
      tmZn: tmZn,
      optResult: fase,
    );

    // Simpan JD maksimum (puncak gerhana)
    if (fase == "Mx") jdMax = jdVal;

    if (jdVal.isNaN || jdVal == 0.0) {
      print("${label.padRight(20)} : -");
      continue;
    }

    // Konversi JD → tanggal dan jam
    final tgl = jd.jdkm(jdVal, tmZn);
    final jamDes = double.parse(jd.jdkm(jdVal, tmZn, "Jam Des"));
    final detikDesimal = (fase == "Mx")
        ? mf.dhhms(jamDes, optResult: "HH:MM:SS", secDecPlaces: 1)
        : mf.dhhms(jamDes, optResult: "HH:MM:SS", secDecPlaces: 0);

    final dltT = dt.deltaT(jdVal);

    // Hitung azimut (satu kali saja, ringan)
    final azmVal = mo.moonTopocentricAzimuth(jdVal, dltT, gLon, gLat, elev);
    final altVal = mo.moonTopocentricAltitude(
      jdVal,
      dltT,
      gLon,
      gLat,
      elev,
      1010.0,
      10.0,
      "htc",
    );

    // Gabungkan tanggal + jam dan ratakan panjang kolomnya
    final waktuText = "$tgl | Jam: $detikDesimal";
    // panjang kolom waktu disamakan (misal 50 karakter)
    final waktuPad = waktuText.padRight(40);

    // Format kolom azimut, beri 2 spasi tambahan di awal untuk rapih
    final azmText = (azmVal.isNaN || azmVal == 0.0)
        ? ""
        : "  | Azm: ${mf.dddms(azmVal)}";
    //: "  | Azm: ${azmVal.toStringAsFixed(1).padLeft(0)}°";

    final altText = (azmVal.isNaN || azmVal == 0.0)
        ? ""
        : "  | Alt: ${mf.dddms(altVal)}";
    //: "  | Alt: ${altVal.toStringAsFixed(1).padLeft(0)}°";

    print("${label.padRight(20)} : $waktuPad $azmText $altText");
  }

  print(" ");

  final dataGerhana = [
    ["MagP", "Magnitudo Penumbra"],
    ["MagU", "Magnitudo Umbra"],
    ["RadP", "Radius Penumbra"],
    ["RadU", "Radius Umbra"],
    ["DurP", "Durasi Penumbra"],
    ["DurU", "Durasi Umbra"],
    ["DurT", "Durasi Total"],
  ];

  for (var d in dataGerhana) {
    final jdVal = le.lunarEclipse(
      hijriMonth: blnH2,
      hijriYear: thnH2,
      gLon: gLon,
      gLat: gLat,
      elev: elev,
      tmZn: tmZn,
      optResult: d[0],
    );

    // Nama parameter misalnya "DurP", "DurU", "DurT", "P1", dst.
    final nama = d[1].padRight(20);

    if (jdVal.isNaN || jdVal == 0.0) {
      print("$nama : -");
    } else {
      // --- Aturan tambahan ---
      String valStr;

      if (d[0] == "DurP" || d[0] == "DurU" || d[0] == "DurT") {
        // Format durasi jam-menit-detik
        valStr = mf.dhhms(jdVal, optResult: "HH:MM:SS", secDecPlaces: 0);
      } else {
        // Format default (bilangan biasa)
        valStr = jdVal.toStringAsFixed(7);
      }

      print("$nama : $valStr");
    }
  }

  if (jdMax != null && !jdMax.isNaN && jdMax != 0.0) {
    final jdMx = jdMax;
    final delT = dt.deltaT(jdMx);

    // ===================== Matahari =====================
    final arSun = sn.sunGeocentricRightAscension(jdMx, delT) / 15;
    final deSun = sn.sunGeocentricDeclination(jdMx, delT);
    final sdSun = sn.sunGeocentricSemidiameter(jdMx, delT);
    final hpSun = sn.sunEquatorialHorizontalParallax(jdMx, delT);

    // ===================== Bulan =====================
    final arMoon = mo.moonGeocentricRightAscension(jdMx, delT) / 15;
    final deMoon = mo.moonGeocentricDeclination(jdMx, delT);
    final sdMoon = mo.moonGeocentricSemidiameter(jdMx, delT);
    final hpMoon = mo.moonEquatorialHorizontalParallax(jdMx, delT);

    print("\nData Matahari pada saat Puncak Gerhana:");
    print(
      "${'R.A'.padRight(5)}: ${mf.dhhms(arSun, optResult: "HHMMSS", secDecPlaces: 1)}",
    );
    print(
      "${'Dec'.padRight(5)}: ${mf.dddms(deSun, optResult: "DD:MM:SS", sdp: 1)}",
    );
    print(
      "${'S.D'.padRight(5)}: ${mf.dddms(sdSun, optResult: "DD:MM:SS", sdp: 1)}",
    );
    print(
      "${'H.P'.padRight(5)}: ${mf.dddms(hpSun, optResult: "DD:MM:SS", sdp: 1)}",
    );

    print("\nData Bulan pada saat Puncak Gerhana:");
    print(
      "${'R.A'.padRight(5)}: ${mf.dhhms(arMoon, optResult: "HHMMSS", secDecPlaces: 1)}",
    );
    print(
      "${'Dec'.padRight(5)}: ${mf.dddms(deMoon, optResult: "DD:MM:SS", sdp: 1)}",
    );
    print(
      "${'S.D'.padRight(5)}: ${mf.dddms(sdMoon, optResult: "DD:MM:SS", sdp: 1)}",
    );
    print(
      "${'H.P'.padRight(5)}: ${mf.dddms(hpMoon, optResult: "DD:MM:SS", sdp: 1)}",
    );
  } else {
    print("\nData Matahari pada saat Puncak Gerhana:");
    print("${'R.A'.padRight(5)}: -");
    print("${'Dec'.padRight(5)}: -");
    print("${'S.D'.padRight(5)}: -");
    print("${'H.P'.padRight(5)}: -");

    print("\nData Bulan pada saat Puncak Gerhana:");
    print("${'R.A'.padRight(5)}: -");
    print("${'Dec'.padRight(5)}: -");
    print("${'S.D'.padRight(5)}: -");
    print("${'H.P'.padRight(5)}: -");
  }

  print("========================================");
}
