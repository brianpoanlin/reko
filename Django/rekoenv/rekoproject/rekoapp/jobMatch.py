import numpy as np
import pandas as pd
import json
import random
import string
import pandas as pd
from pymongo import MongoClient
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn import preprocessing

def connect_mongo(host, port, username, password, db):
    if username and password:
        mongo_uri = 'mongodb://%s:%s@%s:%s/%s' % (username, password, host, port, db)
        conn = MongoClient(mongo_uri)
    else:
        conn = MongoClient(host, port)


    return conn[db]

def read_mongo(db_details, recruiter_id, user_id):
    # Connect to MongoDB
    db = connect_mongo(host = db_details['host'], port = db_details['port'], username = db_details['user'], password = db_details['pass'], db = db_details['db'])

    # Make a query to the specific DB and Collection
    collection = db[db_details['collection']]
    recruiter = collection[recruiter_id]
    impTable = recruiter['imp']

    # Expand the cursor and construct the DataFrame



def jobMatchApi(requestJson):
    db_details = {
        "host":
        "port":
        "user":
        "pass":
        "db":
    }
    collection = "users"
    student_id = requestJson['student_id']
    recruiter_id = requestJson['recruiter_id']

    impTable = read_mongo(db_details, recruiter_id, user_id)

    jobMatchProb = 0

    returnJson = {
        'student_id': student_id,
        'impTable': impTable
    }
    return returnJson
