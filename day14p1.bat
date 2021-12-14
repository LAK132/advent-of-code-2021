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
var index_of = function(arr, v) {
  for (var i = 0; i < arr.length; ++i) if ((""+arr[i]) == (""+v)) return i;
  return -1;
}
var maybe_push = function(arr, v) {
  if (index_of(arr, v) == -1) { arr.push(v); return true; }
  else return false;
}
var repeat_string = function(str, count) {
  var result = "";
  for (var i = 0; i < count; ++i) result += str;
  return result;
}
var insert_at = function(str, index, replacement) {
  return str.substr(0, index) + replacement + str.substr(index);
}
var replace_at = function(str, index, replacement) {
  return
    str.substr(0, index)
    + replacement
    + str.substr(index + replacement.length);
}

var argc = WSH.Arguments.Length;
var argv = function(ind) { return WSH.Arguments(ind); }

if (argc < 1) {
  print("Expected session id (day#.bat [session-id])");
  WSH.Quit();
}

var xhr = new ActiveXObject("WinHTTP.WinHTTPRequest.5.1");
xhr.open("GET", "https://adventofcode.com/2021/day/14/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var polymer = input.match(/([A-Z]+)\n/i)[1];

print("polymer: " + polymer);

var instructions = input.match(/[A-Z]{2} -> [A-Z]/gi);

print("instructions: " + instructions.length);

var table = [[], []];
for (var i = 0; i < instructions.length; ++i) {
  var instruction = instructions[i].match(/([A-Z]{2}) -> ([A-Z])/i);
  table[0].push(instruction[1]);
  table[1].push(instruction[2]);
}


for (var step = 0; step < 10; ++step) {
  for (var i = 0; i + 1 < polymer.length; ++i) {
    var pair = polymer.charAt(i) + polymer.charAt(i + 1);
    var index = index_of(table[0], pair);
    if (index != -1) {
      polymer = insert_at(polymer, i + 1, table[1][index]);
      ++i;
    }
  }

  // print("polymer: " + polymer);
}

var counts = [[], []]
for (var i = 0; i < polymer.length; ++i) {
  var index = index_of(counts[0], polymer.charAt(i));
  if (index != -1) {
    ++counts[1][index];
  } else {
    counts[0].push(polymer.charAt(i));
    counts[1].push(1);
  }
}

if (counts[0].length != counts[1].length) fatal("bad lengths");

counts[1].sort(function(a, b) { return a - b; });

print(counts[1].join(", "));

print("result: " + (counts[1][counts[1].length-1] - counts[1][0]));
