<?php get_header(); ?>

<main id="main" class="site-main">
    <div class="container">
    <?php
    if (have_posts()) :
        while (have_posts()) :
            the_post();
            ?>
            <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>

                <div class="entry-content">
                    <?php
                    the_content();
                    ?>
                </div>
            </article>
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
    </div>
</main>

<?php get_footer(); ?>
