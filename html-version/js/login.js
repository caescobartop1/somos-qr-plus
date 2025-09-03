// Login Page JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM Content Loaded - Initializing login page');
    
    // Initialize login functionality
    initializeLoginForm();
    initializePasswordToggle();
    initializeErrorModal();
    
    // Handle forgot password
    const forgotPasswordLink = document.querySelector('.forgot-password');
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', function(e) {
            // Navigate to forgot password page
            window.location.href = 'forgot-password.html';
        });
    }
    

    
    // Add smooth animations on page load
    animateLoginCard();
    
    // Check login status LAST (after all event listeners are set up)
    // checkLoginStatus(); // TEMPORARILY DISABLED
    
    // Add a simple test to see if clicks work at all
    document.addEventListener('click', function(e) {
        console.log('CLICK DETECTED on:', e.target.tagName, e.target.className);
    });
});

// Initialize login form
function initializeLoginForm() {
    console.log('Initializing login form...');
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
    
    console.log('Found elements:', {
        loginForm: !!loginForm,
        emailInput: !!emailInput,
        passwordInput: !!passwordInput,
        loginBtn: !!loginBtn
    });
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            console.log('FORM SUBMIT CLICKED!');
            handleLoginSubmit(e);
        });
        console.log('Login form submit event listener added');
    }
    
    // Real-time validation
    if (emailInput) {
        emailInput.addEventListener('blur', validateEmail);
        emailInput.addEventListener('input', clearEmailError);
        console.log('Email input event listeners added');
    }
    
    if (passwordInput) {
        passwordInput.addEventListener('blur', validatePassword);
        passwordInput.addEventListener('input', clearPasswordError);
        console.log('Password input event listeners added');
    }
    
    // Enter key support
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !loginBtn.disabled) {
            handleLoginSubmit(e);
        }
    });
    console.log('Keydown event listener added');
}

// Handle login form submission
function handleLoginSubmit(e) {
    e.preventDefault();
    
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
    
    // Validate form
    const isEmailValid = validateEmail();
    const isPasswordValid = validatePassword();
    
    if (!isEmailValid || !isPasswordValid) {
        return;
    }
    
    // Get form data
    const formData = {
        email: emailInput.value.trim(),
        password: passwordInput.value,
        rememberMe: document.getElementById('rememberMe').checked
    };
    
    // Show loading state
    setLoadingState(true);
    
    // Simulate API call
    simulateLogin(formData);
}

// Validate email
function validateEmail() {
    const emailInput = document.getElementById('email');
    const emailError = document.getElementById('emailError');
    const email = emailInput.value.trim();
    
    // Clear previous error
    clearEmailError();
    
    // Check if empty
    if (!email) {
        showEmailError('Email address is required');
        return false;
    }
    
    // Check email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showEmailError('Please enter a valid email address');
        return false;
    }
    
    return true;
}

// Validate password
function validatePassword() {
    const passwordInput = document.getElementById('password');
    const passwordError = document.getElementById('passwordError');
    const password = passwordInput.value;
    
    // Clear previous error
    clearPasswordError();
    
    // Check if empty
    if (!password) {
        showPasswordError('Password is required');
        return false;
    }
    
    // Check minimum length
    if (password.length < 6) {
        showPasswordError('Password must be at least 6 characters');
        return false;
    }
    
    return true;
}

// Show email error
function showEmailError(message) {
    const emailError = document.getElementById('emailError');
    const emailInput = document.getElementById('email');
    
    emailError.textContent = message;
    emailInput.style.borderColor = '#d32f2f';
}

// Show password error
function showPasswordError(message) {
    const passwordError = document.getElementById('passwordError');
    const passwordInput = document.getElementById('password');
    
    passwordError.textContent = message;
    passwordInput.style.borderColor = '#d32f2f';
}

// Clear email error
function clearEmailError() {
    const emailError = document.getElementById('emailError');
    const emailInput = document.getElementById('email');
    
    emailError.textContent = '';
    emailInput.style.borderColor = '#e0e0e0';
}

// Clear password error
function clearPasswordError() {
    const passwordError = document.getElementById('passwordError');
    const passwordInput = document.getElementById('password');
    
    passwordError.textContent = '';
    passwordInput.style.borderColor = '#e0e0e0';
}

