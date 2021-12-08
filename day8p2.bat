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

var equivalent = function(str1, str2) {
  if (str1.length != str2.length) return false;
  for (var i = 0; i < str1.length; ++i) {
    if (str2.indexOf(str1.charAt(i)) == -1) return false;
  }
  return true;
}

// str1 - str2
var difference = function(str1, str2) {
  var result = "";
  for (var i = 0; i < str1.length; ++i) {
    if (str2.indexOf(str1.charAt(i)) == -1) result += str1.charAt(i);
  }
  return result;
}

var result = 0;
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

  var values = [
    null, // 0
    null, // 1
    null, // 2
    null, // 3
    null, // 4
    null, // 5
    null, // 6
    null, // 7
    null, // 8
    null  // 9
  ]

  var others = [];
  for (var j = 0; j < 10; ++j) {
    var reading = readings[j];
    switch (reading.length) {
      case 2:
        values[1] = reading;
        break;

      case 4:
        values[4] = reading;
        break;

      case 3:
        values[7] = reading;
        break;

      case 7:
        values[8] = reading;
        break;

      default:
        others.push(reading);
        break;
    }
  }

  // difference(0, 1).length = 4
  // difference(2, 1).length = 4
  // difference(3, 1).length = 3
  // difference(5, 1).length = 4
  // difference(6, 1).length = 5
  // difference(9, 1).length = 4

  var others2 = [];
  for (var j = 0; j < others.length; ++j) {
    var reading = others[j];
    switch (difference(reading, values[1]).length) {
      case 3:
        values[3] = reading;
        break;

      case 5:
        values[6] = reading;
        break;

      case 4:
        others2.push(reading);
        break;

      default:
        print("aaaaaaaaaaaaa");
        WSH.Quit();
    }
  }
  others = others2;

  // difference(0, 3).length = 2
  // difference(2, 3).length = 1
  // difference(5, 3).length = 1
  // difference(9, 3).length = 1

  // difference(0, 4).length = 3
  // difference(2, 4).length = 3
  // difference(5, 4).length = 2
  // difference(9, 4).length = 2

  // difference(0, 6).length = 1
  // difference(2, 6).length = 1
  // difference(5, 6).length = 0
  // difference(9, 6).length = 1

  var others2 = [];
  for (var j = 0; j < others.length; ++j) {
    var reading = others[j];
    switch (difference(reading, values[4]).length) {
      case 3:
        switch (difference(reading, values[3]).length) {
          case 2:
            values[0] = reading;
            break;

          case 1:
            values[2] = reading;
            break;

          default:
            print("aaaaaaaaaaaaa2");
            WSH.Quit();
        }
        break;

      case 2:
        switch (difference(reading, values[6]).length) {
          case 0:
            values[5] = reading;
            break;

          case 1:
            values[9] = reading;
            break;

          default:
            print("aaaaaaaaaaaaa3");
            WSH.Quit();
        }
        break;

      default:
        print("aaaaaaaaaaaaa4");
        WSH.Quit();
    }
  }

  var readingstr = "";
  for (var j = 10; j < readings.length; ++j) {
    var reading = readings[j];
    for (var k = 0; k < values.length; ++k) {
      if (!(k == 0 && readingstr == "") &&
          equivalent(reading, values[k])) {
        readingstr += k;
        break;
      }
    }
  }
  print("line: " + readingstr + " " + parseInt(readingstr));
  result += parseInt(readingstr);
}

print("result: " + result);
