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
    data = pd.DataFrame(list(collection.find({'user': recruiter_id})))
    studentData = list(collection.find({'user': student_id}))

    testData = []

    testData.append(studentData[0]['we'])
    testData.append(studentData[0]['ed'])
    testData.append(studentData[0]['sk'])
    testData.append(studentData[0]['aw'])
    testData.append(studentData[0]['vl'])
    testData.append(studentData[0]['cw'])
    testData.append(studentData[0]['ot'])

    trainData = []
    imp = data['imp']
    for x in imp:
        for y in x:
            trainData.append(y['ratings'])
    trainData = pd.DataFrame(trainData, columns = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot', 'result'])
    testData = pd.DataFrame([testData], columns = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot'])

    print(trainData)
    print(testData)

    conn.close()

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
    print (requestJson)
    student_id = requestJson['student_id']
    recruiter_id = requestJson['recruiter_id']

    print (student_id)
    print (recruiter_id)

    trainData, testData = read_mongo(connection, collection, recruiter_id, student_id)

    X_cols = ['we', 'ed', 'sk', 'aw', 'vl', 'cw', 'ot']

    X_train = trainData[X_cols]
    y_train = trainData['result']

    X_predict = testData[X_cols]
    jobMatchProb, accuracy = jobPredict(X_train, y_train, X_predict)

    we_a = X_train['we'].mean()
    ed_a = X_train['ed'].mean()
    sk_a = X_train['sk'].mean()
    aw_a = X_train['aw'].mean()
    vl_a = X_train['vl'].mean()
    cw_a = X_train['cw'].mean()
    ot_a = X_train['ot'].mean()

    returnJson = {
        'student_id': student_id,
        'student_stats': {
            'we':{
                's': X_predict['we'][0],
                'a': we_a
            },
            'ed':{
                's':X_predict['ed'][0],
                'a': ed_a
            },
            'sk':{
                's': X_predict['sk'][0],
                'a': sk_a
            },
            'aw':{
                's': X_predict['aw'][0],
                'a': aw_a
            },
            'vl':{
                's': X_predict['vl'][0],
                'a': vl_a
            },
            'cw':{
                's': X_predict['cw'][0],
                'a': cw_a
            },
            'ot':{
                's': X_predict['ot'][0],
                'a': ot_a
            },
            'jobMatchProb': jobMatchProb[0] * 100,
        },
        'accuracy': accuracy * 100
    }

    return returnJson
