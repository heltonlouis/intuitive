para rodar o web scraping:

```bash
python3 web_scraping.py
```

para extrair os dados das demonstrações contábeis:

```bash
python3 extract_demonstracoes.py
```

para instalar o banco de dados:

```bash
sudo -u postgres psql -f create.sql
```

para importar os dados das operadoras:

```bash
psql -d intuitive_db -f import.sql
```

para importar os dados das demonstrações contábeis:

```bash
sudo chmod +x import_demonstracoes.sh
./import_demonstracoes.sh
```

para analisar os dados:

```bash
sudo -u postgres psql -f analitic.sql
```

para acessar a api:

```bash
cd api
python server.py
```

para acessar a interface:

```bash
cd front
npm install
npm run dev
```
