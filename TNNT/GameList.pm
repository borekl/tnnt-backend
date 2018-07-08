#!/usr/bin/env perl

#=============================================================================
# Object representing list of games.
#=============================================================================


package TNNT::GameList;

use TNNT::Game;
use Tie::Array::Sorted;
use Moo;



#=============================================================================
#=== ATTRIBUTES ==============================================================
#=============================================================================

has list => (
  is => 'rw',
  default => sub {
    my @ar;
    tie @ar, 'Tie::Array::Sorted', sub {
      $_[0]->endtime() <=> $_[1]->endtime()
    };
    return \@ar;
  },
);



#=============================================================================
#=== METHODS =================================================================
#=============================================================================

sub add_game
{
  my (
    $self,
    $game
  ) = @_;

  my $gl = $self->list();
  push(@$gl, $game);
}


sub count
{
  my ($self) = @_;

  my $gl = $self->list();
  return scalar(@$gl);
}


sub iter
{
  my ($self, $cb) = @_;

  foreach (@{$self->list()}) {
    $cb->($_);
  }
}


#=============================================================================
# Return last game in the list. This is also the newest game, because the list
# is always sorted.
#=============================================================================

sub last
{
  my ($self) = @_;

  if($self->count()) {
    return $self->list()->[-1];
  } else {
    return ();
  }
}



#=============================================================================

1;
