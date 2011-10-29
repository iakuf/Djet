package Jet::Context::Config;

use 5.010;
use Moose;

use Config::Any;

with 'Jet::Role::Log';

=head1 NAME

Jet::Context::Config - Jet Configuration

=head1 SYNOPSIS

=head1 ATTRIBUTES

=head2 config

The configuration is loaded from etc by default

=head2 jet

The jet part of the config

=head2 options

The options part of the config

=cut

has config => (
	isa => 'HashRef',
	is => 'ro',
	default => sub {
		my $self = shift;
		my $config_total = Config::Any->load_files({
			files => [glob 'etc/*'],
			use_ext => 1,
			flatten_to_hash => 1,
		});
		return $config_total;
	},
);
has jet => (
	isa => 'HashRef',
	is => 'ro',
	default => sub {
		my $self = shift;
		return $self->config->{'etc/jet.conf'};
	},
);
has options => (
	isa => 'HashRef',
	is => 'ro',
	default => sub {
		my $self = shift;
		return $self->config->{'etc/options.conf'};
	},
);

=head1 METHODS

=head2 private

Return the private config

For future use

=cut

sub private {
	my ($self, $module) = @_;
	return {};
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 AUTHOR

Kaare Rasmussen, <kaare at cpan dot com>

=head1 BUGS 

Please report any bugs or feature requests to my email address listed above.

=head1 COPYRIGHT & LICENSE 

Copyright 2011 Kaare Rasmussen, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the same terms as 
Perl itself, either Perl version 5.8.8 or, at your option, any later version of Perl 5 you may 
have available.
