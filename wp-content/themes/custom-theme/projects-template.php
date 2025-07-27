<?php 
/**
 * Template Name: Projects Page
 * 
 * This template displays a portfolio of projects/posts organized by categories.
 * It includes:
 * - Hero banner section
 * - Category filter navigation
 * - Responsive project grid
 * - AJAX load more functionality
 * - Smooth animations and hover effects
 * 
 * To use this template:
 * 1. Create a new page in WordPress admin
 * 2. Set the page template to "Projects Page"
 * 3. Add banner content using ACF fields (banner_image, banner_content)
 * 4. Make sure your posts have featured images and are assigned to categories
 */

get_header(); ?>

<main id="main" class="site-main">
    <?php get_template_part('partials/banner'); ?>
    <div class="container">
        <section class="projects-section">
            <div class="projects-content">
                <h2 class="section-title"><?php echo pll_translate('DỰ ÁN THỰC HIỆN'); ?></h2>
                
                <!-- Project Categories Navigation -->
                <div class="project-categories">
                    <button class="category-btn active" data-category="all"><?php echo pll_translate('TẤT CẢ'); ?></button>
                    <?php
                    // Get all categories that have posts
                    $categories = get_categories(array(
                        'hide_empty' => true,
                        'exclude' => array(1) // Exclude uncategorized
                    ));
                    
                    foreach ($categories as $category) {
                        echo '<button class="category-btn" data-category="' . $category->slug . '">' . mb_strtoupper($category->name) . '</button>';
                    }
                    ?>
                </div>

                <!-- Projects Grid -->
                <div class="portfolio-grid">
                    <div class="grid-container">
                        <?php
                        // Query for all posts with featured images
                        $projects_query = new WP_Query(array(
                            'post_type' => 'post',
                            'posts_per_page' => 9,
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
                                $category_classes = implode(' ', $category_slugs);
                        ?>
                            <article class="grid-item project-item" data-categories="<?php echo esc_attr($category_classes); ?>">
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
                        else :
                        ?>
                            <p class="no-projects"><?php echo pll_translate('Không có dự án nào được tìm thấy.'); ?></p>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Load More Button -->
                <div class="load-more-wrapper">
                    <button class="load-more-btn" id="load-more-projects"><?php echo pll_translate('Xem thêm dự án'); ?></button>
                </div>
            </div>
        </section>
    </div>
</main>

<?php get_footer(); ?>
