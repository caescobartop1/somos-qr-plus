// Reset Password JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeResetPassword();
});

function initializeResetPassword() {
    const form = document.getElementById('resetPasswordForm');
    const otpInputs = [
        document.getElementById('otp1'),
        document.getElementById('otp2'),
        document.getElementById('otp3'),
        document.getElementById('otp4'),
        document.getElementById('otp5'),
        document.getElementById('otp6')
    ];
    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const resetBtn = document.getElementById('resetBtn');
    const backToLoginBtn = document.getElementById('backToLoginBtn');
    const newPasswordToggle = document.getElementById('newPasswordToggle');
    const confirmPasswordToggle = document.getElementById('confirmPasswordToggle');
    
    // Password strength elements
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');
    
    // Requirement elements
    const reqLength = document.getElementById('req-length');
    const reqUppercase = document.getElementById('req-uppercase');
    const reqLowercase = document.getElementById('req-lowercase');
    const reqNumber = document.getElementById('req-number');
    const reqSpecial = document.getElementById('req-special');

    // Password toggle functionality
    newPasswordToggle.addEventListener('click', function() {
        togglePasswordVisibility(newPasswordInput, newPasswordToggle);
    });

    confirmPasswordToggle.addEventListener('click', function() {
        togglePasswordVisibility(confirmPasswordInput, confirmPasswordToggle);
    });

    // Password strength and requirements checking
    newPasswordInput.addEventListener('input', function() {
        const password = this.value;
        checkPasswordStrength(password);
        checkPasswordRequirements(password);
        validateForm();
    });

    confirmPasswordInput.addEventListener('input', function() {
        validateForm();
    });

    // OTP validation
    otpInputs.forEach((input, index) => {
        input.addEventListener('input', function(e) {
            const value = e.target.value;
            
            // Only allow numbers
            if (!/^\d*$/.test(value)) {
                e.target.value = '';
                return;
            }

            // Auto-focus next input
            if (value && index < otpInputs.length - 1) {
                otpInputs[index + 1].focus();
            }

            // Update filled state
            if (value) {
                input.classList.add('filled');
            } else {
                input.classList.remove('filled');
            }

            validateForm();
        });

        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && !e.target.value && index > 0) {
                otpInputs[index - 1].focus();
            }
        });
    });

    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        handlePasswordReset();
    });

    // Back to login
    backToLoginBtn.addEventListener('click', function() {
        window.location.href = 'login.html';
    });

    function togglePasswordVisibility(input, toggleBtn) {
        const type = input.type === 'password' ? 'text' : 'password';
        input.type = type;
        
        // Update toggle button icon
        const svg = toggleBtn.querySelector('svg');
        if (type === 'text') {
            svg.innerHTML = `
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
            `;
        } else {
            svg.innerHTML = `
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
            `;
        }
    }

    function checkPasswordStrength(password) {
        let strength = 0;
        let strengthLabel = '';

        if (password.length >= 8) strength += 25;
        if (/[A-Z]/.test(password)) strength += 25;
        if (/[a-z]/.test(password)) strength += 25;
        if (/[0-9]/.test(password)) strength += 25;

        // Remove all classes
        strengthFill.className = 'strength-fill';
        
        if (strength === 0) {
            strengthLabel = 'Password strength';
        } else if (strength <= 25) {
            strengthFill.classList.add('weak');
            strengthLabel = 'Weak';
        } else if (strength <= 50) {
            strengthFill.classList.add('fair');
            strengthLabel = 'Fair';
        } else if (strength <= 75) {
            strengthFill.classList.add('good');
            strengthLabel = 'Good';
        } else {
            strengthFill.classList.add('strong');
            strengthLabel = 'Strong';
        }

        strengthText.textContent = strengthLabel;
    }

    function checkPasswordRequirements(password) {
        // Length requirement
        if (password.length >= 8) {
            reqLength.classList.add('met');
            reqLength.querySelector('.requirement-icon').textContent = '✓';
        } else {
            reqLength.classList.remove('met');
            reqLength.querySelector('.requirement-icon').textContent = '○';
        }

        // Uppercase requirement
        if (/[A-Z]/.test(password)) {
            reqUppercase.classList.add('met');
            reqUppercase.querySelector('.requirement-icon').textContent = '✓';
        } else {
            reqUppercase.classList.remove('met');
            reqUppercase.querySelector('.requirement-icon').textContent = '○';
        }

        // Lowercase requirement
        if (/[a-z]/.test(password)) {
            reqLowercase.classList.add('met');
            reqLowercase.querySelector('.requirement-icon').textContent = '✓';
        } else {
            reqLowercase.classList.remove('met');
            reqLowercase.querySelector('.requirement-icon').textContent = '○';
        }

        // Number requirement
        if (/[0-9]/.test(password)) {
            reqNumber.classList.add('met');
            reqNumber.querySelector('.requirement-icon').textContent = '✓';
        } else {
            reqNumber.classList.remove('met');
            reqNumber.querySelector('.requirement-icon').textContent = '○';
        }

        // Special character requirement
        if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
            reqSpecial.classList.add('met');
            reqSpecial.querySelector('.requirement-icon').textContent = '✓';
        } else {
            reqSpecial.classList.remove('met');
            reqSpecial.querySelector('.requirement-icon').textContent = '○';
        }
    }

    function validateForm() {
        const otp = otpInputs.map(input => input.value).join('');
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        const otpError = document.getElementById('otpError');
        const newPasswordError = document.getElementById('newPasswordError');
        const confirmPasswordError = document.getElementById('confirmPasswordError');

        // Clear previous errors
        otpError.textContent = '';
        newPasswordError.textContent = '';
        confirmPasswordError.textContent = '';
        otpInputs.forEach(input => input.style.borderColor = '#e0e0e0');
        newPasswordInput.style.borderColor = '#e0e0e0';
        confirmPasswordInput.style.borderColor = '#e0e0e0';

        let isValid = true;

        // Check OTP
        if (otp && otp.length !== 6) {
            otpError.textContent = 'Please enter a 6-digit verification code';
            otpInputs.forEach(input => input.style.borderColor = '#d32f2f');
            isValid = false;
        }

        // Check if passwords match
        if (confirmPassword && newPassword !== confirmPassword) {
            confirmPasswordError.textContent = 'Passwords do not match';
            confirmPasswordInput.style.borderColor = '#d32f2f';
            isValid = false;
        }

        // Check if all requirements are met
        const requirements = [
            newPassword.length >= 8,
            /[A-Z]/.test(newPassword),
            /[a-z]/.test(newPassword),
            /[0-9]/.test(newPassword),
            /[!@#$%^&*(),.?":{}|<>]/.test(newPassword)
        ];

        if (newPassword && !requirements.every(req => req)) {
            newPasswordError.textContent = 'Please meet all password requirements';
            newPasswordInput.style.borderColor = '#d32f2f';
            isValid = false;
        }

        // Enable/disable submit button
        resetBtn.disabled = !isValid || !otp || !newPassword || !confirmPassword;

        return isValid;
    }

    function setLoading(loading) {
        if (loading) {
            resetBtn.classList.add('loading');
            resetBtn.disabled = true;
        } else {
            resetBtn.classList.remove('loading');
            validateForm();
        }
    }

    async function handlePasswordReset() {
        const otp = otpInputs.map(input => input.value).join('');
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        if (!validateForm()) {
            return;
        }

        if (newPassword !== confirmPassword) {
            showError('Passwords do not match');
            return;
        }

        setLoading(true);

        try {
            // Simulate API call with OTP verification
            await simulatePasswordResetWithOtp(otp, newPassword);
            
            // Success - show success message and redirect
            showSuccess();
            setTimeout(() => {
                window.location.href = 'login.html';
            }, 2000);
            
        } catch (error) {
            showError(error.message || 'Failed to reset password. Please try again.');
        } finally {
            setLoading(false);
        }
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
        `;
        
        document.body.appendChild(errorDiv);
        
        setTimeout(() => {
            errorDiv.remove();
        }, 4000);
    }

    function showSuccess() {
        const authCard = document.querySelector('.auth-card');
        authCard.classList.add('success');
        
        // Update button text
        const btnText = resetBtn.querySelector('.btn-text');
        btnText.textContent = 'Password Reset Successful!';
        
        // Show success message
        const successDiv = document.createElement('div');
        successDiv.textContent = 'Password reset successfully! Redirecting to login...';
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
        `;
        
        document.body.appendChild(successDiv);
        
        setTimeout(() => {
            successDiv.remove();
        }, 3000);
    }
}

// Simulate API call with OTP verification
function simulatePasswordResetWithOtp(otp, newPassword) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // For demo purposes, always succeed if OTP is 6 digits and password is valid
            if (otp && otp.length === 6 && newPassword.length >= 8) {
                resolve({ success: true });
            } else {
                reject(new Error('Invalid OTP or password'));
            }
        }, 1500);
    });
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
