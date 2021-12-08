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
xhr.open("GET", "https://adventofcode.com/2021/day/8/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.match(/(?:[a-g]+ ){10}\|(?: [a-g]+){4}/gi);

if (lines == null) {
  print("bad lines");
  WSH.Quit();
}

var num_count = [];
for (var i = 0; i < 10; ++i) {
  num_count.push(0);
}

for (var i = 0; i < lines.length; ++i) {
  var readings = lines[i].match(/[a-g]+/gi);
  if (readings == null) {
    print("bad readings");
    WSH.Quit();
  }
  if (readings.length != 14) {
    print("bad readings length");
    WSH.Quit();
  }
  for (var j = 10; j < readings.length; ++j) {
    var reading = readings[j];
    switch (reading.length) {
      case 2: // 1
        ++num_count[1];
        break;

      case 3: // 7
        ++num_count[7];
        break;

      case 4: // 4
        ++num_count[4];
        break;

      case 7: // 8
        ++num_count[8];
        break;

      default: break;
    }
  }
}

for (var i = 0; i < num_count.length; ++i) {
  print(i + " count: " + num_count[i]);
}

var sum = function(arr) {
  var result = 0;
  for (var i = 0; i < arr.length; ++i) result += arr[i];
  return result;
}

print("result: " + sum(num_count));