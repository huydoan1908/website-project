<?php
/**
 * Theme functions and definitions
 */

if (!function_exists('custom_theme_setup')) :
    /**
     * Sets up theme defaults and registers support for various WordPress features.
     */
    function custom_theme_setup() {
        // Add default posts and comments RSS feed links to head.
        add_theme_support('automatic-feed-links');

        // Let WordPress manage the document title.
        add_theme_support('title-tag');

        // Enable support for Post Thumbnails on posts and pages.
        add_theme_support('post-thumbnails');

        // Register menu
        register_nav_menus(array(
            'primary' => esc_html__('Primary Menu', 'custom-theme'),
        ));

        // Switch default core markup to output valid HTML5.
        add_theme_support('html5', array(
            'search-form',
            'comment-form',
            'comment-list',
            'gallery',
            'caption',
        ));

        // Set up the WordPress core custom background feature.
        add_theme_support('custom-background', apply_filters('custom_theme_custom_background_args', array(
            'default-color' => 'ffffff',
            'default-image' => '',
        )));

        // Add theme support for selective refresh for widgets.
        add_theme_support('customize-selective-refresh-widgets');

        // Add support for core custom logo.
        add_theme_support('custom-logo', array(
            'height'      => 250,
            'width'       => 250,
            'flex-width'  => true,
            'flex-height' => true,
        ));
    }
endif;
add_action('after_setup_theme', 'custom_theme_setup');

/**
 * Enqueue scripts and styles.
 */
function custom_theme_scripts() {
    // Core CSS files - loaded in order
    wp_enqueue_style('custom-theme-variables', get_template_directory_uri() . '/css/variables.css', array(), '1.1');
    wp_enqueue_style('custom-theme-reset', get_template_directory_uri() . '/css/reset.css', array('custom-theme-variables'), '1.1');
    wp_enqueue_style('custom-theme-utilities', get_template_directory_uri() . '/css/utilities.css', array('custom-theme-variables'), '1.1');
    wp_enqueue_style('custom-theme-components', get_template_directory_uri() . '/css/components.css', array('custom-theme-reset', 'custom-theme-utilities'), '1.1');
    wp_enqueue_style('custom-theme-header', get_template_directory_uri() . '/css/header.css', array('custom-theme-components'), '1.1');
    wp_enqueue_style('custom-theme-footer', get_template_directory_uri() . '/css/footer.css', array('custom-theme-components'), '1.1');
    wp_enqueue_style('custom-theme-hero', get_template_directory_uri() . '/css/hero.css', array('custom-theme-components'), '1.1');
    
    // Add front-page CSS only on the front page
    if (is_front_page()) {
        wp_enqueue_style('custom-theme-front-page', get_template_directory_uri() . '/css/front-page.css', array('custom-theme-components'), '1.1');
    }
    
    // Add projects CSS and JS only on projects page
    if (is_page_template('projects-template.php') || is_page('projects') || is_page('du-an')) {
        wp_enqueue_style('custom-theme-projects', get_template_directory_uri() . '/css/projects.css', array('custom-theme-components'), '1.1');
        wp_enqueue_script('custom-theme-projects', get_template_directory_uri() . '/js/projects.js', array('jquery'), '1.0', true);
        
        // Localize script for AJAX
        wp_localize_script('custom-theme-projects', 'ajax_object', array(
            'ajax_url' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('load_more_projects_nonce'),
            'strings' => array(
                'no_projects' => pll_translate('Không có dự án nào được tìm thấy.'),
                'load_more' => pll_translate('Xem thêm dự án'),
                'loading' => pll_translate('Đang tải...'),
                'no_more' => pll_translate('Không còn dự án nào'),
                'error' => pll_translate('Lỗi tải dữ liệu')
            )
        ));
    }
    
    wp_enqueue_style('dashicons');
    
    wp_enqueue_script('custom-theme-navigation', get_template_directory_uri() . '/js/navigation.js', array(), '20151215', true);

    if (is_singular() && comments_open() && get_option('thread_comments')) {
        wp_enqueue_script('comment-reply');
    }
}
add_action('wp_enqueue_scripts', 'custom_theme_scripts');

