package Sledge::Template::Xslate::TTerse;

use strict;
use warnings;
use version;

our $VERSION = qv('0.0.2');

use parent qw(Sledge::Template::Xslate);

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_);
    $self->{_options}{syntax} = 'TTerse';

    return $self;
}

1;

=head1 NAME

Sledge::Template::Xslate::TTerse - Text::Xslate template system for Sledge and use TTerse syntax

=head1 VERSION

This document describes Sledge::Template::Xslate::TTerse version 0.0.2

=head1 SYNOPSIS

    package MyApp::Pages;
    use strict;
    use Sledge::Pages::Compat;
    use Sledge::Template::Xslate::TTerse;

    # ...

    package MyApp::Pages::Foo;
    use strict;
    use utf8;

    use parent qw(MyApp::Pages);
    
    sub bar{
        my $self = shift;
	
	$self->tmpl->set_option(input_layer => ':utf8');# Please use set_config method if you want to use utf-8.

	# ...
    }

    # ...

=head1 DESCRIPTION

Sledge::Template::Xslate::TTerse is Text::Xslate template system for Sledge.
This module is use TTerse syntax for Text::Xslate on Sledge::Template::Xslate.

=head1 AUTHOR

Kenta Sato  C<< <kenta.sato.1990@gmail.com> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Kenta Sato C<< <kenta.sato.1990@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 SEE ALSO

L<Text::Xslate> L<Text::Xslate::Syntax::TTerse>

=cut
