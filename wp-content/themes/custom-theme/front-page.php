<?php
/**
 * The front page template file
 *
 * This is the most generic template file in a WordPress theme
 * and one of the two required files for a theme (the other being style.css).
 * It is used to display the homepage when Home page displays is set to "Your latest posts"
 * or when Settings > Reading is set to "A static page" and Front page is selected.
 *
 * @link https://developer.wordpress.org/themes/basics/template-hierarchy/
 *
 * @package Custom_Theme
 */

get_header();
?>

<main id="primary" class="site-main">
    <!-- Hero Section -->
    <?php get_template_part('partials/banner'); ?>
    <!-- Portfolio Grid Section -->
    <section class="portfolio-grid">
        <div class="container">
            <h2 class="section-title"><?php echo pll_translate('Dự án'); ?></h2>
            <div class="grid-container">
                <?php
                // Query for all posts with featured images
                $projects_query = new WP_Query(array(
                    'post_type' => 'post',
                    'posts_per_page' => 6,
                    'orderby' => 'date',
                    'order' => 'DESC',
                ));
    
                if ($projects_query->have_posts()) :
                    while ($projects_query->have_posts()) : $projects_query->the_post();
                        $categories = get_the_category();
                        $category_slugs = array();
                        foreach ($categories as $cat) {
                            $category_slugs[] = $cat->slug;
                        }
                ?>
                    <article class="grid-item project-item">
                        <?php if (has_post_thumbnail()) : ?>
                            <?php the_post_thumbnail('large'); ?>
                        <?php endif; ?>
                        <div class="grid-content">
                            <h3 class="grid-title"><?php the_title(); ?></h3>
                            <div class="grid-subtitle">
                                <?php
                                if (!empty($categories)) {
                                    $category_names = array();
                                    foreach ($categories as $category) {
                                        $category_names[] = $category->name;
                                    }
                                    echo implode(' • ', $category_names);
                                }
                                ?>
                            </div>
                            <a href="<?php the_permalink(); ?>" class="read-more"><?php echo pll_translate('Xem chi tiết'); ?></a>
                        </div>
                    </article>
                <?php
                    endwhile;
                    wp_reset_postdata();
                endif;
                ?>
            </div>
        </div>
    </section>

    <!-- Studio Section -->
    <section class="studio-section">
        <div class="container">
            <h2 class="section-title"><?php echo pll_translate('Về chúng tôi'); ?></h2>
            <div class="studio-description">
                <p><?php echo pll_translate('Lorem ipsum dolor sit, amet consectetur adipisicing elit. Alias sit ipsum qui, unde ducimus vero similique rem tempora, nesciunt ipsam, mollitia quis consectetur sequi dolorum est illum doloribus quae suscipit!'); ?></p>
            </div>
            <?php 
            $about_page = get_page_by_path('about-us');
            $about_url = $about_page ? pll_get_post($about_page->ID) : null;
            $about_link = $about_url ? get_permalink($about_url) : pll_home_url() . '/about-us';
            ?>
            <a href="<?php echo $about_link; ?>" class="read-more" style="color: #000; border-color: #000;"><?php echo pll_translate('Xem thêm'); ?></a>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <h2 class="section-title"><?php echo pll_translate('Liên hệ'); ?></h2>
            <p style="margin-bottom: 2rem;"><?php echo pll_translate('Liên hệ với chúng tôi và cho chúng tôi biết về dự án của bạn.'); ?></p>
            <?php 
            $contact_page = get_page_by_path('contact-us');
            $contact_url = $contact_page ? pll_get_post($contact_page->ID) : null;
            $contact_link = $contact_url ? get_permalink($contact_url) : pll_home_url() . '/contact';
            ?>
            <a href="<?php echo $contact_link; ?>" class="contact-btn"><?php echo pll_translate('Liên hệ ngay'); ?></a>   
        </div>
     </section>
</main>

<?php
get_footer();
