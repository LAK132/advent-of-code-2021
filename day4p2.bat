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
xhr.open("GET", "https://adventofcode.com/2021/day/4/input", false);
xhr.setRequestHeader("User-Agent", "XMLHTTP/1.0");
xhr.setRequestHeader("Cookie", "session=" + argv(0));
xhr.send("");
var input = xhr.responseText;

var lines = input.split("\n");

var numbers = lines[0].match(/[0-9]+/gi);

if (numbers == null) {
  print("bad numbers");
  WSH.Quit();
}

for (var i = 0; i < numbers.length; ++i) {
  numbers[i] = parseInt(numbers[i]);
}

var boards = [];
for (var i = 0; (i * 6) + 2 < lines.length; ++i) {
  var rows = []
  for (var j = 0; j < 5; ++j) {
    var row = lines[(i * 6) + j + 2].match(/[0-9]+/gi);
    if (row == null) {
      print("bad row");
      WSH.Quit();
    }
    if (row.length != 5) {
      print("bad row length");
      WSH.Quit();
    }
    for (var k = 0; k < row.length; ++k) {
      row[k] = {value: parseInt(row[k]), hit: false};
    }
    rows.push(row);
  }
  boards.push(rows);
}

var check_row = function(number, board, row) {
  var is_bingo = true;
  for (var i = 0; i < 5; ++i) {
    if (board[row][i].value == number) {
      board[row][i].hit = true;
    }
    if (!board[row][i].hit) is_bingo = false;
  }
  return is_bingo;
}

var check_col = function(number, board, col) {
  var is_bingo = true;
  for (var i = 0; i < 5; ++i) {
    if (board[i][col].value == number) {
      board[i][col].hit = true;
    }
    if (!board[i][col].hit) is_bingo = false;
  }
  return is_bingo;
}

var check_board = function(number, board) {
  for (var i = 0; i < 5; ++i) {
    if (check_row(number, board, i)) return true;
    if (check_col(number, board, i)) return true;
  }
  return false;
}

var sum_unmarked = function(board) {
  var sum = 0;
  for (var i = 0; i < 5; ++i) {
    for (var j = 0; j < 5; ++j) {
      if (!board[i][j].hit) sum += board[i][j].value;
    }
  }
  return sum;
}

for (var i = 0; i < numbers.length; ++i) {
  print("checking: " + numbers[i]);
  var not_won = [];
  for (var j = 0; j < boards.length; ++j) {
    if (!check_board(numbers[i], boards[j])) {
      not_won.push(boards[j]);
    }
  }
  if (not_won.length == 0) {
    if (boards.length != 1) {
      print("bad board numbers");
      WSH.Quit();
    }
    print("result: " + (numbers[i] * sum_unmarked(boards[0])));
    WSH.Quit();
  }
  boards = not_won;
}

print("uhmm");
