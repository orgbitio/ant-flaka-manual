

!defined $insec && /^\|\|/ && do {
  $insec = 1;
  # how man many '||' do we have here??
  $count = 0;
  $count++ while $_ =~ /\|\|/g;
  $count--; # last one does not count ..
  # Let the last column be 50% and split rest equally. However, Asciidoc does
  # not allow for rational numbers, only integral numbers are allowed. Further-
  # more, the total percentage must be 100%.
  #
  # Make the first column 15% wide fixed. 
  $c = int($count - 2);
  if ($c > 0) {
      $w = int((50-15) / $c);
      $r = int(100 - ($c * $w) - 15);
      print "// cols=$count\n";
      print "[cols=\"15%,$c*$w%,$r%\"]\n"; 
    }
  elsif ($count == 2) {
    print "// cols=2\n";
    print "[cols=\"20%,80%\"]\n"; 
  }
  else {
    print "// cols=1\n";
    print "[cols=\"100%\"]\n"; 
  }
  
  print "|===========================\n";
};

defined $insec && do {
  s/\|\|\s*$/\n/g;
  s/\|\|/\|/g ;
  /^[^|]/ && do {
    print "|===========================\n";
    undef $insec;
  }
}

