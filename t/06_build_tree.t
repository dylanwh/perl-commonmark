use strict;
use warnings;

use Symbol;
use Test::More tests => 2;

BEGIN {
    use_ok('CommonMarkGFM', ':node');
}

sub create_text {
    my $literal = shift;
    my $node = CommonMarkGFM::Node->new(NODE_TEXT);
    $node->set_literal($literal);
    return $node;
}

my $doc         = CommonMarkGFM::Node->new(NODE_DOCUMENT);
my $paragraph   = CommonMarkGFM::Node->new(NODE_PARAGRAPH);
my $emph        = CommonMarkGFM::Node->new(NODE_EMPH);
my $strong      = CommonMarkGFM::Node->new(NODE_STRONG);
my $normal_text = create_text('normal ');
my $emph_text   = create_text('emph');
my $space       = create_text(' ');
my $strong_text = create_text('strong');

$paragraph->prepend_child($emph);
$emph->append_child($emph_text);
$emph->insert_before($normal_text);
$paragraph->append_child($strong);
$doc->prepend_child($paragraph);
$strong->append_child($space);
$emph->insert_after($space);
$strong->append_child($strong_text);

my $expected_html = <<EOF;
<p>normal <em>emph</em> <strong>strong</strong></p>
EOF

is($doc->render_html, $expected_html, 'build tree');

