package Bugzilla::Extension::Gitzilla;
use strict;
use base qw(Bugzilla::Extension);

use Bugzilla::Util qw(html_quote);

use Data::Dumper;

our $VERSION = '1.0';

# this relies on using a formatspec in /etc/gitzillarc like this
# (replace MyProject.git appropriately):
# 
# formatspec:
#   MyProject.git commit      %H
#   MyProject.git parents     %P
#   Author      %aN (%aE)
#   ...

sub bug_format_comment {
    my ($self, $args) = @_;

    my $regexes = $args->{'regexes'};

    my $commit_match = qr/\b((\S+\.git)\s+((?:commit|parents)\b\s+)([0-9a-fA-F]{7,40}))/;
    push(@$regexes, { match => $commit_match, replace => \&_replace_commit });
}

sub _replace_commit {
    my $args = shift;
    my $matches = $args->{matches};
    return qq{$matches->[2]<a href="http://www.example.com/gitweb/?p=$matches->[1];a=commit;h=$matches->[3]">$matches->[3]</a>};
}

__PACKAGE__->NAME;
