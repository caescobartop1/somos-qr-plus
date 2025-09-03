// Dashboard JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize charts
    initializePanelChart();
    initializeIncentiveChart();
    
    // Initialize interactive elements
    initializeScheduleToggle();
    initializePracticeDropdown();
    initializeSearchableDropdown();
    initializeProviderToggles();
    initializeNavigation();
    initializeNotifications();
});

// Navigation functionality
function initializeNavigation() {
    const menuBtn = document.querySelector('.nav-menu-btn');
    const profileBtn = document.querySelector('.profile-btn');
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    // Open navigation drawer
    if (menuBtn) {
        menuBtn.addEventListener('click', () => {
            navDrawer.classList.add('open');
            drawerOverlay.classList.add('active');
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        });
    }
    
    // Close on overlay click
    if (drawerOverlay) {
        drawerOverlay.addEventListener('click', closeDrawer);
    }
    
    // Close on escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && navDrawer.classList.contains('open')) {
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
            case 'schedule':
                window.location.href = 'schedule.html';
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
    
    if (profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            toggleProfileDropdown();
        });
    }
    
    // Initialize profile dropdown
    initializeProfileDropdown();
}

// Close drawer function
function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    navDrawer.classList.remove('open');
    drawerOverlay.classList.remove('active');
    document.body.style.overflow = ''; // Restore scrolling
}

// Panel Chart (My Panel)
function initializePanelChart() {
    const ctx = document.getElementById('panelChart').getContext('2d');
    
    const panelChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Anthem', 'Emblem', 'Healthfirst', 'Humana', 'Metroplus', 'Molina', 'United'],
            datasets: [
                {
                    label: 'EP',
                    data: [238, 238, 550, 170, 476, 0, 238],
                    backgroundColor: '#1976d2',
                    borderColor: '#1976d2',
                    borderWidth: 0,
                    borderRadius: 4
                },
                {
                    label: 'MCD',
                    data: [714, 96, 700, 240, 238, 476, 96],
                    backgroundColor: '#4caf50',
                    borderColor: '#4caf50',
                    borderWidth: 0,
                    borderRadius: 4
                },
                {
                    label: 'MCR',
                    data: [0, 0, 750, 190, 0, 572, 0],
                    backgroundColor: '#4dd0e1',
                    borderColor: '#4dd0e1',
                    borderWidth: 0,
                    borderRadius: 4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#666',
                        font: {
                            size: 12
                        }
                    },
                    barPercentage: 0.15,
                    categoryPercentage: 0.8
                },
                y: {
                    beginAtZero: true,
                    max: 1000,
                    ticks: {
                        stepSize: 200,
                        color: '#666',
                        font: {
                            size: 12
                        }
                    },
                    grid: {
                        color: '#e0e0e0',
                        drawBorder: false,
                        lineWidth: 1
                    }
                }
            },
            elements: {
                bar: {
                    borderWidth: 0,
                    borderRadius: 4,
                    borderSkipped: false
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: '#fff',
                    bodyColor: '#fff',
                    borderColor: '#fff',
                    borderWidth: 1,
                    cornerRadius: 8,
                    displayColors: true
                }
            },
            interaction: {
                intersect: true,
                mode: 'nearest'
            }
        }
    });
}

