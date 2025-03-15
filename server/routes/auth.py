from uuid import uuid4
import bcrypt
from fastapi import Depends, HTTPException
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from database import get_db
from pydantic_schemas.user_login import UserLogin
import jwt

router = APIRouter()

@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400, 'User with the same email already exists')

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    new_user = User(id=str(uuid4()), name=user.name, email=user.email, password=hashed_pw)

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {  
    "id": new_user.id,   
    "name": new_user.name,
    "email": new_user.email
}

@router.post("/login")
def login_user(user: UserLogin, db=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, 'User not found')

    if not bcrypt.checkpw(user.password.encode('utf-8'), bytes(user_db.password)):
        raise HTTPException(status_code=400, detail="Invalid email or password")


    token = jwt.encode({"id": user_db.id}, 'password_key')
    return {'token': token, 'user': {
        "email": user_db.email,
        "id": user_db.id,
        "name": user_db.name,
        }}

