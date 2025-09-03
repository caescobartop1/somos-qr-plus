document.addEventListener('DOMContentLoaded', function() {
    // Initialize all functionality
    initializeNavigation();
    initializeKPICards();
    initializeTableSorting();
    initializePagination();
    initializeTableControls();
    initializeInlineFilters();
});

// Navigation functionality
function initializeNavigation() {
    const navDrawer = document.getElementById('navDrawer');
    const menuBtn = document.querySelector('.nav-menu-btn');
    const profileBtn = document.querySelector('.profile-btn');
    const drawerItems = document.querySelectorAll('.drawer-item[data-page]');

    // Open/close drawer
    menuBtn.addEventListener('click', function() {
        navDrawer.classList.toggle('open');
        document.body.style.overflow = navDrawer.classList.contains('open') ? 'hidden' : '';
    });

    // Close drawer when clicking outside
    document.addEventListener('click', function(e) {
        if (!navDrawer.contains(e.target) && !menuBtn.contains(e.target)) {
            navDrawer.classList.remove('open');
            document.body.style.overflow = '';
        }
    });

    // Close drawer with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            navDrawer.classList.remove('open');
            document.body.style.overflow = '';
        }
    });

    // Navigation to other pages
    drawerItems.forEach(item => {
        item.addEventListener('click', function() {
            const page = this.getAttribute('data-page');
            navigateToPage(page);
        });
    });

    // Profile dropdown functionality
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
}

// KPI Cards functionality
function initializeKPICards() {
    const kpiCards = document.querySelectorAll('.kpi-card');
    
    kpiCards.forEach(card => {
        card.addEventListener('click', function() {
            // Remove active class from all cards
            kpiCards.forEach(c => c.classList.remove('active'));
            // Add active class to clicked card
            this.classList.add('active');
            
            // Update table data based on selected KPI
            updateTableData(this.querySelector('.kpi-title').textContent);
        });
    });
    
    // Initialize RA navigation
    initializeRANavigation();
    
    // Initialize GIC navigation
    initializeGICNavigation();
    
    // Initialize MWOV's pie chart
    initializeMWOVPieChart();
    
    // Initialize APPT navigation
    initializeAPPTNavigation();
    
    // Initialize MWOV navigation
    initializeMWOVNavigation();
    
    // Initialize SIIP navigation
    initializeSIIPNavigation();
    
    // Initialize card-to-table linking
    initializeCardToTableLinking();
}

// RA Navigation functionality
function initializeRANavigation() {
    const raCard = document.querySelector('.kpi-card:nth-child(2)'); // RA card
    if (!raCard) return;
    
    const prevArrow = raCard.querySelector('.prev-arrow');
    const nextArrow = raCard.querySelector('.next-arrow');
    const timeframeIndicator = raCard.querySelector('.timeframe-indicator');
    const kpiDate = raCard.querySelector('.kpi-date');
    const kpiDateValue = raCard.querySelector('.kpi-date-value');
    
    let currentTimeframe = 0; // 0 = TODAY, 1 = LAST 30 DAYS, 2 = YTD
    
    const timeframes = [
        {
            name: 'TODAY',
            date: '07-29-2025',
            missed: 2,
            completed: 8,
            rank: 'RANK 3/5',
            networkRank: '9 of 2,118 providers'
        },
        {
            name: 'LAST 30 DAYS',
            date: '06-29-2025 to 07-29-2025',
            missed: 12,
            completed: 45,
            rank: 'RANK 1/5',
            networkRank: '12 of 2,118 providers'
        },
        {
            name: 'YTD',
            date: '01-01-2025 to 07-29-2025',
            missed: 67,
            completed: 234,
            rank: 'RANK 2/5',
            networkRank: '18 of 2,118 providers'
        }
    ];
    
    function updateRADisplay() {
        const timeframe = timeframes[currentTimeframe];
        
        timeframeIndicator.textContent = timeframe.name;
        kpiDate.textContent = timeframe.name;
        kpiDateValue.textContent = timeframe.date;
        
        // Update metrics
        const missedValue = raCard.querySelector('.metric-bar.missed .metric-value');
        const completedValue = raCard.querySelector('.metric-bar.completed .metric-value');
        const rankText = raCard.querySelector('.rank-text');
        const networkRankText = raCard.querySelector('.network-rank');
        
        if (missedValue) missedValue.textContent = timeframe.missed;
        if (completedValue) completedValue.textContent = timeframe.completed;
        if (rankText) rankText.textContent = timeframe.rank;
        if (networkRankText) networkRankText.textContent = timeframe.networkRank;
        
        // Update arrow states
        prevArrow.disabled = currentTimeframe === 0;
        nextArrow.disabled = currentTimeframe === timeframes.length - 1;
        
        // Update arrow styling
        if (prevArrow.disabled) {
            prevArrow.classList.add('disabled');
        } else {
            prevArrow.classList.remove('disabled');
        }
        
        if (nextArrow.disabled) {
            nextArrow.classList.add('disabled');
        } else {
            nextArrow.classList.remove('disabled');
        }
    }
    
    prevArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe > 0) {
            currentTimeframe--;
            updateRADisplay();
        }
    });
    
    nextArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe < timeframes.length - 1) {
            currentTimeframe++;
            updateRADisplay();
        }
    });
    
    // Initialize display
    updateRADisplay();
}

