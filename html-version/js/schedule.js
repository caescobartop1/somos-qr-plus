// Schedule JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize schedule functionality
    initializeNavigation();
    initializeScheduleControls();
    initializeModals();
    initializeAppointments();
    initializeSearchableDropdown();
    initializeStatusFiltering();
    initializeProviderFiltering();
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
    
    // Profile dropdown functionality
    const profileDropdown = document.getElementById('profileDropdown');
    
    if (profileBtn) {
        profileBtn.addEventListener('click', function(event) {
            event.stopPropagation();
            profileDropdown.classList.toggle('show');
        });
    }
    
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
}

// Close drawer function
function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    if (navDrawer) {
        navDrawer.classList.remove('open');
    }
    if (drawerOverlay) {
        drawerOverlay.classList.remove('active');
    }
    document.body.style.overflow = 'auto';
}

// Schedule Controls
function initializeScheduleControls() {
    // Initialize current date and view
    let currentDate = new Date();
    let currentView = 'day';
    
    // View toggle buttons
    const viewButtons = document.querySelectorAll('.view-btn');
    viewButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            // Remove active class from all buttons
            viewButtons.forEach(b => b.classList.remove('active'));
            // Add active class to clicked button
            btn.classList.add('active');
            
            const view = btn.getAttribute('data-view');
            currentView = view;
            console.log('Switched to view:', view);
            updateScheduleView(currentDate, currentView);
        });
    });
    
    // Date navigation
    const prevBtn = document.getElementById('prevWeek');
    const nextBtn = document.getElementById('nextWeek');
    
    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            navigateDate(-1, currentView);
        });
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            navigateDate(1, currentView);
        });
    }
    
    // Add keyboard navigation
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') {
            navigateDate(-1, currentView);
        } else if (e.key === 'ArrowRight') {
            navigateDate(1, currentView);
        }
    });
    
    // Add today button functionality
    const todayBtn = document.getElementById('todayBtn');
    if (todayBtn) {
        todayBtn.addEventListener('click', () => {
            currentDate = new Date();
            updateScheduleView(currentDate, currentView);
        });
    }
    
    // Add click functionality to current date display
    const currentDateDisplay = document.getElementById('currentDateDisplay');
    if (currentDateDisplay) {
        currentDateDisplay.addEventListener('click', () => {
            // Quick jump to today
            currentDate = new Date();
            updateScheduleView(currentDate, currentView);
        });
        
        // Add tooltip
        currentDateDisplay.title = 'Click to jump to today';
    }
    
    // Add double-click to reset view
    let clickCount = 0;
    let clickTimer;
    
    if (currentDateDisplay) {
        currentDateDisplay.addEventListener('click', () => {
            clickCount++;
            if (clickCount === 1) {
                clickTimer = setTimeout(() => {
                    clickCount = 0;
                }, 300);
            } else {
                clearTimeout(clickTimer);
                clickCount = 0;
                // Double click - reset to current day
                currentDate = new Date();
                currentView = 'day';
                // Update view buttons
                viewButtons.forEach(b => b.classList.remove('active'));
                document.querySelector('[data-view="day"]').classList.add('active');
                updateScheduleView(currentDate, currentView);
            }
        });
    }
    
    // Practice dropdown
    const practiceDropdown = document.querySelector('.practice-dropdown');
    if (practiceDropdown) {
        practiceDropdown.addEventListener('change', (e) => {
            console.log('Practice changed to:', e.target.value);
            // TODO: Load schedule for selected practice
        });
    }
    
    // Initialize with day view
    updateScheduleView(currentDate, currentView);
}

