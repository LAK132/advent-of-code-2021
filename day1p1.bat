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
  print("Expected session id (day1.bat [session-id])");
  WSH.Quit();
}

var xhr = new ActiveXObject("WinHTTP.WinHTTPRequest.5.1");
xhr.open("GET", "https://adventofcode.com/2021/day/1/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");

var count = 0;
var prev = NaN;
var lines = xhr.responseText.match(/[0-9]+/gi);
if (lines != null) {
  for (var i = 0; i < lines.length; i++) {
    var num = +lines[i];
    print("reading: " + num);
    if (num > prev) {
      count = count + 1;
    }
    prev = num;
  }
}

print("result: " + count);
