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
xhr.open("GET", "https://adventofcode.com/2021/day/2/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var horipos = 0;
var depth = 0;
var aim = 0;
var lines = input.match(/[a-z]+ +[0-9]+/gi);
if (lines != null) {
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].match(/([a-z]+) +([0-9]+)/i);
    if (line != null) {
      switch (line[1]) {
        case "forward":
          var forward = +line[2];
          print("forward " + forward);
          horipos = horipos + forward;
          depth = depth + (aim * forward);
          break;

        case "up":
          var up = +line[2];
          print("up " + up);
          aim = aim - up;
          break;

        case "down":
          var down = +line[2];
          print("down " + down);
          aim = aim + down;
          break;

        default:
          WSH.Quit();
      }
    } else {
      WSH.Quit();
    }
  }
} else {
  WSH.Quit();
}

print("horizontal: " + horipos);
print("depth: " + depth);
print("result: " + (horipos * depth));
