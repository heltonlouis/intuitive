import requests
from bs4 import BeautifulSoup
import zipfile
import os

# Configurações
url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

try:
    # Requisição HTTP
    response = requests.get(url, headers=headers, timeout=10)
    response.raise_for_status()

    # Parse do HTML
    soup = BeautifulSoup(response.text, "html.parser")

    # Encontrar links de Anexos
    links = soup.find_all("a", string=lambda x: x and "Anexo" in x)

    if not links:
        print("Nenhum link com 'Anexo' encontrado na página.")
        exit()

    print(f"Encontrados {len(links)} links com 'Anexo'.")

    # Criar pasta para PDFs
    os.makedirs("pdf_files", exist_ok=True)

    # Baixar PDFs
    for link in links:
        pdf_url = link.get("href")
        if not pdf_url or not pdf_url.lower().endswith(".pdf"):
            continue

        try:
            pdf_response = requests.get(pdf_url, headers=headers, timeout=10)
            pdf_response.raise_for_status()

            pdf_name = pdf_url.split("/")[-1]
            pdf_path = os.path.join("pdf_files", pdf_name)

            with open(pdf_path, "wb") as pdf_file:
                pdf_file.write(pdf_response.content)

            print(f"Arquivo {pdf_name} baixado com sucesso.")
        except Exception as e:
            print(f"Erro ao baixar {pdf_url}: {e}")

    # Compactar em ZIP
    with zipfile.ZipFile("anexos.zip", "w") as zipf:
        for file in os.listdir("pdf_files"):
            if file.endswith(".pdf"):
                zipf.write(os.path.join("pdf_files", file))
    print("Anexos compactados em 'anexos.zip'")

except Exception as e:
    print(f"Erro durante a execução: {e}")