// GIC Navigation functionality
function initializeGICNavigation() {
    console.log('Initializing GIC Navigation...');
    const gicCard = document.querySelector('.kpi-card:nth-child(1)'); // GIC card
    if (!gicCard) {
        console.log('GIC card not found!');
        return;
    }
    console.log('GIC card found:', gicCard);
    
    const prevArrow = gicCard.querySelector('.prev-arrow');
    const nextArrow = gicCard.querySelector('.next-arrow');
    const timeframeIndicator = gicCard.querySelector('.timeframe-indicator');
    const kpiDate = gicCard.querySelector('.kpi-date');
    const kpiDateValue = gicCard.querySelector('.kpi-date-value');
    
    console.log('GIC Navigation elements found:');
    console.log('- prevArrow:', prevArrow);
    console.log('- nextArrow:', nextArrow);
    console.log('- timeframeIndicator:', timeframeIndicator);
    console.log('- kpiDate:', kpiDate);
    console.log('- kpiDateValue:', kpiDateValue);
    
    let currentTimeframe = 0; // 0 = TODAY, 1 = LAST 30 DAYS, 2 = YTD
    
    const timeframes = [
        {
            name: 'TODAY',
            date: '07-29-2025',
            missed: 3,
            completed: 12,
            rank: 'RANK 2/5',
            networkRank: '9 of 2,118 providers'
        },
        {
            name: 'LAST 30 DAYS',
            date: '06-29-2025 to 07-29-2025',
            missed: 18,
            completed: 67,
            rank: 'RANK 1/5',
            networkRank: '15 of 2,118 providers'
        },
        {
            name: 'YTD',
            date: '01-01-2025 to 07-29-2025',
            missed: 89,
            completed: 342,
            rank: 'RANK 1/5',
            networkRank: '23 of 2,118 providers'
        }
    ];
    
    function updateGICDisplay() {
        const timeframe = timeframes[currentTimeframe];
        
        timeframeIndicator.textContent = timeframe.name;
        kpiDate.textContent = timeframe.name;
        kpiDateValue.textContent = timeframe.date;
        
        // Update metrics
        const missedValue = gicCard.querySelector('.metric-bar.missed .metric-value');
        const completedValue = gicCard.querySelector('.metric-bar.completed .metric-value');
        const rankText = gicCard.querySelector('.rank-text');
        const networkRankText = gicCard.querySelector('.network-rank');
        
        if (missedValue) missedValue.textContent = timeframe.missed;
        if (completedValue) completedValue.textContent = timeframe.completed;
        if (rankText) rankText.textContent = timeframe.rank;
        if (networkRankText) networkRankText.textContent = timeframe.networkRank;
        
        // Update arrow states
        prevArrow.disabled = currentTimeframe === 0;
        nextArrow.disabled = currentTimeframe === timeframes.length - 1;
        
        // Update arrow styling
        if (prevArrow.disabled) {
            prevArrow.classList.add('disabled');
        } else {
            prevArrow.classList.remove('disabled');
        }
        
        if (nextArrow.disabled) {
            nextArrow.classList.add('disabled');
        } else {
            nextArrow.classList.remove('disabled');
        }
        
        console.log('GIC Navigation - Current timeframe:', currentTimeframe, 'Total timeframes:', timeframes.length);
    }
    
    prevArrow.addEventListener('click', function(e) {
        console.log('GIC Prev arrow clicked!');
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe > 0) {
            currentTimeframe--;
            updateGICDisplay();
        } else {
            console.log('Cannot go prev - already at first timeframe');
        }
    });
    
    nextArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        console.log('Next arrow clicked. Current timeframe:', currentTimeframe, 'Total timeframes:', timeframes.length);
        if (currentTimeframe < timeframes.length - 1) {
            currentTimeframe++;
            updateGICDisplay();
        } else {
            console.log('Cannot go next - already at last timeframe');
        }
    });
    
    // Initialize display
    updateGICDisplay();
    
    // Test click handler for debugging
    gicCard.addEventListener('click', function(e) {
        console.log('GIC card clicked!', e.target);
    });
}

// APPT Navigation functionality
function initializeAPPTNavigation() {
    const apptCard = document.querySelector('.kpi-card:nth-child(3)'); // APPT card
    if (!apptCard) return;
    
    const prevArrow = apptCard.querySelector('.prev-arrow');
    const nextArrow = apptCard.querySelector('.next-arrow');
    const timeframeIndicator = apptCard.querySelector('.timeframe-indicator');
    const kpiDate = apptCard.querySelector('.kpi-date');
    const kpiDateValue = apptCard.querySelector('.kpi-date-value');
    
    let currentTimeframe = 0; // 0 = TODAY, 1 = LAST WEEK, 2 = LAST 30 DAYS
    
    const timeframes = [
        {
            name: 'TODAY',
            date: '07-29-2025',
            scheduled: 8,
            completed: 6,
            missed: 2,
            rank: 'RANK 3/5'
        },
        {
            name: 'LAST WEEK',
            date: '07-22-2025 to 07-28-2025',
            scheduled: 45,
            completed: 38,
            missed: 7,
            rank: 'RANK 2/5'
        },
        {
            name: 'LAST 30 DAYS',
            date: '06-29-2025 to 07-29-2025',
            scheduled: 156,
            completed: 142,
            missed: 14,
            rank: 'RANK 4/5'
        }
    ];
    
    function updateAPPTDisplay() {
        const timeframe = timeframes[currentTimeframe];
        
        timeframeIndicator.textContent = timeframe.name;
        kpiDate.textContent = timeframe.name;
        kpiDateValue.textContent = timeframe.date;
        
        // Update metrics
        const scheduledValue = apptCard.querySelector('.metric-bar.scheduled .metric-value');
        const completedValue = apptCard.querySelector('.metric-bar.completed .metric-value');
        const missedValue = apptCard.querySelector('.metric-bar.missed .metric-value');
        
        if (scheduledValue) scheduledValue.textContent = timeframe.scheduled;
        if (completedValue) completedValue.textContent = timeframe.completed;
        if (missedValue) missedValue.textContent = timeframe.missed;
        
        // Update arrow states
        prevArrow.disabled = currentTimeframe === 0;
        nextArrow.disabled = currentTimeframe === timeframes.length - 1;
        
        // Update arrow styling
        if (prevArrow.disabled) {
            prevArrow.classList.add('disabled');
        } else {
            prevArrow.classList.remove('disabled');
        }
        
        if (nextArrow.disabled) {
            nextArrow.classList.add('disabled');
        } else {
            nextArrow.classList.remove('disabled');
        }
    }
    
    // Event listeners for navigation arrows
    prevArrow.addEventListener('click', function() {
        if (currentTimeframe > 0) {
            currentTimeframe--;
            updateAPPTDisplay();
        }
    });
    
    nextArrow.addEventListener('click', function() {
        if (currentTimeframe < timeframes.length - 1) {
            currentTimeframe++;
            updateAPPTDisplay();
        }
    });
    
    // Initialize display
    updateAPPTDisplay();
}

