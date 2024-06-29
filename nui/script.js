window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.type === "openShop") {
        openShop(data.shop);
    } else if (data.type === "closeShop") {
        closeShop();
    }
});

function openShop(shop) {
    const shopElement = document.getElementById('shop');
    shopElement.classList.remove('hidden');
    document.getElementById('shopTitle').innerText = shop.name;
    const itemsContainer = document.getElementById('items');
    itemsContainer.innerHTML = '';
    shop.items.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.classList.add('item');
        itemElement.innerHTML = `
            <span>${item.name}</span>
            <button onclick="purchaseItem('${item.name}', ${item.price})">$${item.price}</button>
        `;
        itemsContainer.appendChild(itemElement);
    });
}

function closeShop() {
    const shopElement = document.getElementById('shop');
    shopElement.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeShop`, { method: 'POST' });
}

function purchaseItem(item, cost) {
    fetch(`https://${GetParentResourceName()}/purchaseItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ item, cost })
    });
}
