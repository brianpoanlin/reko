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

def read_mongo(connection, collection, recruiter_id, student_id):
    # Connect to MongoDB
    conn = MongoClient(connection)

    db = conn['reko']

    # Make a query to the specific DB and Collection
    collection = db.users

    # Expand the cursor and construct the DataFrame
    data = pd.DataFrame(list(collection.find({'user': 'brian'})))

    ratingsList = []
    testData = []
    trainData = []
    imp = data['imp']
    for x in imp:
        for y in x:
            print (y)
            if (y['ratings']['result'] == -1 and y['user'] == student_id):
                testData.append(y['ratings'])
            else:
                trainData.append(y['ratings'])
    trainData = pd.DataFrame(trainData, columns = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot', 'result'])
    testData = pd.DataFrame(testData, columns = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot', 'result'])

    return trainData, testData

def jobPredict(X_train, y_train, X_predict):
    model = LogisticRegression()
    # model = RandomForestClassifier(n_estimators = 1000)

    X_tr, X_te, y_tr, y_te = train_test_split(X_train, y_train, test_size=0.2, random_state=42)

    model.fit(X_tr, y_tr)

    prediction_prob = model.predict_proba(X_predict)

    X_te = X_te.dropna()
    accuracy = model.score(X_te, y_te)

    return prediction_prob[:,1], accuracy

def jobMatchApi(requestJson):
    connection = 'mongodb+srv://poppro:reko123@reko-no8a0.gcp.mongodb.net/'
    collection = 'users'
    student_id = requestJson['student_id']
    recruiter_id = requestJson['recruiter_id']

    trainData, testData = read_mongo(connection, collection, recruiter_id, student_id)

    X_cols = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot']

    X_train = trainData[X_cols]
    y_train = trainData['result']

    X_predict = testData[X_cols]
    jobMatchProb, accuracy = jobPredict(X_train, y_train, X_predict)

    returnJson = {
        'student_id': student_id,
        'jobMatchProb': jobMatchProb * 100,
        'accuracy': accuracy * 100
    }

    return returnJson
