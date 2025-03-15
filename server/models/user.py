from sqlalchemy import TEXT, Column, String
from models.base import Base


class User(Base):
    __tablename__ = 'users'
    
    id = Column(TEXT, primary_key=True)
    name = Column(String(100))
    email = Column(String(100), unique=True)
    password = Column(String(255))