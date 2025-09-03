// Notifications Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all functionality
    initializeNavigation();
    initializeNotifications();
    initializeFilters();
    initializePagination();
    loadNotifications();
});

// Sample notifications data
const notificationsData = [
    {
        id: 1,
        type: 'quality',
        title: 'New Quality Scorecard Available',
        message: 'Your Q2 2025 quality scorecard is ready for review.',
        time: '2 hours ago',
        timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000),
        unread: true
    },
    {
        id: 2,
        type: 'appointment',
        title: 'Patient Appointment Reminder',
        message: '5 patients have appointments scheduled for tomorrow.',
        time: '4 hours ago',
        timestamp: new Date(Date.now() - 4 * 60 * 60 * 1000),
        unread: true
    },
    {
        id: 3,
        type: 'report',
        title: 'Monthly Report Generated',
        message: 'Your July 2025 performance report has been generated.',
        time: '1 day ago',
        timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
        unread: true
    },
    {
        id: 4,
        type: 'system',
        title: 'Document Upload Complete',
        message: 'Patient records have been successfully uploaded.',
        time: '2 days ago',
        timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 5,
        type: 'system',
        title: 'System Maintenance',
        message: 'Scheduled maintenance completed successfully.',
        time: '3 days ago',
        timestamp: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 6,
        type: 'quality',
        title: 'Quality Metrics Updated',
        message: 'Your quality metrics have been updated for the current period.',
        time: '1 week ago',
        timestamp: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 7,
        type: 'appointment',
        title: 'Appointment Cancellation',
        message: 'Patient appointment has been cancelled for tomorrow.',
        time: '1 week ago',
        timestamp: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 8,
        type: 'report',
        title: 'Weekly Summary Available',
        message: 'Your weekly performance summary is ready for review.',
        time: '2 weeks ago',
        timestamp: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 9,
        type: 'system',
        title: 'Password Reset Required',
        message: 'Your password will expire in 7 days. Please reset it.',
        time: '2 weeks ago',
        timestamp: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000),
        unread: false
    },
    {
        id: 10,
        type: 'quality',
        title: 'Quality Review Complete',
        message: 'Quality review for Q1 2025 has been completed.',
        time: '3 weeks ago',
        timestamp: new Date(Date.now() - 21 * 24 * 60 * 60 * 1000),
        unread: false
    }
];

let currentNotifications = [...notificationsData];
let currentPage = 1;
const itemsPerPage = 10;

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
            document.body.style.overflow = 'hidden';
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
            const action = item.getAttribute('data-action');
            
            if (action === 'logout') {
                showLogoutDialog();
                return;
            }
            
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
        });
    });
    
    // Profile dropdown functionality
    if (profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            toggleProfileDropdown();
        });
    }
    
    // Close profile dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const profileDropdown = document.getElementById('profileDropdown');
        if (!profileBtn.contains(event.target) && !profileDropdown.contains(event.target)) {
            closeProfileDropdown();
        }
    });
    
    // Handle profile dropdown options
    const profileOptions = document.querySelectorAll('.profile-option');
    profileOptions.forEach(option => {
        option.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            handleProfileAction(action);
            closeProfileDropdown();
        });
    });
    
    // Initialize searchable dropdown
    initializeSearchableDropdown();
}

function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    navDrawer.classList.remove('open');
    drawerOverlay.classList.remove('active');
    document.body.style.overflow = '';
}

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
        case 'settings':
            window.location.href = 'settings.html';
            break;
        default:
            console.log('Page not implemented yet:', page);
    }
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