// Date navigation
function navigateDate(direction, view) {
    const currentDateElement = document.querySelector('.current-date');
    if (!currentDateElement) return;
    
    let currentDate = new Date();
    
    // Parse current date from display based on view format
    const currentText = currentDateElement.textContent;
    
    if (view === 'day') {
        // Parse single day format: "Monday, July 29, 2025"
        const dayMatch = currentText.match(/(\w+),\s+(\w+)\s+(\d+),\s+(\d+)/);
        if (dayMatch) {
            const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                               'July', 'August', 'September', 'October', 'November', 'December'];
            const monthIndex = monthNames.indexOf(dayMatch[2]);
            if (monthIndex !== -1) {
                currentDate = new Date(parseInt(dayMatch[4]), monthIndex, parseInt(dayMatch[3]));
            }
        }
    } else if (view === 'week') {
        // Parse week format: "July 29 - August 4, 2025"
        const weekMatch = currentText.match(/(\w+)\s+(\d+)\s*-\s*(\w+)\s+(\d+),\s*(\d+)/);
        if (weekMatch) {
            const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                               'July', 'August', 'September', 'October', 'November', 'December'];
            const startMonthIndex = monthNames.indexOf(weekMatch[1]);
            if (startMonthIndex !== -1) {
                currentDate = new Date(parseInt(weekMatch[5]), startMonthIndex, parseInt(weekMatch[2]));
            }
        }
    } else if (view === 'month') {
        // Parse month format: "July 2025"
        const monthMatch = currentText.match(/(\w+)\s+(\d+)/);
        if (monthMatch) {
            const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 
                               'July', 'August', 'September', 'October', 'November', 'December'];
            const monthIndex = monthNames.indexOf(monthMatch[1]);
            if (monthIndex !== -1) {
                currentDate = new Date(parseInt(monthMatch[2]), monthIndex, 1);
            }
        }
    }
    
    // Navigate based on view
    switch(view) {
        case 'day':
            currentDate.setDate(currentDate.getDate() + direction);
            break;
        case 'week':
            currentDate.setDate(currentDate.getDate() + (direction * 7));
            break;
        case 'month':
            currentDate.setMonth(currentDate.getMonth() + direction);
            break;
    }
    
    updateScheduleView(currentDate, view);
}

// Update schedule view
function updateScheduleView(date, view) {
    console.log(`Updating schedule view to ${view} for ${date.toDateString()}`);
    
    const scheduleGrid = document.querySelector('.schedule-grid');
    if (!scheduleGrid) return;
    
    // Clear existing grid
    scheduleGrid.innerHTML = '';
    
    switch(view) {
        case 'day':
            createDayView(scheduleGrid, date);
            break;
        case 'week':
            createWeekView(scheduleGrid, date);
            break;
        case 'month':
            createMonthView(scheduleGrid, date);
            break;
    }
    
        // Re-initialize appointment interactions
    initializeAppointments();
}

// Create day view
function createDayView(container, date) {
    const dayName = date.toLocaleDateString('en-US', { weekday: 'long' });
    const dayDate = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    
    container.style.gridTemplateColumns = '100px 1fr';
    
    // Time column
    const timeColumn = document.createElement('div');
    timeColumn.className = 'time-column';
    timeColumn.innerHTML = `
        <div class="time-header">Time</div>
        <div class="time-slots">
            <div class="time-slot">8:00 AM</div>
            <div class="time-slot">9:00 AM</div>
            <div class="time-slot">10:00 AM</div>
            <div class="time-slot">11:00 AM</div>
            <div class="time-slot">12:00 PM</div>
            <div class="time-slot">1:00 PM</div>
            <div class="time-slot">2:00 PM</div>
            <div class="time-slot">3:00 PM</div>
            <div class="time-slot">4:00 PM</div>
            <div class="time-slot">5:00 PM</div>
        </div>
    `;
    container.appendChild(timeColumn);
    
    // Day column
    const dayColumn = document.createElement('div');
    dayColumn.className = 'day-column';
    dayColumn.innerHTML = `
        <div class="day-header">
            <div class="day-name">${dayName}</div>
            <div class="day-date">${dayDate}</div>
        </div>
        <div class="day-slots">
            <!-- Sample appointments for the day -->
            <div class="appointment" style="top: 60px; height: 60px; background: #4CAF50;">
                <div class="appointment-content">
                    <div class="patient-name">Sarah Johnson</div>
                    <div class="appointment-time">9:00 - 10:00</div>
                    <div class="appointment-type">Annual Checkup</div>
                </div>
            </div>
            <div class="appointment" style="top: 180px; height: 60px; background: #2196F3;">
                <div class="appointment-content">
                    <div class="patient-name">Michael Chen</div>
                    <div class="appointment-time">11:00 - 12:00</div>
                    <div class="appointment-type">Follow-up</div>
                </div>
            </div>
        </div>
    `;
    container.appendChild(dayColumn);
}

