/**
 * Projects Page JavaScript
 * Handles category filtering and load more functionality
 */

document.addEventListener('DOMContentLoaded', function() {
    
    // Category Filter Functionality
    const categoryButtons = document.querySelectorAll('.category-btn');
    let projectItems = document.querySelectorAll('.project-item');
    
    categoryButtons.forEach(button => {
        button.addEventListener('click', function() {
            const selectedCategory = this.getAttribute('data-category');
            
            // Don't do anything if this category is already active
            if (this.classList.contains('active')) return;
            
            // Show loading state
            showLoadingState();
            
            // Update active button
            categoryButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Load projects for selected category via API
            loadProjectsByCategory(selectedCategory);
        });
    });
    
    function loadProjectsByCategory(category) {
        // Reset pagination when changing category
        currentPage = 1;
        
        // Make AJAX call to load projects for this category
        fetch(ajax_object.ajax_url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                action: 'load_more_projects',
                category: category,
                page: 1,
                nonce: ajax_object.nonce
            })
        })
        .then(response => response.text())
        .then(data => {
            if (data.trim()) {
                const grid = document.querySelector('.grid-container');
                
                // Clear existing items
                grid.innerHTML = '';
                
                // Add new items
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = data;
                const newItems = tempDiv.querySelectorAll('.project-item');
                
                newItems.forEach((item, index) => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(30px)';
                    grid.appendChild(item);
                    
                    setTimeout(() => {
                        item.style.transition = 'all 0.6s ease';
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }, index * 100);
                });
                
                // Update projectItems collection
                projectItems = document.querySelectorAll('.project-item');
                
                // Hide loading and update UI
                setTimeout(() => {
                    hideLoadingState();
                    updateLoadMoreButton();
                }, Math.max(newItems.length * 100, 500));
                
            } else {
                // No projects found
                const grid = document.querySelector('.grid-container');
                grid.innerHTML = '<p class="no-projects">' + ajax_object.strings.no_projects + '</p>';
                hideLoadingState();
                updateLoadMoreButton();
            }
        })
        .catch(error => {
            console.error('Error loading projects:', error);
            hideLoadingState();
            
            // Show error message
            const grid = document.querySelector('.grid-container');
            grid.innerHTML = '<p class="no-projects">Lỗi tải dữ liệu. Vui lòng thử lại.</p>';
        });
    }
    
    // Keep the old filterProjects function for backward compatibility (if needed)
    function filterProjects(category) {
        // This function is now replaced by loadProjectsByCategory
        // but kept for any potential backward compatibility
        loadProjectsByCategory(category);
    }
    
    function showLoadingState() {
        const grid = document.querySelector('.grid-container');
        const loadingOverlay = document.getElementById('category-loading');
        
        if (!loadingOverlay) {
            // Create loading overlay if it doesn't exist
            const overlay = document.createElement('div');
            overlay.id = 'category-loading';
            overlay.innerHTML = `
                <div class="loading-spinner">
                    <div class="spinner"></div>
                    <p>Loading...</p>
                </div>
            `;
            grid.parentNode.appendChild(overlay);
        }
        
        // Show overlay and add loading class to grid
        document.getElementById('category-loading').style.display = 'flex';
        grid.classList.add('loading');
        
        // Disable category buttons during loading
        categoryButtons.forEach(btn => {
            btn.disabled = true;
            btn.style.opacity = '0.6';
        });
    }
    
    function hideLoadingState() {
        const grid = document.querySelector('.grid-container');
        const loadingOverlay = document.getElementById('category-loading');
        
        if (loadingOverlay) {
            loadingOverlay.style.display = 'none';
        }
        
        grid.classList.remove('loading');
        
        // Re-enable category buttons
        categoryButtons.forEach(btn => {
            btn.disabled = false;
            btn.style.opacity = '1';
        });
    }
    
    function updateGridLayout() {
        const grid = document.querySelector('.grid-container');
        if (grid) {
            // Force a reflow to update grid layout
            grid.style.display = 'none';
            grid.offsetHeight; // Trigger reflow
            grid.style.display = 'grid';
        }
    }
    
    function updateLoadMoreButton() {
        const loadMoreBtn = document.getElementById('load-more-projects');
        const activeBtn = document.querySelector('.category-btn.active');
        const currentCategory = activeBtn ? activeBtn.getAttribute('data-category') : 'all';
        
        if (loadMoreBtn) {
            // Reset to initial state when category changes
            loadMoreBtn.textContent = ajax_object.strings.load_more;
            loadMoreBtn.disabled = false;
            loadMoreBtn.style.display = 'inline-block';
            isLoading = false;
        }
    }
    
    // Load More Functionality
    const loadMoreBtn = document.getElementById('load-more-projects');
    let currentPage = 1;
    let isLoading = false;
    
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function() {
            if (isLoading) return;
            
            isLoading = true;
            this.textContent = ajax_object.strings.loading;
            this.disabled = true;
            
            // Simulate loading delay (replace with actual AJAX call)
            setTimeout(() => {
                loadMoreProjects();
            }, 1000);
        });
    }
    
    function loadMoreProjects() {
        // Get current active category
        const activeBtn = document.querySelector('.category-btn.active');
        const currentCategory = activeBtn ? activeBtn.getAttribute('data-category') : 'all';
        
        fetch(ajax_object.ajax_url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                action: 'load_more_projects',
                page: currentPage + 1,
                category: currentCategory,
                nonce: ajax_object.nonce
            })
        })
        .then(response => response.text())
        .then(data => {
            if (data.trim()) {
                const grid = document.querySelector('.grid-container');
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = data;
                
                // Add new items with animation
                const newItems = tempDiv.querySelectorAll('.project-item');
                newItems.forEach((item, index) => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(30px)';
                    grid.appendChild(item);
                    
                    setTimeout(() => {
                        item.style.transition = 'all 0.6s ease';
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }, index * 100);
                });
                
                // Update projectItems collection to include new items
                projectItems = document.querySelectorAll('.project-item');
                
                currentPage++;
                
                // Reset load more button
                loadMoreBtn.textContent = ajax_object.strings.load_more;
                loadMoreBtn.disabled = false;
                isLoading = false;
            } else {
                // No more projects to load
                loadMoreBtn.textContent = ajax_object.strings.no_more;
                loadMoreBtn.disabled = true;
                setTimeout(() => {
                    loadMoreBtn.style.display = 'none';
                }, 2000);
            }
        })
        .catch(error => {
            console.error('Error loading more projects:', error);
            loadMoreBtn.textContent = ajax_object.strings.error;
            setTimeout(() => {
                loadMoreBtn.textContent = ajax_object.strings.load_more;
                loadMoreBtn.disabled = false;
                isLoading = false;
            }, 2000);
        });
    }
    
    // Smooth scrolling for project links
    document.querySelectorAll('.project-link').forEach(link => {
        link.addEventListener('click', function(e) {
            // Add a subtle loading effect
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });
    });
    
    // Lazy loading for images
    const images = document.querySelectorAll('.project-thumb');
    
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.style.opacity = '0';
                img.style.transition = 'opacity 0.5s ease';
                
                img.onload = function() {
                    this.style.opacity = '1';
                };
                
                observer.unobserve(img);
            }
        });
    });
    
    images.forEach(img => {
        imageObserver.observe(img);
    });
    
    // Add hover effects for better UX
    projectItems.forEach(item => {
        const overlay = item.querySelector('.project-overlay');
        const link = item.querySelector('.project-link');
        
        item.addEventListener('mouseenter', function() {
            if (overlay && link) {
                link.style.transform = 'scale(0.8) rotate(5deg)';
                setTimeout(() => {
                    link.style.transform = 'scale(1) rotate(0deg)';
                }, 150);
            }
        });
    });
    
    // Keyboard navigation for category buttons
    categoryButtons.forEach((button, index) => {
        button.addEventListener('keydown', function(e) {
            if (e.key === 'ArrowLeft' && index > 0) {
                categoryButtons[index - 1].focus();
            } else if (e.key === 'ArrowRight' && index < categoryButtons.length - 1) {
                categoryButtons[index + 1].focus();
            } else if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                this.click();
            }
        });
    });
    
    // Initialize with "all" category active if no specific category is set
    const activeBtn = document.querySelector('.category-btn.active');
    if (activeBtn) {
        const initialCategory = activeBtn.getAttribute('data-category');
        if (initialCategory !== 'all') {
            filterProjects(initialCategory);
        }
    }
});

// Utility function for smooth animations
function animateElement(element, animation, duration = 300) {
    return new Promise(resolve => {
        element.style.animation = `${animation} ${duration}ms ease forwards`;
        setTimeout(resolve, duration);
    });
}

// Add to window for potential external use
window.ProjectsPage = {
    filterProjects: function(category) {
        const button = document.querySelector(`[data-category="${category}"]`);
        if (button && !button.disabled) {
            button.click();
        }
    },
    
    getCurrentCategory: function() {
        const activeBtn = document.querySelector('.category-btn.active');
        return activeBtn ? activeBtn.getAttribute('data-category') : 'all';
    },
    
    isLoading: function() {
        const loadingOverlay = document.getElementById('category-loading');
        return loadingOverlay ? loadingOverlay.style.display === 'flex' : false;
    }
};
