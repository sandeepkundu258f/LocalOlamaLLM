from langchain_huggingface import HuggingFaceEmbeddings

model_path = "./models/embedding_model"

embeddings = HuggingFaceEmbeddings(
    model_name="nomic-ai/nomic-embed-text-v1.5",
    cache_folder=model_path,
    model_kwargs = {'device': 'cpu'}
)