from flask import Flask, request, jsonify
import pandas as pd
from fuzzywuzzy import fuzz

# CORS
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

df = pd.read_csv("../downloads/Relatorio_cadop.csv", sep=";", encoding="utf-8")


@app.route("/api/buscar", methods=["GET"])
def buscar():
    termo = request.args.get("termo", "")
    limite = int(request.args.get("limite", 10))

    if not termo:
        return jsonify([])

    # Função para calcular a relevância
    def calcular_relevancia(row):
        nome_fantasia = (
            str(row["Nome_Fantasia"]) if pd.notna(row["Nome_Fantasia"]) else ""
        )
        razao_social = str(row["Razao_Social"])
        cidade = str(row["Cidade"])
        uf = str(row["UF"])

        score = max(
            fuzz.token_set_ratio(termo.lower(), nome_fantasia.lower()),
            fuzz.token_set_ratio(termo.lower(), razao_social.lower()),
            fuzz.token_set_ratio(termo.lower(), cidade.lower()),
            fuzz.token_set_ratio(termo.lower(), uf.lower()),
        )
        return score

    # Calcular relevância para cada registro
    df["Relevancia"] = df.apply(calcular_relevancia, axis=1)

    # Ordenar por relevância e pegar os top resultados
    resultados = df.sort_values("Relevancia", ascending=False).head(limite)

    # Converter para formato JSON
    return jsonify(resultados.fillna("").to_dict("records"))


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5005)
