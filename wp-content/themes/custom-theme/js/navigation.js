document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.querySelector('.menu-toggle');
    const siteNavigation = document.querySelector('.site-navigation');

    if (menuToggle && siteNavigation) {
        menuToggle.addEventListener('click', function() {
            siteNavigation.classList.toggle('active');
            menuToggle.setAttribute('aria-expanded', 
                menuToggle.getAttribute('aria-expanded') === 'true' ? 'false' : 'true'
            );
        });
    }

    // Close menu when clicking outside
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.site-navigation') && 
            !event.target.closest('.menu-toggle') && 
            siteNavigation.classList.contains('active')) {
            siteNavigation.classList.remove('active');
            menuToggle.setAttribute('aria-expanded', 'false');
        }
    });

    // Add scroll class to header
    const header = document.querySelector('.site-header');
    if (header) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }
});
