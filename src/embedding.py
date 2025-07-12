import os
from sentence_transformers import SentenceTransformer
from dotenv import load_dotenv
from huggingface_hub import login

# Load environment variables
load_dotenv()

# Optional debug logging
debug = os.getenv("DEBUG", "false").lower() == "true"

# Login to Hugging Face (if key is present)
hf_api_key = os.getenv("HUGGINGFACE_API_KEY")
if hf_api_key:
    login(hf_api_key)
    if debug:
        print("[Embedding] Logged into HuggingFace Hub.")
else:
    if debug:
        print("[Embedding] No HuggingFace API key provided. Using public access.")

# Model loader
def get_embedding_model(model_name="paraphrase-MiniLM-L6-v2"):
    if debug:
        print(f"[Embedding] Loading model: sentence-transformers/{model_name}")
    return SentenceTransformer(f"sentence-transformers/{model_name}")
