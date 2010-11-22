package Sledge::Template::Xslate;

use strict;
use warnings;
use version;

our $VERSION = qv('0.0.2');
our $XSLATE_CACHE_DIR_NAME = 'xslate';

use parent qw(Sledge::Template);

use Text::Xslate;
use File::Spec::Memoized;
use File::Basename;
use Sledge::Exceptions;

sub import {
    my $class = shift;
    my $pkg = caller(0);
    no strict 'refs';
    *{"$pkg\::create_template"} = sub {
	my($self, $file) = @_;
	return $class->new($file, $self);
    };
}

sub new {
    my($class, $file, $page) = @_;

    my $config = $page->create_config();

    my $self = {
        _options => {
            filename    => $file,
	    path        => ['/', dirname($file)],
	    input_layer => ':encoding(euc-jp)',# Default encoding is euc-jp (not utf-8)
	    suffix      => '.html',
            type        => 'html',
            cache       => 1
        },
	_params  => {
            config  => $config,
            r       => $page->r,
            session => $page->session,
        }
    };

    bless($self, $class);
}

sub add_associate       { Sledge::Exception::UnimplementedMethod->throw }
sub associate_namespace { Sledge::Exception::UnimplementedMethod->throw }

sub output {
    my $self = shift;
    my $config = $self->{_options};
    my $input  = delete $config->{filename};
    my $cache_dir = $self->{'_params'}->{'config'}->can('cache_dir') ? 
	$self->{'_params'}->{'config'}->cache_dir : undef;

    # Cache directory check
    if(defined($cache_dir)){
	$config->{cache_dir} = File::Spec->catfile($cache_dir, $XSLATE_CACHE_DIR_NAME);
	Sledge::Exception::TemplateCacheDirNotFound->throw(
	    "No template cache directory detected: $cache_dir"
	) unless(-d $config->{cache_dir});
    }else{
	$config->{cache} = 0;
    }

    # Template file check
    unless (ref($input) || -e $input) {
	Sledge::Exception::TemplateNotFound->throw(
	    "No template file detected: $input",
	);
    }
    
    # Create object
    my $template = Text::Xslate->new($config);
    
    # Render
    return ((ref $input eq 'SCALAR') ?
	    $template->render_string($$input, $self->{_params}):
	    $template->render($input, $self->{_params})
	)or Sledge::Exception::TemplateParseError->throw($template->error);
}

1;
__END__

=head1 NAME

Sledge::Template::Xslate - Text::Xslate template system for Sledge

=head1 VERSION

This document describes Sledge::Template::Xslate version 0.0.2

=head1 SYNOPSIS

    package MyApp::Pages;
    use strict;
    use Sledge::Pages::Compat;
    use Sledge::Template::Xslate;

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

Sledge::Template::Xslate is Text::Xslate template system for Sledge.

=head1 AUTHOR

Kenta Sato  C<< <kenta.sato.1990@gmail.com> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Kenta Sato C<< <kenta.sato.1990@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 SEE ALSO

L<Sledge::Template>
L<Text::Xslate> L<Text::Xslate::Syntax::Kolon>

=cut
