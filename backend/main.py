from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# 🌐 CORS aktivieren – für lokalen Zugriff von Flutter Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Oder z. B. ["http://localhost:52342"] für eingeschränkten Zugriff
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 🔹 Beispielhafte Live-Daten
rohstoffdaten = {
    "Gold": 3329.4,
    "Silber": 33.58,
    "Öl_WTI": 60.95,
    "Öl_Brent": 64.25,
    "Weizen": 546.75,
    "Mais": 459.0,
    "Sojabohnen": 1057.5,
    "Erdgas": 3.34
}

@app.get("/api/rohstoffe")
def get_rohstoffpreise():
    return rohstoffdaten

@app.get("/api/rohstoffe/{name}/verlauf")
def get_verlauf(name: str, zeitraum: str = "1y"):
    # Platzhalterdaten (können später aus echter Quelle kommen)
    fake_data = [
        {"datum": "2024-01-01", "wert": 100 + i * 5} for i in range(12)
    ]
    return fake_data