// Innovation Incentive Program Chart
function initializeIncentiveChart() {
    const ctx = document.getElementById('incentiveChart').getContext('2d');
    
    const incentiveChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['AWV', 'BCS', 'CBP', 'CCS', 'CDC-EYE', 'CDC-1C', 'COL', 'PCR', 'POD', 'PPC', 'SAA', 'W30', 'WCV', 'HVL'],
            datasets: [
                {
                    label: 'Earnings',
                    data: [1764, 1596, 2142, 1218, 1428, 1932, 1344, 2016, 1638, 1848, 1512, 2184, 1722, 1554],
                    backgroundColor: '#388e3c',
                    borderColor: '#388e3c',
                    borderWidth: 0,
                    borderRadius: 4,
                },
                {
                    label: 'Potential',
                    data: [1960, 2240, 1680, 2870, 2520, 1540, 2660, 1400, 2170, 1820, 2380, 1260, 2030, 2310],
                    backgroundColor: '#a5d6a7',
                    borderColor: '#a5d6a7',
                    borderWidth: 0,
                    borderRadius: 4,
                },

            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    stacked: true,
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#666',
                        font: {
                            size: 10
                        },
                        maxRotation: 45
                    }
                },
                y: {
                    stacked: true,
                    beginAtZero: true,
                    max: 6000,
                    ticks: {
                        stepSize: 1000,
                        callback: function(value) {
                            return '$' + value.toLocaleString();
                        },
                        color: '#666',
                        font: {
                            size: 12
                        }
                    },
                    grid: {
                        color: '#e0e0e0',
                        drawBorder: false
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: '#fff',
                    bodyColor: '#fff',
                    borderColor: '#fff',
                    borderWidth: 1,
                    cornerRadius: 8,
                    displayColors: true,
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': $' + context.parsed.y.toLocaleString();
                        }
                    }
                }
            },
            interaction: {
                intersect: false,
                mode: 'index'
            }
        }
    });
}

// Schedule Toggle Functionality
function initializeScheduleToggle() {
    const expandButton = document.getElementById('expandSchedule');
    const scheduleContent = document.getElementById('scheduleContent');
    let isExpanded = true;
    
    if (expandButton && scheduleContent) {
        expandButton.addEventListener('click', function() {
            isExpanded = !isExpanded;
            
            if (isExpanded) {
                scheduleContent.style.display = 'block';
                expandButton.querySelector('.icon').textContent = '▼';
            } else {
                scheduleContent.style.display = 'none';
                expandButton.querySelector('.icon').textContent = '▶';
            }
        });
    }
}

// Practice Dropdown Functionality
function initializePracticeDropdown() {
    const practiceDropdown = document.getElementById('practiceDropdown');
    
    if (practiceDropdown) {
        practiceDropdown.addEventListener('change', function() {
            const selectedPractice = this.value;
            console.log('Selected practice:', selectedPractice);
            
            // Here you would typically make an API call to update the dashboard data
            // For now, we'll just log the selection
            updateDashboardData(selectedPractice);
        });
    }
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
            updateProviderData(value, text);
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

// Update Provider Data (placeholder function)
function updateProviderData(provider, providerText) {
    // This function would typically:
    // 1. Make API calls to fetch new data for the selected provider
    // 2. Update the KPI cards
    // 3. Update the charts
    // 4. Update the schedule
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Dashboard updated for ' + providerText);
        
        // Example of how you might update the dashboard data
        // updateKPIValues(newData);
        // updateCharts(newData);
        // updateSchedule(newData);
    }, 1000);
}

// Update Dashboard Data (placeholder function)
function updateDashboardData(practice) {
    // This function would typically:
    // 1. Make API calls to fetch new data for the selected practice
    // 2. Update the KPI cards
    // 3. Update the charts
    // 4. Update the schedule
    
    console.log('Updating dashboard data for practice:', practice);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Dashboard updated for ' + practice);
        
        // Example of how you might update the KPI values
        // updateKPIValues(newData);
        // updateCharts(newData);
        // updateSchedule(newData);
    }, 1000);
}

// Utility function to update KPI values
function updateKPIValues(data) {
    const kpiCards = document.querySelectorAll('.kpi-card');
    
    kpiCards.forEach((card, index) => {
        const valueElement = card.querySelector('.kpi-value');
        if (valueElement && data.kpiValues && data.kpiValues[index]) {
            valueElement.textContent = data.kpiValues[index];
        }
    });
}

// Utility function to format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount);
}

// Utility function to format numbers with commas
function formatNumber(num) {
    return num.toLocaleString();
}