// Create week view
function createWeekView(container, date) {
    container.style.gridTemplateColumns = '100px repeat(7, 1fr)';
    
    // Time column
    const timeColumn = document.createElement('div');
    timeColumn.className = 'time-column';
    timeColumn.innerHTML = `
        <div class="time-header">Time</div>
        <div class="time-slots">
            <div class="time-slot">8:00 AM</div>
            <div class="time-slot">9:00 AM</div>
            <div class="time-slot">10:00 AM</div>
            <div class="time-slot">11:00 AM</div>
            <div class="time-slot">12:00 PM</div>
            <div class="time-slot">1:00 PM</div>
            <div class="time-slot">2:00 PM</div>
            <div class="time-slot">3:00 PM</div>
            <div class="time-slot">4:00 PM</div>
            <div class="time-slot">5:00 PM</div>
        </div>
    `;
    container.appendChild(timeColumn);
    
    // Find Monday of the current week
    const monday = new Date(date);
    const dayOfWeek = date.getDay();
    const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
    monday.setDate(date.getDate() - daysToMonday);
    
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    // Create day columns
    for (let i = 0; i < 7; i++) {
        const currentDate = new Date(monday);
        currentDate.setDate(monday.getDate() + i);
        
        const dayName = dayNames[i];
        const dayDate = currentDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
        const isWeekend = i >= 5;
        
        const dayColumn = document.createElement('div');
        dayColumn.className = `day-column ${isWeekend ? 'weekend' : ''}`;
        dayColumn.setAttribute('data-day', dayName.toLowerCase());
        
        dayColumn.innerHTML = `
            <div class="day-header">
                <div class="day-name">${dayName}</div>
                <div class="day-date">${dayDate}</div>
            </div>
            <div class="day-slots">
                ${getAppointmentsForDay(i)}
            </div>
        `;
        
        container.appendChild(dayColumn);
    }
}

// Create month view
function createMonthView(container, date) {
    container.style.gridTemplateColumns = 'repeat(7, 1fr)';
    
    const monthName = date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
    
    // Create month header
    const monthHeader = document.createElement('div');
    monthHeader.className = 'month-header';
    monthHeader.style.gridColumn = '1 / -1';
    monthHeader.innerHTML = `<h2>${monthName}</h2>`;
    container.appendChild(monthHeader);
    
    // Create day headers
    const dayHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    dayHeaders.forEach(day => {
        const dayHeader = document.createElement('div');
        dayHeader.className = 'month-day-header';
        dayHeader.textContent = day;
        container.appendChild(dayHeader);
    });
    
    // Get first day of month and number of days
    const firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
    const lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
    const daysInMonth = lastDay.getDate();
    const startDayOfWeek = firstDay.getDay();
    
    // Add empty cells for days before month starts
    for (let i = 0; i < startDayOfWeek; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.className = 'month-day empty';
        container.appendChild(emptyCell);
    }
    
    // Add day cells
    for (let day = 1; day <= daysInMonth; day++) {
        const dayCell = document.createElement('div');
        dayCell.className = 'month-day';
        dayCell.innerHTML = `
            <div class="day-number">${day}</div>
            <div class="day-appointments">
                ${getMonthAppointments(day)}
            </div>
        `;
        container.appendChild(dayCell);
    }
}

