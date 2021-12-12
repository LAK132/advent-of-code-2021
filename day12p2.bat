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
xhr.open("GET", "https://adventofcode.com/2021/day/12/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.match(/[a-z]+-[a-z]+/gi);

if (lines == null) fatal("bad lines");

var connections = {
  start: []
};

var index_of = function(arr, v) {
  for (var i = 0; i < arr.length; ++i) {
    if (arr[i] == v) return i;
  }
  return -1;
}

var maybe_push = function(arr, v) {
  if (index_of(arr, v) == -1) { arr.push(v); return true; }
  else return false;
}

for (var i = 0; i < lines.length; ++i) {
  var line = lines[i].match(/([a-z]+)-([a-z]+)/i);
  if (line == null || line.length != 3) fatal("bad line");

  if (line[1] != "end" && line[2] != "start") {
    if (connections[line[1]] == undefined) {
      connections[line[1]] = [line[2]];
    } else {
      maybe_push(connections[line[1]], line[2]);
    }
  }
  if (line[2] != "end" && line[1] != "start") {
    if (connections[line[2]] == undefined) {
      connections[line[2]] = [line[1]];
    } else {
      maybe_push(connections[line[2]], line[1]);
    }
  }
}

for (var src in connections) {
  var dst = connections[src];
  for (var i = 0; i < dst.length; ++i) {
    print(src + " - " + dst[i]);
  }
}

var paths = 0;
var been = ["start"];

var first_dupe_small = null;
var start_after = null;

while (been.length > 0) {
  var next_set = connections[been[been.length-1]];
  var could_move = false;
  for (var i = index_of(next_set, start_after) + 1; i < next_set.length; ++i) {
    var next = next_set[i];
    if (next == "end") {
      ++paths;
      // print(been.join(", ") + ", end " + paths);
    } else if (next == "start") {
      // skip starts
    } else if (next.match(/[a-z]+/g) != null) {
      // little cave
      if (maybe_push(been, next)) {
        // haven't been here before
        could_move = true;
        break;
      } else if (first_dupe_small == null) {
        been.push(next);
        first_dupe_small = next;
        could_move = true;
        break;
      } else {
        // print(been.join(", ") + ", " + next + " (failed) " + first_dupe_small);
      }
    } else {
      // big cave
      been.push(next);
      could_move = true;
      break;
    }
  }

  // print(been.join(", "));

  if (!could_move) {
    start_after = been.pop();
    if (start_after == first_dupe_small) first_dupe_small = null;
  } else {
    start_after = null;
  }
}

print("result: " + paths);
