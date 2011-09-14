package Jet::Plugin::Node::Stitch;

use 5.010;
use Moose;

extends 'Jet::Plugin';

with 'Jet::Role::Log';

=head1 NAME

Jet::Node::Stitch - Stich some nodes together

=head1 SYNOPSIS

=head1 METHODS

=head2 data

Stich some nodes together

=head1 PARAMETERS

=head2 container

What container holds the data to be stitched together

default stash

=head2 nodes

Which nodes to be stitched together

=head2 name

What name to use for the result in the stash

=head2 TODO

container should be per node

=cut

sub data {
	my $self = shift;
	my $parms = $self->parameters;
	my $nodes = $parms->{nodes};
	my $name = $parms->{name};
	my @nodes;
	@nodes = (@nodes, @$_) for values %$nodes;
	$self->stash->{$name} = \@nodes;
}

no Moose::Role;

1;

=head1 AUTHOR

Kaare Rasmussen, <kaare at cpan dot com>

=head1 BUGS 

Please report any bugs or feature requests to my email address listed above.

=head1 COPYRIGHT & LICENSE 

Copyright 2011 Kaare Rasmussen, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the same terms as 
Perl itself, either Perl version 5.8.8 or, at your option, any later version of Perl 5 you may 
have available.