// MWOV Navigation functionality
function initializeMWOVNavigation() {
    const mwovCard = document.querySelector('.kpi-card:nth-child(4)'); // MWOV card
    if (!mwovCard) return;
    
    const prevArrow = mwovCard.querySelector('.prev-arrow');
    const nextArrow = mwovCard.querySelector('.next-arrow');
    const timeframeIndicator = mwovCard.querySelector('.timeframe-indicator');
    
    let currentTimeframe = 0; // 0 = TODAY, 1 = LAST 30 DAYS, 2 = YTD
    
    const timeframes = [
        {
            name: 'TODAY',
            date: '07-29-2025',
            noVisits: 12,
            withVisits: 8,
            percentage: 60
        },
        {
            name: 'LAST 30 DAYS',
            date: '06-29-2025 to 07-29-2025',
            noVisits: 45,
            withVisits: 23,
            percentage: 66
        },
        {
            name: 'YTD',
            date: '01-01-2025 to 07-29-2025',
            noVisits: 234,
            withVisits: 156,
            percentage: 60
        }
    ];
    
    function updateMWOVDisplay() {
        const timeframe = timeframes[currentTimeframe];
        
        timeframeIndicator.textContent = timeframe.name;
        
        // Update pie chart data
        updateMWOVPieChart(timeframe.noVisits, timeframe.withVisits, timeframe.percentage);
        
        // Update legend
        const noVisitsLegend = mwovCard.querySelector('.legend-item:first-child .legend-text');
        const withVisitsLegend = mwovCard.querySelector('.legend-item:last-child .legend-text');
        
        if (noVisitsLegend) noVisitsLegend.textContent = `No Visits: ${timeframe.noVisits} patients`;
        if (withVisitsLegend) withVisitsLegend.textContent = `With Visits: ${timeframe.withVisits} patients`;
        
        // Update arrow states
        prevArrow.disabled = currentTimeframe === 0;
        nextArrow.disabled = currentTimeframe === timeframes.length - 1;
        
        // Update arrow styling
        if (prevArrow.disabled) {
            prevArrow.classList.add('disabled');
        } else {
            prevArrow.classList.remove('disabled');
        }
        
        if (nextArrow.disabled) {
            nextArrow.classList.add('disabled');
        } else {
            nextArrow.classList.remove('disabled');
        }
    }
    
    function updateMWOVPieChart(noVisits, withVisits, percentage) {
        const canvas = document.getElementById('mwovPieChart');
        if (!canvas) return;
        
        const ctx = canvas.getContext('2d');
        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        const radius = 50;
        
        // Clear canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Calculate angles
        const total = noVisits + withVisits;
        const noVisitsAngle = (noVisits / total) * 2 * Math.PI;
        const withVisitsAngle = (withVisits / total) * 2 * Math.PI;
        
        // Draw pie chart
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, 0, noVisitsAngle);
        ctx.closePath();
        ctx.fillStyle = '#2196f3';
        ctx.fill();
        
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, noVisitsAngle, noVisitsAngle + withVisitsAngle);
        ctx.closePath();
        ctx.fillStyle = '#4caf50';
        ctx.fill();
        
        // Update center percentage
        const centerText = mwovCard.querySelector('.pie-chart-percentage');
        if (centerText) {
            centerText.textContent = `${percentage}%`;
        }
    }
    
    prevArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe > 0) {
            currentTimeframe--;
            updateMWOVDisplay();
        }
    });
    
    nextArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe < timeframes.length - 1) {
            currentTimeframe++;
            updateMWOVDisplay();
        }
    });
    
    // Initialize display
    updateMWOVDisplay();
}

