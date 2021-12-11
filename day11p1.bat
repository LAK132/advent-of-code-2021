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
var fatal = function(str) {
  print("fatal: " + str);
  WSH.Quit();
}

var argc = WSH.Arguments.Length;
var argv = function(ind) { return WSH.Arguments(ind); }

if (argc < 1) {
  print("Expected session id (day#.bat [session-id])");
  WSH.Quit();
}

var xhr = new ActiveXObject("WinHTTP.WinHTTPRequest.5.1");
xhr.open("GET", "https://adventofcode.com/2021/day/11/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.match(/[0-9]+/gi);

if (lines == null) fatal("bad lines");

var ymax = lines.length;
var xmax = lines[0].length;

var octo = [];

var get_value = function(x, y) {
  return octo[(y * xmax) + x];
}

var set_value = function(x, y, v) {
  octo[(y * xmax) + x] = v;
}

for (var y = 0; y < ymax; ++y) {
  var str = "";
  for (var x = 0; x < xmax; ++x) {
    octo.push(parseInt(lines[y].charAt(x)));
    str += get_value(x, y) + " ";
  }
  print("line: " + str);
}

var step_flashes = function() {
  var flashes = 0;
  for (var y = 0; y < ymax; ++y) {
    for (var x = 0; x < xmax; ++x) {
      if (get_value(x, y) >= 9) {
        set_value(x, y, NaN);
        ++flashes;
        if (x > 0) {
          if (y > 0) set_value(x-1, y-1, get_value(x-1, y-1)+1); // (-1, -1)
          set_value(x-1, y, get_value(x-1, y)+1); // (-1, 0)
          if (y < ymax-1) set_value(x-1, y+1, get_value(x-1, y+1)+1); // (-1, +1)
        }
        if (y > 0) set_value(x, y-1, get_value(x, y-1)+1); // (0, -1)
        if (y < ymax-1) set_value(x, y+1, get_value(x, y+1)+1); // (0, +1)
        if (x < xmax-1) {
          if (y > 0) set_value(x+1, y-1, get_value(x+1, y-1)+1); // (+1, -1)
          set_value(x+1, y, get_value(x+1, y)+1); // (+1, 0)
          if (y < ymax-1) set_value(x+1, y+1, get_value(x+1, y+1)+1); // (+1, +1)
        }
      }
    }
  }
  return flashes;
}

var step_reset = function() {
  for (var y = 0; y < ymax; ++y) {
    for (var x = 0; x < xmax; ++x) {
      var v = get_value(x, y);
      ++v;
      if (!(v >= 0)) v = 0;
      set_value(x, y, v);
    }
  }
}

var flashes = 0;
for (var i = 0; i < 100; ++i) {
  for (var f = step_flashes(); f > 0; f = step_flashes()) flashes += f;
  step_reset();
}

print("flashes: " + flashes);
