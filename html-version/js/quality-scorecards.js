// Quality Score Cards JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Pagination elements
    const pageSizeSelect = document.getElementById('pageSizeSelect');
    const pageInfo = document.getElementById('pageInfo');
    const firstPageBtn = document.getElementById('firstPage');
    const prevPageBtn = document.getElementById('prevPage');
    const nextPageBtn = document.getElementById('nextPage');
    const lastPageBtn = document.getElementById('lastPage');
    
    // Table elements
    const scorecardsTable = document.querySelector('.scorecards-table tbody');
    const tableRows = scorecardsTable.querySelectorAll('tr');
    
    // Pagination state
    let currentPage = 0;
    let rowsPerPage = 15;
    const totalItems = tableRows.length;
    
    // Navigation drawer functionality
    const navDrawer = document.getElementById('navDrawer');
    const navMenuBtn = document.querySelector('.nav-menu-btn');
    
    // Profile dropdown functionality
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');
    
    // Toggle profile dropdown
    profileBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        profileDropdown.classList.toggle('show');
    });
    
    // Close profile dropdown when clicking outside
    document.addEventListener('click', function(event) {
        if (!profileBtn.contains(event.target) && !profileDropdown.contains(event.target)) {
            profileDropdown.classList.remove('show');
        }
    });
    
    // Handle profile dropdown options
    const profileOptions = document.querySelectorAll('.profile-option');
    profileOptions.forEach(option => {
        option.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            handleProfileAction(action);
            profileDropdown.classList.remove('show');
        });
    });
    
    // Handle profile actions
    function handleProfileAction(action) {
        switch(action) {
            case 'language':
                console.log('Language option clicked');
                // Add language change functionality here
                break;
            case 'invitations':
                console.log('Invitations clicked');
                window.location.href = 'invitation.html';
                break;
            case 'logout':
                showLogoutDialog();
                break;
            default:
                console.log('Unknown profile action:', action);
        }
    }
    
    // Notifications functionality
    initializeNotifications();
    
    // Open navigation drawer
    navMenuBtn.addEventListener('click', function() {
        navDrawer.classList.add('open');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    });
    
    // Close drawer when clicking outside
    document.addEventListener('click', function(event) {
        if (!navDrawer.contains(event.target) && !navMenuBtn.contains(event.target)) {
            closeDrawer();
        }
    });
    
    // Close on escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && navDrawer.classList.contains('open')) {
            closeDrawer();
        }
    });
    
    // Handle drawer items
    const drawerItems = document.querySelectorAll('.drawer-item');
    drawerItems.forEach(item => {
        item.addEventListener('click', () => {
            const page = item.getAttribute('data-page');
            
            // Remove active class from all items
            document.querySelectorAll('.drawer-item').forEach(drawerItem => {
                drawerItem.classList.remove('active');
            });
            
            // Add active class to clicked item
            item.classList.add('active');
            
            // Close drawer after selection
            closeDrawer();
            
            // Navigate to page if it has a data-page attribute
            if (page) {
                navigateToPage(page);
            }
            
            console.log('Navigation clicked:', item.querySelector('.drawer-text').textContent);
        });
    });
    
    // Navigation function
    function navigateToPage(page) {
        switch(page) {
            case 'dashboard':
                window.location.href = 'dashboard.html';
                break;
            case 'patients':
                window.location.href = 'patients.html';
                break;
            case 'quality-scorecards':
                window.location.href = 'quality-scorecards.html';
                break;
            case 'reports':
                window.location.href = 'reports.html';
                break;
            case 'resources':
                window.location.href = 'resources.html';
                break;
            default:
                console.log('Page not implemented yet:', page);
        }
    }
    
    // Close drawer function
    function closeDrawer() {
        navDrawer.classList.remove('open');
        document.body.style.overflow = ''; // Restore scrolling
    }
    
    // Initialize pagination
    function initializePagination() {
        updatePagination();
        updateTableVisibility();
    }
    
    // Update pagination controls
    function updatePagination() {
        const totalPages = Math.ceil(totalItems / rowsPerPage);
        const startIndex = currentPage * rowsPerPage + 1;
        const endIndex = Math.min((currentPage + 1) * rowsPerPage, totalItems);
        
        // Update page info
        pageInfo.textContent = `${startIndex}-${endIndex} of ${totalItems}`;
        
        // Update button states
        firstPageBtn.disabled = currentPage === 0;
        prevPageBtn.disabled = currentPage === 0;
        nextPageBtn.disabled = currentPage >= totalPages - 1;
        lastPageBtn.disabled = currentPage >= totalPages - 1;
        
        // Update button colors
        updateButtonColors();
    }
    
    // Update button colors based on disabled state
    function updateButtonColors() {
        [firstPageBtn, prevPageBtn, nextPageBtn, lastPageBtn].forEach(btn => {
            if (btn.disabled) {
                btn.style.color = '#ccc';
            } else {
                btn.style.color = '#333';
            }
        });
    }
    
    // Update table visibility based on current page
    function updateTableVisibility() {
        const startIndex = currentPage * rowsPerPage;
        const endIndex = Math.min(startIndex + rowsPerPage, totalItems);
        
        tableRows.forEach((row, index) => {
            if (index >= startIndex && index < endIndex) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
    
    // Pagination event listeners
    firstPageBtn.addEventListener('click', function() {
        if (!this.disabled) {
            currentPage = 0;
            updatePagination();
            updateTableVisibility();
        }
    });
    
    prevPageBtn.addEventListener('click', function() {
        if (!this.disabled) {
            currentPage--;
            updatePagination();
            updateTableVisibility();
        }
    });
    
    nextPageBtn.addEventListener('click', function() {
        if (!this.disabled) {
            currentPage++;
            updatePagination();
            updateTableVisibility();
        }
    });
    
    lastPageBtn.addEventListener('click', function() {
        if (!this.disabled) {
            const totalPages = Math.ceil(totalItems / rowsPerPage);
            currentPage = totalPages - 1;
            updatePagination();
            updateTableVisibility();
        }
    });
    
    // Page size change
    pageSizeSelect.addEventListener('change', function() {
        rowsPerPage = parseInt(this.value);
        currentPage = 0; // Reset to first page
        updatePagination();
        updateTableVisibility();
    });
    
    // Initialize the page
    initializePagination();
    
    // Add hover effects for better UX
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#f8f9fa';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '';
        });
    });
    
    // Keyboard navigation for pagination
    document.addEventListener('keydown', function(event) {
        if (event.key === 'ArrowLeft' && !prevPageBtn.disabled) {
            prevPageBtn.click();
        } else if (event.key === 'ArrowRight' && !nextPageBtn.disabled) {
            nextPageBtn.click();
        }
    });
    
    // Initialize searchable dropdown
    initializeSearchableDropdown();
    
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
    // Here you would typically clear any stored authentication tokens
    // and redirect to the login page
    
    // For now, we'll just redirect to the login page
    window.location.href = '../pages/login.html';
}

