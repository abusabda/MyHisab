import 'dart:math';

class MathFunction {
  // Konversi sudut
  double deg(double x) => x * 180.0 / pi;
  double rad(double x) => x * pi / 180.0;

  // Modulus
  double mod(double x, double y) => x - y * (x / y).floor();

  double floor(double x) => (x).floorToDouble();
  double abs(double x) => (x).abs();

  // Sign
  int sign(double x) => (x > 0) ? 1 : (x < 0 ? -1 : 0);

  // Pembulatan umum (seperti extension round di Kotlin)
  String roundDouble(double value, int decimals) {
    return value.toStringAsFixed(decimals);
  }

  // Pembulatan manual ala RoundTo
  String roundTo(double xDec, {int place = 2}) {
    final A = pow(10.0, place.toDouble());
    final H = (xDec >= 0)
        ? floor(xDec * A + 0.5) / A
        : -floor(abs(xDec) * A + 0.5) / A;
    return H.toString();
  }

  // Format jam HH:MM:SS
  String dhhms(
    double dHrs, {
    String optResult = "HH:MM:SS",
    int secDecPlaces = 2,
    String posNegSign = "",
  }) {
    final uDHrs = abs(dHrs);
    double uHrs = floor(uDHrs);
    final uDMin = (uDHrs - uHrs) * 60.0;
    double uMin = floor(uDMin);
    final uDSec = (uDMin - uMin) * 60.0;

    // format detik dengan jumlah desimal sesuai
    String uSec = uDSec.toStringAsFixed(secDecPlaces);

    // koreksi jika detik = 60.0
    if (double.parse(uSec) == 60.0) {
      uSec = 0.0.toStringAsFixed(secDecPlaces);
      uMin += 1.0;
    }

    // koreksi jika menit = 60
    if (uMin == 60.0) {
      uMin = 0.0;
      uHrs += 1.0;
    }

    final sHrs = uHrs.toInt() < 10 ? "0${uHrs.toInt()}" : "${uHrs.toInt()}";
    final sMin = uMin.toInt() < 10 ? "0${uMin.toInt()}" : "${uMin.toInt()}";
    final sSec = double.parse(uSec) < 10.0 ? "0$uSec" : uSec;

    // tanda positif/negatif
    String pns;
    if (posNegSign == "+-") {
      if (dHrs > 0.0) {
        pns = "+";
      } else if (dHrs < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    } else {
      if (dHrs < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    }

    switch (optResult) {
      case "HH:MM:SS":
        return "$pns$sHrs:$sMin:$sSec";
      case "HHMMSS":
        return "$pns${sHrs}h ${sMin}m ${sSec}s";
      case "MMSS":
        return "$pns${sMin}m ${sSec}s";
      case "HH:MM":
        return "$pns$sHrs:$sMin";
      default:
        return "$pns$sHrs:$sMin:$sSec";
    }
  }

  // Format jam HH:MM
  String dhhm(
    double dHrs, {
    String optResult = "HH:MM",
    int minDecPlaces = 2,
    String posNegSign = "",
  }) {
    final uDHrs = abs(dHrs);
    double uHrs = floor(uDHrs);
    final uDMin = (uDHrs - uHrs) * 60.0;
    String uMin = uDMin.toStringAsFixed(minDecPlaces);

    // koreksi bila menit = 60.0
    if (double.parse(uMin) == 60.0) {
      uMin = 0.0.toStringAsFixed(minDecPlaces);
      uHrs += 1.0;
    }

    final sHrs = uHrs.toInt() < 10 ? "0${uHrs.toInt()}" : "${uHrs.toInt()}";
    final sMin = double.parse(uMin) < 10.0 ? "0$uMin" : uMin;

    // tanda positif/negatif
    String pns;
    if (posNegSign == "+-") {
      if (dHrs > 0.0) {
        pns = "+";
      } else if (dHrs < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    } else {
      if (dHrs < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    }

    switch (optResult) {
      case "HH:MM":
        return "$pns$sHrs:$sMin";
      case "HHMM":
        return "$pns${sHrs}h ${sMin}m";
      default:
        return "$pns$sHrs:$sMin";
    }
  }

  // Format derajat DD°MM'SS"
  String dddms(
    double dDeg, {
    String optResult = "DDMMSS",
    int sdp = 2,
    String posNegSign = "+-",
  }) {
    final double uDDeg = abs(dDeg);
    double uDeg = floor(uDDeg);
    final double uDMin = (uDDeg - uDeg) * 60.0;
    double uMin = floor(uDMin);
    final double uDSec = (uDMin - uMin) * 60.0;
    String uSec = uDSec.toStringAsFixed(sdp);

    if (double.parse(uSec) == 60.0) {
      uSec = 0.0.toStringAsFixed(sdp);
      uMin = uMin + 1.0;
    }

    if (uMin == 60.0) {
      uMin = 0.0;
      uDeg = uDeg + 1.0;
    }

    final String sDeg = (uDeg.toInt() < 10)
        ? "00${uDeg.toInt()}"
        : (uDeg.toInt() < 100)
        ? "0${uDeg.toInt()}"
        : "${uDeg.toInt()}";

    final String sMin = (uMin.toInt() < 10)
        ? "0${uMin.toInt()}"
        : "${uMin.toInt()}";

    final String sSec = (double.parse(uSec) < 10.0) ? "0$uSec" : uSec;

    // --- PNS sesuai aturan PosNegSign ---
    final String pns;
    if (posNegSign == "+-") {
      if (dDeg > 0.0) {
        pns = "+";
      } else if (dDeg < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    } else {
      if (dDeg > 0.0) {
        pns = "";
      } else if (dDeg < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    }

    final String bbbt;
    final String luls;

    if (dDeg > 0.0) {
      bbbt = "BT";
      luls = "LU";
    } else {
      bbbt = "BB";
      luls = "LS";
    }

    switch (optResult) {
      case "DDMMSS":
        return "$pns$sDeg° $sMin’ $sSec”";
      case "MMSS":
        return "$pns$sMin’ $sSec”";
      case "SS":
        return "$pns$sSec”";
      case "BBBT":
        return "$pns$sDeg° $sMin’ $sSec” $bbbt";
      case "LULS":
        return "$pns$sDeg° $sMin’ $sSec” $luls";
      default:
        return "$pns$sDeg° $sMin’ $sSec”";
    }
  }

  // Format derajat versi 2 (DDDMS2)
  String dddms2(
    double dDeg, {
    String optResult = "DDMMSS",
    int sdp = 2,
    String posNegSign = "", // "" atau "+-"
  }) {
    // Nilai absolut untuk dihitung
    final double uDDeg = abs(dDeg);

    // Derajat
    String uDeg = floor(uDDeg).toStringAsFixed(0);

    // Menit
    double uDMin = (uDDeg - double.parse(uDeg)) * 60.0;
    String uMin = floor(uDMin).toStringAsFixed(0);

    // Detik
    double uDSec = (uDMin - double.parse(uMin)) * 60.0;
    String uSec = uDSec.toStringAsFixed(sdp);

    // Koreksi pembulatan detik -> menit
    if (double.parse(uSec) == 60.0) {
      uSec = 0.0.toStringAsFixed(sdp);
      uMin = (double.parse(uMin) + 1.0).toStringAsFixed(0);
    }

    // Koreksi pembulatan menit -> derajat
    if (double.parse(uMin) == 60.0) {
      uMin = "0";
      uDeg = (double.parse(uDeg) + 1.0).toStringAsFixed(0);
    }

    // Tanda Positif/Negatif sesuai pilihan
    final String pns;
    if (posNegSign == "+-") {
      if (dDeg > 0.0) {
        pns = "+";
      } else if (dDeg < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    } else {
      if (dDeg > 0.0) {
        pns = "";
      } else if (dDeg < 0.0) {
        pns = "-";
      } else {
        pns = "";
      }
    }

    // BT/BB dan LU/LS
    final String bbbt = (dDeg > 0.0) ? "BT" : "BB";
    final String luls = (dDeg > 0.0) ? "LU" : "LS";

    // Hasil sesuai OptResult
    switch (optResult) {
      case "DDMMSS":
        return "$pns$uDeg° $uMin’ $uSec”";
      case "MMSS":
        return "$pns$uMin’ $uSec”";
      case "SS":
        return "$pns$uSec”";
      case "BBBT":
        return "$pns$uDeg° $uMin’ $uSec” $bbbt";
      case "LULS":
        return "$pns$uDeg° $uMin’ $uSec” $luls";
      default:
        return "$pns$uDeg° $uMin’ $uSec”";
    }
  }

  // Interpolasi 5 nilai
  double interpolationFromFiveTabularValues(
    double xM2,
    double xM1,
    double x00,
    double xP1,
    double xP2,
    int optResult,
  ) {
    final A = xM1 - xM2;
    final B = x00 - xM1;
    final C = xP1 - x00;
    final D = xP2 - xP1;
    final E = B - A;
    final F = C - B;
    final G = D - C;
    final H = F - E;
    final J = G - F;
    final K = J - H;

    switch (optResult) {
      case 0:
        return x00;
      case 1:
        return ((B + C) / 2 - (H + J) / 12);
      case 2:
        return (F / 2 - K / 24);
      case 3:
        return ((H + J) / 12);
      case 4:
        return (K / 24);
      default:
        return x00;
    }
  }
}
