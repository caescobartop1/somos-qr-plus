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
            if (page && page !== 'settings') {
                window.location.href = `../pages/${page}.html`;
            }
        });
    });

    // Modal functionality
    const modals = {
        reportBug: document.getElementById('reportBugModal'),
        changePassword: document.getElementById('changePasswordModal'),
        invite: document.getElementById('inviteModal'),
        accounts: document.getElementById('accountsModal')
    };

    const modalButtons = {
        reportBug: document.getElementById('reportBugBtn'),
        changePassword: document.getElementById('changePasswordBtn'),
        invite: document.getElementById('inviteBtn'),
        accounts: document.getElementById('accountsBtn')
    };

    const closeButtons = {
        reportBug: document.getElementById('closeReportBugModal'),
        changePassword: document.getElementById('closeChangePasswordModal'),
        invite: document.getElementById('closeInviteModal'),
        accounts: document.getElementById('closeAccountsModal')
    };

    const cancelButtons = {
        reportBug: document.getElementById('cancelReportBug'),
        changePassword: document.getElementById('cancelChangePassword'),
        invite: document.getElementById('cancelInvite'),
        accounts: document.getElementById('cancelAccounts')
    };

    // Open modal functions
    function openModal(modalName) {
        const modal = modals[modalName];
        if (modal) {
            modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }
    }

    // Close modal functions
    function closeModal(modalName) {
        const modal = modals[modalName];
        if (modal) {
            modal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }
    }

    // Close all modals
    function closeAllModals() {
        Object.values(modals).forEach(modal => {
            if (modal) {
                modal.classList.remove('show');
            }
        });
        document.body.style.overflow = 'auto';
    }

    // Event listeners for opening modals
    modalButtons.reportBug.addEventListener('click', () => openModal('reportBug'));
    modalButtons.changePassword.addEventListener('click', () => openModal('changePassword'));
    modalButtons.invite.addEventListener('click', () => openModal('invite'));
    modalButtons.accounts.addEventListener('click', () => openModal('accounts'));

    // Event listeners for closing modals
    closeButtons.reportBug.addEventListener('click', () => closeModal('reportBug'));
    closeButtons.changePassword.addEventListener('click', () => closeModal('changePassword'));
    closeButtons.invite.addEventListener('click', () => closeModal('invite'));
    closeButtons.accounts.addEventListener('click', () => closeModal('accounts'));

    // Event listeners for cancel buttons
    cancelButtons.reportBug.addEventListener('click', () => closeModal('reportBug'));
    cancelButtons.changePassword.addEventListener('click', () => closeModal('changePassword'));
    cancelButtons.accounts.addEventListener('click', () => closeModal('accounts'));

    // Close modal when clicking outside
    Object.values(modals).forEach(modal => {
        if (modal) {
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeAllModals();
                }
            });
        }
    });

    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });

    // Toggle switches functionality
    const twoFactorToggle = document.getElementById('twoFactorToggle');
    const darkModeToggle = document.getElementById('darkModeToggle');

    // Load saved settings from localStorage
    function loadSettings() {
        const savedTwoFactor = localStorage.getItem('twoFactorEnabled');
        const savedDarkMode = localStorage.getItem('darkModeEnabled');

        if (savedTwoFactor === 'true') {
            twoFactorToggle.checked = true;
        }

        if (savedDarkMode === 'true') {
            darkModeToggle.checked = true;
            enableDarkMode();
        }
    }

    // User Management Functionality
    let currentPage = 1;
    let usersPerPage = 10;
    let filteredUsers = [];
    let allUsers = [
        { name: 'Mirza Morales-Diaz', role: 'Admin', status: true, lastLogin: '04/29/2025' },
        { name: 'Joel Cedano', role: 'Provider', status: true, lastLogin: '04/28/2025' },
        { name: 'Sarah Johnson', role: 'Nurse', status: false, lastLogin: '04/27/2025' },
        { name: 'Michael Chen', role: 'Admin', status: true, lastLogin: '04/26/2025' },
        { name: 'Emily Rodriguez', role: 'Provider', status: true, lastLogin: '04/25/2025' },
        { name: 'David Kim', role: 'Nurse', status: false, lastLogin: '04/24/2025' },
        { name: 'Lisa Thompson', role: 'Viewer', status: true, lastLogin: '04/23/2025' },
        { name: 'Robert Wilson', role: 'Provider', status: true, lastLogin: '04/22/2025' }
    ];

    // Initialize user management
    function initUserManagement() {
        filteredUsers = [...allUsers];
        renderUsersTable();
        setupUserEventListeners();
    }

    // Setup event listeners for user management
    function setupUserEventListeners() {
        // Filter functionality
        const userFilter = document.getElementById('userFilter');
        if (userFilter) {
            userFilter.addEventListener('input', function() {
                filterUsers(this.value);
            });
        }

        // Sort functionality
        const sortableHeaders = document.querySelectorAll('.users-table th.sortable');
        sortableHeaders.forEach(header => {
            header.addEventListener('click', function() {
                const column = this.textContent.trim().toLowerCase();
                sortUsers(column);
            });
        });

        // Pagination
        const paginationButtons = {
            firstPage: document.getElementById('firstPage'),
            prevPage: document.getElementById('prevPage'),
            nextPage: document.getElementById('nextPage'),
            lastPage: document.getElementById('lastPage')
        };

        Object.entries(paginationButtons).forEach(([key, button]) => {
            if (button) {
                button.addEventListener('click', () => handlePagination(key));
            }
        });

        // User status toggles
        const statusToggles = document.querySelectorAll('.users-table .toggle-switch input');
        statusToggles.forEach(toggle => {
            toggle.addEventListener('change', function() {
                const row = this.closest('tr');
                const userName = row.cells[0].textContent;
                const isActive = this.checked;
                
                updateUserStatus(userName, isActive);
                showNotification(`${userName} ${isActive ? 'activated' : 'deactivated'}`, 'success');
            });
        });

        // Select role buttons
        const selectRoleButtons = document.querySelectorAll('.btn-select-role');
        selectRoleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const row = this.closest('tr');
                const userName = row.cells[0].textContent;
                showRoleSelectionModal(userName);
            });
        });
    }

    // Filter users
    function filterUsers(searchTerm) {
        if (!searchTerm) {
            filteredUsers = [...allUsers];
        } else {
            filteredUsers = allUsers.filter(user => 
                user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                user.role.toLowerCase().includes(searchTerm.toLowerCase())
            );
        }
        currentPage = 1;
        renderUsersTable();
    }

    // Sort users
    function sortUsers(column) {
        filteredUsers.sort((a, b) => {
            let aVal = a[column] || a[column === 'name' ? 'name' : column === 'role' ? 'role' : 'lastLogin'];
            let bVal = b[column] || b[column === 'name' ? 'name' : column === 'role' ? 'role' : 'lastLogin'];
            
            if (typeof aVal === 'string') {
                return aVal.localeCompare(bVal);
            }
            return aVal - bVal;
        });
        renderUsersTable();
    }

    // Render users table
    function renderUsersTable() {
        const tbody = document.getElementById('usersTableBody');
        if (!tbody) return;

        const startIndex = (currentPage - 1) * usersPerPage;
        const endIndex = startIndex + usersPerPage;
        const pageUsers = filteredUsers.slice(startIndex, endIndex);

        tbody.innerHTML = pageUsers.map(user => `
            <tr>
                <td>${user.name}</td>
                <td>${user.role}</td>
                <td>
                    <label class="toggle-switch small">
                        <input type="checkbox" ${user.status ? 'checked' : ''}>
                        <span class="toggle-slider"></span>
                    </label>
                </td>
                <td>${user.lastLogin}</td>
                <td>
                    <button class="btn-select-role">select role</button>
                </td>
            </tr>
        `).join('');

        // Re-attach event listeners
        setupUserEventListeners();
        updatePagination();
    }

    // Update pagination
    function updatePagination() {
        const totalPages = Math.ceil(filteredUsers.length / usersPerPage);
        const currentPageBtn = document.getElementById('currentPage');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const firstBtn = document.getElementById('firstPage');
        const lastBtn = document.getElementById('lastPage');

        if (currentPageBtn) currentPageBtn.textContent = currentPage;
        if (prevBtn) prevBtn.disabled = currentPage === 1;
        if (nextBtn) nextBtn.disabled = currentPage === totalPages;
        if (firstBtn) firstBtn.disabled = currentPage === 1;
        if (lastBtn) lastBtn.disabled = currentPage === totalPages;
    }

    // Handle pagination
    function handlePagination(action) {
        const totalPages = Math.ceil(filteredUsers.length / usersPerPage);
        
        switch (action) {
            case 'firstPage':
                currentPage = 1;
                break;
            case 'prevPage':
                currentPage = Math.max(1, currentPage - 1);
                break;
            case 'nextPage':
                currentPage = Math.min(totalPages, currentPage + 1);
                break;
            case 'lastPage':
                currentPage = totalPages;
                break;
        }
        
        renderUsersTable();
    }

    // Update user status
    function updateUserStatus(userName, status) {
        const user = allUsers.find(u => u.name === userName);
        if (user) {
            user.status = status;
        }
    }

    // Show role selection modal (placeholder)
    function showRoleSelectionModal(userName) {
        const roles = ['Admin', 'Provider', 'Nurse', 'Viewer'];
        const currentRole = allUsers.find(u => u.name === userName)?.role || 'Viewer';
        
        const roleOptions = roles.map(role => 
            `<option value="${role}" ${role === currentRole ? 'selected' : ''}>${role}</option>`
        ).join('');

        const modal = document.createElement('div');
        modal.className = 'modal show';
        modal.innerHTML = `
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Change Role for ${userName}</h2>
                    <button class="close-btn" onclick="this.closest('.modal').remove()">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="newRole">Select New Role</label>
                        <select id="newRole">
                            ${roleOptions}
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="this.closest('.modal').remove()">Cancel</button>
                        <button type="button" class="btn-primary" onclick="changeUserRole('${userName}')">Update Role</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
    }

    // Change user role
    function changeUserRole(userName) {
        const newRole = document.getElementById('newRole').value;
        const user = allUsers.find(u => u.name === userName);
        
        if (user) {
            user.role = newRole;
            renderUsersTable();
            showNotification(`${userName}'s role changed to ${newRole}`, 'success');
        }
        
        document.querySelector('.modal').remove();
    }

    // Initialize user management when accounts modal is opened
    const originalOpenModal = openModal;
    openModal = function(modalName) {
        originalOpenModal(modalName);
        if (modalName === 'accounts') {
            setTimeout(() => {
                initUserManagement();
                feather.replace(); // Re-initialize icons
            }, 100);
        } else if (modalName === 'invite') {
            setTimeout(() => {
                setupInviteModal();
                feather.replace(); // Re-initialize icons
            }, 100);
        }
    };

    // Setup invite modal functionality
    function setupInviteModal() {
        // Action dots button functionality
        const firstNameAction = document.getElementById('firstNameAction');
        if (firstNameAction) {
            firstNameAction.addEventListener('click', function() {
                showFirstNameActionMenu();
            });
        }
    }

    // Show first name action menu
    function showFirstNameActionMenu() {
        const menu = document.createElement('div');
        menu.className = 'action-menu';
        menu.innerHTML = `
            <div class="action-menu-content">
                <button class="action-menu-item" onclick="autoFillFirstName()">
                    <i data-feather="user-plus"></i>
                    Auto-fill from Directory
                </button>
                <button class="action-menu-item" onclick="clearFirstName()">
                    <i data-feather="x"></i>
                    Clear Field
                </button>
            </div>
        `;
        
        menu.style.cssText = `
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1000;
            min-width: 200px;
            margin-top: 4px;
        `;
        
        const firstNameContainer = document.querySelector('.input-with-action');
        firstNameContainer.style.position = 'relative';
        firstNameContainer.appendChild(menu);
        
        // Close menu when clicking outside
        document.addEventListener('click', function closeMenu(e) {
            if (!menu.contains(e.target) && !firstNameAction.contains(e.target)) {
                menu.remove();
                document.removeEventListener('click', closeMenu);
            }
        });
        
        feather.replace();
    }

    // Auto-fill first name function
    window.autoFillFirstName = function() {
        const firstNameInput = document.getElementById('inviteFirstName');
        firstNameInput.value = 'John'; // Simulate auto-fill
        showNotification('First name auto-filled from directory', 'success');
        document.querySelector('.action-menu')?.remove();
    };

    // Clear first name function
    window.clearFirstName = function() {
        const firstNameInput = document.getElementById('inviteFirstName');
        firstNameInput.value = '';
        showNotification('First name field cleared', 'info');
        document.querySelector('.action-menu')?.remove();
    };

    // Save settings to localStorage
    function saveSettings() {
        localStorage.setItem('twoFactorEnabled', twoFactorToggle.checked);
        localStorage.setItem('darkModeEnabled', darkModeToggle.checked);
    }

    // Dark mode functionality
    function enableDarkMode() {
        document.body.classList.add('dark-mode');
        document.documentElement.setAttribute('data-theme', 'dark');
    }

    function disableDarkMode() {
        document.body.classList.remove('dark-mode');
        document.documentElement.setAttribute('data-theme', 'light');
    }

    // Toggle event listeners
    twoFactorToggle.addEventListener('change', function() {
        saveSettings();
        if (this.checked) {
            showNotification('2-Step Verification enabled', 'success');
        } else {
            showNotification('2-Step Verification disabled', 'info');
        }
    });

    darkModeToggle.addEventListener('change', function() {
        saveSettings();
        if (this.checked) {
            enableDarkMode();
            showNotification('Dark mode enabled', 'success');
        } else {
            disableDarkMode();
            showNotification('Dark mode disabled', 'info');
        }
    });

    // Form submissions
    const bugReportForm = document.getElementById('bugReportForm');
    const changePasswordForm = document.getElementById('changePasswordForm');
    const inviteForm = document.getElementById('inviteForm');
    const accountsForm = document.getElementById('accountsForm');

    // Bug report form
    bugReportForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const title = document.getElementById('bugTitle').value;
        const description = document.getElementById('bugDescription').value;
        const severity = document.getElementById('bugSeverity').value;

        // Simulate API call
        console.log('Bug Report Submitted:', { title, description, severity });
        
        showNotification('Bug report submitted successfully!', 'success');
        closeModal('reportBug');
        bugReportForm.reset();
    });

    // Change password form
    changePasswordForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const currentPassword = document.getElementById('currentPassword').value;
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            showNotification('New passwords do not match', 'error');
            return;
        }

        if (newPassword.length < 8) {
            showNotification('Password must be at least 8 characters long', 'error');
            return;
        }

        // Simulate API call
        console.log('Password Change Request:', { currentPassword, newPassword });
        
        showNotification('Password changed successfully!', 'success');
        closeModal('changePassword');
        changePasswordForm.reset();
    });

    // Invite form
    inviteForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const role = document.getElementById('inviteRole').value;
        const npi = document.getElementById('inviteNpi').value;
        const firstName = document.getElementById('inviteFirstName').value;
        const lastName = document.getElementById('inviteLastName').value;
        const phone = document.getElementById('invitePhone').value;
        const email = document.getElementById('inviteEmail').value;

        // Validate required fields
        if (!role || !npi || !firstName || !lastName || !phone || !email) {
            showNotification('Please fill in all required fields', 'error');
            return;
        }

        // Simulate API call
        console.log('New Invite Sent:', { role, npi, firstName, lastName, phone, email });
        
        showNotification('Invitation sent successfully!', 'success');
        closeModal('invite');
        inviteForm.reset();
    });

    // Accounts form
    accountsForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const name = document.getElementById('accountName').value;
        const email = document.getElementById('accountEmail').value;
        const phone = document.getElementById('accountPhone').value;
        const practice = document.getElementById('accountPractice').value;

        // Simulate API call
        console.log('Account Updated:', { name, email, phone, practice });
        
        showNotification('Account settings updated successfully!', 'success');
        closeModal('accounts');
    });

    // Notification system
    function showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <span class="notification-message">${message}</span>
                <button class="notification-close">×</button>
            </div>
        `;

        // Add styles
        notification.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            background: ${type === 'success' ? '#4caf50' : type === 'error' ? '#f44336' : '#2196f3'};
            color: white;
            padding: 16px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 3000;
            max-width: 400px;
            animation: slideInRight 0.3s ease-out;
        `;

        // Add animation styles
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
            .notification-content {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
            }
            .notification-close {
                background: none;
                border: none;
                color: white;
                font-size: 18px;
                cursor: pointer;
                padding: 0;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
        `;
        document.head.appendChild(style);

        // Add to page
        document.body.appendChild(notification);

        // Close button functionality
        const closeBtn = notification.querySelector('.notification-close');
        closeBtn.addEventListener('click', () => {
            notification.remove();
        });

        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    // Initialize settings
    loadSettings();

    // Add some sample data for demonstration
    console.log('Settings page loaded successfully');
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