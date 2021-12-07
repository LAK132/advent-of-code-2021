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
xhr.open("GET", "https://adventofcode.com/2021/day/7/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var crabs = input.match(/[0-9]+/gi);
if (crabs == null) {
  print("bad crabs");
  WSH.Quit();
}

var min = NaN;
var max = NaN;
for (var i = 0; i < crabs.length; ++i) {
  crabs[i] = parseInt(crabs[i]);
  print("crab: " + crabs[i]);
  if (!(min < crabs[i])) min = crabs[i];
  if (!(max > crabs[i])) max = crabs[i];
}
print("min: " + min);
print("max: " + max);

var count_moves = function(crabs, pos) {
  var total = 0;
  for (var i = 0; i < crabs.length; ++i) {
    var diff;
    if (pos > crabs[i]) {
      diff = pos - crabs[i];
    } else {
      diff = crabs[i] - pos;
    }
    diff = ((diff * (diff - 1)) / 2) + diff;
    total += diff;
  }
  return total;
}

var pos = NaN;
var moves = NaN;
for (var i = min; i <= max; ++i) {
  var m = count_moves(crabs, i);
  if (!(m > moves)) {
    pos = i;
    moves = m;
  }
}

print("pos: " + pos);
print("moves: " + moves);