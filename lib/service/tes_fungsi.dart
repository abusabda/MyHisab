//import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/sun_function.dart';
//import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/service/calendar_service.dart';
import 'package:myhisab/service/lunar_eclipse_service.dart';
import 'package:myhisab/service/qibla_service.dart';
import 'package:myhisab/service/salat_service.dart';
import 'package:myhisab/service/solar_eclipse_service.dart';

void main() {
  final ss = SalatService();
  final qs = QiblaService();
  final cs = CalendarService();
  final le = LunarEclipseService();
  final se = SolarEclipseService();
  final jd = JulianDay();
  final mf = MathFunction();
  final mo = MoonFunction();
  final sn = SunFunction();
  //final dt = DynamicalTime();

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
  final gLon2 = 107 + 36 / 60.0 + 0 / 3600.0;
  final gLat2 = -(7 + 5 / 60.0 + 0 / 3600.0);
  final elev2 = 730.0;
  double tmZn2 = 7;

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

  print("========================================");

  final lunarEclipse = [
    "JLE",
    "JDP1",
    "JDU1",
    "JDU2",
    "JDMX",
    "JDU3",
    "JDU4",
    "JDP4",
    "DURP",
    "DURU",
    "DURT",
    "MAGP",
    "MAGU",
    "RADP",
    "RADU",
    "RAS",
    "DCS",
    "SDS",
    "HPS",
    "RAM",
    "DCM",
    "SDM",
    "HPM",
  ];

  final Map<String, String> lunarEclipseLabel = {
    "JLE": "Jenis Gerhana",
    "JDP1": "Awal Penumbra (P1)",
    "JDU1": "Awal Umbra (U1)",
    "JDU2": "Awal Total (U2)",
    "JDMX": "Puncak Gerhana (MX)",
    "JDU3": "Akhir Total (U3)",
    "JDU4": "Akhir Umbra(U4)",
    "JDP4": "Akhir Penumbra (P4)",
    "DURP": "Durasi Penumbra",
    "DURU": "Durasi Umbra",
    "DURT": "Durasi Total",
    "MAGP": "Magnitudo Penumbra",
    "MAGU": "Magnitudo Umbra",
    "RADP": "Radius Penumbra",
    "RADU": "Radius Umbra",
    "RAS": "RAs",
    "DCS": "DCs",
    "SDS": "SDs",
    "HPS": "HPs",
    "RAM": "RAm",
    "DCM": "DCm",
    "SDM": "SDm",
    "HPM": "HPm",
  };

  final result = le.lunarEclipse(
    blnH: blnH2,
    thnH: thnH2,
    gLon: gLon2,
    gLat: gLat2,
    elev: elev2,
    tmZn: tmZn2,
  );

  for (final e in lunarEclipse) {
    final val = result[e];
    String text;

    if (val == null || (val is double && val.isNaN) || val == 0.0) {
      text = "-";
    } else {
      switch (e) {
        case "JLE":
          // Jenis gerhana → teks
          text = val.toString();
          break;

        case "JDP1":
          // Tanggal & Jam P1
          final jdVal = val;
          final azmP1 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altP1 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmP1, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altP1, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU1":
          // Tanggal & Jam U1
          final jdVal = val;
          final azmU1 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altU1 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU1, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU1, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU2":
          // Tanggal & Jam U2
          final jdVal = val as double;
          final azmU2 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altU2 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU2, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU2, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDMX":
          // Tanggal & Jam puncak gerhana
          final jdVal = val;
          final azmMX = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altMX = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmMX, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altMX, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU3":
          // Tanggal & Jam U3
          final jdVal = val as double;
          final azmU3 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altU3 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU3, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU3, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU4":
          // Tanggal & Jam U3
          final jdVal = val as double;
          final azmU4 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altU4 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU4, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU4, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDP4":
          // Tanggal & Jam U1
          final jdVal = val as double;
          final azmP4 = mo.moonTopocentricAzimuth(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
          );
          final altP4 = mo.moonTopocentricAltitude(
            jdVal,
            0,
            gLon2,
            gLat2,
            elev2,
            1010.0,
            10.0,
            "htoc",
          );
          text =
              "${jd.jdkm(jdVal, tmZn2)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn2, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmP4, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altP4, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "DURP":
          // Durasi Gerhana
          text = mf.dhhms(
            val as double,
            optResult: "HH:MM:SS",
            secDecPlaces: 0,
          );
          break;

        case "DURU":
          // Durasi Total/Cincin
          text = mf.dhhms(val, optResult: "HH:MM:SS", secDecPlaces: 0);
          break;

        case "DURT":
          // Durasi Total/Cincin
          text = mf.dhhms(val, optResult: "HH:MM:SS", secDecPlaces: 0);
          break;

        case "MAGP":
          // Magnitudo
          text = (val as double).toStringAsFixed(3);
          break;

        case "MAGU":
          // Magnitudo
          text = (val as double).toStringAsFixed(3);
          break;

        case "RADP":
          // Radius Penumbra
          text = (val as double).toStringAsFixed(3);
          break;

        case "RADU":
          // Radius Umbra
          text = (val as double).toStringAsFixed(3);
          break;

        case "RAS":
          // R.A → HH:MM:SS
          text = mf.dhhms(
            val / 15 as double,
            optResult: "HHMMSS",
            secDecPlaces: 1,
          );
          break;

        case "DCS":
          // Dec → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "SDS":
          // S.D → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "HPS":
          // H.P → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "RAM":
          // R.A → HH:MM:SS
          text = mf.dhhms(
            val / 15 as double,
            optResult: "HHMMSS",
            secDecPlaces: 1,
          );
          break;
        case "DCM":
          // Dec → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;
        case "SDM":
          // S.D → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;
        case "HPM":
          // H.P → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        default:
          text = val.toString();
      }
    }

    // 🔹 Print dengan label panjang
    print("${lunarEclipseLabel[e]!.padRight(25)} : $text");
  }

  print("========================================");

  // INPUT GERHANA MATAHARI
  final blnH3 = 5;
  final thnH3 = 1437;
  final gLon3 = (108 + 17 / 60.0 + 50 / 3600.0);
  final gLat3 = -(2 + 51 / 60.0 + 25 / 3600.0);
  final elev3 = 2.0;
  double tmZn3 = 7;

  print("========================================");
  print("        DATA GERHANA MATAHARI");
  print("========================================");
  print("Bulan Hijriah : $blnH3");
  print("Tahun Hijriah : $thnH3");
  print("");

  // ================================
  // CETAK ELEMEN BESSELIAN
  // ================================
  print("Elemen Besselian:");
  final elements3 = [
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

  for (var e in elements3) {
    final val = se.sBesselian(blnH3, thnH3, e);

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
  print("========================================");

  final solarEclipse = [
    "JSE",
    "JDU1",
    "JDU2",
    "JDMX",
    "JDU3",
    "JDU4",
    "DURG",
    "DURT",
    "MAG",
    "OBS",
    "RAS",
    "DCS",
    "SDS",
    "HPS",
    "RAM",
    "DCM",
    "SDM",
    "HPM",
  ];

  final Map<String, String> solarEclipseLabel = {
    "JSE": "Jenis Gerhana",
    "JDU1": "Awal Gerhana (U1)",
    "JDU2": "Awal Total/Cincin (U2)",
    "JDMX": "Puncak Gerhana (MX)",
    "JDU3": "Akhir Total/Cincin (U3)",
    "JDU4": "Akhir Gerhana (U4)",
    "DURG": "Durasi Gerhana",
    "DURT": "Durasi Total/Cincin",
    "MAG": "Magnitudo",
    "OBS": "Obskurasi",
    "RAS": "RAs",
    "DCS": "DCs",
    "SDS": "SDs",
    "HPS": "HPs",
    "RAM": "RAm",
    "DCM": "DCm",
    "SDM": "SDm",
    "HPM": "HPm",
  };

  final result3 = se.solarEclipseLocal(
    blnH: blnH3,
    thnH: thnH3,
    gLon: gLon3,
    gLat: gLat3,
    elev: elev3,
    tmZn: tmZn3,
  );

  for (final e in solarEclipse) {
    final val = result3[e];
    String text;

    if (val == null || (val is double && val.isNaN) || val == 0.0) {
      text = "-";
    } else {
      switch (e) {
        case "JSE":
          // Jenis gerhana → teks
          text = val.toString();
          break;

        case "JDU1":
          // Tanggal & Jam U1
          final jdVal = val as double;
          final azmU1 = sn.sunTopocentricAzimuth(jdVal, 0, gLon3, gLat3, elev3);
          final altU1 = sn.sunTopocentricAltitude(
            jdVal,
            0,
            gLon3,
            gLat3,
            elev3,
            1010.0,
            10.0,
            "hto",
          );
          text =
              "${jd.jdkm(jdVal, tmZn3)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn3, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU1, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU1, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU2":
          // Tanggal & Jam U2
          final jdVal = val as double;
          final azmU2 = sn.sunTopocentricAzimuth(jdVal, 0, gLon3, gLat3, elev3);
          final altU2 = sn.sunTopocentricAltitude(
            jdVal,
            0,
            gLon3,
            gLat3,
            elev3,
            1010.0,
            10.0,
            "hto",
          );
          text =
              "${jd.jdkm(jdVal, tmZn3)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn3, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU2, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU2, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDMX":
          // Tanggal & Jam puncak gerhana
          final jdVal = val as double;
          final azmMX = sn.sunTopocentricAzimuth(jdVal, 0, gLon3, gLat3, elev3);
          final altMX = sn.sunTopocentricAltitude(
            jdVal,
            0,
            gLon3,
            gLat3,
            elev3,
            1010.0,
            10.0,
            "hto",
          );
          text =
              "${jd.jdkm(jdVal, tmZn3)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn3, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmMX, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altMX, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU3":
          // Tanggal & Jam U3
          final jdVal = val as double;
          final azmU3 = sn.sunTopocentricAzimuth(jdVal, 0, gLon3, gLat3, elev3);
          final altU3 = sn.sunTopocentricAltitude(
            jdVal,
            0,
            gLon3,
            gLat3,
            elev3,
            1010.0,
            10.0,
            "hto",
          );
          text =
              "${jd.jdkm(jdVal, tmZn3)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn3, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU3, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU3, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "JDU4":
          // Tanggal & Jam U3
          final jdVal = val as double;
          final azmU4 = sn.sunTopocentricAzimuth(jdVal, 0, gLon3, gLat3, elev3);
          final altU4 = sn.sunTopocentricAltitude(
            jdVal,
            0,
            gLon3,
            gLat3,
            elev3,
            1010.0,
            10.0,
            "hto",
          );
          text =
              "${jd.jdkm(jdVal, tmZn3)} |"
              " jam : ${mf.dhhms(double.parse(jd.jdkm(jdVal, tmZn3, "Jam Des")), optResult: "HH:MM:SS", secDecPlaces: 0)} | Azm: ${mf.dddms(azmU4, optResult: "DDMMSS", sdp: 0, posNegSign: "")} | Alt: ${mf.dddms(altU4, optResult: "DDMMSS", sdp: 0, posNegSign: "")}";
          break;

        case "DURG":
          // Durasi Gerhana
          text = mf.dhhms(
            val as double,
            optResult: "HH:MM:SS",
            secDecPlaces: 0,
          );
          break;

        case "DURT":
          // Durasi Total/Cincin
          text = mf.dhhms(val, optResult: "HH:MM:SS", secDecPlaces: 0);
          break;

        case "MAG":
          // Magnitudo → 3 desimal
          text = (val as double).toStringAsFixed(3);
          break;

        case "OBS":
          // Obskurasi → persen 1 desimal
          text = "${(val as double).toStringAsFixed(1)} %";
          break;

        case "RAS":
          // R.A → HH:MM:SS
          text = mf.dhhms(
            val / 15 as double,
            optResult: "HHMMSS",
            secDecPlaces: 1,
          );
          break;

        case "DCS":
          // Dec → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "SDS":
          // S.D → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "HPS":
          // H.P → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        case "RAM":
          // R.A → HH:MM:SS
          text = mf.dhhms(
            val / 15 as double,
            optResult: "HHMMSS",
            secDecPlaces: 1,
          );
          break;
        case "DCM":
          // Dec → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;
        case "SDM":
          // S.D → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;
        case "HPM":
          // H.P → DD:MM:SS
          text = mf.dddms(val as double, optResult: "DDMMSS", sdp: 1);
          break;

        default:
          text = val.toString();
      }
    }

    // 🔹 Print dengan label panjang
    print("${solarEclipseLabel[e]!.padRight(25)} : $text");
  }
}