// Searchable dropdown functionality
function initializeSearchableDropdown() {
    const dropdownTrigger = document.getElementById('dropdownTrigger');
    const dropdownMenu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const dropdownOptions = document.querySelectorAll('.dropdown-option');
    const selectedText = document.getElementById('selectedText');
    
    if (dropdownTrigger) {
        dropdownTrigger.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdownMenu.classList.toggle('show');
            dropdownTrigger.classList.toggle('active');
            
            if (dropdownMenu.classList.contains('show')) {
                searchInput.focus();
            }
        });
    }
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdownTrigger.contains(e.target) && !dropdownMenu.contains(e.target)) {
            dropdownMenu.classList.remove('show');
            dropdownTrigger.classList.remove('active');
        }
    });
    
    // Search functionality
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            
            dropdownOptions.forEach(option => {
                const text = option.querySelector('.option-text').textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    option.style.display = 'flex';
                } else {
                    option.style.display = 'none';
                }
            });
        });
    }
    
    // Option selection
    dropdownOptions.forEach(option => {
        option.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            const text = this.querySelector('.option-text').textContent;
            
            // Update selected option
            dropdownOptions.forEach(opt => {
                opt.setAttribute('data-selected', 'false');
            });
            this.setAttribute('data-selected', 'true');
            
            // Update display
            selectedText.textContent = text;
            
            // Close dropdown
            dropdownMenu.classList.remove('show');
            dropdownTrigger.classList.remove('active');
            
            console.log('Selected provider:', value);
        });
    });
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

// Filters functionality
function initializeFilters() {
    const statusFilter = document.getElementById('statusFilter');
    const typeFilter = document.getElementById('typeFilter');
    const dateFilter = document.getElementById('dateFilter');
    const searchInput = document.getElementById('searchNotifications');
    const markAllReadBtnPage = document.getElementById('markAllReadBtnPage');
    const refreshBtn = document.getElementById('refreshBtn');
    const selectAllCheckbox = document.getElementById('selectAllNotifications');
    
    // Filter change handlers
    if (statusFilter) {
        statusFilter.addEventListener('change', applyFilters);
    }
    
    if (typeFilter) {
        typeFilter.addEventListener('change', applyFilters);
    }
    
    if (dateFilter) {
        dateFilter.addEventListener('change', applyFilters);
    }
    
    // Search functionality
    if (searchInput) {
        searchInput.addEventListener('input', applyFilters);
    }
    
    // Mark all read button
    if (markAllReadBtnPage) {
        markAllReadBtnPage.addEventListener('click', markAllAsRead);
    }
    
    // Refresh button
    if (refreshBtn) {
        refreshBtn.addEventListener('click', refreshNotifications);
    }
    
    // Select all checkbox
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', toggleSelectAll);
    }
}

function applyFilters() {
    const statusFilter = document.getElementById('statusFilter').value;
    const typeFilter = document.getElementById('typeFilter').value;
    const dateFilter = document.getElementById('dateFilter').value;
    const searchTerm = document.getElementById('searchNotifications').value.toLowerCase();
    
    let filteredNotifications = [...notificationsData];
    
    // Status filter
    if (statusFilter !== 'all') {
        filteredNotifications = filteredNotifications.filter(notification => {
            if (statusFilter === 'unread') {
                return notification.unread;
            } else {
                return !notification.unread;
            }
        });
    }
    
    // Type filter
    if (typeFilter !== 'all') {
        filteredNotifications = filteredNotifications.filter(notification => 
            notification.type === typeFilter
        );
    }
    
    // Date filter
    if (dateFilter !== 'all') {
        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const weekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
        const monthAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);
        
        filteredNotifications = filteredNotifications.filter(notification => {
            switch (dateFilter) {
                case 'today':
                    return notification.timestamp >= today;
                case 'week':
                    return notification.timestamp >= weekAgo;
                case 'month':
                    return notification.timestamp >= monthAgo;
                default:
                    return true;
            }
        });
    }
    
    // Search filter
    if (searchTerm) {
        filteredNotifications = filteredNotifications.filter(notification =>
            notification.title.toLowerCase().includes(searchTerm) ||
            notification.message.toLowerCase().includes(searchTerm)
        );
    }
    
    currentNotifications = filteredNotifications;
    currentPage = 1;
    renderNotifications();
    updatePagination();
}

function markAllAsRead() {
    currentNotifications.forEach(notification => {
        notification.unread = false;
    });
    
    // Update the main notifications data
    notificationsData.forEach(notification => {
        if (currentNotifications.find(n => n.id === notification.id)) {
            notification.unread = false;
        }
    });
    
    renderNotifications();
    updateNotificationBadge();
    showSuccess('All notifications marked as read');
}

function refreshNotifications() {
    // Simulate refreshing notifications
    showSuccess('Notifications refreshed');
    applyFilters();
}

function toggleSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAllNotifications');
    const notificationCheckboxes = document.querySelectorAll('.notification-checkbox input[type="checkbox"]');
    
    notificationCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
}

