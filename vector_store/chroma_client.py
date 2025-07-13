import chromadb
import os
os.environ["ANONYMIZED_TELEMETRY"] = "False"

def get_chroma_client():
    return chromadb.PersistentClient(path="vector_store/chroma_db")
