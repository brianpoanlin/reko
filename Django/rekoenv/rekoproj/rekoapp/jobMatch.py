import json
import django


def jobMatch(requestJson):
    cardType = requestJson['type']
    title = requestJson['title']
    company = requestJson['Company']
    fromDate = requestJson['From']
    toDate = requestJson['To']
    desc = requestJson['Desc']

    returnJson = {
        'cardType': cardType,
        'title': title,
        'company': company,
        'fromDate': fromDate,
        'toDate': toDate,
        'desc': desc
    }

    return returnJson
