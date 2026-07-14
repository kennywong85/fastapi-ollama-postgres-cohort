from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles


# Create the FastAPI application object.
app = FastAPI(title="Local LLM Question Log")

# Anything beginning with /static, should be served from app/static.
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# Our HTML templates live in app/templates.
templates = Jinja2Templates(directory="app/templates")

# When someone sends GET /, run the function immediately below.
@app.get("/", response_class=HTMLResponse)

# This is the function handling homepage visitors.
def index(request: Request):
    # Load index.html and return it as webpage content.
    return templates.TemplateResponse("index.html", {"request": request})
