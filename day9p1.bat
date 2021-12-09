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

if (lines == null) {
  print("bad lines");
  WSH.Quit();
}

var risk = function(x, y) {
  return parseInt(lines[y].charAt(x)) + 1;
}

var is_risk = function(x, y) {
  var r = risk(x, y);
  if (x+1 < lines[y].length && risk(x+1, y) <= r) return null;
  if (x > 0 && risk(x-1, y) <= r) return null;
  if (y+1 < lines.length && risk(x, y+1) <= r) return null;
  if (y > 0 && risk(x, y-1) <= r) return null;
  return r;
}

var result = 0;
for (var y = 0; y < lines.length; ++y) {
  var line = lines[y];
  for (var x = 0; x < line.length; ++x) {
    var r = is_risk(x, y);
    if (r != null) result += r;
  }
}

print("result: " + result);
