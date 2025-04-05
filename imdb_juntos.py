import os
import numpy as np
from sklearn.model_selection import train_test_split

datapath = r'D:\Data\aclImdb'
save_dir = r'./data'

def get_data(data_folder):
    """Leer datos de forma segura para evitar truncamiento de archivos"""
    pos_path = os.path.join(data_folder, 'pos')
    neg_path = os.path.join(data_folder, 'neg')
    
    # Leer todas las reseñas positivas
    pos_all = []
    for filename in os.listdir(pos_path):
        with open(os.path.join(pos_path, filename), 'r', encoding='utf-8') as f:
            pos_all.append(f.read())
    
    # Leer todas las reseñas negativas
    neg_all = []
    for filename in os.listdir(neg_path):
        with open(os.path.join(neg_path, filename), 'r', encoding='utf-8') as f:
            neg_all.append(f.read())
    
    # Combinar datos
    X = np.array(pos_all + neg_all)
    y = np.array([1]*len(pos_all) + [0]*len(neg_all))
    return X, y

def generate_train_data():
    # Configurar semilla aleatoria reproducible
    np.random.seed(42)  # Corregir error en el código original: usar np.random.seed(42) en lugar de np.random.seed = ...
    
    # Cargar solo el conjunto de entrenamiento original (sin mezclar con el de prueba)
    X_train_full, y_train_full = get_data(os.path.join(datapath, 'train'))
    
    # Dividir el conjunto de entrenamiento original en entrenamiento y validación (80% entrenamiento/20% validación)
    X_train, X_val, y_train, y_val = train_test_split(
        X_train_full, 
        y_train_full,
        test_size=0.2,       # Proporción del conjunto de validación
        stratify=y_train_full,  # Mantener la distribución de clases
        random_state=42
    )
    
    # Cargar el conjunto de prueba original de forma independiente (mantener la independencia del conjunto de prueba)
    X_test, y_test = get_data(os.path.join(datapath, 'test'))
    
    # Imprimir distribución de datos
    print("\nDistribución final de los datos:")
    print(f"Conjunto de entrenamiento original: {X_train_full.shape[0]}")
    print(f"Nuevo conjunto de entrenamiento: {X_train.shape[0]}")
    print(f"Conjunto de validación: {X_val.shape[0]}")
    print(f"Conjunto de prueba: {X_test.shape[0]}")
    
    # Guardar datos
    os.makedirs(save_dir, exist_ok=True)
    np.savez(os.path.join(save_dir, 'imdb_train.npz'), x=X_train, y=y_train)
    np.savez(os.path.join(save_dir, 'imdb_val.npz'), x=X_val, y=y_val)
    np.savez(os.path.join(save_dir, 'imdb_test.npz'), x=X_test, y=y_test)

if __name__ == '__main__':
    generate_train_data()