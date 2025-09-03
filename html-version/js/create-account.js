document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('createAccountForm');
    const passwordToggle = document.getElementById('passwordToggle');
    const confirmPasswordToggle = document.getElementById('confirmPasswordToggle');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const errorModal = document.getElementById('errorModal');
    const modalCloseBtn = document.getElementById('modalCloseBtn');
    const modalMessage = document.getElementById('modalMessage');

    // Password toggle functionality
    passwordToggle.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        // Update icon
        const icon = this.querySelector('svg');
        if (type === 'text') {
            icon.innerHTML = `
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
            `;
        } else {
            icon.innerHTML = `
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
            `;
        }
    });

    confirmPasswordToggle.addEventListener('click', function() {
        const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        confirmPasswordInput.setAttribute('type', type);
        
        // Update icon
        const icon = this.querySelector('svg');
        if (type === 'text') {
            icon.innerHTML = `
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
            `;
        } else {
            icon.innerHTML = `
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
            `;
        }
    });

    // Form validation
    function validateForm() {
        let isValid = true;
        const errors = {};

        // Clear previous errors
        document.querySelectorAll('.input-error').forEach(error => {
            error.textContent = '';
        });

        // Validate first name
        const firstName = document.getElementById('firstName').value.trim();
        if (!firstName) {
            errors.firstName = 'First name is required';
            isValid = false;
        } else if (firstName.length < 2) {
            errors.firstName = 'First name must be at least 2 characters';
            isValid = false;
        }

        // Validate last name
        const lastName = document.getElementById('lastName').value.trim();
        if (!lastName) {
            errors.lastName = 'Last name is required';
            isValid = false;
        } else if (lastName.length < 2) {
            errors.lastName = 'Last name must be at least 2 characters';
            isValid = false;
        }

        // Validate email
        const email = document.getElementById('email').value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email) {
            errors.email = 'Email is required';
            isValid = false;
        } else if (!emailRegex.test(email)) {
            errors.email = 'Please enter a valid email address';
            isValid = false;
        }

        // Validate practice
        const practice = document.getElementById('practice').value;
        if (!practice) {
            errors.practice = 'Practice is required';
            isValid = false;
        }

        // Validate NPI if practice is selected
        const npiField = document.getElementById('npiField');
        const npi = document.getElementById('npi').value.trim();
        if (practice && practice !== 'other' && npiField.style.display !== 'none') {
            if (!npi) {
                errors.npi = 'NPI number is required';
                isValid = false;
            } else if (!/^\d{10}$/.test(npi)) {
                errors.npi = 'NPI number must be exactly 10 digits';
                isValid = false;
            }
        }

        // Validate password
        const password = passwordInput.value;
        if (!password) {
            errors.password = 'Password is required';
            isValid = false;
        } else if (password.length < 8) {
            errors.password = 'Password must be at least 8 characters';
            isValid = false;
        } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password)) {
            errors.password = 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
            isValid = false;
        }

        // Validate confirm password
        const confirmPassword = confirmPasswordInput.value;
        if (!confirmPassword) {
            errors.confirmPassword = 'Please confirm your password';
            isValid = false;
        } else if (password !== confirmPassword) {
            errors.confirmPassword = 'Passwords do not match';
            isValid = false;
        }

        // Validate terms agreement
        const agreeTerms = document.getElementById('agreeTerms').checked;
        if (!agreeTerms) {
            errors.agreeTerms = 'You must agree to the Terms of Service and Privacy Policy';
            isValid = false;
        }

        // Display errors
        Object.keys(errors).forEach(field => {
            const errorElement = document.getElementById(field + 'Error');
            if (errorElement) {
                errorElement.textContent = errors[field];
            }
        });

        return isValid;
    }

    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (validateForm()) {
            // Show loading state
            const submitBtn = document.getElementById('createAccountBtn');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;

            // Simulate API call
            setTimeout(() => {
                // For demo purposes, show success
                showModal('Account created successfully! You will receive a confirmation email shortly.');
                
                // Reset form
                form.reset();
                
                // Remove loading state
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }, 2000);
        }
    });

    // Modal functionality
    function showModal(message) {
        modalMessage.textContent = message;
        errorModal.classList.add('show');
    }

    modalCloseBtn.addEventListener('click', function() {
        errorModal.classList.remove('show');
    });

    // Close modal when clicking outside
    errorModal.addEventListener('click', function(e) {
        if (e.target === errorModal) {
            errorModal.classList.remove('show');
        }
    });

    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && errorModal.classList.contains('show')) {
            errorModal.classList.remove('show');
        }
    });

    // Practice selection handler
    const practiceSelect = document.getElementById('practice');
    const npiField = document.getElementById('npiField');
    
    if (practiceSelect) {
        practiceSelect.addEventListener('change', function() {
            const selectedPractice = this.value;
            if (selectedPractice && selectedPractice !== 'other') {
                npiField.style.display = 'block';
                document.getElementById('npi').required = true;
            } else {
                npiField.style.display = 'none';
                document.getElementById('npi').required = false;
                document.getElementById('npi').value = '';
                document.getElementById('npiError').textContent = '';
            }
        });
    }

    // Real-time validation
    const inputs = form.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateForm();
        });
    });

    // Password confirmation validation
    confirmPasswordInput.addEventListener('input', function() {
        const password = passwordInput.value;
        const confirmPassword = this.value;
        const errorElement = document.getElementById('confirmPasswordError');
        
        if (confirmPassword && password !== confirmPassword) {
            errorElement.textContent = 'Passwords do not match';
        } else {
            errorElement.textContent = '';
        }
    });
});
