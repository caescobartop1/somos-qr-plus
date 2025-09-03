// 2-Factor Authentication JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeTwoFactorAuth();
});

function initializeTwoFactorAuth() {
    const form = document.getElementById('twoFactorForm');
    const codeInputs = document.querySelectorAll('.code-input');
    const verifyBtn = document.getElementById('verifyBtn');
    const resendBtn = document.getElementById('resendBtn');
    const backBtn = document.getElementById('backBtn');
    const codeError = document.getElementById('codeError');
    const countdown = document.getElementById('countdown');

    let resendTimer = null;
    let resendCountdown = 30;

    // Initialize code inputs
    codeInputs.forEach((input, index) => {
        // Focus management
        input.addEventListener('focus', function() {
            this.select();
        });

        // Input handling
        input.addEventListener('input', function(e) {
            const value = e.target.value;
            
            // Only allow numbers
            if (!/^\d*$/.test(value)) {
                e.target.value = '';
                return;
            }

            // Clear error when user starts typing
            if (codeError.textContent) {
                codeError.textContent = '';
                codeInputs.forEach(input => input.classList.remove('error'));
            }

            // Move to next input if value entered
            if (value && index < codeInputs.length - 1) {
                codeInputs[index + 1].focus();
            }

            // Update filled state
            updateFilledState();
            updateVerifyButton();
        });

        // Backspace handling
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && !this.value && index > 0) {
                codeInputs[index - 1].focus();
            }
        });

        // Paste handling
        input.addEventListener('paste', function(e) {
            e.preventDefault();
            const pastedData = e.clipboardData.getData('text');
            const numbers = pastedData.replace(/\D/g, '').slice(0, 6);
            
            if (numbers.length === 6) {
                codeInputs.forEach((input, i) => {
                    input.value = numbers[i] || '';
                });
                updateFilledState();
                updateVerifyButton();
                codeInputs[5].focus();
            }
        });
    });

    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        handleVerification();
    });

    // Resend code
    resendBtn.addEventListener('click', function() {
        if (!resendBtn.disabled) {
            handleResendCode();
        }
    });

    // Back to login
    backBtn.addEventListener('click', function() {
        window.location.href = 'login.html';
    });

    // Initialize resend countdown
    startResendCountdown();

    function updateFilledState() {
        codeInputs.forEach(input => {
            if (input.value) {
                input.classList.add('filled');
            } else {
                input.classList.remove('filled');
            }
        });
    }

    function updateVerifyButton() {
        const isComplete = Array.from(codeInputs).every(input => input.value);
        verifyBtn.disabled = !isComplete;
    }

    function getCode() {
        return Array.from(codeInputs).map(input => input.value).join('');
    }

    function showError(message) {
        codeError.textContent = message;
        codeInputs.forEach(input => input.classList.add('error'));
    }

    function clearError() {
        codeError.textContent = '';
        codeInputs.forEach(input => input.classList.remove('error'));
    }

    function setLoading(loading) {
        if (loading) {
            verifyBtn.classList.add('loading');
            verifyBtn.disabled = true;
        } else {
            verifyBtn.classList.remove('loading');
            updateVerifyButton();
        }
    }

    function startResendCountdown() {
        resendBtn.disabled = true;
        resendCountdown = 30;
        
        resendTimer = setInterval(() => {
            resendCountdown--;
            countdown.textContent = ` (${resendCountdown}s)`;
            
            if (resendCountdown <= 0) {
                clearInterval(resendTimer);
                resendBtn.disabled = false;
                countdown.textContent = '';
            }
        }, 1000);
    }

    async function handleVerification() {
        const code = getCode();
        
        if (code.length !== 6) {
            showError('Please enter the complete 6-digit code');
            return;
        }

        setLoading(true);
        clearError();

        try {
            // Simulate API call
            await simulateVerification(code);
            
            // Success - redirect to dashboard
            showSuccess();
            setTimeout(() => {
                window.location.href = 'dashboard.html';
            }, 1500);
            
        } catch (error) {
            showError(error.message || 'Invalid verification code. Please try again.');
            // Clear inputs on error
            codeInputs.forEach(input => input.value = '');
            updateFilledState();
            updateVerifyButton();
            codeInputs[0].focus();
        } finally {
            setLoading(false);
        }
    }

    async function handleResendCode() {
        try {
            // Simulate API call
            await simulateResendCode();
            
            // Show success message
            showResendSuccess();
            
            // Restart countdown
            startResendCountdown();
            
        } catch (error) {
            showError('Failed to resend code. Please try again.');
        }
    }

    function showSuccess() {
        const authCard = document.querySelector('.auth-card');
        authCard.classList.add('success');
        
        // Update button text
        const btnText = verifyBtn.querySelector('.btn-text');
        btnText.textContent = 'Verification Successful!';
    }

    function showResendSuccess() {
        // Create temporary success message
        const message = document.createElement('div');
        message.textContent = 'Code resent successfully!';
        message.style.cssText = `
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
        
        document.body.appendChild(message);
        
        setTimeout(() => {
            message.remove();
        }, 3000);
    }
}

// Simulate API calls
function simulateVerification(code) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // For demo purposes, accept any 6-digit code
            if (code === '123456') {
                resolve({ success: true });
            } else {
                reject(new Error('Invalid verification code'));
            }
        }, 1500);
    });
}

function simulateResendCode() {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve({ success: true });
        }, 1000);
    });
}

// Add CSS for success message animation
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