// Searchable Dropdown Functionality
function initializeSearchableDropdown() {
    const dropdown = document.getElementById('searchableDropdown');
    const trigger = document.getElementById('dropdownTrigger');
    const menu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const options = document.querySelectorAll('.dropdown-option');
    const selectedText = document.getElementById('selectedText');
    
    let isOpen = false;
    
    // Toggle dropdown
    trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        toggleDropdown();
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target)) {
            closeDropdown();
        }
    });
    
    // Handle search input
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        filterOptions(searchTerm);
    });
    
    // Handle option selection
    options.forEach(option => {
        option.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            const text = this.querySelector('.option-text').textContent;
            
            // Update selected option
            updateSelectedOption(value, text);
            
            // Close dropdown
            closeDropdown();
            
            // Clear search
            searchInput.value = '';
            showAllOptions();
            
            // Trigger change event
            updateQualityScorecardsData(value, text);
        });
    });
    
    // Handle keyboard navigation
    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeDropdown();
        } else if (e.key === 'Enter') {
            e.preventDefault();
            const visibleOptions = document.querySelectorAll('.dropdown-option:not(.hidden)');
            if (visibleOptions.length > 0) {
                visibleOptions[0].click();
            }
        }
    });
    
    function toggleDropdown() {
        if (isOpen) {
            closeDropdown();
        } else {
            openDropdown();
        }
    }
    
    function openDropdown() {
        menu.classList.add('show');
        trigger.classList.add('active');
        searchInput.focus();
        isOpen = true;
    }
    
    function closeDropdown() {
        menu.classList.remove('show');
        trigger.classList.remove('active');
        isOpen = false;
    }
    
    function filterOptions(searchTerm) {
        options.forEach(option => {
            const text = option.querySelector('.option-text').textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                option.classList.remove('hidden');
            } else {
                option.classList.add('hidden');
            }
        });
    }
    
    function showAllOptions() {
        options.forEach(option => {
            option.classList.remove('hidden');
        });
    }
    
    function updateSelectedOption(value, text) {
        // Remove previous selection
        options.forEach(option => {
            option.classList.remove('selected');
            option.setAttribute('data-selected', 'false');
        });
        
        // Add selection to new option
        const selectedOption = document.querySelector(`[data-value="${value}"]`);
        if (selectedOption) {
            selectedOption.classList.add('selected');
            selectedOption.setAttribute('data-selected', 'true');
        }
        
        // Update display text
        selectedText.textContent = text;
    }
}

