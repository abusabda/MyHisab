import 'package:myhisab/core/math_utils.dart';
import 'package:myhisab/core/julian_day.dart';
import 'package:myhisab/core/dynamical_time.dart';
import 'package:myhisab/core/sun_function.dart';

final julianDay = JulianDay();
final dynamicalTime = DynamicalTime();
final sunData = SunFunction();

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

  print("Julian Day                         = $jd");
  print("Delta T                            = ${dt.toStringAsFixed(14)}");

  print(
    "Sun True Geocentric Longitude      = ${mf.dddms(sunData.sunGeocentricLongitude(jd, dt, "True"))}",
  );
  print(
    "Sun Apparent Geocentric Longitude  = ${mf.dddms(sunData.sunGeocentricLongitude(jd, dt, "Appa"))}",
  );
  print(
    "Sun Geocentric Latitude            = ${mf.dddms(sunData.sunGeocentricLatitude(jd, dt))}",
  );
  print(
    "Sun Geocentric Right Ascension     = ${mf.dddms(sunData.sunGeocentricRightAscension(jd, dt))}",
  );
  print(
    "Sun Geocentric Declination         = ${mf.dddms(sunData.sunGeocentricDeclination(jd, dt))}",
  );
  print(
    "Sun Geocentric Azimuth             = ${mf.dddms(sunData.sunGeocentricAzimuth(jd, dt, gLon, gLat))}",
  );
  print(
    "Sun Geocentric Altitude            = ${mf.dddms(sunData.sunGeocentricAltitude(jd, dt, gLon, gLat))}",
  );

  print(
    "Sun Geocentric Semidiamater        = ${mf.dddms(sunData.sunGeocentricSemidiameter(jd, dt))}",
  );

  print(
    "Sun Geocentris Horizontal Parallax = ${mf.dddms(sunData.sunEquatorialHorizontalParallax(jd, dt))}",
  );

  print(
    "Sun Abberation                     = ${mf.dddms(sunData.sunAberration(jd, dt) / 3600, optResult: "SS")}",
  );

  print(
    "Sun Topocentric ecliptic Longitude = ${mf.dddms(sunData.sunTopocentricLongitude(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Sun Topocentric ecliptic Latitude  = ${mf.dddms(sunData.sunTopocentricLatitude(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Sun Topocentric Right Ascension    = ${mf.dddms(sunData.sunTopocentricRightAscension(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Sun Topocentric Declination        = ${mf.dddms(sunData.sunTopocentricDeclination(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Sun Topocentric Azimuth            = ${mf.dddms(sunData.sunTopocentricAzimuth(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Sun Airless Topocentric Altitude   = ${mf.dddms(sunData.sunTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "ht"))}",
  );

  print(
    "Sun Apparent Topocentric Altitude  = ${mf.dddms(sunData.sunTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "hta"))}",
  );

  print(
    "Sun Observered Topo Altitude       = ${mf.dddms(sunData.sunTopocentricAltitude(jd, dt, gLon, gLat, elev, pres, temp, "hto"))}",
  );

  print(
    "Sun Topocentric Semidiameter       = ${mf.dddms(sunData.sunTopocentricSemidiameter(jd, dt, gLon, gLat, elev))}",
  );

  print(
    "Equation of Time                   = ${mf.dhhms(sunData.equationOfTime(jd, dt))}",
  );
}
