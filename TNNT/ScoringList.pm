#!/usr/bin/env perl

#=============================================================================
# Scoring list for players/clans.
#=============================================================================

package TNNT::ScoringList;

use Moo::Role;



#=============================================================================
#=== ATTRIBUTES ==============================================================
#=============================================================================

has scores => (
  is => 'rwp',
  default => sub { [] },
);



#=============================================================================
#=== METHODS =================================================================
#=============================================================================

#-----------------------------------------------------------------------------
# Add scoring entry, the entry should be a TNNT::ScoringEntry instance.
#-----------------------------------------------------------------------------

sub add_score
{
  my (
    $self,
    $entry,
  ) = @_;

  my $lst = $self->scores();
  push(@$lst, $entry);

  return $self;
}


#-----------------------------------------------------------------------------
# Remove scoring entry by trophy name.
#-----------------------------------------------------------------------------

sub remove_score
{
  my (
    $self,
    $trophy,
  ) = @_;

  $self->_set_scores(
    [ grep { $_->trophy() ne $trophy } @{$self->scores()} ]
  );
}


#-----------------------------------------------------------------------------
# Display the scoring list (for development purposes only)
#-----------------------------------------------------------------------------

sub disp_scores
{
  my ($self) = @_;
  my $i = 1;

  printf "--- SCORING LIST -- %d entries ---\n", scalar(@{$self->scores()});
  my $scores = $self->scores();
  foreach (@$scores) { printf "%d. ", $i++; $_->disp() };
  print "--- END OF SCORING LIST ---\n";
}


#=============================================================================

1;
