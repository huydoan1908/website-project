</div><!-- .content-area -->

    <footer class="site-footer">
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3><?php bloginfo('name'); ?></h3>
                    <?php if (is_active_sidebar('footer-1')): ?>
                        <?php dynamic_sidebar('footer-1'); ?>
                    <?php else: ?>
                        <p>We are a team of passionate professionals dedicated to delivering exceptional results.</p>
                    <?php endif; ?>
                </div>

                <div class="footer-section">
                    <h3><?php _e('Quick Links', 'custom-theme'); ?></h3>
                    <?php
                    wp_nav_menu(array(
                        'theme_location' => 'footer',
                        'menu_class' => 'footer-menu',
                        'container' => false,
                        'depth' => 1,
                        'fallback_cb' => function() {
                            echo '<ul class="footer-menu">
                                <li><a href="' . esc_url(home_url('/')) . '">Home</a></li>
                                <li><a href="' . esc_url(home_url('/about')) . '">About</a></li>
                                <li><a href="' . esc_url(home_url('/services')) . '">Services</a></li>
                                <li><a href="' . esc_url(home_url('/contact')) . '">Contact</a></li>
                            </ul>';
                        }
                    ));
                    ?>
                </div>

                <div class="footer-section">
                    <h3><?php _e('Contact Us', 'custom-theme'); ?></h3>
                    <?php if (is_active_sidebar('footer-2')): ?>
                        <?php dynamic_sidebar('footer-2'); ?>
                    <?php else: ?>
                        <p>Email: info@example.com</p>
                        <p>Phone: +1 (555) 123-4567</p>
                        <p>Address: 123 Main Street, City, Country</p>
                    <?php endif; ?>
                </div>

                <div class="footer-section">
                    <h3><?php _e('Follow Us', 'custom-theme'); ?></h3>
                    <div class="social-links">
                        <?php
                        $social_links = array(
                            'facebook' => '#',
                            'twitter' => '#',
                            'instagram' => '#',
                            'linkedin' => '#',
                        );

                        foreach ($social_links as $platform => $url) {
                            echo '<a href="' . esc_url($url) . '" target="_blank" rel="noopener noreferrer"><span class="dashicons dashicons-' . esc_attr($platform) . '"></span></a>';
                        }
                        ?>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; <?php echo date('Y'); ?> <?php bloginfo('name'); ?>. <?php _e('All Rights Reserved.', 'custom-theme'); ?></p>
            </div>
        </div>
    </footer>

    <?php wp_footer(); ?>
</body>
</html>
