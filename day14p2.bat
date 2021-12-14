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

var instructions = input.match(/[A-Z]{2} -> [A-Z]/gi);

print("instructions: " + instructions.length);

var table = [[], []];
for (var i = 0; i < instructions.length; ++i) {
  var instruction = instructions[i].match(/([A-Z]{2}) -> ([A-Z])/i);
  table[0].push(instruction[1]);
  table[1].push(instruction[2]);
}

var inc_map = function(map, key, value) {
  var index = index_of(map[0], key);
  if (index != -1) {
    map[1][index] += value;
  } else {
    map[0].push(key);
    map[1].push(value);
  }
}

var dec_map = function(map, key, value) {
  var index = index_of(map[0], key);
  if (index != -1) {
    map[1][index] -= value;
  } else {
    fatal("key not found");
  }
}

var clone_map = function(map) {
  var result = [[], []];
  for (var j = 0; j < 2; ++j) {
    for (var i = 0; i < map[j].length; ++i) {
      result[j].push(map[j][i]);
    }
  }
  return result;
}

var pairs = [[], []];

for (var i = 0; i + 1 < polymer.length; ++i) {
  var pair = polymer.charAt(i) + polymer.charAt(i + 1);
  inc_map(pairs, pair, 1);
}

print("pairs: " + pairs[0].length);

for (var step = 0; step < 40; ++step) {
  var new_pairs = clone_map(pairs);
  for (var i = 0; i < pairs[0].length; ++i) {
    var pair = pairs[0][i];
    var pair_count = pairs[1][i];
    var index = index_of(table[0], pair);
    if (index != -1) {
      var newc = table[1][index];
      var old1 = pair.charAt(0);
      var old2 = pair.charAt(1);

      // dec_map(counts, old1, pair_count);
      // dec_map(counts, old2, pair_count);
      inc_map(counts, newc, pair_count);
      // var count_index = index_of(counts[0], newc);
      // if (count_index != -1) {
      //   counts[1][count_index] += pair_count;
      // } else {
      //   counts[0].push(newc);
      //   counts[1].push(pair_count);
      // }

      var new1 = old1 + newc;
      var new2 = newc + old2;
      print(pair + " + " + newc + " -- " + new1 + " + " + new2 + " (" + pair_count + "x)");
      inc_map(new_pairs, new1, pair_count);
      inc_map(new_pairs, new2, pair_count);
      dec_map(new_pairs, pair, pair_count);
    }
  }
  print(counts[1].join(", "));
  pairs = new_pairs;
}

if (counts[0].length != counts[1].length) fatal("bad lengths");

counts[1].sort(function(a, b) { return a - b; });

print(counts[1].join(", "));

print("result: " + (counts[1][counts[1].length-1] - counts[1][0]));

