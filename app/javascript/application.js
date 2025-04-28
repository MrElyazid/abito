// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// Dark Mode Toggle Logic
document.addEventListener('turbo:load', () => {
  const toggleButton = document.getElementById('darkModeToggle');
  const htmlElement = document.documentElement; // Target the <html> element
  const moonIconClass = 'bi-moon-stars-fill';
  const sunIconClass = 'bi-sun-fill';

  // Function to apply the theme
  const applyTheme = (theme) => {
    if (theme === 'dark') {
      htmlElement.setAttribute('data-bs-theme', 'dark');
      if (toggleButton) {
        toggleButton.innerHTML = `<i class="bi ${sunIconClass}"></i>`; // Show sun icon in dark mode
      }
    } else {
      htmlElement.removeAttribute('data-bs-theme');
      if (toggleButton) {
        toggleButton.innerHTML = `<i class="bi ${moonIconClass}"></i>`; // Show moon icon in light mode
      }
    }
  };

  // Function to toggle the theme
  const toggleTheme = () => {
    const currentTheme = htmlElement.getAttribute('data-bs-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    localStorage.setItem('theme', newTheme); // Save preference
    applyTheme(newTheme);
  };

  // Get initial theme preference
  const savedTheme = localStorage.getItem('theme');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const initialTheme = savedTheme || (prefersDark ? 'dark' : 'light');

  // Apply the initial theme
  applyTheme(initialTheme);

  // Add event listener to the button
  if (toggleButton) {
    toggleButton.addEventListener('click', toggleTheme);
  }

  // Optional: Listen for system preference changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    // Only change if no theme is explicitly saved in localStorage
    if (!localStorage.getItem('theme')) {
      applyTheme(event.matches ? 'dark' : 'light');
    }
  });
});