// Initialize password toggle
function initializePasswordToggle() {
    console.log('Initializing password toggle...');
    const passwordToggle = document.getElementById('passwordToggle');
    const passwordInput = document.getElementById('password');
    
    console.log('Password toggle elements:', {
        passwordToggle: !!passwordToggle,
        passwordInput: !!passwordInput
    });
    
    if (passwordToggle && passwordInput) {
        passwordToggle.addEventListener('click', function() {
            console.log('PASSWORD TOGGLE CLICKED!');
            const type = passwordInput.type === 'password' ? 'text' : 'password';
            passwordInput.type = type;
            
            const toggleIcon = this.querySelector('svg');
            if (type === 'password') {
                toggleIcon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>';
            } else {
                toggleIcon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line>';
            }
            console.log('Password type changed to:', type);
        });
        console.log('Password toggle event listener added');
    }
}

// Set loading state
function setLoadingState(isLoading) {
    const loginBtn = document.getElementById('loginBtn');
    const btnText = loginBtn.querySelector('.btn-text');
    const btnSpinner = loginBtn.querySelector('.btn-spinner');
    
    if (isLoading) {
        loginBtn.disabled = true;
        loginBtn.classList.add('loading');
        btnText.style.opacity = '0';
        btnSpinner.style.opacity = '1';
    } else {
        loginBtn.disabled = false;
        loginBtn.classList.remove('loading');
        btnText.style.opacity = '1';
        btnSpinner.style.opacity = '0';
    }
}

// Simulate login API call
function simulateLogin(formData) {
    // Simulate network delay
    setTimeout(() => {
        // Mock validation - replace with real API call
        if (formData.email === 'demo@somosipa.com' && formData.password === 'password123') {
            // Success
            handleLoginSuccess(formData);
        } else {
            // Error
            handleLoginError('Invalid email or password. Please try again.');
        }
    }, 1500);
}

// Handle successful login
function handleLoginSuccess(formData) {
    setLoadingState(false);
    
    // Store user data (in real app, this would be a JWT token)
    if (formData.rememberMe) {
        localStorage.setItem('userEmail', formData.email);
    } else {
        sessionStorage.setItem('userEmail', formData.email);
    }
    
    // Show success message briefly
    showSuccessMessage('Login successful! Redirecting...');
    
    // Redirect to dashboard
    setTimeout(() => {
        window.location.href = 'dashboard.html';
    }, 1000);
}

// Handle login error
function handleLoginError(message) {
    setLoadingState(false);
    showErrorModal(message);
}

// Show success message
function showSuccessMessage(message) {
    // Create success notification
    const successDiv = document.createElement('div');
    successDiv.className = 'success-notification';
    successDiv.textContent = message;
    successDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4caf50;
        color: white;
        padding: 12px 16px;
        border-radius: 8px;
        font-weight: 500;
        z-index: 1001;
        animation: slideIn 0.3s ease;
    `;
    
    document.body.appendChild(successDiv);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
}

// Initialize error modal
function initializeErrorModal() {
    const modalCloseBtn = document.getElementById('modalCloseBtn');
    
    if (modalCloseBtn) {
        modalCloseBtn.addEventListener('click', closeErrorModal);
    }
    
    // Close modal on outside click
    const errorModal = document.getElementById('errorModal');
    if (errorModal) {
        errorModal.addEventListener('click', function(e) {
            if (e.target === errorModal) {
                closeErrorModal();
            }
        });
    }
    
    // Close modal on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeErrorModal();
        }
    });
}

// Show error modal
function showErrorModal(message) {
    const errorModal = document.getElementById('errorModal');
    const modalMessage = document.getElementById('modalMessage');
    
    if (errorModal && modalMessage) {
        modalMessage.textContent = message;
        errorModal.classList.add('show');
    }
}

// Close error modal
function closeErrorModal() {
    const errorModal = document.getElementById('errorModal');
    
    if (errorModal) {
        errorModal.classList.remove('show');
    }
}

// Animate login card on page load
function animateLoginCard() {
    const loginCard = document.querySelector('.login-card');
    
    if (loginCard) {
        loginCard.style.opacity = '0';
        loginCard.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            loginCard.style.transition = 'all 0.6s ease';
            loginCard.style.opacity = '1';
            loginCard.style.transform = 'translateY(0)';
        }, 100);
    }
}

// Utility function to check if user is already logged in
function checkLoginStatus() {
    const userEmail = localStorage.getItem('userEmail') || sessionStorage.getItem('userEmail');
    
    if (userEmail) {
        // User is already logged in, redirect to dashboard
        window.location.href = 'dashboard.html';
    }
}

// Add CSS for success notification animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
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