/**
 * Register widget area.
 */
function custom_theme_widgets_init() {
    register_sidebar(array(
        'name'          => esc_html__('Sidebar', 'custom-theme'),
        'id'            => 'sidebar-1',
        'description'   => esc_html__('Add widgets here.', 'custom-theme'),
        'before_widget' => '<section id="%1$s" class="widget %2$s">',
        'after_widget'  => '</section>',
        'before_title'  => '<h2 class="widget-title">',
        'after_title'   => '</h2>',
    ));

    register_sidebar(array(
        'name'          => esc_html__('Footer', 'custom-theme'),
        'id'            => 'footer',
        'description'   => esc_html__('Add widgets for footer area', 'custom-theme'),
        'before_widget' => '<div id="%1$s" class="widget %2$s">',
        'after_widget'  => '</div>',
        'before_title'  => '<h3 class="widget-title">',
        'after_title'   => '</h3>',
    ));
}
add_action('widgets_init', 'custom_theme_widgets_init');

/**
 * AJAX handler for loading more projects
 */
function load_more_projects_ajax() {
    // Verify nonce
    // if (!wp_verify_nonce($_POST['nonce'], 'load_more_projects_nonce')) {
    //     wp_die('Security check failed');
    // }
    
    $page = intval($_POST['page']);
    $category = sanitize_text_field($_POST['category']);
    
    // Build query args
    $query_args = array(
        'post_type' => 'post',
        'posts_per_page' => 9,
        'paged' => $page,
        'orderby'   => 'date', // Sort by the post_date column
        'order'     => 'DESC'
    );
    
    // Add category filter if not 'all'
    if ($category && $category !== 'all') {
        $query_args['category_name'] = $category;
    }
    
    $projects_query = new WP_Query($query_args);
    
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
    endif;
    
    wp_die(); // Always end AJAX handlers with wp_die()
}
add_action('wp_ajax_load_more_projects', 'load_more_projects_ajax');
add_action('wp_ajax_nopriv_load_more_projects', 'load_more_projects_ajax');

/**
 * Register strings for Polylang translation
 */
function register_polylang_strings() {
    if (function_exists('pll_register_string')) {
        // Home Page strings group
        pll_register_string('home_projects_title', 'Dự án', 'Home');
        pll_register_string('home_about_title', 'Về chúng tôi', 'Home');
        pll_register_string('home_about_description', 'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Alias sit ipsum qui, unde ducimus vero similique rem tempora, nesciunt ipsam, mollitia quis consectetur sequi dolorum est illum doloribus quae suscipit!', 'Home');
        pll_register_string('home_about_read_more', 'Xem thêm', 'Home');
        pll_register_string('home_contact_title', 'Liên hệ', 'Home');
        pll_register_string('home_contact_description', 'Liên hệ với chúng tôi và cho chúng tôi biết về dự án của bạn.', 'Home');
        pll_register_string('home_contact_button', 'Liên hệ ngay', 'Home');
        pll_register_string('home_read_more', 'Xem chi tiết', 'Home');
        
        // Projects Page strings group
        pll_register_string('projects_main_title', 'DỰ ÁN THỰC HIỆN', 'Projects');
        pll_register_string('projects_filter_all', 'TẤT CẢ', 'Projects');
        pll_register_string('projects_read_more', 'Xem chi tiết', 'Projects');
        pll_register_string('projects_no_found', 'Không có dự án nào được tìm thấy.', 'Projects');
        pll_register_string('projects_load_more', 'Xem thêm dự án', 'Projects');
        pll_register_string('projects_loading', 'Đang tải...', 'Projects');
        pll_register_string('projects_no_more', 'Không còn dự án nào', 'Projects');
        pll_register_string('projects_error', 'Lỗi tải dữ liệu', 'Projects');
    }
}
add_action('init', 'register_polylang_strings');

/**
 * Helper function for Polylang translations with fallback
 */
function pll_translate($string, $fallback = '') {
    if (function_exists('pll__')) {
        $translation = pll__($string);
        return !empty($translation) ? $translation : ($fallback ?: $string);
    }
    return $fallback ?: $string;
}
