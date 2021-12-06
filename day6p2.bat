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

var fishdays = [];
fishdays.length = 8;
for (var i = 0; i <= 8; ++i) {
  fishdays[i] = 0;
}

for (var i = 0; i < fish.length; ++i) {
  var day = parseInt(fish[i]);
  ++fishdays[day];
}

var count = function(fd) {
  var result = 0;
  var str = "";
  for (var i = 0; i <= 8; ++i) {
    result += fd[i];
    str += fd[i] + " ";
  }
  print(str);
  return result;
}

print("fish count: " + count(fishdays));

for (var day = 0; day < 256; ++day) {
  var dupe = fishdays[0];
  for (var i = 1; i <= 8; ++i) {
    fishdays[i - 1] = fishdays[i];
  }
  fishdays[6] += dupe;
  fishdays[8] = dupe;
  print("fish count " + day + ": " + count(fishdays));
}

print("fish count: " + count(fishdays));
