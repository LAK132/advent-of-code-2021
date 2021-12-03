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
xhr.open("GET", "https://adventofcode.com/2021/day/3/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var commonbits = [];

var lines = input.match(/[01]+/gi);
if (lines != null) {
  if (lines.length == 0) {
    print("no lines");
    WSH.Quit();
  }

  commonbits.length = lines[0].length;
  for (var i = 0; i < commonbits.length; ++i) commonbits[i] = [0, 0];

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    print("line: " + line);
    for (var j = 0; j < line.length; ++j) {
      switch(line.charAt(j)) {
        case "0":
          ++commonbits[j][0];
          break;

        case "1":
          ++commonbits[j][1];
          break;

        default:
          print("invalid character: '" + line.charAt(j) + "'");
          WSH.Quit();
      }
    }
  }
} else {
  print("error on input.match");
  WSH.Quit();
}

var gamma = 0;
var epsilon = 0;
for (var i = 0; i < commonbits.length; ++i) {
  var j = commonbits.length - (i + 1);
  if (commonbits[i][0] > commonbits[i][1]) {
    epsilon = epsilon + (1 << j);
  } else if (commonbits[i][0] < commonbits[i][1]) {
    gamma = gamma + (1 << j);
  } else {
    print("values at " + i + " are equally common");
    WSH.Quit();
  }
}

print("commonbits: " + commonbits);
print("gamma: " + gamma);
print("epsilon: " + epsilon);
print("result: " + (gamma * epsilon));
