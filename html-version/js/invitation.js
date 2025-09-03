// Invitation Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeInvitation();
});

function initializeInvitation() {
    // Initialize navigation
    initializeNavigation();
    
    // Initialize searchable dropdown
    initializeSearchableDropdown();
    
    // Initialize notifications
    initializeNotifications();
    
    // Initialize profile dropdown
    initializeProfileDropdown();
    
    // Initialize form
    initializeForm();
}

// Navigation Functions
function initializeNavigation() {
    const menuBtn = document.querySelector('.nav-menu-btn');
    const drawer = document.getElementById('navDrawer');
    const overlay = document.getElementById('drawerOverlay');
    
    menuBtn.addEventListener('click', function() {
        drawer.classList.add('open');
        overlay.classList.add('active');
    });
    
    overlay.addEventListener('click', closeDrawer);
    
    // Navigation items
    const navItems = document.querySelectorAll('.drawer-item[data-page]');
    navItems.forEach(item => {
        item.addEventListener('click', function() {
            const page = this.getAttribute('data-page');
            navigateToPage(page);
        });
    });
}

function closeDrawer() {
    const drawer = document.getElementById('navDrawer');
    const overlay = document.getElementById('drawerOverlay');
    drawer.classList.remove('open');
    overlay.classList.remove('active');
}

function navigateToPage(page) {
    closeDrawer();
    switch(page) {
        case 'dashboard':
            window.location.href = 'dashboard.html';
            break;
        case 'quality-scorecards':
            window.location.href = 'quality-scorecards.html';
            break;
        case 'patients':
            window.location.href = 'patients.html';
            break;
        case 'reports':
            window.location.href = 'reports.html';
            break;
        case 'resources':
            window.location.href = 'resources.html';
            break;
        default:
            console.log('Page not found:', page);
    }
}

// Searchable Dropdown Functions
function initializeSearchableDropdown() {
    const dropdown = document.getElementById('searchableDropdown');
    const trigger = document.getElementById('dropdownTrigger');
    const menu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const options = document.querySelectorAll('.dropdown-option');
    const selectedText = document.getElementById('selectedText');
    
    // Toggle dropdown
    trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        menu.classList.toggle('show');
        trigger.classList.toggle('active');
        
        if (menu.classList.contains('show')) {
            searchInput.focus();
        }
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target)) {
            menu.classList.remove('show');
            trigger.classList.remove('active');
        }
    });
    
    // Search functionality
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        options.forEach(option => {
            const text = option.querySelector('.option-text').textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                option.classList.remove('hidden');
            } else {
                option.classList.add('hidden');
            }
        });
    });
    
    // Option selection
    options.forEach(option => {
        option.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            const text = this.querySelector('.option-text').textContent;
            
            // Update selected option
            options.forEach(opt => {
                opt.classList.remove('selected');
                opt.setAttribute('data-selected', 'false');
            });
            
            this.classList.add('selected');
            this.setAttribute('data-selected', 'true');
            selectedText.textContent = text;
            
            // Close dropdown
            menu.classList.remove('show');
            trigger.classList.remove('active');
        });
    });
}

// Notifications Functions
function initializeNotifications() {
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    const markAllReadBtn = document.getElementById('markAllReadBtn');
    const notificationItems = document.querySelectorAll('.notification-item');
    const notificationBadge = document.getElementById('notificationBadge');
    
    // Toggle notifications dropdown
    notificationBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        notificationsDropdown.classList.toggle('show');
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!notificationBtn.contains(e.target) && !notificationsDropdown.contains(e.target)) {
            notificationsDropdown.classList.remove('show');
        }
    });
    
    // Mark all as read
    markAllReadBtn.addEventListener('click', function() {
        notificationItems.forEach(item => {
            item.classList.remove('unread');
        });
        notificationBadge.textContent = '0';
        notificationBadge.style.display = 'none';
    });
    
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

// Profile Dropdown Functions
function initializeProfileDropdown() {
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');
    const profileOptions = document.querySelectorAll('.profile-option');
    
    // Toggle dropdown on button click
    profileBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        profileDropdown.classList.toggle('show');
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!profileBtn.contains(e.target) && !profileDropdown.contains(e.target)) {
            profileDropdown.classList.remove('show');
        }
    });
    
    // Handle profile option clicks
    profileOptions.forEach(option => {
        option.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            handleProfileAction(action);
        });
    });
}

function handleProfileAction(action) {
    const dropdown = document.getElementById('profileDropdown');
    dropdown.classList.remove('show');
    
    switch(action) {
        case 'language':
            // Handle language change
            console.log('Language change requested');
            break;
        case 'invitations':
            // Navigate to invitations page
            window.location.href = 'invitation.html';
            break;
        case 'logout':
            showLogoutDialog();
            break;
    }
}

// Form Functions
function initializeForm() {
    const form = document.getElementById('invitationForm');
    const sendBtn = document.getElementById('sendInviteBtn');
    
    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        handleFormSubmission();
    });
    
    // Real-time validation and button state
    const inputs = form.querySelectorAll('input, select');
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', function() {
            clearFieldError.call(this);
            updateButtonState();
        });
        input.addEventListener('change', updateButtonState);
    });
    
    // Initial button state
    updateButtonState();
}

