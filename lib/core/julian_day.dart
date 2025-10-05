import 'math_utils.dart';

class JulianDay {
  //final dt = DynamicalTime();
  final mf = MathFunction();

  // Konversi Kalender Masehi ke Julian Day
  double kmjd(
    int tglM,
    int blnM,
    int thnM, [
    double jamDes = 0.0,
    double timeZone = 0.0,
  ]) {
    double dd = tglM + ((jamDes - timeZone) / 24.0);
    double mm;
    double yy;

    if (blnM > 2) {
      mm = blnM.toDouble();
      yy = thnM.toDouble();
    } else {
      mm = blnM.toDouble() + 12;
      yy = thnM.toDouble() - 1;
    }

    double bb;
    if ((thnM.toDouble() + blnM.toDouble() / 100 + tglM.toDouble() / 10000) >=
        1582.1015) {
      double aa = (yy / 100).floorToDouble();
      bb = 2 - aa + (aa / 4).floorToDouble();
    } else {
      bb = 0.0;
    }

    double jd =
        (365.25 * (yy + 4716)).floorToDouble() +
        (30.6001 * (mm + 1)).floorToDouble() +
        dd +
        bb -
        1524.5;

    return jd;
  }

  // Konversi Julian Day ke Kalender Masehi
  String jdkm(double jd, [double tmZn = 0.0, String optResult = ""]) {
    double cjd = jd + 0.5 + tmZn / 24.0;
    double cjdn = cjd.floorToDouble();
    double fracD = cjd - cjdn;

    double alpha = ((cjdn - 1867216.25) / 36524.25).floorToDouble();
    double beta = 1 + alpha - (alpha / 4).floorToDouble();

    double gc = (cjdn >= 2299161) ? beta : 0.0;

    double a = cjdn + gc;
    double b = a + 1524;
    double c = ((b - 122.1) / 365.25).floorToDouble();
    double d = (365.25 * c).floorToDouble();
    double e = ((b - d) / 30.6001).floorToDouble();

    double tglM = b - d - (30.6001 * e).floorToDouble();
    double blnM = (e < 14) ? e - 1 : e - 13;
    double thnM = (blnM > 2) ? c - 4716 : c - 4715;

    double jamDes = fracD * 24;

    // Nama hari
    double noHrM = cjdn - 7 * (cjdn / 7).floorToDouble();
    List<String> nmHrMDt = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jum'at",
      "Sabtu",
      "Ahad",
    ];
    String nmHrM = nmHrMDt[noHrM.toInt()];

    // Nama bulan
    List<String> nmBlnMDt = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    String nmBlnM = nmBlnMDt[blnM.toInt() - 1];

    // Jenis penomoran tahun
    String thnMHYNS;
    String thnMAYNS;
    if (thnM > 0) {
      thnMHYNS = "$nmHrM, ${tglM.toInt()} $nmBlnM ${thnM.toInt()} M";
      thnMAYNS = "$nmHrM, ${tglM.toInt()} $nmBlnM +${thnM.toInt()}";
    } else {
      thnMHYNS =
          "$nmHrM, ${tglM.toInt()} $nmBlnM ${(thnM.abs().toInt() + 1)} SM";
      thnMAYNS = "$nmHrM, ${tglM.toInt()} $nmBlnM ${thnM.toInt()}";
    }

    switch (optResult.replaceAll(" ", "").toUpperCase()) {
      case "TGLM":
      case "TGL":
        return tglM.toInt().toString();
      case "BLNM":
      case "BLN":
        return blnM.toInt().toString();
      case "THNM":
      case "THN":
        return thnM.toInt().toString();
      case "NMBLNM":
      case "BULAN":
        return nmBlnM;
      case "NMHRM":
      case "HARI":
      case "HR":
        return nmHrM;
      case "THNMHYNS":
        return thnMHYNS;
      case "THNMAYNS":
        return thnMAYNS;
      case "JAMDES":
      case "JAMDESIMAL":
      case "JAMD":
        return jamDes.toString();
      case "FRACDAY":
      case "PECAHANHARI":
        return fracD.toString();
      default:
        return "$nmHrM, ${tglM.toInt()} $nmBlnM ${thnM.toInt()}";
    }
  }

  double jde(double jd, {double deltaT = 0.0}) {
    return jd + deltaT / 86400.0;
  }

  double jc(double jd) {
    return (jd - 2451545) / 36525;
  }

  double jce(double jde) {
    return (jde - 2451545) / 36525;
  }

  double jm(double jc) {
    return jc / 10.0;
  }

  double jme(double jce) {
    return jce / 10.0;
  }

  // Konversi CJDN ke Kalender Hijriah
  dynamic cjdnKH(
    int cjdn, {
    int hCalE = 2, //pilihan epoch
    int hCalL = 2, //pilihan leap year correction
    String optResult = " ",
  }) {
    double dltD = (hCalE == 1) ? 1948439.0 : 1948440.0;

    double lyCor;
    switch (hCalL) {
      case 1:
        lyCor = 15.0;
        break;
      case 2:
        lyCor = 14.0;
        break;
      case 3:
        lyCor = 11.0;
        break;
      case 4:
        lyCor = 9.0;
        break;
      default:
        lyCor = 14.0;
    }

    double hCalDN = cjdn - dltD;
    int x2 = ((30.0 * hCalDN + 29.0 - lyCor) / 10631).floor();
    double r2 = mf.mod(30 * hCalDN + 29 - lyCor, 10631.0);
    int x1 = ((11 * (r2 / 30).floor() + 5) / 325).floor();
    double r1 = mf.mod(11 * (r2 / 30).floor() + 5, 325.0);

    int hCalD = (r1 / 11).floor() + 1;
    int hCalM = x1 + 1;
    int hCalY = x2 + 1;

    List<String> namaBulanHijriah = [
      "Al-Muharram",
      "Shafar",
      "Rabiul Awwal",
      "Rabiul Akhir",
      "Jumadal Ula",
      "Jumadal Akhirah",
      "Rajab",
      "Syaban",
      "Ramadhan",
      "Syawal",
      "Zulqadah",
      "Zulhijjah",
    ];
    List<String> namaHari = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jum'at",
      "Sabtu",
      "Ahad",
    ];
    List<String> namaPasaran = ["Legi", "Pahing", "Pon", "Wage", "Kliwon"];

    String nmBlnH = namaBulanHijriah[hCalM - 1];
    String nmHrH = namaHari[cjdn % 7];
    String nmPsH = namaPasaran[cjdn % 5];

    switch (optResult.replaceAll(" ", "").toUpperCase()) {
      case "TGLH":
      case "TGL":
        return hCalD;
      case "BLNH":
      case "BLN":
        return hCalM;
      case "THNH":
      case "THN":
        return hCalY;
      case "NMBLNH":
      case "BULAN":
        return nmBlnH;
      case "NMHRH":
      case "HARI":
      case "HR":
        return nmHrH;
      case "NMPSM":
      case "PASARAN":
      case "PS":
        return nmPsH;
      default:
        return "$nmHrH, $hCalD, $nmBlnH, $hCalY";
    }
  }
}
