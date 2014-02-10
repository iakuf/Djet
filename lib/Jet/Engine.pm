package Jet::Engine;

use 5.010;
use Moose;
use namespace::autoclean;

use Jet::Engine::Control;

with qw/Jet::Role::Log/;

=head1 NAME

Jet::Engine - Jet Engine Base Class

=head1 DESCRIPTION

Jet::Engine is the basic building block of all Jet Engines.

In your engine you just write

extends 'Jet::Engine';

=head1 ATTRIBUTES

=cut

has control => (
	isa => 'Jet::Engine::Control',
	is => 'ro',
	lazy => 1,
	default => sub { Jet::Engine::Control->new },
);
has stash => (
	isa => 'HashRef',
	traits => ['Hash'],
	is => 'ro',
	lazy => 1,
	default => sub { {} },
	handles => {
		set_stash => 'set',
		clear_stash => 'clear',
	},
);
has request => (
	isa => 'Jet::Request',
	is => 'ro',
	handles => [qw/
		basetypes
		cache
		config
		schema
		log
	/],
);
has basenode => (
	isa => 'Jet::Schema::Result::Jet::DataNode',
	is => 'ro',
);
has response => (
	isa => 'Jet::Response',
	is => 'ro',
);

=head2 arguments

This is the set of arguments for this engine

=cut

has 'arguments' => (
	isa => 'HashRef',
	is => 'ro',
);

sub _run {
	my ($self, $stage) = @_;
	my $vstage = '_' . $stage;
	for my $method ($self->$vstage) {
		my $omitmethod = "first$vstage";
		last if $self->control->first_skip( sub { $stage } );
		next if $self->control->omit->$omitmethod( sub { $method } );

		$self->log->debug("Executing method $method in stage $stage");
		$self->$method;
	}
	return 1;
}

=head1 METHODS

=head2 init

Engine initialization stuff

=cut

sub init {
	my $self = shift;
	$self->_run('init');
}

=head2 data

Process data

=cut

sub data {
	my $self = shift;
	$self->_run('data');
}

=head2 set_renderer

Choose the renderer

=cut

sub set_renderer {
	my $self = shift;
	my $response = $self->response;
	return if $response->_has_renderer;

	my $type = $response->type =~/(html|json)/i ? $1 : 'html';
	$response->set_renderer($self->request->renderers->{$type})
}

=head2 render

Render data

=cut

sub render {
	my $self = shift;
	my $response = $self->response;
	my $basenode = $response->basenode;
	$response->template($basenode->render_template) unless $response->_has_template;
	$self->_run('render');
	$response->render;
}

__PACKAGE__->meta->make_immutable;

1;

# COPYRIGHT

__END__