// SIIP Navigation functionality
function initializeSIIPNavigation() {
    const siipCard = document.querySelector('.kpi-card:nth-child(5)'); // SIIP card (5th card)
    if (!siipCard) return;
    
    const prevArrow = siipCard.querySelector('.prev-arrow');
    const nextArrow = siipCard.querySelector('.next-arrow');
    const timeframeIndicator = siipCard.querySelector('.timeframe-indicator');
    const kpiDate = siipCard.querySelector('.kpi-date');
    const kpiDateValue = siipCard.querySelector('.kpi-date-value');
    
    let currentTimeframe = 0; // 0 = TODAY, 1 = LAST 30 DAYS, 2 = YTD
    
    const timeframes = [
        {
            name: 'TODAY',
            date: '07-29-2025',
            completed: 2,
            open: 3,
            total: 5,
            earnings: 20.00
        },
        {
            name: 'LAST 30 DAYS',
            date: '06-29-2025 to 07-29-2025',
            completed: 15,
            open: 8,
            total: 23,
            earnings: 150.00
        },
        {
            name: 'YTD',
            date: '01-01-2025 to 07-29-2025',
            completed: 89,
            open: 34,
            total: 123,
            earnings: 890.00
        }
    ];
    
    function updateSIIPDisplay() {
        const timeframe = timeframes[currentTimeframe];
        
        timeframeIndicator.textContent = timeframe.name;
        kpiDate.textContent = timeframe.name;
        kpiDateValue.textContent = timeframe.date;
        
        // Update metrics
        const completedValue = siipCard.querySelector('.metric-bar.completed .metric-value');
        const openValue = siipCard.querySelector('.metric-bar.missed .metric-value');
        const summaryText = siipCard.querySelector('.summary-text');
        const summaryEarnings = siipCard.querySelector('.summary-earnings');
        
        if (completedValue) completedValue.textContent = timeframe.completed;
        if (openValue) openValue.textContent = timeframe.open;
        if (summaryText) summaryText.textContent = `Total: ${timeframe.total} appointments`;
        if (summaryEarnings) summaryEarnings.textContent = `Earnings: $${timeframe.earnings.toFixed(2)}`;
        
        // Update arrow states
        prevArrow.disabled = currentTimeframe === 0;
        nextArrow.disabled = currentTimeframe === timeframes.length - 1;
        
        // Update arrow styling
        if (prevArrow.disabled) {
            prevArrow.classList.add('disabled');
        } else {
            prevArrow.classList.remove('disabled');
        }
        
        if (nextArrow.disabled) {
            nextArrow.classList.add('disabled');
        } else {
            nextArrow.classList.remove('disabled');
        }
    }
    
    prevArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe > 0) {
            currentTimeframe--;
            updateSIIPDisplay();
        }
    });
    
    nextArrow.addEventListener('click', function(e) {
        e.stopPropagation(); // Prevent card click
        if (currentTimeframe < timeframes.length - 1) {
            currentTimeframe++;
            updateSIIPDisplay();
        }
    });
    
    // Initialize display
    updateSIIPDisplay();
}

// Card-to-Table Linking functionality
function initializeCardToTableLinking() {
    const kpiCards = document.querySelectorAll('.kpi-card');
    const tableWrappers = document.querySelectorAll('.table-wrapper');
    
    // Hide all tables except the first one (GIC)
    tableWrappers.forEach((wrapper, index) => {
        if (index > 0) {
            wrapper.style.display = 'none';
        }
    });
    
    kpiCards.forEach((card, index) => {
        card.addEventListener('click', function() {
            // Remove active class from all cards
            kpiCards.forEach(c => c.classList.remove('active'));
            // Add active class to clicked card
            this.classList.add('active');
            
            // Show corresponding table
            const cardTitle = this.querySelector('.kpi-title').textContent;
            showTableForCard(cardTitle);
        });
    });
    
    function showTableForCard(cardTitle) {
        // Hide all tables
        tableWrappers.forEach(wrapper => {
            wrapper.style.display = 'none';
        });
        
        // Update table title
        const tableTitleElement = document.getElementById('currentTableTitle');
        let tableTitle = '';
        
        // Show the appropriate table based on card title
        switch(cardTitle) {
            case 'GIC':
                document.getElementById('gic-table').style.display = 'block';
                tableTitle = 'GIC Detailed Report';
                break;
            case 'RA':
                document.getElementById('ra-table').style.display = 'block';
                tableTitle = 'RA Detailed Report';
                break;
            case 'APPT':
                document.getElementById('appt-table').style.display = 'block';
                tableTitle = 'Appointment Detailed Report';
                break;
            case 'MWOV\'s':
                document.getElementById('mwov-table').style.display = 'block';
                tableTitle = 'Members Without Visits Report';
                break;
            case 'SIIP':
                document.getElementById('siip-table').style.display = 'block';
                tableTitle = 'SIIP Detailed Report';
                break;
            case 'STAFF LOGIN':
                document.getElementById('staff-login-table').style.display = 'block';
                tableTitle = 'Staff Login Report';
                break;
            default:
                document.getElementById('gic-table').style.display = 'block';
                tableTitle = 'GIC Detailed Report';
        }
        
        // Update the table title
        if (tableTitleElement) {
            tableTitleElement.textContent = tableTitle;
        }
        
               // Reset collapse state when switching tables - start collapsed
       const collapseBtn = document.querySelector('.collapse-btn');
       if (collapseBtn) {
           collapseBtn.classList.add('collapsed');
       }
       
       // Set all table wrappers to collapsed state
       document.querySelectorAll('.table-wrapper').forEach(wrapper => {
           wrapper.classList.add('collapsed');
           wrapper.classList.remove('expanded');
       });
        
        // Reinitialize pagination for the new table
        setTimeout(() => {
            initializePagination();
        }, 100);
    }
}