// Add click handlers for appointment items
document.addEventListener('DOMContentLoaded', function() {
    const appointmentItems = document.querySelectorAll('.appointment-item');
    
    appointmentItems.forEach(item => {
        item.addEventListener('click', function() {
            const patientName = this.querySelector('.patient-name').textContent;
            console.log('Appointment clicked:', patientName);
            
            // Here you would typically navigate to appointment details
            // or open a modal with appointment information
            showAppointmentDetails(patientName);
        });
    });
});

// Show appointment details (placeholder function)
function showAppointmentDetails(patientName) {
    // This would typically open a modal or navigate to a detail page
    console.log('Showing details for:', patientName);
    
    // Example modal implementation:
    // const modal = document.createElement('div');
    // modal.className = 'appointment-modal';
    // modal.innerHTML = `
    //     <div class="modal-content">
    //         <h3>Appointment Details</h3>
    //         <p>Patient: ${patientName}</p>
    //         <!-- More appointment details -->
    //     </div>
    // `;
    // document.body.appendChild(modal);
}

// Add smooth scrolling for better UX
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// Add loading states for better UX
function showLoading() {
    // Add loading spinner or overlay
    const loadingOverlay = document.createElement('div');
    loadingOverlay.className = 'loading-overlay';
    loadingOverlay.innerHTML = '<div class="loading-spinner"></div>';
    document.body.appendChild(loadingOverlay);
}

function hideLoading() {
    // Remove loading spinner
    const loadingOverlay = document.querySelector('.loading-overlay');
    if (loadingOverlay) {
        loadingOverlay.remove();
    }
}

// Error handling
function showError(message) {
    // Create and show error notification
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-notification';
    errorDiv.textContent = message;
    document.body.appendChild(errorDiv);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        errorDiv.remove();
    }, 5000);
}

// Success notification
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

// Profile Dropdown functionality
function initializeProfileDropdown() {
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');
    
    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (profileDropdown && !profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
            closeProfileDropdown();
        }
    });
    
    // Close on escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && profileDropdown && profileDropdown.classList.contains('show')) {
            closeProfileDropdown();
        }
    });
    
    // Handle dropdown options
    const dropdownOptions = document.querySelectorAll('.profile-option');
    dropdownOptions.forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            const action = option.getAttribute('data-action');
            handleProfileAction(action);
        });
    });
}

function toggleProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        if (profileDropdown.classList.contains('show')) {
            closeProfileDropdown();
        } else {
            openProfileDropdown();
        }
    }
}

function openProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        profileDropdown.classList.add('show');
    }
}

function closeProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        profileDropdown.classList.remove('show');
    }
}

function handleProfileAction(action) {
    switch(action) {
        case 'language':
            console.log('Language settings clicked');
            // TODO: Implement language selection
            break;
        case 'invitations':
            console.log('Invitations clicked');
            window.location.href = 'invitation.html';
            break;
        case 'logout':
            console.log('Logout clicked from profile dropdown');
            showLogoutDialog();
            break;
        default:
            console.log('Unknown profile action:', action);
    }
    closeProfileDropdown();
}

// Provider Toggles Functionality
function initializeProviderToggles() {
    const toggleButtons = document.querySelectorAll('.provider-toggle-btn');
    let currentProvider = 'all';
    
    toggleButtons.forEach(button => {
        button.addEventListener('click', function() {
            const provider = this.getAttribute('data-provider');
            
            // Update active button
            toggleButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Update current provider
            currentProvider = provider;
            
            // Update chart data based on provider
            updateIncentiveChartData(provider);
            
            // Show success message
            const providerText = provider === 'all' ? 'All providers' : provider.charAt(0).toUpperCase() + provider.slice(1);
            showSuccess(`Showing data for ${providerText}`);
        });
    });
}

