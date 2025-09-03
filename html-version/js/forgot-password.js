// Forgot Password JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeForgotPassword();
});

function initializeForgotPassword() {
    const form = document.getElementById('forgotPasswordForm');
    const emailInput = document.getElementById('email');
    const sendBtn = document.getElementById('sendBtn');
    const backToLoginBtn = document.getElementById('backToLoginBtn');
    const resendBtn = document.getElementById('resendBtn');
    const successMessage = document.getElementById('successMessage');
    const userEmail = document.getElementById('userEmail');

    // Email validation
    emailInput.addEventListener('blur', validateEmail);
    emailInput.addEventListener('input', clearEmailError);

    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        handleForgotPassword();
    });

    // Back to login
    backToLoginBtn.addEventListener('click', function() {
        window.location.href = 'login.html';
    });

    // Resend email
    resendBtn.addEventListener('click', function() {
        handleResendEmail();
    });

    function validateEmail() {
        const email = emailInput.value.trim();
        const emailError = document.getElementById('emailError');
        
        if (!email) {
            emailError.textContent = 'Email address is required';
            emailInput.style.borderColor = '#d32f2f';
            return false;
        }
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            emailError.textContent = 'Please enter a valid email address';
            emailInput.style.borderColor = '#d32f2f';
            return false;
        }
        
        emailError.textContent = '';
        emailInput.style.borderColor = '#e0e0e0';
        return true;
    }

    function clearEmailError() {
        const emailError = document.getElementById('emailError');
        emailError.textContent = '';
        emailInput.style.borderColor = '#e0e0e0';
    }

    function setLoading(loading) {
        if (loading) {
            sendBtn.classList.add('loading');
            sendBtn.disabled = true;
        } else {
            sendBtn.classList.remove('loading');
            sendBtn.disabled = false;
        }
    }

    async function handleForgotPassword() {
        const email = emailInput.value.trim();
        
        if (!validateEmail()) {
            return;
        }

        setLoading(true);

        try {
            // Simulate API call
            await simulateSendResetEmail(email);
            
            // Show success message
            showSuccessMessage(email);
            
        } catch (error) {
            showError(error.message || 'Failed to send reset email. Please try again.');
        } finally {
            setLoading(false);
        }
    }

    async function handleResendEmail() {
        const email = emailInput.value.trim();
        
        if (!email) {
            showError('Please enter your email address first');
            return;
        }

        setLoading(true);

        try {
            // Simulate API call
            await simulateSendResetEmail(email);
            
            showSuccess('Reset email sent again!');
            
        } catch (error) {
            showError(error.message || 'Failed to resend email. Please try again.');
        } finally {
            setLoading(false);
        }
    }

    function showSuccessMessage(email) {
        // Hide the form
        form.classList.add('hidden');
        
        // Show success message
        userEmail.textContent = email;
        successMessage.classList.add('show');
        
        // Add success animation to card
        const authCard = document.querySelector('.auth-card');
        authCard.classList.add('success');
    }

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
        `;
        
        document.body.appendChild(successDiv);
        
        setTimeout(() => {
            successDiv.remove();
        }, 3000);
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
}

// Simulate API call
function simulateSendResetEmail(email) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // For demo purposes, always succeed
            if (email && email.includes('@')) {
                resolve({ success: true });
            } else {
                reject(new Error('Invalid email address'));
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
    
    .auth-card.success {
        animation: successPulse 0.6s ease-out;
    }
    
    @keyframes successPulse {
        0% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.02);
        }
        100% {
            transform: scale(1);
        }
    }
`;
document.head.appendChild(style);
