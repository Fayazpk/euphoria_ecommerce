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
    let selectedVariantId = null;
    const addToCartBtn = document.querySelector('.add-to-cart-btn');
    const cartForm = document.getElementById('cart-form');
    
    // Handle size button clicks
    document.querySelectorAll('.size-btn').forEach(button => {
        button.addEventListener('click', function() {
            // Remove active class from all buttons
            document.querySelectorAll('.size-btn').forEach(btn => {
                btn.classList.remove('bg-primary', 'text-white');
            });
            
            // Add active class to clicked button
            this.classList.add('bg-primary', 'text-white');
            
            // Store the selected variant ID
            selectedVariantId = this.getAttribute('data-variant-id');
            
            // Enable/disable add to cart button based on selection
            if (selectedVariantId) {
                addToCartBtn.removeAttribute('disabled');
            } else {
                addToCartBtn.setAttribute('disabled', 'disabled');
            }
        });
    });

    // Handle Add to Cart submission
    if (addToCartBtn && cartForm) {
        addToCartBtn.addEventListener('click', function(e) {
            e.preventDefault();
            
            if (!selectedVariantId) {
                alert('Please select a size first');
                return;
            }

            // Create hidden input for variant_id if it doesn't exist
            let variantInput = cartForm.querySelector('input[name="cart_item[product_variant_id]"]');
            if (!variantInput) {
                variantInput = document.createElement('input');
                variantInput.type = 'hidden';
                variantInput.name = 'cart_item[product_variant_id]';
                cartForm.appendChild(variantInput);
            }
            
            // Set the selected variant ID
            variantInput.value = selectedVariantId;

            // Add quantity if not present (default to 1)
            let quantityInput = cartForm.querySelector('input[name="cart_item[quantity]"]');
            if (!quantityInput) {
                quantityInput = document.createElement('input');
                quantityInput.type = 'hidden';
                quantityInput.name = 'cart_item[quantity]';
                quantityInput.value = '1';
                cartForm.appendChild(quantityInput);
            }

            // Submit the form
            cartForm.submit();
        });
    }
});
