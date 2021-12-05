@if (@a==@b) @end /*
@echo off
SetLocal EnableDelayedExpansion

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" %*') do call %%A

goto :eof
*/

var system = function(str) { WSH.Echo(str); }
var print = function(str) {
  s = "" + str;
  if (s != "") system("echo " + s);
}

var argc = WSH.Arguments.Length;
var argv = function(ind) { return WSH.Arguments(ind); }

if (argc < 1) {
  print("Expected session id (day#.bat [session-id])");
  WSH.Quit();
}

var xhr = new ActiveXObject("WinHTTP.WinHTTPRequest.5.1");
xhr.open("GET", "https://adventofcode.com/2021/day/5/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.split("\n");

if (lines == null) {
  print("bad lines");
  WSH.Quit();
}

var xmax = 0;
var ymax = 0;

var vents = [];

for (var i = 0; i < lines.length; ++i) {
  var line = lines[i].match(/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)/);
  if (line != null) {
    var x1 = parseInt(line[1]);
    var y1 = parseInt(line[2]);
    var x2 = parseInt(line[3]);
    var y2 = parseInt(line[4]);
    print(x1 + "," + y1 + " - " + x2 + "," + y2);
    vents.push({x1: x1, y1: y1, x2: x2, y2: y2});
    if (x1 > xmax) xmax = x1;
    if (y1 > ymax) ymax = y1;
    if (x2 > xmax) xmax = x2;
    if (y2 > ymax) ymax = y2;
  }
}

var matrix = [];
matrix.length = ymax * xmax;
for (var y = 0; y < ymax; ++y) {
  for (var x = 0; x < xmax; ++x) {
    matrix[(y * xmax) + x] = 0;
  }
}

print(matrix.length);

for (var i = 0; i < vents.length; ++i) {
  var vent = vents[i];
  if (vent.x1 == vent.x2) {
    for (var y = Math.min(vent.y1, vent.y2);
         y <= Math.max(vent.y1, vent.y2);
         ++y) {
      matrix[(y * xmax) + vent.x1] += 1;
    }
  } else if (vent.y1 == vent.y2) {
    for (var x = Math.min(vent.x1, vent.x2);
         x <= Math.max(vent.x1, vent.x2);
         ++x) {
      matrix[(vent.y1 * xmax) + x] += 1;
    }
  } else {
    if ((vent.x1 > vent.x2 && vent.y1 < vent.y2) ||
        (vent.x1 < vent.x2 && vent.y1 > vent.y2)) {
      // positive slope
      var range = Math.max(vent.x1, vent.x2) - Math.min(vent.x1, vent.x2);
      print("range1: " + range);
      for (var j = 0; j <= range; ++j) {
        var x = Math.min(vent.x1, vent.x2) + j;
        var y = Math.max(vent.y1, vent.y2) - j;
        matrix[(y * xmax) + x] += 1;
      }
    } else {
      // negative slope
      var range = Math.max(vent.x1, vent.x2) - Math.min(vent.x1, vent.x2);
      print("range2: " + range);
      for (var j = 0; j <= range; ++j) {
        var x = Math.min(vent.x1, vent.x2) + j;
        var y = Math.min(vent.y1, vent.y2) + j;
        matrix[(y * xmax) + x] += 1;
      }
    }
  }
}

var dangercount = 0;
for (var y = 0; y < ymax; ++y) {
  for (var x = 0; x < xmax; ++x) {
    if (matrix[(y * xmax) + x] > 1) ++dangercount;
  }
}

print("danger count: " + dangercount);
