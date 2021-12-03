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

var filter = function(strs, index) {
  var result = [[], []];
  for (var i = 0; i < strs.length; ++i) {
    if (index >= strs[i].length) {
      print("index (" + index + ") out of bounds (" + strs[i].length + ")");
      WSH.Quit();
    }
    switch (strs[i].charAt(index)) {
      case "0":
        result[0].push(strs[i]);
        break;

      case "1":
        result[1].push(strs[i]);
        break;

      default:
        print("invalid character: '" + strs[i].charAt(index) + "'");
        WSH.Quit();
    }
  }
  return result;
};

var max_filter = function(strs, index) {
  var result = filter(strs, index);
  if (result[0].length > result[1].length) return result[0];
  if (result[0].length < result[1].length) return result[1];
  return result[1];
}

var min_filter = function(strs, index) {
  var result = filter(strs, index);
  if (result[0].length < result[1].length) return result[0];
  if (result[0].length > result[1].length) return result[1];
  return result[0];
}

var lines = input.match(/[01]+/gi);

if (lines != null) {
  if (lines.length == 0) {
    print("no lines");
    WSH.Quit();
  }

  print("filtering");
  var filtered_lines = filter(lines, 0);
  var oxygen_lines;
  var scrubber_lines;
  if (filtered_lines[0].length > filtered_lines[1].length) {
    oxygen_lines = filtered_lines[0];
    scrubber_lines = filtered_lines[1];
  } else if (filtered_lines[0].length < filtered_lines[1].length) {
    oxygen_lines = filtered_lines[1];
    scrubber_lines = filtered_lines[0];
  } else {
    print("values at 0 are equally common");
  }

  for (var i = 1; oxygen_lines.length > 1; ++i) {
    print("oxy lines: " + oxygen_lines);
    oxygen_lines = max_filter(oxygen_lines, i);
  }
  print("oxy lines: " + oxygen_lines);

  for (var i = 1; scrubber_lines.length > 1; ++i) {
    print("scrub lines: " + scrubber_lines);
    scrubber_lines = min_filter(scrubber_lines, i);
  }
  print("scrub lines: " + scrubber_lines);

  var oxygen = parseInt(oxygen_lines[0], 2);
  var scrubber = parseInt(scrubber_lines[0], 2);
  print("oxygen: " + oxygen);
  print("scrubber: " + scrubber);
  print("result: " + (oxygen * scrubber));

} else {
  print("error on input.match");
  WSH.Quit();
}
