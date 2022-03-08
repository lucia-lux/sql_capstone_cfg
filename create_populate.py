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
        self.fake = Faker("en_GB")
        self.server = server
        self.db = db
        self.uid = uid
        self.pwd = pwd
      #  self.__tables = tables
    
    def connect(self):
        self.engine = sqlalchemy.create_engine(
            f"mysql+pymysql://{self.uid}:{self.pwd}@{self.server}/{self.db}"
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
        """
        Populate existing tables with values.
        
        """
        # populate table "subjects"
        tbl = Table("subjects",self.meta)
        # create values
        for _ in range(100):
            record = dict()
            record["fname"] = self.fake.first_name()
            record["lname"] = self.fake.last_name()
            record["street_address"] = self.fake.street_address()
            record["postcode"] = self.fake.postcode()
            record["phone_number"] = self.fake.phone_number()
            record["email_address"] = self.fake.email()
            record["dob"] = self.fake.date_of_birth()
        
        # insert values into  table
            stmt = (
                    insert(tbl).values(
                        fname=record["fname"], lname=record["lname"],
                        street_address = record["street_address"], postcode = record["postcode"],
                        phone_number = record["phone_number"], email_address = record["email_address"],
                        dob = record["dob"]
                        )
                    )
            self.conn.execute(stmt)
        
        # populate table "screening"
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

        # populate table "researcher"
        tbl = Table("researcher",self.meta)
        dept = ["NEURO", "PHARM", "PSYCH", "MEDIC"]
        sup = [self.fake.last_name() for _ in range(10)]

        for _ in range(100):
            record = dict()
            record["supervisor"] = sup[random.randint(0,9)] #self.fake.last_name()
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
            record["completion_date"] = self.fake.date()
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
            record["payment_date"] = self.fake.date()
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

        for i in range(100):
            record = dict()
            record["subject_id"] = sub_ids[i]
            record["experiment_id"] = exp_ids[i]
            record["iban"] = self.fake.iban()
            record["swift"] = self.fake.swift()
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


sd =  SQLData("localhost","research","root", "pwd")
sd.connect()
sd.populate_tables()

