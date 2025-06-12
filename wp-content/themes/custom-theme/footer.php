</div><!-- .content-area -->

    <footer class="site-footer">
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-section">
                    <?php if (is_active_sidebar('footer')): ?>
                        <?php dynamic_sidebar('footer'); ?>
                    <?php else: ?>
                        <p>Email: info@example.com</p>
                        <p>Phone: +1 (555) 123-4567</p>
                        <p>Address: 123 Main Street, City, Country</p>
                    <?php endif; ?>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; <?php echo date('Y'); ?> <?php bloginfo('name'); ?>. <?php _e('All Rights Reserved.', 'custom-theme'); ?></p>
            </div>
        </div>
    </footer>

    <?php wp_footer(); ?>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
</body>
</html>
