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
xhr.open("GET", "https://adventofcode.com/2021/day/13/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var positions = input.match(/[0-9]+,[0-9]+/gi);

if (positions == null) fatal("bad positions");

for (var i = 0; i < positions.length; ++i) {
  var position = positions[i].match(/([0-9]+),([0-9]+)/i);

  if (position == null || position.length != 3) fatal("bad position");

  // print(position[0] + ": x: " + position[1] + ", y: " + position[2]);

  positions[i] = [parseInt(position[1]), parseInt(position[2])];
}

var instructions = input.match(/fold along [xy]=[0-9]+/gi);

if (instructions == null) fatal("bad instructions");

var index_of = function(arr, v) {
  for (var i = 0; i < arr.length; ++i) {
    if ((""+arr[i]) == (""+v)) return i;
    // print(arr[i] + " ^!= " + v);
  }
  return -1;
}

var maybe_push = function(arr, v) {
  if (index_of(arr, v) == -1) { arr.push(v); return true; }
  else return false;
}

print("initial positions: " + positions.length);

for (var i = 0; i < instructions.length; ++i) {
  var instruction = instructions[i].match(/fold along ([xy])=([0-9]+)/i);

  if (instruction == null || instruction.length != 3) fatal("bad instruction");

  var new_positions = [];

  var pos = parseInt(instruction[2]);

  if (instruction[1] == "x") {
    print("fold x " + pos);
    for (var j = 0; j < positions.length; ++j) {
      if (positions[j][0] > pos) {
        maybe_push(new_positions,
                   [pos - (positions[j][0] - pos), positions[j][1]]);
      } else {
        maybe_push(new_positions, positions[j]);
      }
    }
  } else if (instruction[1] == "y") {
    print("fold y " + pos);
    for (var j = 0; j < positions.length; ++j) {
      if (positions[j][1] > pos) {
        maybe_push(new_positions,
                   [positions[j][0], pos - (positions[j][1] - pos)]);
      } else {
        maybe_push(new_positions, positions[j]);
      }
    }
  } else fatal("bad fold axis: " + instruction[1]);

  positions = new_positions;

  break;
}

print("result: " + positions.length);
