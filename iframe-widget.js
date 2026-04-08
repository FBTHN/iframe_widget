document.addEventListener('DOMContentLoaded', () => {
    // Find all iframe widgets on the page
    const widgets = document.querySelectorAll('.iframe-widget');

    widgets.forEach(widget => {
        const targetIframe = widget.querySelector('.z-target');
        const buttons = widget.querySelectorAll('.z-btn');

        buttons.forEach(button => {
            button.addEventListener('click', (event) => {
                // Get the target z-index from the button's data attribute
                const newZ = button.getAttribute('data-z');

                // Set the iframe's z-index
                if (targetIframe) {
                    targetIframe.style.zIndex = newZ;
                }

                // Update the 'active' class on buttons within this widget
                buttons.forEach(btn => btn.classList.remove('active'));
                event.currentTarget.classList.add('active');
            });
        });
    });
});