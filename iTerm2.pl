#!/usr/bin/perl

# Cmd+i > Colours tab > Color Presets dropdown > Import/Export

sub get {
  my ($line, $x) = @_;
  if($line =~ /"$x" *: *([0-9.]+)\b/){
    return $1;
  }
  die "couldn't get /$x/ in '$_'";
}

while(<DATA>){
  my $line = $_;

  $r = get($line, 'Red Component');
  $g = get($line, 'Green Component');
  $b = get($line, 'Blue Component');

  $line =~ /^"([^"]+) Color"/ || die;
  $type = $1;

  $rgb = sprintf
    '%02x%02x%02x',
    $r * 256,
    $g * 256,
    $b * 256;

  print "$type: #$rgb\n";
}

__DATA__
"Ansi 0 Color": { "Blue Component": 0.25882354378700256 "Green Component": 0.21176470816135406 "Red Component": 0.027450980618596077 }
"Ansi 1 Color": { "Blue Component": 0.18431372940540314 "Green Component": 0.19607843458652496 "Red Component": 0.86274510622024536 }
"Ansi 10 Color": { "Blue Component": 0.014780973084270954 "Green Component": 0.7780609130859375 "Red Component": 0.32919603586196899 }
"Ansi 11 Color": { "Blue Component": 0.23348262906074524 "Green Component": 0.75838851928710938 "Red Component": 0.926971435546875 }
"Ansi 12 Color": { "Blue Component": 0.923553466796875 "Green Component": 0.61130446195602417 "Red Component": 0.16711920499801636 }
"Ansi 13 Color": { "Blue Component": 0.56491506099700928 "Green Component": 0.23465703427791595 "Red Component": 0.916900634765625 }
"Ansi 14 Color": { "Blue Component": 0.62907302379608154 "Green Component": 0.66632080078125 "Red Component": 0.17382282018661499 }
"Ansi 15 Color": { "Blue Component": 0.6380767822265625 "Green Component": 0.86889564990997314 "Red Component": 1 }
"Ansi 2 Color": { "Blue Component": 0.0 "Green Component": 0.60000002384185791 "Red Component": 0.5215686559677124 }
"Ansi 3 Color": { "Blue Component": 0.081758759915828705 "Green Component": 0.6745336651802063 "Red Component": 0.8649139404296875 }
"Ansi 4 Color": { "Blue Component": 0.7423095703125 "Green Component": 0.49133825302124023 "Red Component": 0.13432268798351288 }
"Ansi 5 Color": { "Blue Component": 0.50980395078659058 "Green Component": 0.21176470816135406 "Red Component": 0.82745099067687988 }
"Ansi 6 Color": { "Blue Component": 0.55283749103546143 "Green Component": 0.5855712890625 "Red Component": 0.15275771915912628 }
"Ansi 7 Color": { "Blue Component": 0.77772867679595947 "Green Component": 0.94955968856811523 "Red Component": 0.963592529296875 }
"Ansi 8 Color": { "Blue Component": 0.21176470816135406 "Green Component": 0.16862745583057404 "Red Component": 0.0 }
"Ansi 9 Color": { "Blue Component": 0.050668027251958847 "Green Component": 0.28547519445419312 "Red Component": 0.92779541015625 }
"Cursor Color": { "Blue Component": 0.94921875 "Green Component": 0.4543919563293457 "Red Component": 0.13129681348800659 }
"Cursor Text Color": { "Blue Component": 0.83529412746429443 "Green Component": 0.90980392694473267 "Red Component": 0.93333333730697632 }
"Foreground Color": { "Blue Component": 0.51372551918029785 "Green Component": 0.41211539506912231 "Red Component": 0.13268786668777466 }
"Selected Text Color": { "Blue Component": 0.45882353186607361 "Green Component": 0.43137255311012268 "Red Component": 0.34509804844856262 }
"Selection Color": { "Blue Component": 0.83529412746429443 "Green Component": 0.90980392694473267 "Red Component": 0.93333333730697632 }
"Background Color": { "Blue Component": 0.89019608497619629 "Green Component": 0.96470588445663452 "Red Component": 0.99215686321258545 }
"Badge Color": { "Blue Component": 0.0 "Green Component": 0.1491314172744751 "Red Component": 1 }
"Bold Color": { "Blue Component": 0.45882353186607361 "Green Component": 0.43137255311012268 "Red Component": 0.34509804844856262 }
"Cursor Guide Color": { "Blue Component": 1 "Green Component": 0.9268307089805603 "Red Component": 0.70213186740875244 }
"Link Color": { "Blue Component": 0.73423302173614502 "Green Component": 0.35916060209274292 "Red Component": 0.0 }
