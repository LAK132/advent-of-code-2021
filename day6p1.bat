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
xhr.open("GET", "https://adventofcode.com/2021/day/6/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var fish = input.match(/[0-9]/gi);
if (fish == null) {
  print("bad fish");
  WSH.Quit();
}

for (var i = 0; i < fish.length; ++i) {
  fish[i] = parseInt(fish[i]);
}

print("fish count: " + fish.length);

for (var day = 0; day < 80; ++day) {
  var len = fish.length;
  for (var i = 0; i < len; ++i) {
    if (fish[i] == 0) {
      fish[i] = 6;
      fish.push(8);
    } else {
      --fish[i];
    }
  }
}

print("fish count: " + fish.length);
