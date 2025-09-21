import 'dart:math';

class MathFunction {
  // Konversi sudut
  double deg(double x) => x * 180.0 / pi;
  double rad(double x) => x * pi / 180.0;

  // Modulus
  double mod(double x, double y) => x - y * (x / y).floor();

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
        ? (xDec * A + 0.5).floor() / A
        : -(xDec.abs() * A + 0.5).floor() / A;
    return H.toString();
  }

  // Format jam HH:MM:SS
  String dhhms(
    double dHrs, {
    String optResult = "HH:MM:SS",
    int secDecPlaces = 2,
    String posNegSign = "",
  }) {
    final uDHrs = dHrs.abs();
    double uHrs = uDHrs.floorToDouble();
    final uDMin = (uDHrs - uHrs) * 60.0;
    double uMin = uDMin.floorToDouble();
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
    final uDHrs = dHrs.abs();
    double uHrs = uDHrs.floorToDouble();
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
  String dddms(double dDeg, {String optResult = "DDMMSS", int sdp = 2}) {
    final uDDeg = dDeg.abs();
    double uDeg = uDDeg.floorToDouble();
    final uDMin = (uDDeg - uDeg) * 60.0;
    double uMin = uDMin.floorToDouble();
    final uDSec = (uDMin - uMin) * 60.0;
    String uSec = uDSec.toStringAsFixed(sdp);

    // Koreksi jika detik = 60
    if (double.parse(uSec) == 60.0) {
      uSec = 0.0.toStringAsFixed(sdp);
      uMin = uMin + 1.0;
    }

    // Koreksi jika menit = 60
    if (uMin == 60.0) {
      uMin = 0.0;
      uDeg = uDeg + 1.0;
    }

    // Format derajat
    final sDeg = (uDeg.toInt() < 10)
        ? "00${uDeg.toInt()}"
        : (uDeg.toInt() < 100)
        ? "0${uDeg.toInt()}"
        : "${uDeg.toInt()}";

    // Format menit
    final sMin = (uMin.toInt() < 10) ? "0${uMin.toInt()}" : "${uMin.toInt()}";

    // Format detik
    final sSec = (double.parse(uSec) < 10.0) ? "0$uSec" : uSec;

    // Penanda positif/negatif
    final pns = (dDeg > 0.0)
        ? "+"
        : (dDeg < 0.0)
        ? "-"
        : "";

    // Label BT/BB dan LU/LS
    final bbbt = (dDeg > 0.0) ? "BT" : "BB";
    final luls = (dDeg > 0.0) ? "LU" : "LS";

    // Output sesuai opsi
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
  String dddms2(double dDeg, {String optResult = "DDMMSS", int sdp = 2}) {
    final uDDeg = dDeg.abs();

    // Derajat, menit, detik
    double uDeg = uDDeg.floorToDouble();
    double uDMin = (uDDeg - uDeg) * 60.0;
    double uMin = uDMin.floorToDouble();
    double uDSec = (uDMin - uMin) * 60.0;
    double uSec = double.parse(uDSec.toStringAsFixed(sdp));

    // Koreksi jika detik = 60
    if (uSec == 60.0) {
      uSec = 0.0;
      uMin += 1.0;
    }

    // Koreksi jika menit = 60
    if (uMin == 60.0) {
      uMin = 0.0;
      uDeg += 1.0;
    }

    // String format dengan leading zero
    final sDeg = (uDeg.toInt() < 10)
        ? "00${uDeg.toInt()}"
        : (uDeg.toInt() < 100)
        ? "0${uDeg.toInt()}"
        : "${uDeg.toInt()}";

    final sMin = (uMin.toInt() < 10) ? "0${uMin.toInt()}" : "${uMin.toInt()}";

    final sSec = (uSec < 10.0)
        ? "0${uSec.toStringAsFixed(sdp)}"
        : uSec.toStringAsFixed(sdp);

    // Penanda positif/negatif
    final pns = (dDeg > 0.0)
        ? "+"
        : (dDeg < 0.0)
        ? "-"
        : "";

    // Label BT/BB dan LU/LS
    final bbbt = (dDeg > 0.0) ? "BT" : "BB";
    final luls = (dDeg > 0.0) ? "LU" : "LS";

    // Output sesuai opsi
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
