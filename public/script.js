// 🌓 Toggle Light/Dark Mode and save preference
function toggleMode() {
  document.body.classList.toggle('dark-mode');
  const isDark = document.body.classList.contains('dark-mode');
  localStorage.setItem('darkMode', isDark ? 'enabled' : 'disabled');
}

fetch('/hint')
  .then(response => response.text())
  .then(html => {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const newHint = doc.querySelector('#hint-text')?.textContent || "No hint";
    document.getElementById('hint-text').textContent = newHint;
  })
  .catch(error => {
    console.error("Failed to load hint:", error);
    document.getElementById('hint-text').textContent = "Failed to load hint.";
  });


// 🚀 On load: apply saved dark mode
window.onload = () => {
  if (localStorage.getItem('darkMode') === 'enabled') {
    document.body.classList.add('dark-mode');
  }
};

// 🎵 Play applause on win after guessing
function playWinSound() {
  const audio = new Audio('/mixkit-ending-show-audience-clapping-478.wav');
  audio.play();
}


function playLoseSound() {
  const audio = new Audio('/mixkit-lost-kid-sobbing-474.wav');
  audio.play();
}
