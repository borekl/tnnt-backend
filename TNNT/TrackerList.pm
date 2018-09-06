#!/usr/bin/env perl

#=============================================================================
# List of trackers.
#=============================================================================

package TNNT::TrackerList;

use v5.10;
use Moo;



#=============================================================================
#=== ATTRIBUTES ==============================================================
#=============================================================================

has trackers => (
  is => 'rw',
  default => sub { [] }
);



#=============================================================================
#=== METHODS =================================================================
#=============================================================================

#-----------------------------------------------------------------------------
# Register a new trackers (should be a reference to TNNT::Tracker object).
#-----------------------------------------------------------------------------

sub add_tracker
{
  my (
    $self,
    $tracker
  ) = @_;

  my $tl = $self->trackers();
  push(@$tl, $tracker);
}


#-----------------------------------------------------------------------------
# Find a tracker by the trophy name
#-----------------------------------------------------------------------------

sub get_tracker_by_name
{
  my (
    $self,
    $name
  ) = @_;

  my $tl = $self->trackers();
  my @result = grep { $_->name() eq $name } @$tl;
  if(wantarray) {
    return @result;
  } else {
    return $result[0];
  }
}


#-----------------------------------------------------------------------------
# Run game through all registered trackers.
#-----------------------------------------------------------------------------

sub track_game
{
  my (
    $self,
    $game,
    $player,
  ) = @_;

  my $tl = $self->trackers();
  foreach my $tracker (@$tl) {
    $tracker->add_game($game, $player);
  }
}



#=============================================================================
# Invoke all trackers' finish method. This allows for some final wrap up
# actions like generation of scoring entries etc.
#=============================================================================

sub finish
{
  my ($self) = @_;

  foreach my $tracker (@{$self->trackers()}) {
    printf "calling finish on tracker %s\n", $tracker->name();
    $tracker->finish();
  }
}



#=============================================================================

1;
