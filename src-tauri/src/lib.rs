use tauri::{WebviewUrl, WebviewWindowBuilder};
use std::time::{SystemTime, UNIX_EPOCH};

#[tauri::command]
async fn open_url(app: tauri::AppHandle, url: String) -> Result<(), String> {
    // Перевіряємо, чи URL валідний
    let parsed_url = match url.parse() {
        Ok(u) => u,
        Err(_) => return Err("Невірний формат URL".into()),
    };

    // Генеруємо унікальне ім'я для вікна, щоб Tauri не видавав помилку
    let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis();
    let label = format!("kishka_window_{}", timestamp);

    // Створюємо вікно з сайтом
    WebviewWindowBuilder::new(&app, label, WebviewUrl::External(parsed_url))
        .title("Kishka Browser")
        .inner_size(1024.0, 768.0)
        .build()
        .map_err(|e| e.to_string())?;
    Ok(())
}

pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![open_url])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
