document.addEventListener("DOMContentLoaded", function () {
  const hash = window.location.hash; // Get the URL hash
  if (hash) {
    const targetCollapse = document.querySelector(hash); // Find the target collapse div
    if (targetCollapse && targetCollapse.classList.contains("collapse")) {
      const collapseInstance = new bootstrap.Collapse(targetCollapse, {
        toggle: true,
      });
    }
  }
});
