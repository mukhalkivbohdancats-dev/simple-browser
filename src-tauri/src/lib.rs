use tauri::{WebviewUrl, WebviewWindowBuilder};

#[tauri::command]
async fn open_url(app: tauri::AppHandle, url: String) -> Result<(), String> {
    WebviewWindowBuilder::new(&app, url.clone(), WebviewUrl::External(url.parse().unwrap()))
        .title("Kishka Browser")
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
