#!/usr/bin/env perl

#=============================================================================
# Object representing single game.
#=============================================================================

package TNNT::Game;

use Moo;
use TNNT::Config;

with 'TNNT::ScoringList';



#=============================================================================
#=== ATTRIBUTES ==============================================================
#=============================================================================

has role      => ( is => 'ro', required => 1 );
has race      => ( is => 'ro', required => 1 );
has gender    => ( is => 'ro', required => 1 );
has align     => ( is => 'ro', required => 1 );
has gender0   => ( is => 'ro', required => 1 );
has align0    => ( is => 'ro', required => 1 );
has name      => ( is => 'ro', required => 1 );
has death     => ( is => 'ro', required => 1 );
has turns     => ( is => 'ro', required => 1 );
has realtime  => ( is => 'ro', required => 1 );
has starttime => ( is => 'ro', required => 1 );
has endtime   => ( is => 'ro', required => 1 );
has points    => ( is => 'ro', required => 1 );
has deathlev  => ( is => 'ro', required => 1 );
has maxlvl    => ( is => 'ro', required => 1 );
has hp        => ( is => 'ro', required => 1 );
has maxhp     => ( is => 'ro', required => 1 );
has deaths    => ( is => 'ro', required => 1 );
has elbereths => ( is => 'ro' );

# convert hexdecimal values

has conduct   => (
  is => 'ro',
  required => 1,
  coerce => sub { hex($_[0]) },
);

has achieve   => (
  is => 'ro',
  required => 1,
  coerce => sub { hex($_[0]) },
);

has tnntachieve0 => (
  is => 'ro',
  coerce => sub { hex($_[0]) },
);

has tnntachieve1 => (
  is => 'ro',
  coerce => sub { hex($_[0]) },
);

# reference to TNNT::Player object

has player => (
  is => 'rw',
);

# list of achievements

has achievements => (
  is => 'ro',
  lazy => 1,
  builder => 1,
);



#=============================================================================
#=== METHODS =================================================================
#=============================================================================

#=============================================================================
#=============================================================================

sub is_ascended
{
  my ($self) = @_;

  return ($self->death() =~ /^ascended/);
}



#=============================================================================
# Display game on console (for development purposes only)
#=============================================================================

sub disp
{
  my ($self) = @_;

  printf(
    "%-16s  %s-%s-%s-%s  %s  %6d turns  %8d points  %s\n",
    $self->name(),
    $self->role(), $self->race(), $self->gender0(), $self->align0(),
    scalar(gmtime($self->endtime())),
    $self->turns(), $self->points(), $self->death()
  );
}



#=============================================================================
# Return conducts as either their number (in scalar context) or list of
# conduct shortcodes (in list context)
#=============================================================================

sub conducts
{
  my $self = shift;
  my $cfg = TNNT::Config->instance()->config()->{'conducts'};
  my $conduct_bitfield = $self->conduct();
  my $achieve_bitfield = $self->achieve();
  my $elbereths = $self->elbereths();

  my @conducts;

  #--- get reverse code-to-value mapping for conducts and also ordering

  my %con_to_val = reverse %{$cfg->{'conduct'}};
  my %ach_to_val = reverse %{$cfg->{'achieve'}};
  my @order = @{$cfg->{'order'}};

  #---

  foreach my $c (@order) {

    if($c eq 'elbe' && defined $elbereths && !$elbereths) {
      push(@conducts, $c);
      last;
    }

    if(exists $con_to_val{$c} && $conduct_bitfield) {
      if($conduct_bitfield & $con_to_val{$c}) {
        push(@conducts, $c);
      }
    }

    elsif(exists $ach_to_val{$c} && $achieve_bitfield) {
      if($achieve_bitfield & $ach_to_val{$c}) {
        push(@conducts, $c);
      }
    }

  }

  #--- return value depending on context

  return wantarray ? @conducts : scalar(@conducts);
}



#-----------------------------------------------------------------------------
# Create list of achievements out of the xlogfile fields 'achieve' and TNNT
# specific 'tnntachieve0' and 'tnntachieve1'. The result is an array of
# achievement shortnames (as referenced in the configuration file)
#-----------------------------------------------------------------------------

sub _build_achievements
{
  my ($self) = @_;
  my $cfg = TNNT::Config->instance()->config()->{'achievements'};

  my @achievements;

  for my $field (qw(achieve tnntachieve0 tnntachieve1)) {
    next if !$self->$field();
    my @found = grep {
      exists $cfg->{$_}{$field}
      && $cfg->{$_}{$field}
      && hex($cfg->{$_}{$field}) & $self->$field()
    } keys %$cfg;

    push(@achievements, @found) if @found;
  }

  return \@achievements;
}



#=============================================================================

1;