// Get appointments for specific day (sample data)
function getAppointmentsForDay(dayIndex) {
    const appointments = {
        0: [ // Monday
            '<div class="appointment" style="top: 60px; height: 60px; background: #4CAF50;"><div class="appointment-content"><div class="patient-name">Sarah Johnson</div><div class="appointment-time">9:00 - 10:00</div><div class="appointment-type">Annual Checkup</div></div></div>',
            '<div class="appointment" style="top: 180px; height: 60px; background: #2196F3;"><div class="appointment-content"><div class="patient-name">Michael Chen</div><div class="appointment-time">11:00 - 12:00</div><div class="appointment-type">Follow-up</div></div></div>'
        ],
        1: [ // Tuesday
            '<div class="appointment" style="top: 120px; height: 60px; background: #FF9800;"><div class="appointment-content"><div class="patient-name">Emily Rodriguez</div><div class="appointment-time">10:00 - 11:00</div><div class="appointment-type">Consultation</div></div></div>'
        ],
        2: [ // Wednesday
            '<div class="appointment" style="top: 240px; height: 60px; background: #9C27B0;"><div class="appointment-content"><div class="patient-name">David Kim</div><div class="appointment-time">2:00 - 3:00</div><div class="appointment-type">Physical Exam</div></div></div>'
        ],
        3: [ // Thursday
            '<div class="appointment" style="top: 60px; height: 60px; background: #F44336;"><div class="appointment-content"><div class="patient-name">Lisa Thompson</div><div class="appointment-time">9:00 - 10:00</div><div class="appointment-type">Urgent Care</div></div></div>'
        ],
        4: [ // Friday
            '<div class="appointment" style="top: 180px; height: 60px; background: #607D8B;"><div class="appointment-content"><div class="patient-name">Robert Wilson</div><div class="appointment-time">11:00 - 12:00</div><div class="appointment-type">Vaccination</div></div></div>'
        ],
        5: [], // Saturday
        6: []  // Sunday
    };
    
    return appointments[dayIndex] ? appointments[dayIndex].join('') : '';
}

// Get month appointments (sample data)
function getMonthAppointments(day) {
    // Sample appointment counts for specific days
    const monthAppointments = {
        15: 2,  // 2 appointments - Green
        16: 1,  // 1 appointment - Green
        17: 1,  // 1 appointment - Green
        18: 1,  // 1 appointment - Green
        19: 1   // 1 appointment - Green
    };
    
    const count = monthAppointments[day] || 0;
    
    if (count === 0) return '';
    
    // Color coding based on appointment count
    let backgroundColor;
    if (count <= 5) {
        backgroundColor = '#4CAF50'; // Green
    } else if (count <= 10) {
        backgroundColor = '#FFC107'; // Yellow
    } else if (count <= 15) {
        backgroundColor = '#F44336'; // Red
    } else {
        backgroundColor = '#9C27B0'; // Purple for 15+ (fallback)
    }
    
    return `<div class="month-appointment" style="background: ${backgroundColor};">${count}</div>`;
}



// Modal functionality
function initializeModals() {
    const addAppointmentBtn = document.getElementById('addAppointment');
    const addAppointmentModal = document.getElementById('addAppointmentModal');
    const closeAddAppointmentModal = document.getElementById('closeAddAppointmentModal');
    const cancelAddAppointment = document.getElementById('cancelAddAppointment');
    const addAppointmentForm = document.getElementById('addAppointmentForm');
    
    // Open add appointment modal
    if (addAppointmentBtn) {
        addAppointmentBtn.addEventListener('click', () => {
            openModal(addAppointmentModal);
        });
    }
    
    // Close modal buttons
    if (closeAddAppointmentModal) {
        closeAddAppointmentModal.addEventListener('click', () => {
            closeModal(addAppointmentModal);
        });
    }
    
    if (cancelAddAppointment) {
        cancelAddAppointment.addEventListener('click', () => {
            closeModal(addAppointmentModal);
        });
    }
    
    // Close modal when clicking outside
    if (addAppointmentModal) {
        addAppointmentModal.addEventListener('click', (e) => {
            if (e.target === addAppointmentModal) {
                closeModal(addAppointmentModal);
            }
        });
    }
    
    // Form submission
    if (addAppointmentForm) {
        addAppointmentForm.addEventListener('submit', (e) => {
            e.preventDefault();
            handleAddAppointment();
        });
    }
    
    // Initialize patient name field switching
    initializePatientNameField();
}