// MWOV's Pie Chart functionality
function initializeMWOVPieChart() {
    const canvas = document.getElementById('mwovPieChart');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const radius = 50;
    
    // Data for the pie chart
    const data = {
        noVisits: 45,
        withVisits: 23
    };
    
    const total = data.noVisits + data.withVisits;
    const noVisitsPercentage = (data.noVisits / total) * 100;
    const withVisitsPercentage = (data.withVisits / total) * 100;
    
    // Colors
    const colors = {
        noVisits: '#2196f3', // Stronger blue
        withVisits: '#4caf50' // Stronger green
    };
    
    // Draw the pie chart
    function drawPieChart() {
        // Clear canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        let currentAngle = -Math.PI / 2; // Start from top
        
        // Draw "No Visits" slice
        const noVisitsAngle = (noVisitsPercentage / 100) * 2 * Math.PI;
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + noVisitsAngle);
        ctx.closePath();
        ctx.fillStyle = colors.noVisits;
        ctx.fill();
        
        currentAngle += noVisitsAngle;
        
        // Draw "With Visits" slice
        const withVisitsAngle = (withVisitsPercentage / 100) * 2 * Math.PI;
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + withVisitsAngle);
        ctx.closePath();
        ctx.fillStyle = colors.withVisits;
        ctx.fill();
        
        // Draw border
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
        ctx.strokeStyle = '#e0e0e0';
        ctx.lineWidth = 2;
        ctx.stroke();
    }
    
    // Update the center text
    function updateCenterText() {
        const percentageElement = document.querySelector('.pie-chart-percentage');
        
        if (percentageElement) {
            percentageElement.textContent = `${Math.round(noVisitsPercentage)}%`;
        }
    }
    
    // Initialize the chart
    drawPieChart();
    updateCenterText();
    
    // Add hover effects
    canvas.addEventListener('mousemove', function(e) {
        const rect = canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const distance = Math.sqrt((x - centerX) ** 2 + (y - centerY) ** 2);
        
        if (distance <= radius) {
            canvas.style.cursor = 'pointer';
        } else {
            canvas.style.cursor = 'default';
        }
    });
}

// Table sorting functionality
function initializeTableSorting() {
    const sortableHeaders = document.querySelectorAll('.reports-table th.sortable');
    
    sortableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const column = Array.from(this.parentElement.children).indexOf(this);
            const isAscending = !this.classList.contains('sort-asc');
            
            // Remove sort classes from all headers
            sortableHeaders.forEach(h => {
                h.classList.remove('sort-asc', 'sort-desc');
            });
            
            // Add sort class to current header
            this.classList.add(isAscending ? 'sort-asc' : 'sort-desc');
            
            // Sort the table
            sortTable(column, isAscending);
        });
    });
}

// Pagination functionality
function initializePagination() {
    const table = document.querySelector('.reports-table tbody');
    const rows = table.querySelectorAll('tr');
    const rowsPerPage = 10;
    const totalPages = Math.ceil(rows.length / rowsPerPage);
    
    // Create pagination container if it doesn't exist
    let paginationContainer = document.querySelector('.pagination');
    if (!paginationContainer) {
        paginationContainer = document.createElement('div');
        paginationContainer.className = 'pagination';
        document.querySelector('.table-wrapper').appendChild(paginationContainer);
    }
    
    // Clear existing pagination
    paginationContainer.innerHTML = '';
    
    // Add pagination controls
    const controls = [
        { text: '<<', action: 'first', disabled: true },
        { text: '<', action: 'prev', disabled: true },
        { text: '1', action: 'page', page: 1, active: true },
        { text: '2', action: 'page', page: 2 },
        { text: '3', action: 'page', page: 3 },
        { text: '>', action: 'next' },
        { text: '>>', action: 'last' }
    ];
    
    controls.forEach(control => {
        const button = document.createElement('button');
        button.textContent = control.text;
        button.className = 'pagination-btn';
        
        if (control.disabled) {
            button.disabled = true;
            button.classList.add('disabled');
        }
        
        if (control.active) {
            button.classList.add('active');
        }
        
        button.addEventListener('click', () => {
            if (!control.disabled) {
                handlePaginationClick(control.action, control.page);
            }
        });
        
        paginationContainer.appendChild(button);
    });
    
    // Show first page by default
    showPage(1);
    
    function handlePaginationClick(action, page) {
        switch(action) {
            case 'first':
                showPage(1);
                break;
            case 'prev':
                const currentPage = getCurrentPage();
                if (currentPage > 1) {
                    showPage(currentPage - 1);
                }
                break;
            case 'page':
                showPage(page);
                break;
            case 'next':
                const nextPage = getCurrentPage();
                if (nextPage < totalPages) {
                    showPage(nextPage + 1);
                }
                break;
            case 'last':
                showPage(totalPages);
                break;
        }
    }
    
    function getCurrentPage() {
        const activeBtn = paginationContainer.querySelector('.pagination-btn.active');
        return parseInt(activeBtn.textContent);
    }
    
    function updatePagination() {
        const currentPage = getCurrentPage();
        const buttons = paginationContainer.querySelectorAll('.pagination-btn');
        
        // Update button states
        buttons.forEach((btn, index) => {
            btn.classList.remove('active', 'disabled');
            
            if (index === 0) { // First button (<<)
                btn.disabled = currentPage === 1;
                if (btn.disabled) btn.classList.add('disabled');
            } else if (index === 1) { // Second button (<)
                btn.disabled = currentPage === 1;
                if (btn.disabled) btn.classList.add('disabled');
            } else if (index >= 2 && index <= 4) { // Page numbers
                const pageNum = index - 1;
                if (pageNum === currentPage) {
                    btn.classList.add('active');
                }
            } else if (index === 5) { // Third to last button (>)
                btn.disabled = currentPage === totalPages;
                if (btn.disabled) btn.classList.add('disabled');
            } else if (index === 6) { // Last button (>>)
                btn.disabled = currentPage === totalPages;
                if (btn.disabled) btn.classList.add('disabled');
            }
        });
    }
    
    function showPage(page) {
        // Hide all rows
        rows.forEach(row => row.style.display = 'none');
        
        // Show rows for current page
        const startIndex = (page - 1) * rowsPerPage;
        const endIndex = startIndex + rowsPerPage;
        
        for (let i = startIndex; i < endIndex && i < rows.length; i++) {
            rows[i].style.display = '';
        }
        
        // Update pagination buttons
        updatePagination();
    }
}