// Pagination functionality
function initializePagination() {
    const firstPageBtn = document.getElementById('firstPage');
    const prevPageBtn = document.getElementById('prevPage');
    const nextPageBtn = document.getElementById('nextPage');
    const lastPageBtn = document.getElementById('lastPage');
    
    if (firstPageBtn) {
        firstPageBtn.addEventListener('click', () => goToPage(1));
    }
    
    if (prevPageBtn) {
        prevPageBtn.addEventListener('click', () => goToPage(currentPage - 1));
    }
    
    if (nextPageBtn) {
        nextPageBtn.addEventListener('click', () => goToPage(currentPage + 1));
    }
    
    if (lastPageBtn) {
        lastPageBtn.addEventListener('click', () => goToPage(getTotalPages()));
    }
    
    // Page number buttons
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('page-number')) {
            const page = parseInt(e.target.getAttribute('data-page'));
            goToPage(page);
        }
    });
}

function goToPage(page) {
    const totalPages = getTotalPages();
    if (page >= 1 && page <= totalPages) {
        currentPage = page;
        renderNotifications();
        updatePagination();
    }
}

function getTotalPages() {
    return Math.ceil(currentNotifications.length / itemsPerPage);
}

function updatePagination() {
    const totalPages = getTotalPages();
    const paginationInfo = document.getElementById('paginationInfo');
    const firstPageBtn = document.getElementById('firstPage');
    const prevPageBtn = document.getElementById('prevPage');
    const nextPageBtn = document.getElementById('nextPage');
    const lastPageBtn = document.getElementById('lastPage');
    const pageNumbers = document.querySelector('.page-numbers');
    
    // Update pagination info
    const start = (currentPage - 1) * itemsPerPage + 1;
    const end = Math.min(currentPage * itemsPerPage, currentNotifications.length);
    paginationInfo.textContent = `Showing ${start}-${end} of ${currentNotifications.length} notifications`;
    
    // Update button states
    firstPageBtn.disabled = currentPage === 1;
    prevPageBtn.disabled = currentPage === 1;
    nextPageBtn.disabled = currentPage === totalPages;
    lastPageBtn.disabled = currentPage === totalPages;
    
    // Update page numbers
    pageNumbers.innerHTML = '';
    const maxVisiblePages = 5;
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
    
    if (endPage - startPage + 1 < maxVisiblePages) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }
    
    for (let i = startPage; i <= endPage; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.className = `page-number ${i === currentPage ? 'active' : ''}`;
        pageBtn.setAttribute('data-page', i);
        pageBtn.textContent = i;
        pageNumbers.appendChild(pageBtn);
    }
}

// Load and render notifications
function loadNotifications() {
    renderNotifications();
    updatePagination();
    updateNotificationBadge();
}

function renderNotifications() {
    const notificationsList = document.getElementById('notificationsListPage');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageNotifications = currentNotifications.slice(startIndex, endIndex);
    
    notificationsList.innerHTML = '';
    
    if (pageNotifications.length === 0) {
        notificationsList.innerHTML = `
            <div class="no-notifications">
                <div class="no-notifications-icon">📭</div>
                <div class="no-notifications-text">No notifications found</div>
                <div class="no-notifications-subtext">Try adjusting your filters or search terms</div>
            </div>
        `;
        return;
    }
    
    pageNotifications.forEach(notification => {
        const notificationElement = createNotificationElement(notification);
        notificationsList.appendChild(notificationElement);
    });
    
    // Add event listeners to new elements
    addNotificationEventListeners();
}

