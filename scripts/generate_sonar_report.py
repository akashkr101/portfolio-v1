import requests
import pandas as pd
import os

SONAR_URL = "http://51.20.87.70:9000"
PROJECT_KEY = "portfolio"
AUTH_TOKEN = os.getenv("SONAR_TOKEN")

headers = {
    "Authorization": f"Bearer {AUTH_TOKEN}"
}

response = requests.get(
    f"{http://51.20.87.70:9000}/api/issues/search",
    params={
        "componentKeys": portfolio,
        "types": "BUG,VULNERABILITY,CODE_SMELL",
        "ps": 500  # page size
    },
    headers=headers
)

issues = response.json().get("issues", [])
df = pd.json_normalize(issues)
df.to_excel("sonarqube_report.xlsx", index=False)
