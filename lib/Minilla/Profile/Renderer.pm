package Minilla::Profile::Renderer;
use strict;
use warnings;
use utf8;

use Moo::Role;

use File::Path qw(mkpath);
use File::Basename qw(dirname);
use Data::Section::Simple;

use Minilla::Logger;
use Minilla::Util qw(spew_raw);

sub render {
    my ($self, $tmplname, $dst) = @_;
    my $path = $dst || $tmplname;

    infof("Writing %s\n", $path);
    mkpath(dirname($path));

    for my $pkg (@{mro::get_linear_isa(ref $self || $self)}) {
        my $content = Data::Section::Simple->new($pkg)->get_data_section($tmplname);
        next unless defined $content;
        $content =~ s!<%\s*\$([a-z_]+)\s*%>!
            $self->$1()
        !ge;
        spew_raw($path, $content);
        return;
    }
    errorf("Cannot find template for %s\n", $tmplname);
}

sub write_file {
    my ($self, $path, $content) = @_;

    infof("Writing %s\n", $path);
    mkpath(dirname($path));
    spew_raw($path, $content);
}

1;
