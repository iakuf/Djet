use utf8;
package Jet::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-03 11:41:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Z/TKrREPcrSUpNIvqFMf9g

use List::Util qw/first/;

=head1 NAME

Jet::Schema

=head1 DESCRIPTION

The Jet database Schema

=head1 ATTRIBUTES

=head2 config

Jet configuration. Jet::Schema wants to know its surroundings upon start.

=cut

has config => (
	is => 'rw',
	isa => 'Jet::Config',
	handles => [qw/
		renderers
		log
	/],
);

=head2 basetypes

Jet Basetypes

=cut

has basetypes => (
	is => 'ro',
	isa => 'HashRef',
	default => sub {
		my $self = shift;
		return { map { $_->id =>  $_} $self->resultset('Jet::Basetype')->search };
	},
	lazy => 1,
);

=head2 default_class

The default class to do something for every node, before and after other handling

=cut

has default_class => (
	is => 'ro',
	isa => 'Str',
	default => sub {
		my $self = shift;
		my $default_class = $self->config->{config}{jet_config}{default_class} || 'Jet::Correct';
		$self->log->debug("Default Class: $default_class");
		eval "require $default_class";
		warn $@ if $@; # The logical thing would be to die, but we're in Web::Machine country, and it seems to eat it up

		return $default_class;
	},
	lazy => 1,
);

=head2 basetype_by_name

Returns a basetype from the cache, given a name

=cut

sub basetype_by_name {
	my ($self, $basename) = @_;
	return first {$_->name eq $basename} values %{ $self->basetypes };
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

# COPYRIGHT

__END__
