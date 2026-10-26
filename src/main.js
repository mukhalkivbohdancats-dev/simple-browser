async function openUrl() {
    const urlInput = document.getElementById('urlInput').value.trim();
    if (!urlInput) return;

    // Додаємо https://, якщо користувач не вказав протокол
    let finalUrl = urlInput;
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
        finalUrl = 'https://' + finalUrl;
    }

    // Викликаємо Rust-команду для відкриття нового вікна
    try {
        await window.__TAURI__.core.invoke('open_url', { url: finalUrl });
    } catch (error) {
        alert('Помилка відкриття: ' + error);
    }
}
