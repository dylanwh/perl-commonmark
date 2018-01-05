use strict;
use warnings;

use Symbol;
use Test::More tests => 4;

BEGIN {
    use_ok('CommonMarkGFM', ':list', ':delim');
}

my $doc = CommonMarkGFM->create_document(
    children => [
        CommonMarkGFM->create_header(
            level    => 2,
            children => [
                CommonMarkGFM->create_text(
                    literal => 'Header',
                ),
            ],
        ),
        CommonMarkGFM->create_block_quote(
            children => [
                CommonMarkGFM->create_paragraph(
                    text => 'Block quote',
                ),
            ],
        ),
        CommonMarkGFM->create_list(
            type     => ORDERED_LIST,
            delim    => PAREN_DELIM,
            start    => 2,
            tight    => 1,
            children => [
                CommonMarkGFM->create_item(
                    children => [
                        CommonMarkGFM->create_paragraph(
                            text => 'Item 1',
                        ),
                    ],
                ),
                CommonMarkGFM->create_item(
                    children => [
                        CommonMarkGFM->create_paragraph(
                            text => 'Item 2',
                        ),
                    ],
                ),
            ],
        ),
        CommonMarkGFM->create_code_block(
            literal => 'Code block',
        ),
        CommonMarkGFM->create_html(
            literal => '<div>html</html>',
        ),
        CommonMarkGFM->create_hrule,
        CommonMarkGFM->create_paragraph(
            children => [
                CommonMarkGFM->create_emph(
                    children => [
                        CommonMarkGFM->create_text(
                            literal => 'emph',
                        ),
                    ],
                ),
                CommonMarkGFM->create_softbreak,
                CommonMarkGFM->create_link(
                    url   => '/url',
                    title => 'link title',
                    children => [
                        CommonMarkGFM->create_strong(
                            text => 'link text',
                        ),
                    ],
                ),
                CommonMarkGFM->create_linebreak,
                CommonMarkGFM->create_image(
                    url   => '/facepalm.jpg',
                    title => 'image title',
                    text  => 'alt text',
                ),
            ],
        ),
    ],
);

my $expected_html = <<'EOF';
<h2>Header</h2>
<blockquote>
<p>Block quote</p>
</blockquote>
<ol start="2">
<li>Item 1</li>
<li>Item 2</li>
</ol>
<pre><code>Code block</code></pre>
<div>html</html>
<hr />
<p><em>emph</em>
<a href="/url" title="link title"><strong>link text</strong></a><br />
<img src="/facepalm.jpg" alt="alt text" title="image title" /></p>
EOF
is($doc->render_html, $expected_html, 'create_* helpers');

SKIP: {
    skip('Requires libcmark 0.23', 1) if CommonMarkGFM->version < 0x001700;

    $doc = CommonMarkGFM->create_document(
        children => [
            CommonMarkGFM->create_custom_block(
                on_enter => '<div class="custom">',
                on_exit  => '</div>',
                children => [
                    CommonMarkGFM->create_paragraph(
                        children => [
                            CommonMarkGFM->create_custom_inline(
                                on_enter => '<span class="custom">',
                                on_exit  => '</span>',
                                text     => 'foo',
                            ),
                        ],
                    ),
                ],
            ),
        ],
    );

    $expected_html = <<'EOF';
<div class="custom">
<p><span class="custom">foo</span></p>
</div>
EOF

    is($doc->render_html, $expected_html, 'create_custom_* helpers');
}

SKIP: {
    # libcmark's HTML renderer ignores fence_info before 0.24.0.
    skip('Requires libcmark 0.24', 1) if CommonMarkGFM->version < 0x001800;

    $doc = CommonMarkGFM->create_document(
        children => [
            CommonMarkGFM->create_code_block(
                fence_info => 'perl',
                literal    => 'my @a = qw(1 2 3);',
            ),
    ]);

    $expected_html = <<'EOF';
<pre><code class="language-perl">my @a = qw(1 2 3);</code></pre>
EOF

    is($doc->render_html, $expected_html, 'create_custom_* helpers');
}

