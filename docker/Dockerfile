# Partimos de la imagen oficial de Langflow
FROM langflowai/langflow:latest

# Instalamos las dependencias de Python necesarias para los módulos de RRSS
# tweepy: Para la API de X | facebook-sdk: Para Instagram | requests: Para APIs REST
RUN pip install tweepy facebook-sdk requests linkedin-api

# Copiamos nuestros módulos personalizados (.py) al directorio de componentes de Langflow
COPY ./custom_modules /app/langflow/custom_components

# Exponemos el puerto por defecto
EXPOSE 7860