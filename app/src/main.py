from fastapi import FastAPI

# Se crea una instancia de FastAPI para la aplicación
app = FastAPI()

# Definimos una ruta (endpoint) GET en la raíz ("/") de la API
@app.get("/")
def read_root():
    # Cuando se accede a este endpoint, retorna un diccionario con un mensaje
    return {"message": "Hello, world!"}
