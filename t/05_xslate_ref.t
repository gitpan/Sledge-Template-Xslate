use strict;
use Test::More tests => 1;
use Test::Requires qw(Sledge Sledge::TestPages Text::Xslate);

use lib "t/lib";

package Mock::Pages;
use parent qw(Sledge::TestPages);
use Sledge::Template::Xslate ({
  syntax => 'TTerse',
  module => ['Text::Xslate::Bridge::TT2Like'],
});

my $data = <<DATA
Hello world!
DATA
    ;

sub dispatch_name {
    my $self = shift;
    $self->tmpl->set_option(filename => \$data);
}

our $COOKIE_NAME   = "session";
our $COOKIE_PATH   = "/";
our $COOKIE_DOMAIN = "localhost";
our $TMPL_PATH = "t/template";
our $CACHE_DIR = "t/cache";

package main;

$ENV{HTTP_HOST}      = "localhost";
$ENV{REQUEST_URI}    = "http://localhost/include1.cgi";
$ENV{REQUEST_METHOD} = 'GET';

my $p = Mock::Pages->new();
$p->dispatch("name");
my $output = $p->output;
like $output, qr/Hello world!/, $output;
