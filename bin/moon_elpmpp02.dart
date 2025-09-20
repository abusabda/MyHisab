import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/moon_function.dart';
import 'package:myhisab/core/moon_distance.dart';
import 'package:myhisab/core/moon_longitude.dart';
import 'package:myhisab/core/moon_latitude.dart';

final julianDay = JulianDay();
final dynamicalTime = DynamicalTime();
final moonLon = MoonLongitude();
final moonLat = MoonLatitude();
final moonDis = MoonDistance();
final moonData = MoonFunction();

void main() {
  int tglM = 20;
  int blnM = 4;
  int thnM = 2023;
  int jam = 17;
  int menit = 51;
  int detik = 27;
  double jamDes = jam + (menit / 60) + (detik / 3600);
  double gLon = (106 + 33 / 60.0 + 27.8 / 3600.0);
  double gLat = -(7 + 1 / 60.0 + 44.6 / 3600.0);
  double tmzn = 7.0;
  double elev = 52.685;
  double temp = 10.0;
  double pres = 1010.0;

  double jd = julianDay.kmjd(tglM, blnM, thnM, jamDes, tmzn);
  double dt = dynamicalTime.deltaT(jd);

  final mf = MathFunction();

  print("Julian Day                                       = $jd");
  print(
    "Delta T                                          = ${dt.toStringAsFixed(14)}",
  );

  print(
    "Moon True Geocentric Longitude                   = ${mf.dddms(moonLon.moonGeocentricLongitude(jd, dt, "True"))}",
  );
  print(
    "Moon Apparent Geocentric Longitude               = ${mf.dddms(moonLon.moonGeocentricLongitude(jd, dt, "Appa"))}",
  );
  print(
    "Moon Geocentric Latitude                         = ${mf.dddms(moonLat.moonGeocentricLatitude(jd, dt))}",
  );

  print(
    "Moon Geocentric Right Ascension                  = ${mf.dddms(moonData.moonGeocentricRightAscension(jd, dt))}",
  );
  print(
    "Moon Geocentric Declination                      = ${mf.dddms(moonData.moonGeocentricDeclination(jd, dt))}",
  );
  print(
    "Moon Geocentric Azimuth                          = ${mf.dddms(moonData.moonGeocentricAzimuth(jd, dt, gLon, gLat))}",
  );
  print(
    "Moon Geocentric Altitude                         = ${mf.dddms(moonData.moonGeocentricAltitude(jd, dt, gLon, gLat))}",
  );

  print(
    "Moon Geocentric Distance (KM)                    = ${moonDis.moonGeocentricDistance(jd, dt, "KM").toStringAsFixed(11)}",
  );
  print(
    "Moon Geocentric Distance (AU)                    = ${moonDis.moonGeocentricDistance(jd, dt, "AU").toStringAsFixed(11)}",
  );
  print(
    "Moon Geocentric Distance (ER)                    = ${moonDis.moonGeocentricDistance(jd, dt, "ER").toStringAsFixed(11)}",
  );
  print(
    "Moon Geocentric Equatorial Horizontal Parallax   = ${mf.dddms(moonData.moonEquatorialHorizontalParallax(jd, dt))}",
  );

  print(
    "Moon Geocentric Semidiameter                     = ${mf.dddms(moonData.moonGeocentricSemidiameter(jd, dt))}",
  );
  print(
    "Moon Geocentric Elongation                       = ${mf.dddms(moonData.moonSunGeocentricElongation(jd, dt))}",
  );

  print(
    "Moon Geocentric Phase Angle                      = ${mf.dddms(moonData.moonGeocentricPhaseAngle(jd, dt))}",
  );

  print(
    "Moon Geocentric Disk Illuminated fraction        = ${moonData.moonGeocentricDiskIlluminatedFraction(jd, dt).toStringAsFixed(11)}",
  );

  print(
    "Moon Geocentric Bright Limb Angle                = ${mf.dddms(moonData.moonGeocentricBrightLimbAngle(jd, dt))}",
  );

  print(
    "Moon Topocentric Ecliptic Longitude              = ${mf.dddms(moonData.moonTopocentricLongitude(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Ecliptic Latitude               = ${mf.dddms(moonData.moonTopocentricLatitude(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Right Ascension                 = ${mf.dddms(moonData.moonTopocentricRightAscension(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Declination                     = ${mf.dddms(moonData.moonTopocentricDeclination(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Local Hour Angel                = ${mf.dhhms(moonData.moonTopocentricLocalHourAngel(jd, dt, gLon, gLat, elev) / 15, optResult: "HHMMSS", secDecPlaces: 2, posNegSign: "")}",
  );

  print(
    "Moon Topocentric Semidiameter                    = ${mf.dddms(moonData.moonTopocentricSemidiameter(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Elongation                      = ${mf.dddms(moonData.moonSunTopocentricElongation(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Phase Angle                     = ${mf.dddms(moonData.moonTopocentricPhaseAngle(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Disk Illuminated fraction       = ${moonData.moonTopocentricDiskIlluminatedFraction(jd, dt, gLon, gLat, elev).toStringAsFixed(11)}",
  );

  print(
    "Moon Topocentric Bright Limb Angle               = ${mf.dddms(moonData.moonTopocentricBrightLimbAngle(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Topocentric Azimuth                         = ${mf.dddms(moonData.moonTopocentricAzimuth(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Moon Airless Topocentric Altitude (Center Limb)  = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htc"))}",
  );

  print(
    "Moon Apparent Topocentric Altitude (Center Limb) = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htac"))}",
  );

  print(
    "Moon Observed Topocentric Altitude (Center Limb) = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htoc"))}",
  );

  print(
    "Moon Airless Topocentric Altitude (Upper Limb)   = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htu"))}",
  );

  print(
    "Moon Apparent Topocentric Altitude (Upper Limb)  = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htau"))}",
  );

  print(
    "Moon Observed Topocentric Altitude (Upper Limb)  = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htou"))}",
  );

  print(
    "Moon Airless Topocentric Altitude (Lower Limb)   = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htl"))}",
  );

  print(
    "Moon Apparent Topocentric Altitude (Lower Limb)  = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htal"))}",
  );

  print(
    "Moon Observed Topocentric Altitude (Lower Limb)  = ${mf.dddms(moonData.moonTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "htol"))}",
  );
}
