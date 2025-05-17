<?php get_header(); ?>

<main id="main" class="site-main">
    <?php
    if (have_posts()) :
        while (have_posts()) :
            the_post();
            ?>
            <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
                <header class="entry-header">
                    <?php the_title('<h1 class="entry-title">', '</h1>'); ?>
                    <div class="entry-meta">
                        <span class="posted-on">Posted on <?php echo get_the_date(); ?></span>
                    </div>
                </header>

                <div class="entry-content">
                    <?php
                    the_content();
                    
                    wp_link_pages(array(
                        'before' => '<div class="page-links">' . esc_html__('Pages:', 'custom-theme'),
                        'after'  => '</div>',
                    ));
                    ?>
                </div>

                <footer class="entry-footer">
                    <?php
                    if (has_category() || has_tag()) {
                        echo '<div class="entry-taxonomy">';
                        if (has_category()) {
                            echo '<div class="category-links">Categories: ' . get_the_category_list(', ') . '</div>';
                        }
                        if (has_tag()) {
                            echo '<div class="tag-links">Tags: ' . get_the_tag_list('', ', ') . '</div>';
                        }
                        echo '</div>';
                    }
                    ?>
                </footer>
            </article>

            <?php
            // If comments are open or we have at least one comment, load up the comment template.
            if (comments_open() || get_comments_number()) :
                comments_template();
            endif;
            ?>
            
        <?php
        endwhile;
    else :
        ?>
        <article class="no-results">
            <header class="entry-header">
                <h1 class="entry-title">Nothing Found</h1>
            </header>
            <div class="entry-content">
                <p>It seems we can't find what you're looking for.</p>
            </div>
        </article>
        <?php
    endif;
    ?>
</main>

<?php get_footer(); ?>
