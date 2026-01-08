from fastapi import FastAPI, Request, HTTPException, UploadFile, File, Form
from fastapi.responses import RedirectResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel
from typing import Optional, List
import os
import json
import uuid
from datetime import datetime
import google.generativeai as genai
import uvicorn # Added for direct execution
import mysql.connector

# Configure Gemini
genai.configure(api_key="AIzaSyBrOLwx1OYNX0UJ5qMxjYIWND-rM1Jn49I")
# Use gemini-flash-latest (Stable & Fast)
model = genai.GenerativeModel('gemini-flash-latest')

app = FastAPI(title="MedFlow API")

# Setup Static and Templates
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FRONTEND_DIR = os.path.join(os.path.dirname(ROOT_DIR), "frontend")

print(f"DEBUG: ROOT_DIR is {ROOT_DIR}")
print(f"DEBUG: FRONTEND_DIR is {FRONTEND_DIR}")

app.mount("/static", StaticFiles(directory=os.path.join(FRONTEND_DIR, "static")), name="static")
templates = Jinja2Templates(directory=os.path.join(FRONTEND_DIR, "templates"))

# --- Database Connection ---
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="medflow_llm"
    )

def init_db():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                full_name VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                role VARCHAR(50) NOT NULL
            )
        """)
        conn.commit()
        cursor.close()
        conn.close()
        print("Database initialized successfully.")
    except Exception as e:
        print(f"Database initialization failed: {e}")

# Initialize DB on startup
init_db()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ... (Previous Helper Functions & Models - Unchanged) ...

# --- Data Persistence Helper ---
def get_data(filename):
    file_path = os.path.join(ROOT_DIR, filename)
    # print(f"DEBUG: Loading data from {file_path}")
    if not os.path.exists(file_path):
        print(f"DEBUG: File not found: {file_path}")
        return []
    try:
        with open(file_path, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"ERROR: Failed to load {filename}: {e}")
        return []

def save_data(filename, data):
    file_path = os.path.join(ROOT_DIR, filename)
    with open(file_path, "w") as f:
        json.dump(data, f, indent=4)

def append_data(filename, item):
    data = get_data(filename)
    data.append(item)
    save_data(filename, data)

# --- Pydantic Models ---
class UserRegistration(BaseModel):
    full_name: str
    email: str
    phone: str
    password: str
    role: str
    confirm_password: Optional[str] = None

class UserLogin(BaseModel):
    email: str
    password: str

class Appointment(BaseModel):
    doctor_id: str
    patient_id: str
    date: str
    time: str
    reason: str

class ChatMessage(BaseModel):
    sender_id: str
    receiver_id: str
    message: str
    timestamp: Optional[str] = None

class ProfileSetup(BaseModel):
    email: str
    dob: str
    gender: str
    blood_type: str
    allergies: List[str]
    conditions: List[str]

# --- Page Routes ---

@app.get("/")
async def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.get("/onboarding")
async def onboarding_page(request: Request):
    return templates.TemplateResponse("onboarding.html", {"request": request})

@app.get("/feature/symptom-checker")
async def symptom_checker_feature(request: Request):
    return templates.TemplateResponse("symptom_checker.html", {"request": request})

@app.get("/feature/prescription")
async def prescription_feature(request: Request):
    return templates.TemplateResponse("prescription_summary.html", {"request": request})

@app.get("/feature/lab-reports")
async def lab_reports_feature(request: Request):
    return templates.TemplateResponse("lab_reports.html", {"request": request})

@app.get("/feature/ai-chat")
async def ai_chat_feature(request: Request):
    return templates.TemplateResponse("ai_assistant.html", {"request": request})

@app.get("/feature/book-visit")
async def book_visit_feature(request: Request):
    return templates.TemplateResponse("book_appointment.html", {"request": request})

@app.get("/role-selection")
async def role_selection(request: Request):
    return templates.TemplateResponse("role_selection.html", {"request": request})

@app.post("/login_submit")
async def login_submit(request: Request):
    # Mock login - specific logic can be added here
    return RedirectResponse(url="/patient/dashboard", status_code=303)

@app.get("/login")
async def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@app.get("/signup")
async def signup_page(request: Request):
    return templates.TemplateResponse("signup.html", {"request": request})

@app.get("/reset-password")
async def reset_password_page(request: Request):
    return templates.TemplateResponse("reset_password.html", {"request": request})

@app.get("/doctor/signup")
async def doctor_signup(request: Request):
    return templates.TemplateResponse("doctor_signup.html", {"request": request})

# Patient Flows
@app.get("/patient/dashboard")
async def patient_dashboard(request: Request):
    return templates.TemplateResponse("patient_dashboard.html", {"request": request})

@app.get("/patient/symptoms")
async def symptom_checker(request: Request):
    return templates.TemplateResponse("symptoms.html", {"request": request})

@app.get("/patient/profile-setup")
async def profile_setup(request: Request):
    return templates.TemplateResponse("profile_setup.html", {"request": request})

@app.get("/patient/emergency-contact")
async def emergency_contact(request: Request):
    return templates.TemplateResponse("emergency_contact.html", {"request": request})

@app.get("/patient/health-summary")
async def health_summary(request: Request):
    return templates.TemplateResponse("health_summary.html", {"request": request})


@app.get("/profile")
async def profile_page(request: Request):
    return templates.TemplateResponse("profile_setup.html", {"request": request})

@app.get("/dashboard/notifications")
async def notifications(request: Request):
    return templates.TemplateResponse("notifications.html", {"request": request})

# Shared/Feature Flows
@app.get("/appointments")
async def appointments_page(request: Request):
    return templates.TemplateResponse("appointments.html", {"request": request})

@app.get("/consultation")
async def consultation_page(request: Request):
    return templates.TemplateResponse("consultation.html", {"request": request})

@app.get("/reports")
async def reports_page(request: Request):
    return templates.TemplateResponse("reports.html", {"request": request})

@app.get("/prescriptions")
async def prescriptions_page(request: Request):
    return templates.TemplateResponse("prescription_flow.html", {"request": request})

@app.get("/notes")
async def notes_page(request: Request):
    return templates.TemplateResponse("handwritten_notes.html", {"request": request})

@app.get("/scans")
async def scans_page(request: Request):
    return templates.TemplateResponse("scan_analysis.html", {"request": request})

@app.get("/ai-assistant")
async def ai_assistant_page(request: Request):
    return templates.TemplateResponse("ai_assistant.html", {"request": request})

@app.get("/emergency-help")
async def emergency_help_page(request: Request):
    return templates.TemplateResponse("emergency_help.html", {"request": request})

# Doctor Flows
@app.get("/doctor/dashboard")
async def doctor_dashboard(request: Request):
    # Load Data
    appointments = get_data("appointments.json")
    users = get_data("users.json")
    
    # Calculate Stats
    today_count = len(appointments)
    patient_count = len([u for u in users if u.get('role') == 'patient'])
    pending_count = len([a for a in appointments if a.get('status') == 'Pending'])
    
    return templates.TemplateResponse("dashboard_doctor.html", {
        "request": request,
        "today_count": today_count,
        "patient_count": patient_count,
        "pending_count": pending_count,
        "appointments": appointments,
        "user": {"full_name": "Dr. Smith"} # Mock for now or pull from session if implemented
    })

@app.get("/doctor/presentation")
async def doctor_presentation(request: Request):
    return templates.TemplateResponse("presentation_components.html", {"request": request})


@app.get("/doctor/appointments")
async def doctor_appointments(request: Request):
    appointments = get_data("appointments.json")
    return templates.TemplateResponse("doctor_appointments.html", {
        "request": request, 
        "appointments": appointments
    })

@app.get("/doctor/patients")
async def doctor_patients(request: Request):
    patients = get_data("patient_records.json")
    return templates.TemplateResponse("doctor_patients.html", {
        "request": request,
        "patients": patients
    })

@app.get("/doctor/patient/{patient_id}")
async def doctor_patient_detail(request: Request, patient_id: str):
    patients = get_data("patient_records.json")
    patient = next((p for p in patients if p['id'] == patient_id), None)
    if not patient:
        # Fallback or 404
        return RedirectResponse(url="/doctor/patients")
    return templates.TemplateResponse("doctor_patient_detail.html", {
        "request": request,
        "patient": patient
    })

@app.get("/doctor/add-patient")
async def doctor_add_patient(request: Request):
    return templates.TemplateResponse("doctor_add_patient.html", {"request": request})

@app.get("/doctor/add-patient/step2")
async def doctor_add_patient_step2(request: Request):
    return templates.TemplateResponse("doctor_add_patient_step2.html", {"request": request})

@app.get("/doctor/profile")
async def doctor_profile(request: Request):
    # In a real app we would get user from session
    return templates.TemplateResponse("doctor_profile.html", {
        "request": request,
        "user": {"full_name": "Dr. John Smith", "title": "Cardiologist", "license": "MD-8839201"}
    })

# Settings
@app.get("/settings")
async def settings_page(request: Request):
    return templates.TemplateResponse("settings.html", {"request": request}) # Profile settings

@app.get("/settings/app")
async def app_settings_page(request: Request):
    return templates.TemplateResponse("app_settings.html", {"request": request})

@app.get("/settings/privacy")
async def privacy_page(request: Request):
    return templates.TemplateResponse("privacy_security.html", {"request": request})

@app.get("/settings/help")
async def help_page(request: Request):
    return templates.TemplateResponse("help_support.html", {"request": request})

# --- API Endpoints ---

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "service": "medflow-vercel", "version": "3.1.0 (Full-Feature)"}

@app.post("/api/register")
async def register(user: UserRegistration):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if user exists
        cursor.execute("SELECT * FROM users WHERE email = %s", (user.email,))
        if cursor.fetchone():
            cursor.close()
            conn.close()
            raise HTTPException(status_code=400, detail="Email already registered")
            
        # Insert user
        query = "INSERT INTO users (full_name, email, password, role) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (user.full_name, user.email, user.password, user.role))
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return {"message": "Registration successful", "redirect": "/login"}
    except Exception as e:
        print(f"Registration Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/login")
async def login(user: UserLogin):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query = "SELECT * FROM users WHERE email = %s AND password = %s"
        cursor.execute(query, (user.email, user.password))
        valid_user = cursor.fetchone()
        cursor.close()
        conn.close()

        if not valid_user:
            print(f"Login failed for: {user.email}")
            raise HTTPException(status_code=401, detail="Invalid credentials")
        
        print(f"LOGIN SUCCESS: User {valid_user['full_name']} has role {valid_user['role']}")
        
        redirect_url = "/doctor/dashboard" if valid_user['role'] == 'doctor' else "/patient/dashboard"
        
        return {
            "message": "Login successful",
            "redirect": redirect_url,
            "user": valid_user
        }
    except Exception as e:
        print(f"Login Error: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")

@app.post("/api/profile-setup")
async def api_profile_setup(profile: ProfileSetup):
    users = get_data("users.json")
    updated = False
    for user in users:
        if user.get("email") == profile.email:
            user.update(profile.model_dump())
            updated = True
            break
    
    if updated:
        save_data("users.json", users)
        return {"message": "Profile updated successfully", "redirect": "/patient/dashboard"}
    raise HTTPException(status_code=404, detail="User not found")

@app.get("/api/appointments")
async def get_appointments():
    return get_data("appointments.json")

@app.post("/api/appointments")
async def create_appointment(appt: Appointment):
    appt_dict = appt.model_dump()
    appt_dict["id"] = str(uuid.uuid4())
    appt_dict["status"] = "upcoming"
    append_data("appointments.json", appt_dict)
    return {"message": "Appointment booked successfully"}

@app.get("/api/messages")
async def get_messages(sender: str, receiver: str):
    messages = get_data("messages.json")
    # Filter chat between these two users
    chat = [m for m in messages if (m["sender_id"] == sender and m["receiver_id"] == receiver) or (m["sender_id"] == receiver and m["receiver_id"] == sender)]
    return chat

@app.post("/api/messages")
async def send_message(msg: ChatMessage):
    msg_dict = msg.model_dump()
    msg_dict["timestamp"] = str(datetime.now())
    append_data("messages.json", msg_dict)
    return {"message": "Message sent"}

@app.get("/api/notifications")
async def get_notifications():
    # Return dummy notifications for now, or read from notifications.json
    return [
        {"id": 1, "title": "New Lab Results", "message": "Your blood test results are ready.", "time": "5 min ago", "read": False},
        {"id": 2, "title": "Upcoming Appointment", "message": "Dr. Smith tomorrow at 10:00 AM.", "time": "1 hour ago", "read": False}
    ]

# --- Real AI Endpoints (Gemini) ---

@app.post("/api/symptom_checker")
async def symptom_checker_api(request: Request):
    data = await request.json()
    symptoms = data.get("symptoms", "")
    
    prompt = f"""
    Act as a medical AI assistant. Analyze these symptoms:
    {symptoms}
    
    Return a raw JSON object (no markdown, no code blocks) with this EXACT structure:
    {{
        "conditions": [
            {{"name": "Condition Name", "probability": "High/Medium/Low", "description": "Brief explanation"}}
        ],
        "risk_assessment": {{
            "level": "Low/Moderate/High/Critical",
            "summary": "Why this risk level was assigned",
            "color": "green/yellow/orange/red"
        }},
        "actions": [
            {{"step": "Action step (e.g., Rest, Drink Water)", "type": "Home/Doctor/Emergency"}}
        ]
    }}
    Disclaimer: This is AI advice, not a doctor's diagnosis.
    """
    
    try:
        response = model.generate_content(prompt)
        return {"reply": response.text}
    except Exception as e:
        return {"reply": f"Error: {str(e)}"}

@app.post("/api/analyze_image")
async def analyze_image(file: UploadFile = File(...), type: str = Form(...)):
    try:
        print(f"DEBUG: Received upload request. Type: {type}")
        print(f"DEBUG: File contents: {file.filename} - {file.content_type}")
        content = await file.read()
        print(f"DEBUG: File read successfully. Size: {len(content)}")
        
        # Determine prompt based on type
        if type == "prescription":
            prompt = """Analyze this prescription image. Return a raw JSON object (no markdown formatting, no code blocks) with the following structure:
            {
                "medications": [
                    {
                        "name": "Medication Name",
                        "dosage": "e.g. 500mg",
                        "frequency": "e.g. Twice daily",
                        "duration": "e.g. 10 days",
                        "notes": "Take after food"
                    }
                ],
                "summary": "Brief summary of the prescription"
            }
            """
        elif type == "lab_report":
            prompt = """Analyze this medical lab report. Return a raw JSON object (no markdown, no code blocks) with this structure:
            {
                "summary": "Brief health summary based on report",
                "vital_stats": {
                    "normal_count": 0,
                    "attention_count": 0
                },
                "metrics": [
                    {
                        "name": "Test Name (e.g. Hemoglobin)",
                        "value": "Value (e.g. 14.5)",
                        "unit": "Unit (e.g. g/dL)",
                        "range": "Ref Range",
                        "status": "normal/warning/critical"
                    }
                ],
                "insights": [
                    "Key AI insight 1 about the results",
                    "Key AI insight 2"
                ],
                "specialist_recommendation": "Type of doctor to see (e.g. Endocrinologist, Cardiologist)"
            }
            """
        elif type == "handwritten_note":
            prompt = "Transcribe this handwritten medical note or doctor's prescription accurately. Maintain the structure and clarify any medical terms."
        else:
            prompt = "Analyze this medical image."

        image_part = {"mime_type": file.content_type, "data": content}
        
        response = model.generate_content([prompt, image_part])
        return {"reply": response.text}
            
    except Exception as e:
        return {"reply": f"Error analyzing image: {str(e)}"}

# --- AI/LLM Integration ---

# Config: Replace this with your Colab/ngrok public URL
# Example: "https://purple-dog-22.loca.lt/generate"
COLAB_LLM_URL = "" 

import httpx

class SimpleMessage(BaseModel):
    message: str

async def get_ai_response(user_message: str):
    # 1. Try Colab LLM if URL is set
    if COLAB_LLM_URL:
        try:
            async with httpx.AsyncClient() as client:
                # Assuming your Colab model expects {"text": "..."} and returns {"response": "..."}
                # Adjust these keys based on your actual Colab code!
                resp = await client.post(COLAB_LLM_URL, json={"text": user_message}, timeout=10.0)
                if resp.status_code == 200:
                    data = resp.json()
                    # Best effort to find the response key
                    return data.get("response") or data.get("generated_text") or data.get("reply") or str(data)
        except Exception as e:
            print(f"Colab Connection Failed: {e}")
            # Fallback to simulation if connection fails
            pass

    # 2. Fallback: Simulated "Keyword" AI
    msg = user_message.lower()
    
    if "hello" in msg or "hi" in msg:
        return "Hello! I am MedFlow AI. How can I assist you with your health today?"
    
    if "fever" in msg or "temp" in msg:
        return "If you have a fever, please stay hydrated and rest. If it exceeds 102°F (39°C), consult a doctor via the 'Book Appointment' feature."
    
    if "pain" in msg or "headache" in msg:
        return "I'm sorry to hear you're in pain. For mild pain, over-the-counter pain relievers might help. If it persists, please use the Symptom Checker."
    
    if "appointment" in msg or "book" in msg:
        return "You can book an appointment with our specialists by tapping the 'Book Appointment' card on your dashboard."
        
    return "I'm currently in 'Offline Demo Mode'. To get real medical advice, please connect your Colab LLM or consult a doctor."

@app.post("/api/chat_assistant")
async def chat_assistant(request: Request):
    data = await request.json()
    user_message = data.get("message", "")
    
    try:
        response = model.generate_content(f"You are a helpful medical assistant for the MedFlow app. Answer briefly and kindly. User asks: {user_message}")
        return {"reply": response.text}
    except Exception as e:
        return {"reply": f"Error: {str(e)}"}

if __name__ == "__main__":
    import sys
    # Ensure the root directory is in sys.path so 'backend' module is found
    sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
    uvicorn.run("backend.api.index:app", host="0.0.0.0", port=8000, reload=True)
