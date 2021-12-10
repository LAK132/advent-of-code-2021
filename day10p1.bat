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
xhr.open("GET", "https://adventofcode.com/2021/day/10/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.match(/[\[\]\(\)\{\}<>]+/gi);

if (lines == null) {
  print("bad lines");
  WSH.Quit();
}

print("lines: " + lines.length);

var is_opening = function(c) {
  return c == "(" || c == "{" || c == "<" || c == "[";
};

var is_matching = function(open, close) {
  switch (open) {
    case "(": return close == ")";
    case "{": return close == "}";
    case "<": return close == ">";
    case "[": return close == "]";
    default:
      print("bad open: \"" + open + "\"");
      WSH.Quit();
  }
};

var result = 0;
for (var i = 0; i < lines.length; ++i) {
  var line = lines[i];
  print("line: \"" + line + "\"");

  var stack = [];
  for (var j = 0; j < line.length; ++j) {
    var c = line.charAt(j);
    if (is_opening(c)) {
      stack.push(c);
    } else if (stack.length > 0 && is_matching(stack[stack.length-1], c)) {
      stack.pop();
    } else {
      switch(c) {
        case ")":
          result += 3;
          break;
        case "}":
          result += 1197;
          break;
        case ">":
          result += 25137;
          break;
        case "]":
          result += 57;
          break;
        default:
          print("bad c");
          WSH.Quit();
      }
      break;
    }
  }
}

print("result: " + result);