// Table controls functionality
function initializeTableControls() {
    const collapseBtn = document.querySelector('.collapse-btn');
    const exportLink = document.querySelector('.export-link');
    
    // Initialize collapse state
    let isCollapsed = true;
    
    // Set initial collapsed state for the default visible table (GIC)
    const gicTableWrapper = document.getElementById('gic-table');
    if (gicTableWrapper) {
        gicTableWrapper.classList.add('collapsed');
        gicTableWrapper.classList.remove('expanded');
    }
    collapseBtn.classList.add('collapsed');
    
    collapseBtn.addEventListener('click', function() {
        isCollapsed = !isCollapsed;
        
        // Get the currently visible table wrapper
        const visibleTableWrapper = document.querySelector('.table-wrapper[style*="display: block"], .table-wrapper:not([style*="display: none"])');
        
        if (isCollapsed) {
            collapseBtn.classList.add('collapsed');
            if (visibleTableWrapper) {
                visibleTableWrapper.classList.add('collapsed');
                visibleTableWrapper.classList.remove('expanded');
            }
        } else {
            collapseBtn.classList.remove('collapsed');
            if (visibleTableWrapper) {
                visibleTableWrapper.classList.remove('collapsed');
                visibleTableWrapper.classList.add('expanded');
            }
        }
    });
    
    exportLink.addEventListener('click', function(e) {
        e.preventDefault();
        showExportModal();
    });
}

// Export modal functionality
function initializeExportModal() {
    const exportModal = document.getElementById('exportModal');
    const closeBtn = document.getElementById('closeExportModal');
    const cancelBtn = document.getElementById('cancelExport');
    const applyBtn = document.getElementById('applyExport');
    const selectAllCheckbox = document.getElementById('selectAll');
    const fieldCheckboxes = document.querySelectorAll('.field-checkbox:not(#selectAll)');
    
    // Show modal
    function showExportModal() {
        exportModal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
    
    // Hide modal
    function hideExportModal() {
        exportModal.classList.remove('show');
        document.body.style.overflow = '';
    }
    
    // Close modal events
    closeBtn.addEventListener('click', hideExportModal);
    cancelBtn.addEventListener('click', hideExportModal);
    
    // Close modal when clicking outside
    exportModal.addEventListener('click', function(e) {
        if (e.target === exportModal) {
            hideExportModal();
        }
    });
    
    // Select all functionality
    selectAllCheckbox.addEventListener('change', function() {
        fieldCheckboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });
    
    // Update select all when individual checkboxes change
    fieldCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const allChecked = Array.from(fieldCheckboxes).every(cb => cb.checked);
            const anyChecked = Array.from(fieldCheckboxes).some(cb => cb.checked);
            
            selectAllCheckbox.checked = allChecked;
            selectAllCheckbox.indeterminate = anyChecked && !allChecked;
        });
    });
    
    // Apply button functionality
    applyBtn.addEventListener('click', function() {
        const selectedFields = Array.from(fieldCheckboxes)
            .filter(checkbox => checkbox.checked)
            .map(checkbox => checkbox.id.replace('field', ''));
        
        console.log('Selected fields for export:', selectedFields);
        
        // TODO: Implement actual export functionality
        alert(`Exporting data with fields: ${selectedFields.join(', ')}`);
        
        hideExportModal();
    });
    
    // Make showExportModal globally available
    window.showExportModal = showExportModal;
}

// Helper functions
function sortTable(column, ascending) {
    const table = document.querySelector('.reports-table');
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    rows.sort((a, b) => {
        const aValue = a.children[column].textContent.trim();
        const bValue = b.children[column].textContent.trim();
        
        // Handle different data types
        if (column === 2) { // DOB column
            const aDate = new Date(aValue);
            const bDate = new Date(bValue);
            return ascending ? aDate - bDate : bDate - aDate;
        } else if (column === 6) { // PHONE column
            const aNum = parseInt(aValue.replace(/\D/g, ''));
            const bNum = parseInt(bValue.replace(/\D/g, ''));
            return ascending ? aNum - bNum : bNum - aNum;
        } else {
            return ascending ? aValue.localeCompare(bValue) : bValue.localeCompare(aValue);
        }
    });
    
    // Reorder rows in the table
    rows.forEach(row => tbody.appendChild(row));
}

