#!/usr/bin/perl

%rmap = (
"zero"  =>  0,
"at"    =>  1,
"v0"    =>  2,
"a0"    =>  3,
"a1"    =>  4,
"a2"    =>  5,
"t0"    =>  6,
"t1"    =>  7,
"t2"    =>  8,
"s0"    =>  9,
"s1"    =>  10,
"s2"    =>  11,
"k0"    =>  12,
"sp"    =>  13,
"fp"    =>  14,
"ra"    =>  15);

%instr = (
"add"   =>  0,    # add  rd, rs, rt
"nand"  =>  1,    # nand  rd, rs, rt
"addi"  =>  2,    # addi  rd, rs, imm5
"lw"    =>  3,    # lw  rd, imm5(rb)
"sw"    =>  4,    # sw  rs, imm5(rb)
"beq"   =>  5,    # beq  rx, ry, off5
"jalr"  =>  6,    # jalr  rtgt, rsav
"spop"  =>  7);   # spop  imm2

sub sanitize_r_type() {
  my ($op, $rd, $rs, $rt) = @_;

  if(!(defined $rt)) {
    return undef;
  }
  if (!(defined $rmap{$rd}) || !(defined $rmap{$rs}) || !(defined $rmap{$rt})) {
    return undef;
  }

  return "$op $rd $rs $rt";
}

sub sanitize_i_type() {
  my ($op, $r1, $r2, $imm) = @_;

  if(!(defined $imm)) {
    return undef;
  }

  my $val = &parse_num($imm);
  if(!(defined $val)) {
    $val = &parse_num($r2);
    if(!(defined $val)) {
      printf STDERR "Immediate value not defined";
      return undef;
    }
    $r2 = $imm;
  }
  $imm = $val;

  if($imm >= 16 || $imm < -16) {
    print STDERR "Immediate value is too large. range is [-16, 15]\n";
    return undef;
  }

  if (!(defined $rmap{$r1}) || !(defined $rmap{$r2})) {
    return undef;
  }

  return "$op $r1 $r2 $imm";
}

sub sanitize_branch {
  my ($op, $r1, $r2, $label) = @_;

  if(!(defined $label)) {
    return undef;
  }

  if (!(defined $rmap{$r1}) || !(defined $rmap{$r2})) {
    return undef;
  }

  return "$op $r1 $r2 $label";
}

sub sanitize_jalr {
  my ($op, $r1, $r2) = @_;

  if(!(defined $r2)) {
    return undef;
  }

  if (!(defined $rmap{$r1}) || !(defined $rmap{$r2})) {
    return undef;
  }

  return "$op $r1 $r2";
}


sub sanitize_spop {
  my $cmd = shift;

  if(!(defined $cmd)) {
    return undef;
  }

  $cmd = &parse_num($cmd);

  if ($cmd < 0 || $cmd > 3) {
    print STDERR "spop code not recognized.\n";
    return undef;
  }

  return "spop $cmd";
}

sub get_r_type() {
  my $ret = ($instr{$_[0]} << 13) | ($rmap{$_[1]} << 9) | ($rmap{$_[2]} << 5);
  $ret |= $rmap{$_[3]};

  return $ret;
}

sub get_i_type() {
  my $ret = ($instr{$_[0]} << 13) | ($rmap{$_[1]} << 9) | ($rmap{$_[2]} << 5);
  $ret |= $_[3] & 0x1F;

  return $ret;
}


sub parse_num() {
  $num = shift;
  
  if ($num =~ m/^0x([0-9a-f]+)$/) {
    return hex($1);
  } elsif($num =~ m/^\-?[0-9]+$/) {
    return $num + 0;
  } else {
    return undef;
  }
}


sub debug() {
  $l = shift;
  $msg = shift;
  if($debug >= $l) {
    while ($l-- > 0) {
      print "*";
    }
    print " ";
    print "$msg\n";
  }
}

return 1;
