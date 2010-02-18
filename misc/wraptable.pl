

!defined $insec && /^\|\|/ && do {
  $insec = 1;
  # how man many '||' do we have here??
  $count++ while $_ =~ /\|\|/g;
  print "[cols=$count]\n";
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