function createNotificationElement(notification) {
    const typeIcons = {
        quality: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14,2 14,8 20,8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10,9 9,9 8,9"></polyline></svg>',
        appointment: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>',
        report: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10"></path><path d="M12 20V4"></path><path d="M6 20v-6"></path></svg>',
        system: '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path></svg>'
    };
    
    const typeLabels = {
        quality: 'Quality',
        appointment: 'Appointment',
        report: 'Report',
        system: 'System'
    };
    
    const element = document.createElement('div');
    element.className = `notification-item-page ${notification.unread ? 'unread' : ''}`;
    element.setAttribute('data-id', notification.id);
    
    element.innerHTML = `
        <div class="notification-checkbox">
            <input type="checkbox" id="checkbox-${notification.id}">
        </div>
        <div class="notification-type ${notification.type}">
            <div class="notification-type-icon">${typeIcons[notification.type]}</div>
            <span>${typeLabels[notification.type]}</span>
        </div>
        <div class="notification-content-page">
            <div class="notification-title-page">${notification.title}</div>
            <div class="notification-message-page">${notification.message}</div>
        </div>
        <div class="notification-time-page">${notification.time}</div>
        <div class="notification-actions">
            <button class="action-menu-btn" title="Actions">
                ⋮
            </button>
            <div class="action-menu">
                ${notification.unread ? '<div class="menu-item mark-read">Mark as read</div>' : ''}
                <div class="menu-item delete">Delete</div>
            </div>
        </div>
    `;
    
    return element;
}

function addNotificationEventListeners() {
    // Action menu buttons
    const actionMenuButtons = document.querySelectorAll('.action-menu-btn');
    actionMenuButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            const actionMenu = this.nextElementSibling;
            
            // Close all other menus first
            document.querySelectorAll('.action-menu').forEach(menu => {
                if (menu !== actionMenu) {
                    menu.classList.remove('show');
                }
            });
            
            actionMenu.classList.toggle('show');
        });
    });
    
    // Menu items
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.stopPropagation();
            const notificationItem = this.closest('.notification-item-page');
            const notificationId = notificationItem.getAttribute('data-id');
            const action = this.classList.contains('mark-read') ? 'mark-read' : 'delete';
            
            if (action === 'mark-read') {
                markNotificationAsReadPage(notificationId);
            } else if (action === 'delete') {
                deleteNotification(notificationId);
            }
            
            // Close the menu
            this.closest('.action-menu').classList.remove('show');
        });
    });
    
    // Close menus when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.notification-actions')) {
            document.querySelectorAll('.action-menu').forEach(menu => {
                menu.classList.remove('show');
            });
        }
    });
    
    // Checkbox event listeners
    const checkboxes = document.querySelectorAll('.notification-checkbox input[type="checkbox"]');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            updateSelectAllCheckbox();
        });
    });
}

function markNotificationAsReadPage(notificationId) {
    const notification = currentNotifications.find(n => n.id == notificationId);
    if (notification && notification.unread) {
        notification.unread = false;
        
        // Update the main notifications data
        const mainNotification = notificationsData.find(n => n.id == notificationId);
        if (mainNotification) {
            mainNotification.unread = false;
        }
        
        renderNotifications();
        updateNotificationBadge();
        showSuccess('Notification marked as read');
    }
}

function deleteNotification(notificationId) {
    // Remove from current notifications
    currentNotifications = currentNotifications.filter(n => n.id != notificationId);
    
    // Remove from main notifications data
    const index = notificationsData.findIndex(n => n.id == notificationId);
    if (index > -1) {
        notificationsData.splice(index, 1);
    }
    
    renderNotifications();
    updatePagination();
    updateNotificationBadge();
    showSuccess('Notification deleted');
}

function updateSelectAllCheckbox() {
    const selectAllCheckbox = document.getElementById('selectAllNotifications');
    const notificationCheckboxes = document.querySelectorAll('.notification-checkbox input[type="checkbox"]');
    const checkedCheckboxes = document.querySelectorAll('.notification-checkbox input[type="checkbox"]:checked');
    
    if (checkedCheckboxes.length === 0) {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
    } else if (checkedCheckboxes.length === notificationCheckboxes.length) {
        selectAllCheckbox.checked = true;
        selectAllCheckbox.indeterminate = false;
    } else {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = true;
    }
}

// Utility functions
function showSuccess(message) {
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
        transform: translateX(100%);
        transition: transform 0.3s ease;
    `;
    toast.textContent = message;
    
    document.body.appendChild(toast);
    
    // Animate in
    setTimeout(() => {
        toast.style.transform = 'translateX(0)';
    }, 100);
    
    // Remove after 3 seconds
    setTimeout(() => {
        toast.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }, 3000);
}

function showLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.add('show');
    }
}

function closeLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.remove('show');
    }
}

function confirmLogout() {
    // Add logout logic here
    console.log('Logging out...');
    window.location.href = 'login.html';
}
