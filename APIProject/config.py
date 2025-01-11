import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'a_secret_key'
    SQLALCHEMY_DATABASE_URI = (
        'mssql+pyodbc://qua52616_quangminhrt:yc%407%40f6kDtAKnv5l@112.78.2.73:1433/qua52616_TDB?driver=ODBC+Driver+17+for+SQL+Server'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
