@if (@a==@b) @end /*
@echo off
SetLocal EnableDelayedExpansion

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" %*') do call %%A

goto :eof
*/

var system = function(str) { WSH.Echo(str); }
var print = function(str) {
  s = "" + str;
  if (s != "") WScript.StdOut.WriteLine("echo " + s);
}

var argc = WSH.Arguments.Length;
var argv = function(ind) { return WSH.Arguments(ind); }

if (argc < 1) {
  print("Expected session id (day#.bat [session-id])");
  WSH.Quit();
}

var xhr = new ActiveXObject("WinHTTP.WinHTTPRequest.5.1");
xhr.open("GET", "https://adventofcode.com/2021/day/9/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.match(/[0-9]+/gi);

for (var i = 0; i < lines.length; ++i) {
  print("line: " + lines[i]);
}

if (lines == null) {
  print("bad lines");
  WSH.Quit();
}

var ymax = lines.length;
var xmax = lines[0].length;

var values = [];
values.length = ymax * xmax;

var set_value = function(x, y, v) {
  values[(y*xmax)+x] = v;
}

var get_value = function(x, y, def) {
  if (x < 0 || x >= xmax || y < 0 || y >= ymax) return def;
  var v = values[(y*xmax)+x];
  if (v == null) return def;
  return v;
}

for (var y = 0; y < lines.length; ++y) {
  var line = lines[y];
  for (var x = 0; x < line.length; ++x) {
    var v = parseInt(line.charAt(x));
    if (!(v >= 0 && v <= 9)) {
      print("bad value");
      WSH.Quit();
    }
    set_value(x, y, v);
  }
}

var basins = [];

var to_fill = [];

var flood_basin = function(x, y) {
  var v = get_value(x, y, 9);
  if (v >= 9) return null;
  to_fill.push([x, y]);
  var result = 0;
  while (to_fill.length > 0) {
    var loc = to_fill.pop();
    if (get_value(loc[0], loc[1], 9) >= 9) continue;
    ++result;
    set_value(loc[0], loc[1], null);
    if (get_value(loc[0]-1, loc[1], 9) < 9) to_fill.push([loc[0]-1, loc[1]]);
    if (get_value(loc[0]+1, loc[1], 9) < 9) to_fill.push([loc[0]+1, loc[1]]);
    if (get_value(loc[0], loc[1]-1, 9) < 9) to_fill.push([loc[0], loc[1]-1]);
    if (get_value(loc[0], loc[1]+1, 9) < 9) to_fill.push([loc[0], loc[1]+1]);
  }
  return result;
}

for (var y = 0; y < ymax; ++y) {
  for (var x = 0; x < xmax; ++x) {
    var basin = flood_basin(x, y);
    if (basin != null) basins.push(basin);
  }
}

basins.sort(function(a, b) { return a - b; });

print("basins: " + basins.join(", "));

print("result: " + (basins.pop() * basins.pop() * basins.pop()));