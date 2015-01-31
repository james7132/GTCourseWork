#!/usr/bin/perl

require "lcas-fn.pl";

my $infile = undef;
$debug = 0;
$binary = undef;


foreach (@ARGV) {
  if($_ eq "-b" || $_ eq "--binary") {
    $binary = 1;
  } elsif($_ eq "-h" || $_ eq "--help") {
    &help_and_exit();
  } elsif ($_ =~ /^\-\-debug/) {
    $_ =~ s/--debug=//;
    $debug = $_ + 0;
  } elsif ($_ !~ /^(\-.*)/) {
    $infile = $_;
  } else {
    print STDERR "Unrecognized flag: $1\n";
    &help_and_exit();
  }
}

if(!(defined $infile)) {
  &help_and_exit();
}

my $basefile = $infile;
$basefile =~ s/\.a?sm?//i;

my $tempfile = "$basefile.lctemp";

open(ASM, "< $infile") or die "Could not open file $infile: $!\n";
open($stemp, "> $tempfile") or die "Could not create file $tempfile: $!\n";

%labels = ();
my $addr = 0;
$high = 0;
my $line = 0;

&debug(1, "Debug level $debug");
&debug(1, "Starting preprocessor.");

while ($in = <ASM>) {
  $line++;

  $in =~ s/[\r\n]+//;
  $in =~ s/;.*$//;
  $in =~ s/!.*$//;
  $in =~ s/^\s+//;
  $in =~ s/\s+$//;
  $in =~ tr/A-Z/a-z/;
  $in =~ s/\$//g;

  if ($in =~ m/^\s*([a-z_]\w+):\s*(.*)$/) {
    if(defined $labels{$1}) {
      print STDERR "Line $line --\nLabel $1 already defined.\n";
      exit 1;
    }
    $labels{$1} = $addr;
    &debug(2, "Label defined: $1 as $addr");
    $in = $2;
  }
  if ($in =~ m/:/) {
    print STDERR "Line $line --\nWeird label:\n   $in\n";
    exit 3;
  }

  if ($in =~ m/^$/) {
    next;
  }

  my @tokens = split(/[\s,()]+/, $in);

  if ($in =~ m/^\.ori?g\s+(.*)$/) {
    my $val = &parse_num($1);
    if (!(defined $val)) {
      print STDERR "Line $line --\nCannot recognize $num as a number.\n   ";
      exit 4;
    }
    print $stemp ".org $val\n";
    $addr = $val;
    $high = ($addr > $high) ? $addr : $high;
    next;
  } elsif ($in =~ m/^\.byte\s+(.*)$/ || $in =~ m/^\.word\s+(.*)$/) {
    my $val = &parse_num($1);
    if (defined $val) {
      print $stemp ".word $val\n";
    } else {
      print $stemp ".word $1\n";
    }
    if($in =~ m/^\.byte\s+(.*)$/) {
      print STDERR "Line $line --\nWARNING!!!!: use .word instead of .byte\n"
    }
  } elsif ($in =~ m/^\.blkw\s+(.*)$/) {
    my $val = &parse_num($1);
    if (!(defined $val)) {
      print STDERR "Line $line --\nCannot recognize $num as a number.\n";
      exit 5;
    }
    print $stemp ".blkw $val\n";
    $addr += $val;
    $high = ($addr > $high) ? $addr : $high;
    next;
  } elsif ($tokens[0] eq "add" || $tokens[0] eq "nand") {
    $instr = &sanitize_r_type(@tokens);
    if (!(defined $instr)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    print $stemp "$instr\n";
  } elsif ($tokens[0] eq "addi" || $tokens[0] eq "lw" || $tokens[0] eq "sw") {
    $instr = &sanitize_i_type(@tokens);
    if (!(defined $instr)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    print $stemp "$instr\n";
  } elsif ($tokens[0] eq "beq") {
    $instr = &sanitize_branch(@tokens);
    if (!(defined $instr)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    print $stemp "$instr\n";
  } elsif ($tokens[0] eq "jalr") {
    $instr = &sanitize_jalr(@tokens);
    if (!(defined $instr)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    print $stemp "$instr\n";
  } elsif ($tokens[0] eq "spop") {
    $instr = &sanitize_spop($tokens[1]);
    if (!(defined $instr)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    print $stemp "$instr\n";
  } elsif($tokens[0] eq "noop") {
    print $stemp "add zero zero zero\n";
  } elsif($tokens[0] eq "halt") {
    print $stemp "spop 0\n";
  } elsif($tokens[0] eq "la" || $tokens[0] eq "lc") {
    my $reg = $tokens[1];
    my $label = $tokens[2];
    if(!(defined $rmap{$reg}) || !(defined $label)) {
      print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
      exit 6;
    }
    if($tokens[0] eq "lc") {
      $label = &parse_num($label);
      if(!(defined $label)) {
        print STDERR "Line $line --\nMalformed instruction:\n   $in\n";
        exit 6;
      }
    }

    print $stemp "jalr $reg $reg\n";
    print $stemp "lw $reg $reg 2\n";
    print $stemp "beq zero zero 1\n";
    print $stemp ".word $label\n";

    $addr += 3;
  } else {
    print STDERR "Line $line --\nUnrecognized instruction: $in\n";
    exit 127;
  }

  $addr++;
  $high = ($addr > $high) ? $addr : $high;
}

close ASM;
close $stemp;

&debug(1, "Done preprocessing.");
&debug(1, "Writing output.");

my $outfile = "$basefile.lc";

open (STEMP, "< $tempfile") or die "Could not open temp file $tempfile\n";
open ($lcout, "> $outfile") or die "Could not open output file $outfile\n";

%mem = ();
$addr = 0;
while ($in = <STEMP>) {
  chomp $in;

  if ($in =~ m/^\.org (.*)$/) {
    $addr = $1+0;
    next;
  }
  if ($in =~ m/^\.word (.*)$/) {
    my $val = &parse_num($1);
    if (defined $val) {
      $mem{$addr} = $val;
    } else {
      my $lab = $labels{$1};
      if(!(defined $lab)) {
        print STDERR "Label $lab undefined.\n";
        exit 7;
      }
      $mem{$addr} = $lab;
    }
  }
  if ($in =~ m/^\.blkw (.*)$/) {
    $addr += $1;
    next;
  }

  my @tokens = split(/[\s,()]+/, $in);
  if ($tokens[0] eq "add" || $tokens[0] eq "nand") {
    $mem{$addr} = &get_r_type(@tokens);
  }

  if ($tokens[0] eq "addi" || $tokens[0] eq "lw" || $tokens[0] eq "sw") {
    $mem{$addr} = &get_i_type(@tokens);
  }

  if ($tokens[0] eq "beq") {
    my $label = $tokens[3];
    my $off = &parse_num($label);
    if (!(defined $off)) {
      if (!(defined $labels{$label})) {
        print STDERR "Undefined Label $label.\n";
        exit 8;
      }
      $off = $labels{$label} - ($addr + 1);
    }
    if ($off >= 16 || $off < -16) {
      print STDERR "Label $label is too far away. It must fit in [-16, 15].\n";
      exit 8;
  }
    $tokens[3] = $off;
    $mem{$addr} = &get_i_type(@tokens);
  }

  if ($tokens[0] eq "jalr") {
    $tokens[3] = 0;
    $mem{$addr} = &get_i_type(@tokens);
  }

  if ($tokens[0] eq "spop") {
    $mem{$addr} = (0xE000 | ($tokens[1]));
  }
  $addr++;
}


my $i = 0;
while ($i < $high) {
  $word = $mem{$i};
  if(defined $binary) {
    if(!(defined $word)) {
      print $lcout chr(0) . chr(0);
    } else {
      print $lcout chr($word >> 8) . chr($word & 0xFF);
    }
  } else {
    if(!(defined $word)) {
      print $lcout "0000 ";
    } else {
      printf($lcout "%0.4X ", $word);
    }
  }
  $i++;
}


close ASM;
close $lcout;

if($debug == 0) {
  unlink $tempfile;
}

&debug(1, "Done assembling.");
&debug(1, "Writing symbol table.");

open(SYM, "> $basefile.sym") or die "Could not write symbol file $basefile.sym";

print SYM "----------\n";
foreach (keys %labels) {
  my $key = $_;
  my $val = $labels{$_};
  printf(SYM "//\t$key %0.4X\n", $val);
}

close SYM;


sub help_and_exit() {
  print STDERR <<EOF;

Usage:
lcas.pl [options] <asm-file>

  List of options:
    -b, --binary      Output binary file instead of ASCII hex characters
    -h, --help        Print this help message

EOF
  exit 1;
}

