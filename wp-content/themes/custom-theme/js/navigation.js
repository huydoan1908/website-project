/**
 * File navigation.js.
 *
 * Handles toggling the navigation menu for small screens.
 */
(function() {
    // Mobile menu toggle
    const siteNavigation = document.querySelector('.site-navigation');
    
    if (!siteNavigation) {
        return;
    }

    const button = document.createElement('button');
    button.classList.add('menu-toggle');
    button.setAttribute('aria-expanded', 'false');
    button.innerHTML = 'Menu <span></span>';
    
    siteNavigation.insertBefore(button, siteNavigation.firstChild);
    
    const menu = siteNavigation.querySelector('ul');
    
    menu.setAttribute('aria-expanded', 'false');
    menu.classList.add('nav-menu');
    
    button.addEventListener('click', function() {
        siteNavigation.classList.toggle('toggled');
        
        if (button.getAttribute('aria-expanded') === 'true') {
            button.setAttribute('aria-expanded', 'false');
            menu.setAttribute('aria-expanded', 'false');
        } else {
            button.setAttribute('aria-expanded', 'true');
            menu.setAttribute('aria-expanded', 'true');
        }
    });
    
    // Close the menu when clicking outside
    document.addEventListener('click', function(event) {
        const isClickInside = siteNavigation.contains(event.target);
        
        if (!isClickInside && siteNavigation.classList.contains('toggled')) {
            siteNavigation.classList.remove('toggled');
            button.setAttribute('aria-expanded', 'false');
            menu.setAttribute('aria-expanded', 'false');
        }
    });
})();