function updateTableData(kpiType) {
    console.log('Updating table data for:', kpiType);
    // TODO: Implement dynamic table data updates based on KPI selection
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

// Add some sample data updates for demonstration
function updateKPIData() {
    const kpiCards = document.querySelectorAll('.kpi-card');
    
    // Update GIC card (handled by navigation system)
    // The GIC card data is now managed by the navigation system
    
    // Update RA card (handled by navigation system)
    // The RA card data is now managed by the navigation system
    
    // Update APPT card
    const apptCard = kpiCards[2];
    if (apptCard) {
        apptCard.querySelector('.metric-bar.missed .metric-value').textContent = '5';
    }
    
    // Update MWOV's card (handled by pie chart system)
    // The MWOV's card data is now managed by the pie chart system
}

// Initialize sample data after a short delay
setTimeout(updateKPIData, 1000);

// Initialize export modal
initializeExportModal(); 

// Inline Filter functionality
function initializeInlineFilters() {
    const filterInputs = document.querySelectorAll('.column-filter');
    let originalTableData = {};
    
    // Store original table data for current visible table
    function storeOriginalTableData() {
        const visibleTable = document.querySelector('.table-wrapper:not([style*="display: none"]) .reports-table tbody');
        if (visibleTable) {
            const tableId = visibleTable.closest('.table-wrapper').id;
            const rows = visibleTable.querySelectorAll('tr');
            
            if (tableId === 'gic-table') {
                originalTableData[tableId] = Array.from(rows).map(row => {
                    const cells = row.querySelectorAll('td');
                    return {
                        name: cells[0]?.textContent || '',
                        mco: cells[1]?.textContent || '',
                        dob: cells[2]?.textContent || '',
                        appt: cells[3]?.textContent || '',
                        measure: cells[4]?.textContent || '',
                        status: cells[5]?.textContent || '',
                        phone: cells[6]?.textContent || '',
                        element: row
                    };
                });
            } else if (tableId === 'ra-table') {
                originalTableData[tableId] = Array.from(rows).map(row => {
                    const cells = row.querySelectorAll('td');
                    return {
                        name: cells[0]?.textContent || '',
                        mco: cells[1]?.textContent || '',
                        dob: cells[2]?.textContent || '',
                        hcc: cells[3]?.textContent || '',
                        status: cells[4]?.textContent || '',
                        dos: cells[5]?.textContent || '',
                        phone: cells[6]?.textContent || '',
                        element: row
                    };
                });
            } else if (tableId === 'appt-table') {
                originalTableData[tableId] = Array.from(rows).map(row => {
                    const cells = row.querySelectorAll('td');
                    return {
                        name: cells[0]?.textContent || '',
                        mco: cells[1]?.textContent || '',
                        dob: cells[2]?.textContent || '',
                        dos: cells[3]?.textContent || '',
                        missed: cells[4]?.textContent || '',
                        phone: cells[5]?.textContent || '',
                        address: cells[6]?.textContent || '',
                        element: row
                    };
                });
            } else if (tableId === 'mwov-table') {
                originalTableData[tableId] = Array.from(rows).map(row => {
                    const cells = row.querySelectorAll('td');
                    return {
                        name: cells[0]?.textContent || '',
                        mco: cells[1]?.textContent || '',
                        dob: cells[2]?.textContent || '',
                        dos: cells[3]?.textContent || '',
                        phone: cells[4]?.textContent || '',
                        address: cells[5]?.textContent || '',
                        element: row
                    };
                });
            } else if (tableId === 'staff-login-table') {
                originalTableData[tableId] = Array.from(rows).map(row => {
                    const cells = row.querySelectorAll('td');
                    return {
                        name: cells[0]?.textContent || '',
                        user: cells[1]?.textContent || '',
                        login: cells[2]?.textContent || '',
                        element: row
                    };
                });
            }
        }
    }
    
    // Apply filters for current visible table
    function applyFilters() {
        const visibleTable = document.querySelector('.table-wrapper:not([style*="display: none"]) .reports-table tbody');
        if (!visibleTable) return;
        
        const tableId = visibleTable.closest('.table-wrapper').id;
        const tableData = originalTableData[tableId];
        
        if (!tableData || tableData.length === 0) {
            storeOriginalTableData();
            return;
        }
        
        if (tableId === 'gic-table') {
            applyGICFilters(tableData);
        } else if (tableId === 'ra-table') {
            applyRAFilters(tableData);
        } else if (tableId === 'appt-table') {
            applyAPPTFilters(tableData);
        } else if (tableId === 'mwov-table') {
            applyMWOVFilters(tableData);
        } else if (tableId === 'staff-login-table') {
            applyStaffLoginFilters(tableData);
        }
        
        // Update pagination if it exists
        if (typeof updatePagination === 'function') {
            updatePagination();
        }
    }
    
    function applyGICFilters(tableData) {
        const nameFilter = document.getElementById('nameFilter')?.value.toLowerCase() || '';
        const mcoFilter = document.getElementById('mcoFilter')?.value || '';
        const dobFilter = document.getElementById('dobFilter')?.value || '';
        const apptFilter = document.getElementById('apptFilter')?.value || '';
        const measureFilter = document.getElementById('measureFilter')?.value || '';
        const statusFilter = document.getElementById('statusFilter')?.value || '';
        const phoneFilter = document.getElementById('phoneFilter')?.value || '';
        
        // Show all rows first
        tableData.forEach(item => {
            item.element.style.display = '';
        });
        
        // Apply filters
        tableData.forEach(item => {
            let showRow = true;
            
            if (nameFilter && !item.name.toLowerCase().includes(nameFilter)) {
                showRow = false;
            }
            
            if (mcoFilter && item.mco !== mcoFilter) {
                showRow = false;
            }
            
            if (dobFilter && !item.dob.includes(dobFilter)) {
                showRow = false;
            }
            
            if (apptFilter && item.appt !== apptFilter) {
                showRow = false;
            }
            
            if (measureFilter && item.measure !== measureFilter) {
                showRow = false;
            }
            
            if (statusFilter && item.status !== statusFilter) {
                showRow = false;
            }
            
            if (phoneFilter && !item.phone.includes(phoneFilter)) {
                showRow = false;
            }
            
            item.element.style.display = showRow ? '' : 'none';
        });
    }
    
    function applyRAFilters(tableData) {
        const nameFilter = document.getElementById('raNameFilter')?.value.toLowerCase() || '';
        const mcoFilter = document.getElementById('raMcoFilter')?.value || '';
        const dobFilter = document.getElementById('raDobFilter')?.value || '';
        const hccFilter = document.getElementById('raHccFilter')?.value || '';
        const statusFilter = document.getElementById('raStatusFilter')?.value || '';
        const dosFilter = document.getElementById('raDosFilter')?.value || '';
        const phoneFilter = document.getElementById('raPhoneFilter')?.value || '';
        
        // Show all rows first
        tableData.forEach(item => {
            item.element.style.display = '';
        });
        
        // Apply filters
        tableData.forEach(item => {
            let showRow = true;
            
            if (nameFilter && !item.name.toLowerCase().includes(nameFilter)) {
                showRow = false;
            }
            
            if (mcoFilter && item.mco !== mcoFilter) {
                showRow = false;
            }
            
            if (dobFilter && !item.dob.includes(dobFilter)) {
                showRow = false;
            }
            
            if (hccFilter && !item.hcc.includes(hccFilter)) {
                showRow = false;
            }
            
            if (statusFilter && item.status !== statusFilter) {
                showRow = false;
            }
            
            if (dosFilter && !item.dos.includes(dosFilter)) {
                showRow = false;
            }
            
            if (phoneFilter && !item.phone.includes(phoneFilter)) {
                showRow = false;
            }
            
            item.element.style.display = showRow ? '' : 'none';
        });
    }
    
    function applyAPPTFilters(tableData) {
        const nameFilter = document.getElementById('apptNameFilter')?.value.toLowerCase() || '';
        const mcoFilter = document.getElementById('apptMcoFilter')?.value || '';
        const dobFilter = document.getElementById('apptDobFilter')?.value || '';
        const dosFilter = document.getElementById('apptDosFilter')?.value || '';
        const missedFilter = document.getElementById('apptMissedFilter')?.value || '';
        const phoneFilter = document.getElementById('apptPhoneFilter')?.value || '';
        const addressFilter = document.getElementById('apptAddressFilter')?.value.toLowerCase() || '';
        
        // Show all rows first
        tableData.forEach(item => {
            item.element.style.display = '';
        });
        
        // Apply filters
        tableData.forEach(item => {
            let showRow = true;
            
            if (nameFilter && !item.name.toLowerCase().includes(nameFilter)) {
                showRow = false;
            }
            
            if (mcoFilter && item.mco !== mcoFilter) {
                showRow = false;
            }
            
            if (dobFilter && !item.dob.includes(dobFilter)) {
                showRow = false;
            }
            
            if (dosFilter && !item.dos.includes(dosFilter)) {
                showRow = false;
            }
            
            if (missedFilter && !item.missed.includes(missedFilter)) {
                showRow = false;
            }
            
            if (phoneFilter && !item.phone.includes(phoneFilter)) {
                showRow = false;
            }
            
            if (addressFilter && !item.address.toLowerCase().includes(addressFilter)) {
                showRow = false;
            }
            
            item.element.style.display = showRow ? '' : 'none';
        });
    }
    
    function applyMWOVFilters(tableData) {
        const nameFilter = document.getElementById('mwovNameFilter')?.value.toLowerCase() || '';
        const mcoFilter = document.getElementById('mwovMcoFilter')?.value || '';
        const dobFilter = document.getElementById('mwovDobFilter')?.value || '';
        const dosFilter = document.getElementById('mwovDosFilter')?.value || '';
        const phoneFilter = document.getElementById('mwovPhoneFilter')?.value || '';
        const addressFilter = document.getElementById('mwovAddressFilter')?.value.toLowerCase() || '';
        
        // Show all rows first
        tableData.forEach(item => {
            item.element.style.display = '';
        });
        
        // Apply filters
        tableData.forEach(item => {
            let showRow = true;
            
            if (nameFilter && !item.name.toLowerCase().includes(nameFilter)) {
                showRow = false;
            }
            
            if (mcoFilter && item.mco !== mcoFilter) {
                showRow = false;
            }
            
            if (dobFilter && !item.dob.includes(dobFilter)) {
                showRow = false;
            }
            
            if (dosFilter && !item.dos.includes(dosFilter)) {
                showRow = false;
            }
            
            if (phoneFilter && !item.phone.includes(phoneFilter)) {
                showRow = false;
            }
            
            if (addressFilter && !item.address.toLowerCase().includes(addressFilter)) {
                showRow = false;
            }
            
            item.element.style.display = showRow ? '' : 'none';
        });
    }
    
    function applyStaffLoginFilters(tableData) {
        const nameFilter = document.getElementById('staffNameFilter')?.value.toLowerCase() || '';
        const userFilter = document.getElementById('staffUserFilter')?.value.toLowerCase() || '';
        const loginFilter = document.getElementById('staffLoginFilter')?.value || '';
        
        // Show all rows first
        tableData.forEach(item => {
            item.element.style.display = '';
        });
        
        // Apply filters
        tableData.forEach(item => {
            let showRow = true;
            
            if (nameFilter && !item.name.toLowerCase().includes(nameFilter)) {
                showRow = false;
            }
            
            if (userFilter && !item.user.toLowerCase().includes(userFilter)) {
                showRow = false;
            }
            
            if (loginFilter && !item.login.includes(loginFilter)) {
                showRow = false;
            }
            
            item.element.style.display = showRow ? '' : 'none';
        });
    }
    
    // Add event listeners to all filter inputs
    filterInputs.forEach(input => {
        input.addEventListener('input', applyFilters);
        input.addEventListener('change', applyFilters);
    });
    
    // Initialize on page load
    storeOriginalTableData();
    
    // Re-initialize when switching tables
    const kpiCards = document.querySelectorAll('.kpi-card');
    kpiCards.forEach(card => {
        card.addEventListener('click', function() {
            setTimeout(() => {
                storeOriginalTableData();
            }, 100);
        });
    });
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