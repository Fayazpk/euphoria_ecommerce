document.addEventListener('DOMContentLoaded', function() {
    // Handle image thumbnail click
    document.querySelectorAll('[data-thumbnail]').forEach(function(thumbnail) {
        thumbnail.addEventListener('click', function() {
            const mainImage = document.getElementById('mainImage');
            mainImage.src = this.src;
            document.querySelectorAll('.thumbnail-container img').forEach(function(img) {
                img.classList.remove('active');
            });
            this.classList.add('active');
        });
    });

    // Handle size selection
    document.querySelectorAll('.size-btn').forEach(function(button) {
        button.addEventListener('click', function() {
            document.querySelectorAll('.size-btn').forEach(function(btn) {
                btn.classList.remove('selected');
            });
            this.classList.add('selected');
        });
    });

    // Handle quantity change
    document.querySelectorAll('.quantity-btn').forEach(function(button) {
        button.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            const quantityInput = document.querySelector('.quantity-input');
            let currentValue = parseInt(quantityInput.value);

            if (action === 'increase') {
                quantityInput.value = currentValue + 1;
            } else if (action === 'decrease' && currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }
        });
    });
});