// Open modal
function openModal(modal) {
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

// Close modal
function closeModal(modal) {
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

// Initialize patient name field switching
function initializePatientNameField() {
    const appointmentTypeSelect = document.getElementById('appointmentType');
    const patientNameInput = document.getElementById('patientName');
    const patientNameDropdown = document.getElementById('patientNameDropdown');
    const newPatientOnboarding = document.getElementById('newPatientOnboarding');
    
    // Always show dropdown for all appointment types
    if (patientNameDropdown) {
        patientNameDropdown.style.display = 'block';
        patientNameDropdown.required = true;
    }
    
    // Handle patient selection (including new patient)
    if (patientNameDropdown) {
        patientNameDropdown.addEventListener('change', function() {
            const selectedPatient = this.value;
            
            if (selectedPatient === 'new-patient') {
                // Show new patient onboarding fields
                patientNameInput.style.display = 'block';
                patientNameInput.required = true;
                newPatientOnboarding.style.display = 'block';
                
                // Make onboarding fields required
                const onboardingFields = newPatientOnboarding.querySelectorAll('input, textarea');
                onboardingFields.forEach(field => {
                    field.required = true;
                });
            } else if (selectedPatient) {
                // Hide new patient fields for existing patients
                patientNameInput.style.display = 'none';
                patientNameInput.required = false;
                newPatientOnboarding.style.display = 'none';
                
                // Remove required from onboarding fields
                const onboardingFields = newPatientOnboarding.querySelectorAll('input, textarea');
                onboardingFields.forEach(field => {
                    field.required = false;
                });
            } else {
                // No patient selected - hide all fields
                patientNameInput.style.display = 'none';
                patientNameInput.required = false;
                newPatientOnboarding.style.display = 'none';
                
                // Remove required from onboarding fields
                const onboardingFields = newPatientOnboarding.querySelectorAll('input, textarea');
                onboardingFields.forEach(field => {
                    field.required = false;
                });
            }
        });
    }
}

// Handle add appointment
function handleAddAppointment() {
    const form = document.getElementById('addAppointmentForm');
    const appointmentType = document.getElementById('appointmentType').value;
    const selectedPatient = document.getElementById('patientNameDropdown').value;
    
    // Get patient name and onboarding data
    let patientName = '';
    let newPatientData = null;
    
    if (selectedPatient === 'new-patient') {
        patientName = document.getElementById('patientName').value;
        newPatientData = {
            name: patientName,
            email: document.getElementById('patientEmail').value,
            phone: document.getElementById('patientPhone').value,
            dateOfBirth: document.getElementById('patientDOB').value,
            address: document.getElementById('patientAddress').value,
            insurance: document.getElementById('patientInsurance').value,
            emergencyContact: document.getElementById('patientEmergencyContact').value
        };
    } else {
        patientName = selectedPatient;
    }
    
    const appointmentData = {
        patientName: patientName,
        date: document.getElementById('appointmentDate').value,
        time: document.getElementById('appointmentTime').value,
        duration: document.getElementById('appointmentDuration').value,
        type: appointmentType,
        notes: document.getElementById('appointmentNotes').value,
        newPatientData: newPatientData
    };
    
    // Validate required fields
    if (!appointmentData.patientName || !appointmentData.date || !appointmentData.time || !appointmentData.type) {
        showNotification('Please fill in all required fields', 'error');
        return;
    }
    
    // Validate new patient onboarding fields if applicable
    if (selectedPatient === 'new-patient') {
        const requiredOnboardingFields = ['patientEmail', 'patientPhone', 'patientDOB', 'patientAddress', 'patientInsurance', 'patientEmergencyContact'];
        const missingFields = requiredOnboardingFields.filter(fieldId => !document.getElementById(fieldId).value);
        
        if (missingFields.length > 0) {
            showNotification('Please fill in all new patient information', 'error');
            return;
        }
    }
    
    // Simulate API call
    console.log('Adding appointment:', appointmentData);
    
    // Show success message
    const message = selectedPatient === 'new-patient' 
        ? 'New patient created and appointment added successfully!' 
        : 'Appointment added successfully!';
    showNotification(message, 'success');
    
    // Close modal and reset form
    closeModal(document.getElementById('addAppointmentModal'));
    form.reset();
    
    // Reset all field displays
    const patientNameInput = document.getElementById('patientName');
    const patientNameDropdown = document.getElementById('patientNameDropdown');
    const newPatientOnboarding = document.getElementById('newPatientOnboarding');
    
    patientNameInput.style.display = 'none';
    patientNameInput.required = false;
    newPatientOnboarding.style.display = 'none';
    
    // Remove required from onboarding fields
    const onboardingFields = newPatientOnboarding.querySelectorAll('input, textarea');
    onboardingFields.forEach(field => {
        field.required = false;
    });
    
    // TODO: Add appointment to schedule grid
}

// Initialize appointment interactions
function initializeAppointments() {
    const appointments = document.querySelectorAll('.appointment');
    
    appointments.forEach(appointment => {
        appointment.addEventListener('click', () => {
            const patientName = appointment.querySelector('.patient-name').textContent;
            const appointmentTime = appointment.querySelector('.appointment-time').textContent;
            const appointmentType = appointment.querySelector('.appointment-type').textContent;
            
            showAppointmentDetails(patientName, appointmentTime, appointmentType);
        });
    });
}

// Show appointment details
function showAppointmentDetails(patientName, time, type) {
    const modal = document.createElement('div');
    modal.className = 'modal show';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h2>Appointment Details</h2>
                <button class="close-btn" onclick="this.closest('.modal').remove()">×</button>
            </div>
            <div class="modal-body">
                <div class="appointment-details">
                    <div class="detail-item">
                        <label>Patient:</label>
                        <span>${patientName}</span>
                    </div>
                    <div class="detail-item">
                        <label>Time:</label>
                        <span>${time}</span>
                    </div>
                    <div class="detail-item">
                        <label>Type:</label>
                        <span>${type}</span>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="this.closest('.modal').remove()">Close</button>
                    <button type="button" class="btn-primary" onclick="editAppointment('${patientName}')">Edit</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Close on outside click
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.remove();
        }
    });
}

