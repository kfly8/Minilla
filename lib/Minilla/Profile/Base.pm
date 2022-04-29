package Minilla::Profile::Base;
use strict;
use warnings;
use utf8;
use Time::Piece;

use Moo;
with 'Minilla::Profile::Renderer';

has [qw(dist path module)] => (
    is       => 'ro',
    required => 1,
);

has 'version' => (
    is       => 'ro',
    default  => sub { '0.01' },
);

has suffix => (
    is => 'lazy',
    required => 1,
);

has [qw(email author)] => (
    is => 'lazy',
    required => 1,
);

has ci => (
    is => 'lazy',
    default => sub {
        require Minilla::Profile::CI::Travis;
        Minilla::Profile::CI::Travis->new;
    },
);

no Moo;

sub _build_author {
    my $self = shift;

    my $name ||= `git config user.name`;
    $name =~ s/\n$//;

    unless ($name) {
        errorf("You need to set user.name in git config.\nRun: git config user.name 'Your name'\n");
    }

    $name;
}

sub _build_email {
    my $self = shift;

    my $email ||= `git config user.email`;
    $email =~ s/\n$//;

    unless ($email) {
        errorf("You need to set user.email in git config.\nRun: git config user.email 'name\@example.com'\n");
    }

    $email;
}

sub _build_suffix {
    my $self = shift;
    my $suffix = $self->path;
    $suffix =~ s!^.+/!!;
    $suffix =~ s!\.pm!!;
    $suffix;
}

sub new_from_project {
    my ($class, $project) = @_;

    my $path = $project->main_module_path;
    $path =~ s!^lib/!!;
    my $self = $class->new(
        dist    => $project->dist_name,
        author  => $project->authors ? $project->authors->[0] : 'Unknown Author',
        version => $project->version,
        path    => $path,
        module  => $project->name,
    );
    return $self;
}

sub date {
    gmtime->strftime('%Y-%m-%dT%H:%M:%SZ');
}

sub end { '__END__' }

sub module_pm_src { '' }

1;
__DATA__

@@ t/00_compile.t
use strict;
use Test::More 0.98;

use_ok $_ for qw(
    <% $module %>
);

done_testing;

@@ Module.pm
package <% $module %>;
use 5.008001;
use strict;
use warnings;

our $VERSION = "<% $version %>";

<% $module_pm_src %>

1;
<% $end %>

=encoding utf-8

=head1 NAME

<% $module %> - It's new $module

=head1 SYNOPSIS

    use <% $module %>;

=head1 DESCRIPTION

<% $module %> is ...

=head1 LICENSE

Copyright (C) <% $author %>.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

<% $author %> E<lt><% $email %>E<gt>

=cut

@@ Changes
Revision history for Perl extension <% $dist %>

{{$NEXT}}

    - original version

@@ .gitignore
/.build/
/_build/
/Build
/Build.bat
/blib
/Makefile
/pm_to_blib

/carton.lock
/.carton/
/local/

nytprof.out
nytprof/

cover_db/

*.bak
*.old
*~
*.swp
*.o
*.obj

!LICENSE

/_build_params

MYMETA.*

/<% $dist %>-*
