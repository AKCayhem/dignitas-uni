import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from langchain.document_loaders import PyPDFLoader, DirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings  # or HuggingFaceEmbeddings for free
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA
from langchain.llms import OpenAI  # or ChatOpenAI, or use HuggingFacePipeline

load_dotenv()

app = FastAPI()

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your Flutter app's origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for QA chain
qa_chain = None

# Pydantic models
class Question(BaseModel):
    question: str

class Answer(BaseModel):
    answer: str
    sources: list[str]  # optional, for debugging

@app.on_event("startup")
async def load_documents():
    global qa_chain
    # Load PDFs from the documents folder
    loader = DirectoryLoader("documents", glob="*/.pdf", loader_cls=PyPDFLoader)
    documents = loader.load()
    if not documents:
        print("WARNING: No PDF documents found in ./documents/")
        return

    # Split documents into chunks
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
    texts = text_splitter.split_documents(documents)

    # Create embeddings (use OpenAI or free)
    # Option 1: OpenAI (requires API key in .env)
    embeddings = OpenAIEmbeddings()
    # Option 2: Free local embeddings (uncomment below)
    # from langchain.embeddings import HuggingFaceEmbeddings
    # embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")

    # Create vector store
    vectorstore = Chroma.from_documents(texts, embeddings, persist_directory="./chroma_db")
    vectorstore.persist()

    # Create retrieval QA chain
    # Option 1: OpenAI LLM
    llm = OpenAI(temperature=0)
    # Option 2: Free local LLM (requires additional setup)
    # from langchain.llms import Ollama  # if you have Ollama
    # llm = Ollama(model="llama2")

    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=vectorstore.as_retriever(search_kwargs={"k": 3}),
        return_source_documents=True,  # to get sources
    )
    print("Documents loaded and QA chain ready.")

@app.get("/")
def root():
    return {"message": "University Assistant API is running"}

@app.post("/ask", response_model=Answer)
async def ask_question(question: Question):
    if not qa_chain:
        raise HTTPException(status_code=503, detail="Documents not loaded yet. Please check backend.")
    try:
        result = qa_chain({"query": question.question})
        answer = result["result"]
        sources = [doc.metadata.get("source", "Unknown") for doc in result["source_documents"]]
        return Answer(answer=answer, sources=sources)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)