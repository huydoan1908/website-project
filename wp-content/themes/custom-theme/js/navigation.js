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
        
        // Trigger once on page load to handle refresh on scrolled position
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        }
    }
    
    // Add animation to grid items on front page
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1
    });
    
    document.querySelectorAll('.grid-item').forEach(item => {
        observer.observe(item);
    });
    
    document.querySelectorAll('.section-title').forEach(title => {
        observer.observe(title);
        title.classList.add('slide-up');
    });
});