// Update Quality Scorecards Data (placeholder function)
function updateQualityScorecardsData(provider, providerText) {
    // This function would typically:
    // 1. Make API calls to fetch new data for the selected provider
    // 2. Update the quality scorecards table
    // 3. Update the KPI metrics
    // 4. Update any charts or visualizations
    
    console.log('Updating quality scorecards data for:', providerText);
    
    // Show a success message
    showSuccess(`Quality scorecards updated for ${providerText}`);
}

// Notifications Functions
function initializeNotifications() {
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    const markAllReadBtn = document.getElementById('markAllReadBtn');
    const notificationItems = document.querySelectorAll('.notification-item');
    const notificationBadge = document.getElementById('notificationBadge');
    
    // Toggle notifications dropdown
    if (notificationBtn) {
        notificationBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            notificationsDropdown.classList.toggle('show');
        });
    }
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!notificationBtn.contains(e.target) && !notificationsDropdown.contains(e.target)) {
            notificationsDropdown.classList.remove('show');
        }
    });
    
    // Mark all as read
    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', function() {
            notificationItems.forEach(item => {
                item.classList.remove('unread');
            });
            updateNotificationBadge();
        });
    }
    
    // Individual notification actions
    notificationItems.forEach(item => {
        const closeBtn = item.querySelector('.notification-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                const id = this.getAttribute('data-id');
                removeNotification(id);
            });
        }
        
        // Mark as read on click
        item.addEventListener('click', function() {
            this.classList.remove('unread');
            updateNotificationBadge();
        });
    });
    
    updateNotificationBadge();
}

function removeNotification(id) {
    const notification = document.querySelector(`[data-id="${id}"]`);
    if (notification) {
        notification.remove();
        updateNotificationBadge();
    }
}

function updateNotificationBadge() {
    const unreadNotifications = document.querySelectorAll('.notification-item.unread');
    const badge = document.getElementById('notificationBadge');
    
    if (unreadNotifications.length > 0) {
        badge.textContent = unreadNotifications.length;
        badge.style.display = 'block';
    } else {
        badge.style.display = 'none';
    }
}

// Utility Functions
function showSuccess(message) {
    const successDiv = document.createElement('div');
    successDiv.textContent = message;
    successDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4caf50;
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        z-index: 1000;
        animation: slideInRight 0.3s ease-out;
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
    `;
    
    document.body.appendChild(successDiv);
    
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
}

function showLogoutDialog() {
    const dialog = document.getElementById('logoutDialog');
    if (dialog) {
        dialog.classList.add('show');
    }
}

// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
`;
document.head.appendChild(style); 