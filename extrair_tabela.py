import pandas as pd
import zipfile
import os
from tabula import read_pdf
import re

# Configurações
pdf_path = "pdf_files/Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"
output_csv = "Rol_de_Procedimentos.csv"
output_zip = f"Teste_Helton.zip"

# 1. Extrair tabelas do PDF
try:
    # 'pages="all"' processa todas as páginas,
    # 'lattice=True' para tabelas com linhas visíveis
    # 'multiple_tables=True' para extrair todas as tabelas encontradas
    dfs = read_pdf(
        pdf_path,
        pages="all",
        lattice=True,
        multiple_tables=True,
        pandas_options={"header": None},  # Se o PDF não tiver cabeçalhos claros
    )

    # Combina todas as tabelas extraídas em um único DataFrame
    df = pd.concat(dfs, ignore_index=True)

    # Limpeza básica dos dados
    df = df.dropna(how="all")  # Remove linhas totalmente vazias
    df = df.reset_index(drop=True)

    # 2. Substituir abreviações
    df.replace({"OD": "Seg. Odontológica", "AMB": "Seg. Ambulatorial"}, inplace=True)

    # 3. Salvar como CSV
    df.to_csv(output_csv, index=False, encoding="utf-8-sig")
    print(f"Tabela extraída e salva como {output_csv}")

    # 4. Compactar o CSV
    with zipfile.ZipFile(output_zip, "w", zipfile.ZIP_DEFLATED) as zipf:
        zipf.write(output_csv)
    print(f"Arquivo compactado como {output_zip}")

    # Opcional: Remover o CSV após compactar
    os.remove(output_csv)

except Exception as e:
    print(f"Erro durante o processamento: {e}")
