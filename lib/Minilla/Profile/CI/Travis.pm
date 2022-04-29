package Minilla::Profile::CI::Travis;
use strict;
use warnings;
use utf8;

use Moo;
with 'Minilla::Profile::Renderer';

sub generate {
    my $self = shift;
    $self->render('.travis.yml');
}

1;
__DATA__

@@ .travis.yml
language: perl
matrix:
  include:
    - perl: "5.12"
      dist: trusty
    - perl: "5.14"
    - perl: "5.16"
    - perl: "5.18"
    - perl: "5.20"
    - perl: "5.22"
    - perl: "5.24"
    - perl: "5.26"
    - perl: "5.28"
    - perl: "5.30"

