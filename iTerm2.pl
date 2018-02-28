#!/usr/bin/perl

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
"Cursor Color" : { "Green Component" : 0.5096293, "Red Component" : 0.4405802, "Blue Component" : 0.516858 },
"Cursor Text Color" : { "Green Component" : 0.1557593, "Red Component" : 0, "Blue Component" : 0.1937014 },
"Foreground Color" : { "Green Component" : 0.5096293, "Red Component" : 0.4405802, "Blue Component" : 0.516858 },
"Selected Text Color" : { "Green Component" : 0.6197095, "Red Component" : 0.5515414, "Blue Component" : 0.6197095 },
"Selection Color" : { "Green Component" : 0.1557593, "Red Component" : 0, "Blue Component" : 0.1937014 },
"Ansi 0 Color" : { "Green Component" : 0.323596, "Red Component" : 0, "Blue Component" : 0.4033168 },
"Ansi 1 Color" : { "Green Component" : 0.1084066, "Red Component" : 0.8192698, "Blue Component" : 0.1414571 },
"Ansi 2 Color" : { "Green Component" : 0.5411549, "Red Component" : 0.4497745, "Blue Component" : 0.02020876 },
"Ansi 3 Color" : { "Green Component" : 0.4675142, "Red Component" : 0.6474648, "Blue Component" : 0.02348481 },
"Ansi 4 Color" : { "Green Component" : 0.4626595, "Red Component" : 0.1275488, "Blue Component" : 0.7823142 },
"Ansi 5 Color" : { "Green Component" : 0.1080246, "Red Component" : 0.7773894, "Blue Component" : 0.4351664 },
"Ansi 6 Color" : { "Green Component" : 0.5708236, "Red Component" : 0.1467953, "Blue Component" : 0.5250227 },
"Ansi 7 Color" : { "Green Component" : 0.8900124, "Red Component" : 0.9161106, "Blue Component" : 0.797811 },
"Ansi 8 Color" : { "Green Component" : 0, "Red Component" : 0, "Blue Component" : 0 },
"Ansi 9 Color" : { "Green Component" : 0.2379913, "Red Component" : 0.8140998, "Blue Component" : 0.08913947 },
"Ansi 10 Color" : { "Green Component" : 0.4503115, "Red Component" : 0.2100916, "Blue Component" : 0.1561944 },
"Ansi 11 Color" : { "Green Component" : 0.5571686, "Red Component" : 0.557677, "Blue Component" : 0.1535422 },
"Ansi 12 Color" : { "Green Component" : 0.6831834, "Red Component" : 0.5911217, "Blue Component" : 0.696525 },
"Ansi 13 Color" : { "Green Component" : 0.338963, "Red Component" : 0.3479863, "Blue Component" : 0.7290844 },
"Ansi 14 Color" : { "Green Component" : 0.6890607, "Red Component" : 0.3025523, "Blue Component" : 0.5129104 },
"Ansi 15 Color" : { "Green Component" : 0.8357439, "Red Component" : 0.8600703, "Blue Component" : 0.7627645 }
