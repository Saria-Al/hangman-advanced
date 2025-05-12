// 🌓 Toggle Light/Dark Mode and save preference
function toggleMode() {
  document.body.classList.toggle('dark-mode');
  const isDark = document.body.classList.contains('dark-mode');
  localStorage.setItem('darkMode', isDark ? 'enabled' : 'disabled');
}

// 🎵 Play applause on win after guessing
function playWinSound() {
  const audio = new Audio('/mixkit-ending-show-audience-clapping-478.wav');
  audio.play();
}

// 😢 Play sound on loss
function playLoseSound() {
  const audio = new Audio('/mixkit-lost-kid-sobbing-474.wav');
  audio.play();
}

// 🚀 On load: apply saved dark mode and fetch hint
window.onload = () => {
  // Apply saved dark mode preference
  if (localStorage.getItem('darkMode') === 'enabled') {
    document.body.classList.add('dark-mode');
  }

  // Fetch and show dynamic hint if present
  const hintText = document.getElementById('hint-text');
  if (hintText) {
    fetch('/hint')
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newHint = doc.querySelector('#hint-text')?.textContent || "No hint";
        hintText.textContent = newHint;
      })
      .catch(error => {
        console.error("Failed to load hint:", error);
        hintText.textContent = "Failed to load hint.";
      });
  }

  // 🎯 Check win/loss and act accordingly
  const winText = document.getElementById('winText');
  const loseText = document.getElementById('loseText');

  if (winText && winText.style.display !== 'none') {
    playWinSound();
    setTimeout(() => window.location.href = '/new', 3000);
  } else if (loseText && loseText.style.display !== 'none') {
    playLoseSound();
    alert(`😤 You lost! The correct word was: ${correctWord}`);
  }
};
