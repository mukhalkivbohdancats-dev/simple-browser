async function openUrl() {
    let urlInput = document.getElementById('urlInput').value.trim();
    if (!urlInput) return;

    if (!urlInput.startsWith('http://') && !urlInput.startsWith('https://')) {
        urlInput = 'https://' + urlInput;
    }

    try {
        await window.__TAURI__.core.invoke('open_url', { url: urlInput });
    } catch (error) {
        alert('Помилка: ' + error);
    }
}
