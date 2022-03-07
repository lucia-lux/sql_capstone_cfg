# create and populate SQL tables
# Source: medium article.

import numpy as np
import random
import sqlalchemy
from faker import Faker
from sqlalchemy import Table, Column, Integer, String, MetaData, Date
from sqlalchemy import insert

# set up class
class SQLData:
    def __init__(self, server, db, uid, pwd):
        self.__fake = Faker()
        self.__server = server
        self.__db = db
        self.__uid = uid
        self.__pwd = pwd
      #  self.__tables = tables
    
    def connect(self):
        self.engine = sqlalchemy.create_engine(
            f"mysql+pymysql://{self.__uid}:{self.__pwd}@{self.__server}/{self.__db}"
        )
        self.conn = self.engine.connect()
        self.meta = MetaData(bind = self.engine)
        self.meta.reflect()
        #self.tables = self.meta.sorted_tables

    def drop_all_tables(self):
        pass

    def create_tables(self):
        pass


    def populate_tables(self):
        
        # subjects
        tbl = Table("subjects",self.meta)
        for _ in range(100):
            record = dict()
            record["fname"] = self.__fake.first_name()
            record["lname"] = self.__fake.last_name()
            record["street_address"] = self.__fake.street_address()
            record["postcode"] = self.__fake.postcode()
            record["phone_number"] = self.__fake.phone_number()
            record["email_address"] = self.__fake.email()
            record["dob"] = self.__fake.date_of_birth()
        
            stmt = (
                    insert(tbl).
                    values(fname=record["fname"], lname=record["lname"],
                    street_address = record["street_address"], postcode = record["postcode"],
                    phone_number = record["phone_number"], email_address = record["email_address"],
                    dob = record["dob"])
                    )
            self.conn.execute(stmt)
        
        # screening
        tbl = Table("screening",self.meta)
        vision = ["NOR","COR","IMP"]
        handed = ["L","R"]
        med_cond = ["PHYSL", "PSYCH"]
        
        for _ in range(100):
            record = dict()
            record["subject_id"] = random.randint(1,100)
            record["height_metres"] = round(random.uniform(1.5, 2.5),1) 
            record["weight_kg"] = round(random.uniform(40.0, 160.0),2) 
            record["medical_condition"] = med_cond[random.randint(0,1)]
            record["handedness"] = handed[random.randint(0,1)]
            record["normal_vision"] = vision[random.randint(0,2)]
        
            stmt = (
                    insert(tbl).
                    values(
                        subject_id=record["subject_id"], 
                        height_metres = record["height_metres"],
                        weight_kg=record["weight_kg"],
                        medical_condition = record["medical_condition"],
                        handedness = record["handedness"],
                        normal_vision = record["normal_vision"]
                        )
                    )
            self.conn.execute(stmt)

        # researcher
        tbl = Table("researcher",self.meta)
        dept = ["NEURO", "PHARM", "PSYCH", "MEDIC"]
        for _ in range(100):
            record = dict()
            record["supervisor"] = self.__fake.last_name()
            record["department"] = dept[random.randint(0,3)] 
            stmt = (
                    insert(tbl).
                    values(
                        supervisor=record["supervisor"], 
                        department = record["department"]
                        )
                    )
            self.conn.execute(stmt)

        # experiment
        tbl = Table("experiment",self.meta)
        expt_type = ["pharm", "image", "behav", "onlne"]

        for _ in range(100):
            record = dict()
            record["screening_id"] = random.randint(1,100)
            record["researcher_id"] = random.randint(1,100)
            record["ethics_approved"] = random.randint(0,1)
            record["experiment_type"] = expt_type[random.randint(0,3)]
            record["completion_date"] = self.__fake.date()
            stmt = (
                    insert(tbl).
                    values(
                        screening_id=record["screening_id"], 
                        researcher_id = record["researcher_id"],
                        ethics_approved = record["ethics_approved"],
                        experiment_type = record["experiment_type"],
                        completion_date = record["completion_date"]
                        )
                    )
            self.conn.execute(stmt)

        # payments
        tbl = Table("payments",self.meta)

        for _ in range(100):
            record = dict()
            record["subject_id"] = random.randint(1,100)
            record["experiment_id"] = random.randint(1,100)
            record["payment_date"] = self.__fake.date()
            record["payment_amount"] = round(random.uniform(15.0, 65.0),1)
            stmt = (
                    insert(tbl).
                    values(
                        subject_id=record["subject_id"], 
                        experiment_id = record["experiment_id"],
                        payment_date = record["payment_date"],
                        payment_amount = record["payment_amount"],
                        )
                    )
            self.conn.execute(stmt)

        # payment_details
        tbl = Table("payment_details",self.meta)
        sub_ids =  random.sample(range(1, 101), 100)
        exp_ids =  random.sample(range(1, 101), 100)
        for _ in range(100):
            record = dict()
            record["subject_id"] = sub_ids[random.randint(0,99)]
            record["experiment_id"] = exp_ids[random.randint(0,99)]
            record["iban"] = self.__fake.iban()
            record["swift"] = self.__fake.swift()
            stmt = (
                    insert(tbl).
                    values(
                        subject_id=record["subject_id"], 
                        experiment_id = record["experiment_id"],
                        iban = record["iban"],
                        swift = record["swift"],
                        )
                    )
            self.conn.execute(stmt)


sd =  SQLData("localhost","research","root", "Lebkuchenfabrik2412")
sd.connect()
sd.populate_tables()

