document.addEventListener('click', (event) => {
    // 1. Check if the clicked element was one of our widget buttons
    const button = event.target.closest('.z-btn');
    if (!button) return;

    // 2. Find the specific widget container for THIS button
    const widget = button.closest('.iframe_widget');
    if (!widget) return;

    // 3. Apply the z-index to the iframe
    const targetIframe = widget.querySelector('.z-target');
    const newZ = button.getAttribute('data-z');

    if (targetIframe) {
        targetIframe.style.zIndex = newZ;
    }

    // 4. Update the 'active' class styling
    const allButtons = widget.querySelectorAll('.z-btn');
    allButtons.forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');
});