// 🌓 Toggle Light/Dark Mode and save preference
function toggleMode() {
  document.body.classList.toggle('dark-mode');
  const isDark = document.body.classList.contains('dark-mode');
  localStorage.setItem('darkMode', isDark ? 'enabled' : 'disabled');
}

// 💡 Fetch a hint from the server
function getHint() {
  fetch('/hint')
    .then(response => response.json())
    .then(data => {
      document.getElementById('hint-text').textContent = "💡 Hint: " + data.hint;
    })
    .catch(error => {
      console.error("Failed to load hint:", error);
      document.getElementById('hint-text').textContent = "Failed to load hint.";
    });
}

// 🚀 On load: apply saved dark mode
window.onload = () => {
  if (localStorage.getItem('darkMode') === 'enabled') {
    document.body.classList.add('dark-mode');
  }
};

// 🎵 Play applause on win after guessing
document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form[action="/guess"]');
  if (form) {
    form.addEventListener('submit', () => {
      setTimeout(() => {
        const winText = document.querySelector('p');
        const audio = document.getElementById('applause');
        if (winText && winText.textContent.includes("You won") && audio) {
          audio.play().catch(e => console.log("Audio blocked:", e));
        }
      }, 200); // wait for server to render updated result
    });
  }
});
