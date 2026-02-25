# Use a imagem oficial do Python slim para reduzir o tamanho
FROM python:3.11-slim

# Define o diretório de trabalho
WORKDIR /app

# Define variáveis de ambiente para evitar arquivos .pyc e buffer de log
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Instala as dependências do sistema necessárias para compilação (se houver)
# Em seguida, limpa o cache do apt para manter a imagem leve
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia apenas o arquivo de requisitos primeiro para aproveitar o cache das camadas do Docker
COPY requirements.txt .

# Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código do aplicativo
COPY . .

# Expõe a porta 8080
EXPOSE 8080

# Comando para iniciar o aplicativo usando Gunicorn
# -b 0.0.0.0:8080 vincula o servidor à porta correta
# app:app assume que seu arquivo principal é app.py e a instância Flask chama-se app
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
