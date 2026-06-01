let pageHistory = ['page-landing'];
let selectedIngredients = new Set();
let pendingRemoveCard = null;

function goTo(pageId){

  document.querySelectorAll('.page').forEach(page=>{
    page.classList.remove('active');
  });

  document.getElementById(pageId).classList.add('active');

  document.querySelectorAll('.nav-item').forEach(item=>{
    item.classList.remove('active');

    if(item.getAttribute('onclick')?.includes(pageId)){
      item.classList.add('active');
    }
  });
}

function setNav(el,pageId){
  goTo(pageId);
}

function goBack() {
  if (pageHistory.length <= 1) return;
  pageHistory.pop();
  goTo(pageHistory[pageHistory.length - 1], true);
}

function setNav(el, pageId) {
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
  el.classList.add('active');
  goTo(pageId);
}

function changeQty(btn, delta) {
  const qtyEl = btn.parentElement.querySelector('.qty-num');
  let val = parseInt(qtyEl.textContent) + delta;
  if (val < 1) {
    const card = btn.closest('.ingredient-card');
    const name = card.querySelector('.ing-name').textContent;
    pendingRemoveCard = card;
    document.getElementById('modal-ing-name').textContent = name;
    document.getElementById('remove-modal').style.display = 'flex';
    return;
  }
  qtyEl.textContent = val;
}

function closeModal() {
  document.getElementById('remove-modal').style.display = 'none';
  pendingRemoveCard = null;
}

function confirmRemove() {
  if (pendingRemoveCard) pendingRemoveCard.remove();
  closeModal();
}

function toggleIng(el, name) {
  if (el.classList.contains('selected')) {
    el.classList.remove('selected');
    selectedIngredients.delete(name);
  } else {
    el.classList.add('selected');
    selectedIngredients.add(name);
  }
  const label = document.getElementById('selected-label');
  const count = document.getElementById('selected-count');
  if (selectedIngredients.size > 0) {
    label.style.display = 'block';
    count.textContent = selectedIngredients.size;
  } else {
    label.style.display = 'none';
  }
}

function filterIngredients(query) {
  document.querySelectorAll('.ing-chip').forEach(chip => {
    const name = chip.querySelector('span').textContent.toLowerCase();
    chip.style.display = name.includes(query.toLowerCase()) ? '' : 'none';
  });
}

const ingAssets = {
  'Rice': 'assets/rice.png', 'Egg': 'assets/telur.png',
  'Chicken': 'assets/ayam.png', 'Soy Sauce': 'assets/kikoman.png',
  'Beef': 'assets/daging.png', 'Butter': 'assets/butter.png',
  'Tomato': 'assets/tomat.png', 'Paprika': 'assets/paprika.png',
  'Salt': 'assets/salt.png', 'Pepper': 'assets/pepper.png',
  'Spam': 'assets/spam.png', 'Bread': 'assets/bage.png'
};

function addToList() {
  if (selectedIngredients.size === 0) return;
  const list = document.getElementById('home-ing-list');
  selectedIngredients.forEach(name => {
    const exists = [...list.querySelectorAll('.ing-name')].find(el => el.textContent === name);
    if (exists) return;
    const card = document.createElement('div');
    card.className = 'ingredient-card';
    card.innerHTML = `
      <img src="${ingAssets[name]}" alt="${name}" class="ing-img">
      <div class="ing-divider"></div>
      <span class="ing-name">${name}</span>
      <div class="ing-qty">
        <button class="qty-btn" onclick="changeQty(this,-1)">−</button>
        <span class="qty-num">1</span>
        <button class="qty-btn" onclick="changeQty(this,1)">+</button>
      </div>`;
    list.appendChild(card);
  });
  document.querySelectorAll('.ing-chip.selected').forEach(c => c.classList.remove('selected'));
  selectedIngredients.clear();
  document.getElementById('selected-label').style.display = 'none';
  goBack();
}