// Edit appointment (placeholder)
function editAppointment(patientName) {
    console.log('Editing appointment for:', patientName);
    showNotification('Edit functionality coming soon!', 'info');
    document.querySelector('.modal').remove();
}

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
            updateScheduleData(value, text);
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

// Update Schedule Data (placeholder function)
function updateScheduleData(provider, providerText) {
    // This function would typically:
    // 1. Make API calls to fetch new schedule data for the selected provider
    // 2. Update the calendar view
    // 3. Update the appointment list
    // 4. Update any schedule-related metrics
    
    console.log('Updating schedule data for:', providerText);
    
    // Show a success message
    showNotification(`Schedule updated for ${providerText}`, 'success');
}

// Status Filtering Functionality
function initializeStatusFiltering() {
    const statusButtons = document.querySelectorAll('.status-filter-btn');
    const appointments = document.querySelectorAll('.appointment');
    
    let currentFilter = 'all';
    
    // Add click event listeners to status filter buttons
    statusButtons.forEach(button => {
        button.addEventListener('click', function() {
            const status = this.getAttribute('data-status');
            
            // Update active button
            statusButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Filter appointments
            filterAppointmentsByStatus(status);
            
            // Update current filter
            currentFilter = status;
            
            // Show notification
            const statusText = status === 'all' ? 'All appointments' : status.charAt(0).toUpperCase() + status.slice(1) + ' appointments';
            showSuccess(`Showing ${statusText}`);
        });
    });
    
    function filterAppointmentsByStatus(status) {
        appointments.forEach(appointment => {
            const appointmentStatus = appointment.getAttribute('data-status');
            
            if (status === 'all' || appointmentStatus === status) {
                appointment.style.display = 'block';
                appointment.style.opacity = '1';
            } else {
                appointment.style.display = 'none';
                appointment.style.opacity = '0';
            }
        });
    }
}

// Provider Filtering Functionality
function initializeProviderFiltering() {
    const providerSelect = document.getElementById('providerSelect');
    const appointments = document.querySelectorAll('.appointment');
    
    let currentProvider = 'all';
    
    // Add change event listener to provider select
    if (providerSelect) {
        providerSelect.addEventListener('change', function() {
            const provider = this.value;
            
            // Update current provider
            currentProvider = provider;
            
            // Filter appointments by provider
            filterAppointmentsByProvider(provider);
            
            // Show success message
            const providerText = provider === 'all' ? 'All providers' : this.options[this.selectedIndex].text;
            showSuccess(`Showing appointments for ${providerText}`);
        });
    }
    
    function filterAppointmentsByProvider(provider) {
        appointments.forEach(appointment => {
            const appointmentProvider = appointment.getAttribute('data-provider') || 'dr-smith'; // Default provider
            
            if (provider === 'all' || appointmentProvider === provider) {
                appointment.style.display = 'block';
                appointment.style.opacity = '1';
            } else {
                appointment.style.display = 'none';
                appointment.style.opacity = '0';
            }
        });
    }
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