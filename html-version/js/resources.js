document.addEventListener('DOMContentLoaded', function() {
    // Navigation drawer functionality
    const navMenuBtn = document.querySelector('.nav-menu-btn');
    const navDrawer = document.getElementById('navDrawer');
    const drawerItems = document.querySelectorAll('.drawer-item');

    // Toggle navigation drawer
    navMenuBtn.addEventListener('click', function() {
        navDrawer.classList.toggle('open');
    });

    // Close drawer when clicking outside
    document.addEventListener('click', function(e) {
        if (!navDrawer.contains(e.target) && !navMenuBtn.contains(e.target)) {
            navDrawer.classList.remove('open');
        }
    });

    // Navigation item clicks
    drawerItems.forEach(item => {
        item.addEventListener('click', function() {
            const page = this.getAttribute('data-page');
            if (page && page !== 'resources') {
                window.location.href = `../pages/${page}.html`;
            }
        });
    });

    // Resource card expand/collapse functionality
    const qualityHeader = document.getElementById('qualityHeader');
    const qualityContent = document.getElementById('qualityContent');
    const riskHeader = document.getElementById('riskHeader');
    const riskContent = document.getElementById('riskContent');

    // Quality card toggle
    qualityHeader.addEventListener('click', function() {
        const isExpanded = qualityContent.classList.contains('expanded');
        
        if (isExpanded) {
            // Collapse
            qualityContent.classList.remove('expanded');
            qualityHeader.classList.add('collapsed');
        } else {
            // Expand
            qualityContent.classList.add('expanded');
            qualityHeader.classList.remove('collapsed');
        }
    });

    // Risk Adjustments card toggle
    riskHeader.addEventListener('click', function() {
        const isExpanded = riskContent.classList.contains('expanded');
        
        if (isExpanded) {
            // Collapse
            riskContent.classList.remove('expanded');
            riskHeader.classList.add('collapsed');
        } else {
            // Expand
            riskContent.classList.add('expanded');
            riskHeader.classList.remove('collapsed');
        }
    });

    // Search functionality for Quality items
    const qualitySearchInput = qualityContent.querySelector('.search-input');
    const qualityItems = qualityContent.querySelectorAll('.item');

    qualitySearchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        qualityItems.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });

    // Search functionality for Risk Adjustments items
    const riskSearchInput = riskContent.querySelector('.search-input');
    const riskItems = riskContent.querySelectorAll('.item');

    riskSearchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        riskItems.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });

    // Item click functionality
    const allItems = document.querySelectorAll('.item');
    
    allItems.forEach(item => {
        item.addEventListener('click', function() {
            // Check if this is an expandable item
            if (this.classList.contains('expandable')) {
                const isExpanded = this.classList.contains('expanded');
                
                if (isExpanded) {
                    // Collapse
                    this.classList.remove('expanded');
                } else {
                    // Expand
                    this.classList.add('expanded');
                }
                
                console.log('Toggled expandable item:', this.querySelector('.item-header span').textContent);
            } else {
                // Regular item click
                console.log('Clicked item:', this.textContent);
                alert(`Selected: ${this.textContent}`);
            }
        });
    });

    // Initialize cards as collapsed by default
    qualityHeader.classList.add('collapsed');
    riskHeader.classList.add('collapsed');
});

// Logout function
function logout() {
    console.log('Opening logout dialog...');
    showLogoutDialog();
}

// Show logout dialog
function showLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

// Close logout dialog
function closeLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

// Confirm logout
function confirmLogout() {
    console.log('Logging out...');
    // Clear session data and redirect to login
    window.location.href = 'login.html';
} 