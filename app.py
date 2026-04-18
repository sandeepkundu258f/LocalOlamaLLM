import os
from langchain_community.document_loaders import PyPDFDirectoryLoader
from langchain_community.vectorstores import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_ollama import OllamaLLM
import shutil

if os.path.exists("./db"):
    shutil.rmtree("./db")
    print("Old database cleared to sync with current folder.")

loader = PyPDFDirectoryLoader("./RAG_pdfs")
docs = loader.load()

model_path = "./models/embedding_model"
model_kwargs = {'device': 'cpu', 'local_files_only': True} # 'cpu' or 'cuda' if you have an NVIDIA GPU

embeddings = HuggingFaceEmbeddings(
    model_name="all-MiniLM-L6-v2",
    cache_folder=model_path,
    model_kwargs=model_kwargs
)
vectorstore = Chroma.from_documents(documents=docs, embedding=embeddings, persist_directory="./db")

llm = OllamaLLM(model="gemma2:2b", num_thread=8)

while True:
    query = input("\nAsk about your PDFs (or type 'exit'): ")
    if query.lower() == 'exit': break
    
    # Find the relevant parts of your PDFs
    relevant_docs = vectorstore.similarity_search(query, k=4)
    context = "\n".join([d.page_content for d in relevant_docs])
    
    prompt = f"Answer based ONLY on the text below.\nContext: {context}\nQuestion: {query}"
    response = llm.invoke(prompt)

    print(f"\nAI: {response}")