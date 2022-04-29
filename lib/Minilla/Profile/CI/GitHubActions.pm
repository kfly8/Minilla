package Minilla::Profile::CI::GitHubActions;
use strict;
use warnings;
use utf8;

use File::Spec::Functions qw(catfile);

use Moo;
with 'Minilla::Profile::Renderer';

sub generate {
    my $self = shift;
    $self->render('.github.yml', catfile('.github', 'workflows', 'test.yml'));
}

1;
__DATA__

@@ .github.yml
name: test

on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        perl:
          [
            "5.34",
            "5.32",
            "5.30",
            "5.28",
            "5.26",
            "5.24",
            "5.22",
            "5.20",
            "5.18",
            "5.16",
            "5.14",
            "5.12",
            "5.10"
          ]
    name: Perl ${{ matrix.perl }}
    steps:
      - uses: actions/checkout@v2
      - name: Setup perl
        uses: shogo82148/actions-setup-perl@v1
        with:
          perl-version: ${{ matrix.perl }}
      - name: Install dependencies
        run: |
          cpanm -nq --installdeps --with-develop --with-recommends .
      - name: Build
        run: |
          perl Build.PL
          ./Build
      - name: Run test
        run: ./Build test
