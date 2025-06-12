<?php get_header(); ?>

<main id="main" class="site-main">
    <div class="container">
    <?php
    if (have_posts()) :
        while (have_posts()) :
            the_post();
            ?>
            <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
                <header class="entry-header">
                    <?php the_title('<h2 class="entry-title"><a href="' . esc_url(get_permalink()) . '" rel="bookmark">', '</a></h2>'); ?>
                    <div class="entry-meta">
                        <span class="posted-on">Posted on <?php echo get_the_date(); ?></span>
                    </div>
                </header>

                <div class="entry-content">
                    <?php
                    the_excerpt();
                    ?>
                    <a href="<?php echo esc_url(get_permalink()); ?>" class="read-more">Read More</a>
                </div>
            </article>
            <?php
        endwhile;

        the_posts_navigation();
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
    </div>
</main>

<?php get_footer(); ?>
