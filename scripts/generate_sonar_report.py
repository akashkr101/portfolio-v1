import requests
import pandas as pd
import os

SONAR_URL = "https://your-sonarqube-host"
PROJECT_KEY = "your_project_key"
AUTH_TOKEN = os.getenv("SONAR_TOKEN")

headers = {
    "Authorization": f"Bearer {AUTH_TOKEN}"
}

response = requests.get(
    f"{SONAR_URL}/api/issues/search",
    params={
        "componentKeys": PROJECT_KEY,
        "types": "BUG,VULNERABILITY,CODE_SMELL",
        "ps": 500  # page size
    },
    headers=headers
)

issues = response.json().get("issues", [])
df = pd.json_normalize(issues)
df.to_excel("sonarqube_report.xlsx", index=False)
