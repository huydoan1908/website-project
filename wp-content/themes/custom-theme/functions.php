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
            'footer' => esc_html__('Footer Menu', 'custom-theme'),
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
    wp_enqueue_style('custom-theme-style', get_template_directory_uri() . '/css/style.css');
    wp_enqueue_style('custom-theme-header', get_template_directory_uri() . '/css/header.css');
    wp_enqueue_style('custom-theme-footer', get_template_directory_uri() . '/css/footer.css');
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

    // Register footer widget areas
    register_sidebar(array(
        'name'          => esc_html__('Footer 1', 'custom-theme'),
        'id'            => 'footer-1',
        'description'   => esc_html__('Add widgets for footer area 1.', 'custom-theme'),
        'before_widget' => '<div id="%1$s" class="widget %2$s">',
        'after_widget'  => '</div>',
        'before_title'  => '<h3 class="widget-title">',
        'after_title'   => '</h3>',
    ));

    register_sidebar(array(
        'name'          => esc_html__('Footer 2', 'custom-theme'),
        'id'            => 'footer-2',
        'description'   => esc_html__('Add widgets for footer area 2.', 'custom-theme'),
        'before_widget' => '<div id="%1$s" class="widget %2$s">',
        'after_widget'  => '</div>',
        'before_title'  => '<h3 class="widget-title">',
        'after_title'   => '</h3>',
    ));
}
add_action('widgets_init', 'custom_theme_widgets_init');