// Update Incentive Chart Data
function updateIncentiveChartData(provider) {
    // This function would typically:
    // 1. Make API calls to fetch data for the selected provider
    // 2. Update the chart with new data
    // 3. Update the earnings and potential stats
    
    console.log('Updating incentive chart data for provider:', provider);
    
    // For demo purposes, we'll just log the provider change
    // In a real implementation, you would:
    // - Fetch new data from the server
    // - Update the chart with new datasets
    // - Update the earnings and potential values
    
    // Example of how you might update the chart:
    // if (window.incentiveChart) {
    //     const newData = getProviderData(provider);
    //     window.incentiveChart.data.datasets[0].data = newData.earnings;
    //     window.incentiveChart.data.datasets[1].data = newData.potential;
    //     window.incentiveChart.update();
    // }
}

// Notifications functionality
function initializeNotifications() {
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    const markAllReadBtn = document.getElementById('markAllReadBtn');
    const notificationBadge = document.getElementById('notificationBadge');
    
    // Toggle notifications dropdown
    if (notificationBtn) {
        notificationBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            toggleNotificationsDropdown();
        });
    }
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!notificationBtn.contains(e.target) && !notificationsDropdown.contains(e.target)) {
            closeNotificationsDropdown();
        }
    });
    
    // Mark all as read
    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', function() {
            markAllNotificationsAsRead();
        });
    }
    
    // Handle individual notification close buttons
    const closeButtons = document.querySelectorAll('.notification-close');
    closeButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            const notificationId = this.getAttribute('data-id');
            removeNotification(notificationId);
        });
    });
    
    // Handle notification item clicks
    const notificationItems = document.querySelectorAll('.notification-item');
    notificationItems.forEach(item => {
        item.addEventListener('click', function() {
            const notificationId = this.getAttribute('data-id');
            markNotificationAsRead(notificationId);
        });
    });
}

function toggleNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        if (notificationsDropdown.classList.contains('show')) {
            closeNotificationsDropdown();
        } else {
            openNotificationsDropdown();
        }
    }
}

function openNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        notificationsDropdown.classList.add('show');
    }
}

function closeNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        notificationsDropdown.classList.remove('show');
    }
}

function markAllNotificationsAsRead() {
    const unreadNotifications = document.querySelectorAll('.notification-item.unread');
    const notificationBadge = document.getElementById('notificationBadge');
    
    unreadNotifications.forEach(notification => {
        notification.classList.remove('unread');
    });
    
    // Update badge count
    updateNotificationBadge();
    
    // Show success message
    showSuccess('All notifications marked as read');
}

function markNotificationAsRead(notificationId) {
    const notification = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
    if (notification && notification.classList.contains('unread')) {
        notification.classList.remove('unread');
        updateNotificationBadge();
    }
}

function removeNotification(notificationId) {
    const notification = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
    if (notification) {
        // Check if it was unread before removing
        const wasUnread = notification.classList.contains('unread');
        
        // Remove the notification
        notification.remove();
        
        // Update badge count if it was unread
        if (wasUnread) {
            updateNotificationBadge();
        }
        
        // Show success message
        showSuccess('Notification removed');
    }
}

function updateNotificationBadge() {
    const notificationBadge = document.getElementById('notificationBadge');
    const unreadCount = document.querySelectorAll('.notification-item.unread').length;
    
    if (notificationBadge) {
        if (unreadCount > 0) {
            notificationBadge.textContent = unreadCount;
            notificationBadge.style.display = 'block';
        } else {
            notificationBadge.style.display = 'none';
        }
    }
}

// Helper function to show success messages (if not already defined)
function showSuccess(message) {
    // Create a simple success toast
    const toast = document.createElement('div');
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4caf50;
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        z-index: 10000;
        font-size: 14px;
        font-weight: 500;
    `;
    toast.textContent = message;
    
    document.body.appendChild(toast);
    
    // Remove after 3 seconds
    setTimeout(() => {
        if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
        }
    }, 3000);
} 