// Patients Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Filter modal elements
    const filterModal = document.getElementById('filterModal');
    const filterBtn = document.querySelector('.filter-btn');
    const filterModalClose = document.getElementById('filterModalClose');
    const filterClear = document.getElementById('filterClear');
    const filterApply = document.getElementById('filterApply');
    
    // Filter form elements
    const mcoFilter = document.getElementById('mcoFilter');
    const providerFilter = document.getElementById('providerFilter');
    const dobFilter = document.getElementById('dobFilter');
    
    // Table elements
    const patientsTable = document.querySelector('.patients-table tbody');
    const tableRows = patientsTable.querySelectorAll('tr');
    
    // Current filter state
    let currentFilters = {
        mco: '',
        provider: '',
        dob: ''
    };
    
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
    
    // Profile button functionality
    if (profileBtn) {
        profileBtn.addEventListener('click', () => {
            console.log('Profile button clicked');
            // TODO: Implement profile menu
        });
    }
    
    // Close drawer function
    function closeDrawer() {
        navDrawer.classList.remove('open');
        document.body.style.overflow = ''; // Restore scrolling
    }
    
    // Filter modal functionality
    filterBtn.addEventListener('click', function() {
        filterModal.classList.add('show');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    });
    
    function closeFilterModal() {
        filterModal.classList.remove('show');
        document.body.style.overflow = ''; // Restore scrolling
    }
    
    filterModalClose.addEventListener('click', closeFilterModal);
    
    // Close modal when clicking outside
    filterModal.addEventListener('click', function(event) {
        if (event.target === filterModal) {
            closeFilterModal();
        }
    });
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && filterModal.classList.contains('show')) {
            closeFilterModal();
        }
    });
    
    // Date formatting function (similar to Flutter implementation)
    function formatDateInput(value) {
        // Remove any non-digit characters
        value = value.replaceAll(/[^\d]/g, '');
        
        if (value.length > 8) {
            value = value.substring(0, 8);
        }
        
        if (value.length >= 4) {
            // Add month/day separator
            value = value.substring(0, 2) + '/' + value.substring(2);
        }
        if (value.length >= 7) {
            // Add day/year separator
            value = value.substring(0, 5) + '/' + value.substring(5);
        }
        
        // Validate the date
        if (value.length === 10) {
            try {
                const parts = value.split('/');
                const month = parseInt(parts[0]);
                const day = parseInt(parts[1]);
                const year = parseInt(parts[2]);
                
                if (month > 0 && month <= 12 && day > 0 && day <= 31 && year >= 1900) {
                    return value;
                }
            } catch (e) {
                return null;
            }
        }
        
        return value.length < 10 ? value : null;
    }
    
    // Date input formatting
    dobFilter.addEventListener('input', function() {
        const formattedDate = formatDateInput(this.value);
        if (formattedDate !== null && formattedDate !== this.value) {
            this.value = formattedDate;
        }
    });
    
    // Clear filters
    filterClear.addEventListener('click', function() {
        mcoFilter.value = '';
        providerFilter.value = '';
        dobFilter.value = '';
        currentFilters = { mco: '', provider: '', dob: '' };
        applyFilters();
        closeFilterModal();
    });
    
    // Apply filters
    filterApply.addEventListener('click', function() {
        currentFilters = {
            mco: mcoFilter.value,
            provider: providerFilter.value,
            dob: dobFilter.value
        };
        applyFilters();
        closeFilterModal();
    });
    
    // Apply filters to table
    function applyFilters() {
        let visibleCount = 0;
        
        tableRows.forEach(function(row) {
            const cells = row.querySelectorAll('td');
            const provider = cells[0].textContent.trim();
            const fullName = cells[1].textContent.trim();
            const dob = cells[2].textContent.trim();
            const mco = cells[3].textContent.trim();
            
            let shouldShow = true;
            
            // Apply MCO filter
            if (currentFilters.mco && currentFilters.mco !== 'All' && mco !== currentFilters.mco) {
                shouldShow = false;
            }
            
            // Apply Provider filter
            if (currentFilters.provider && currentFilters.provider !== 'All' && provider !== currentFilters.provider) {
                shouldShow = false;
            }
            
            // Apply Date of Birth filter
            if (currentFilters.dob && dob !== currentFilters.dob) {
                shouldShow = false;
            }
            
            // Apply search filter (if implemented)
            const searchInput = document.querySelector('.search-input');
            if (searchInput && searchInput.value.trim()) {
                const searchTerm = searchInput.value.toLowerCase();
                const searchText = `${fullName} ${dob}`.toLowerCase();
                if (!searchText.includes(searchTerm)) {
                    shouldShow = false;
                }
            }
            
            // Show/hide row
            if (shouldShow) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        // Update pagination info (simplified)
        updatePaginationInfo(visibleCount);
    }
    
    // Update pagination information
    function updatePaginationInfo(visibleCount) {
        const pageInfo = document.querySelector('.page-info');
        if (pageInfo) {
            const totalPages = Math.ceil(visibleCount / 15); // Assuming 15 rows per page
            pageInfo.textContent = `Page 1 of ${Math.max(1, totalPages)}`;
        }
    }
    
    // Search functionality
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            applyFilters(); // Re-apply filters when searching
        });
    }
    
    // Practice dropdown change
    const practiceDropdown = document.querySelector('.practice-dropdown');
    if (practiceDropdown) {
        practiceDropdown.addEventListener('change', function() {
            // Here you could implement practice-specific filtering
            console.log('Practice changed to:', this.value);
        });
    }
    
    // Pagination functionality (basic implementation)
    const pageButtons = document.querySelectorAll('.page-btn');
    pageButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            if (!this.disabled) {
                // Basic pagination logic - in a real app, you'd load different data
                console.log('Page button clicked:', this.textContent);
            }
        });
    });
    
    // Page size change
    const pageSizeSelect = document.querySelector('.page-size-select');
    if (pageSizeSelect) {
        pageSizeSelect.addEventListener('change', function() {
            console.log('Page size changed to:', this.value);
            // In a real app, you'd reload data with new page size
        });
    }
    
    // Initialize filters
    applyFilters();
    
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
    // Clear session data and redirect to login
    window.location.href = 'login.html';
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
            updatePatientsData(value, text);
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

// Update Patients Data (placeholder function)
function updatePatientsData(provider, providerText) {
    // This function would typically:
    // 1. Make API calls to fetch new patient data for the selected provider
    // 2. Update the patients table
    // 3. Update the patient count and statistics
    // 4. Update any patient-related filters
    
    console.log('Updating patients data for:', providerText);
    
    // Show a success message
    showSuccess(`Patients data updated for ${providerText}`);
}

// Success notification function
function showSuccess(message) {
    // Create and show success notification
    const successDiv = document.createElement('div');
    successDiv.className = 'success-notification';
    successDiv.textContent = message;
    document.body.appendChild(successDiv);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
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