function validateField() {
    const field = this;
    const value = field.value.trim();
    const fieldName = field.name;
    let isValid = true;
    let errorMessage = '';
    
    // Remove existing error styling
    clearFieldError.call(field);
    
    // Validation rules
    switch(fieldName) {
        case 'providerUsers':
            if (!value) {
                isValid = false;
                errorMessage = 'Please select a provider user';
            }
            break;
            
        case 'npi':
            if (!value) {
                isValid = false;
                errorMessage = 'NPI is required';
            } else if (!/^\d{10}$/.test(value)) {
                isValid = false;
                errorMessage = 'NPI must be 10 digits';
            }
            break;
            
        case 'firstName':
            if (!value) {
                isValid = false;
                errorMessage = 'First name is required';
            } else if (value.length < 2) {
                isValid = false;
                errorMessage = 'First name must be at least 2 characters';
            }
            break;
            
        case 'lastName':
            if (!value) {
                isValid = false;
                errorMessage = 'Last name is required';
            } else if (value.length < 2) {
                isValid = false;
                errorMessage = 'Last name must be at least 2 characters';
            }
            break;
            
        case 'phoneNumber':
            if (!value) {
                isValid = false;
                errorMessage = 'Phone number is required';
            } else if (!/^[\+]?[1-9][\d]{0,15}$/.test(value.replace(/[\s\-\(\)]/g, ''))) {
                isValid = false;
                errorMessage = 'Please enter a valid phone number';
            }
            break;
            
        case 'emailAddress':
            if (!value) {
                isValid = false;
                errorMessage = 'Email address is required';
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                isValid = false;
                errorMessage = 'Please enter a valid email address';
            }
            break;
    }
    
    if (!isValid) {
        showFieldError(field, errorMessage);
    }
    
    // Update button state after validation
    updateButtonState();
    
    return isValid;
}

function showFieldError(field, message) {
    field.style.borderColor = '#d32f2f';
    
    // Create or update error message
    const formGroup = field.closest('.form-group');
    let errorElement = formGroup.querySelector('.field-error');
    if (!errorElement) {
        errorElement = document.createElement('div');
        errorElement.className = 'field-error';
        errorElement.style.cssText = `
            color: #d32f2f;
            font-size: 12px;
            margin-top: 4px;
            font-weight: 500;
        `;
        formGroup.appendChild(errorElement);
    }
    errorElement.textContent = message;
}

function clearFieldError() {
    this.style.borderColor = '#e0e0e0';
    const formGroup = this.closest('.form-group');
    const errorElement = formGroup.querySelector('.field-error');
    if (errorElement) {
        errorElement.remove();
    }
}

function updateButtonState() {
    const form = document.getElementById('invitationForm');
    const sendBtn = document.getElementById('sendInviteBtn');
    const requiredFields = form.querySelectorAll('input[required], select[required]');
    
    let allFieldsValid = true;
    
    requiredFields.forEach(field => {
        const value = field.value.trim();
        const fieldName = field.name;
        
        // Check if field is empty or invalid
        if (!value) {
            allFieldsValid = false;
            return;
        }
        
        // Additional validation for specific fields
        switch(fieldName) {
            case 'npi':
                if (!/^\d{10}$/.test(value)) {
                    allFieldsValid = false;
                }
                break;
            case 'firstName':
            case 'lastName':
                if (value.length < 2) {
                    allFieldsValid = false;
                }
                break;
            case 'phoneNumber':
                if (!/^[\+]?[1-9][\d]{0,15}$/.test(value.replace(/[\s\-\(\)]/g, ''))) {
                    allFieldsValid = false;
                }
                break;
            case 'emailAddress':
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    allFieldsValid = false;
                }
                break;
        }
    });
    
    // Update button state
    if (allFieldsValid) {
        sendBtn.disabled = false;
        sendBtn.style.opacity = '1';
        sendBtn.style.cursor = 'pointer';
    } else {
        sendBtn.disabled = true;
        sendBtn.style.opacity = '0.6';
        sendBtn.style.cursor = 'not-allowed';
    }
}

function setLoading(loading) {
    const sendBtn = document.getElementById('sendInviteBtn');
    if (loading) {
        sendBtn.classList.add('loading');
        sendBtn.disabled = true;
    } else {
        sendBtn.classList.remove('loading');
        sendBtn.disabled = false;
    }
}

async function handleFormSubmission() {
    const form = document.getElementById('invitationForm');
    const formData = new FormData(form);
    
    // Validate all fields
    const inputs = form.querySelectorAll('input, select');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!validateField.call(input)) {
            isValid = false;
        }
    });
    
    if (!isValid) {
        showError('Please fix the errors above before submitting.');
        return;
    }
    
    setLoading(true);
    
    try {
        // Simulate API call
        await simulateSendInvitation(formData);
        
        // Show success message
        showSuccess('Invitation sent successfully!');
        
        // Reset form
        form.reset();
        
    } catch (error) {
        showError(error.message || 'Failed to send invitation. Please try again.');
    } finally {
        setLoading(false);
    }
}

// Simulate API call
function simulateSendInvitation(formData) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // For demo purposes, always succeed
            const email = formData.get('emailAddress');
            if (email && email.includes('@')) {
                resolve({ success: true });
            } else {
                reject(new Error('Invalid email address'));
            }
        }, 2000);
    });
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
    }, 4000);
}

function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #d32f2f;
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        z-index: 1000;
        animation: slideInRight 0.3s ease-out;
        box-shadow: 0 4px 12px rgba(211, 47, 47, 0.3);
    `;
    
    document.body.appendChild(errorDiv);
    
    setTimeout(() => {
        errorDiv.remove();
    }, 5000);
}

// Logout Functions
function showLogoutDialog() {
    const dialog = document.getElementById('logoutDialog');
    dialog.classList.add('show');
}

function closeLogoutDialog() {
    const dialog = document.getElementById('logoutDialog');
    dialog.classList.remove('show');
}

function confirmLogout() {
    // Simulate logout
    console.log('Logging out...');
    window.location.href = 'login.html';
}

function logout() {
    showLogoutDialog();
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
