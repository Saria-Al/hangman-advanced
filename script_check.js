
function toggleMode() {
  document.body.classList.toggle('dark-mode');
}

function fetchHint() {
  fetch('/hint')
    .then(response => response.json())
    .then(data => {
      document.getElementById('hintText').textContent = data.hint || "No hint available.";
    });
}

function playWinSound() {
  const audio = new Audio('/applause.mp3');
  audio.play();
}

window.onload = function () {
  const winText = document.getElementById('winText');
  const loseText = document.getElementById('loseText');

  if (winText && winText.style.display !== 'none') {
    playWinSound();
    setTimeout(() => window.location.href = '/new', 3000);
  } else if (loseText && loseText.style.display !== 'none') {
    alert("😤 ما هذا هو؟ تستغبي؟ حتى ما عرفت تخمن كلمة بسيطة!");
  }
};
