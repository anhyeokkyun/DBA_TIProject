# Libraries Required
import email
from flask import Blueprint, Flask, request, render_template, flash, redirect, url_for
import numpy as np
import matplotlib.pyplot as plt 
from skimage.morphology import skeletonize
import cv2
import json
from sklearn.svm import SVC
from skimage.morphology import skeletonize
import cv2
from sklearn.svm import SVC
import joblib
import warnings
import cx_Oracle
from datetime import datetime
import smtplib                                                                      # Libraries about sending E-MAILs
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

def run():
    dash_starttime = datetime.today().strftime("%Y:%m:%d:%H:%M:%S")
    result = {
        'wrongGuessRate': 0,
        'logList': []
    }
    
    warnings.filterwarnings(action='ignore')                                        # Ignore warning alerts

    test_model = joblib.load('./test_total_model.pkl')                              # Open a machine learning model for prediction 

    # Open push data file and save onto a variable
    file_name = 'test_total_input.csv'                                              # Define CSV file name
    vectors = np.zeros((100,82))                                                    # Declare new variable for saving all data
    r = open(file_name,mode= 'r')                                                   # Open the data file
    lines = r.readlines()                                                           # Read and overwrite file data onto new variable
    lines[0]


    for data in range(0,100):

        numbers = lines[data].split(',')                                            # Save all row data separating by comma(,)
        flir_vector = []                                                            # Declare new variable for saving row data
        for i in range(0,82):
            flir_vector.append(float(numbers[i]))                                   # Join together and save the data in row

        vectors[data,:] = np.transpose(flir_vector)                                 # Save all data in the final variable


    # Push input data to the learning model
    connection = cx_Oracle.connect("testuser", "testuser", "192.168.5.12:1521/XE")  # Connent to the database
    cur = connection.cursor()

    # initialize variables on the error rates
    wrong_guess_stack= 0
    wrong_guess = 0

    # Declare new column for classifying that the data is positive or defective
    predict_result = np.zeros((100,1))

    i = 0
    goodcount = 0
    defectcount = 0
    countyield = 0
    for i in range(0,100):

        sXt = vectors[0:100,0:80]                                                   # Target data for test
        sYt = vectors[0:100,80:81]                                                  # Label data for test
        sZt = vectors[0:100,81:82]                                                  # Test data classified by left or right

        # Save date time for YYYY:mm:dd:HH:MM:SS
        prod_inptime = datetime.today().strftime("%Y:%m:%d:%H:%M:%S")
        s_result = test_model.predict(sXt)
        prod_outtime = datetime.today().strftime("%Y:%m:%d:%H:%M:%S")

        # Classify data that the data is positive or defective
        if s_result[i] == 1:
            goodcount += 1
            predict_result[i] = 1
            prod_quality = '1'    
        elif s_result[i] == 0:
            defectcount += 1
            predict_result[i] = 0
            prod_quality = '0'

        if sZt[i] == 0:
            prod_leftright = 'L'
        elif sZt[i] == 1:
            prod_leftright = 'R'

        
        # Insert into the database
        query_prod = "insert into PROD VALUES(SEQ_PROD_PRODID.NEXTVAL,:col2,:col3,:col4,:col5)"
        cur.execute(query_prod, [prod_quality, prod_inptime, prod_outtime, prod_leftright])
        connection.commit()

        # Select defectives and insert into DEFECTIVE table
        if predict_result[i] == 0 :
            query_fk_select = "select max(PROD_NO) from PROD"
            rs = cur.execute(query_fk_select)
            for record in rs:
                def_prodno = record[0]

            result['logList'].append({
                'def_prodno': def_prodno,
                'prod_inptime': prod_inptime,
                'prod_outtime': prod_outtime,
                'prod_leftright': prod_leftright
            })
            query_def="insert into DEFECTIVE VALUES(:col1,:col2,:col3,:col4)"
            cur.execute(query_def, [def_prodno, prod_inptime, prod_outtime, prod_leftright])
            connection.commit()

        wrong_guess = (np.sum(np.abs(s_result-np.transpose(sYt))))
        wrong_guess_stack = wrong_guess_stack + wrong_guess
    print(goodcount)
    print(defectcount)
    
    countyield = goodcount/(defectcount+goodcount) * 100
    yieldquery = "update DASHBOARD set YIELD=:col1 where PROCESS_NO = :col2"

    # Update new data to DASHBOARD table
    dash_endtime = datetime.today().strftime("%Y:%m:%d:%H:%M:%S")                   # Save date time for YYYY:mm:dd:HH:MM:SS
    
    query_processno_select = "select max(PROCESS_NO) from DASHBOARD"
    rs = cur.execute(query_processno_select)
    for record in rs:
        dash_processno = record[0]
    wrongguessrate = (wrong_guess_stack/100/100)*100

    query_update_process_data = "update DASHBOARD set START_TIME=:col0, END_TIME=:col1 ,ERROR_RATE=:col2 where PROCESS_NO = :col3"
  
    cur.execute(query_update_process_data, [dash_starttime, dash_endtime, wrongguessrate, dash_processno])
    cur.execute(yieldquery, [countyield,dash_processno])

    # Insert yield data into YIELD column of DASHBOARD
    connection.commit()

    print(wrong_guess)
    print(wrong_guess_stack)
    print('오류율 : ', (wrong_guess_stack/100/100)*100)
    result['wrongGuessRate'] = (wrong_guess_stack/100/100)*100
    
    connection.close()

    # Make new defectives log file to TXT
    f = open('def_log.txt', 'w')
    query = "SELECT * FROM defective"

    connection = cx_Oracle.connect("testuser", "testuser", "192.168.5.12:1521/XE")
    cur = connection.cursor()
    cur.execute(query)

    row = cur.fetchone()
    while row is not None:
        f.write(str(row))
        f.write("\n")
        row = cur.fetchone()
    print("'def_log.txt' is writed successfully.")

    f.close()
    cur.close()
    connection.close()

    # Send an E-MAIL attached log file to administrator
    connection = cx_Oracle.connect("testuser", "testuser", "192.168.5.12:1521/XE")
    cur = connection.cursor()
    query_select_email = "select email from emp"
  
    rs3 = cur.execute(query_select_email)
    for record3 in rs3:
        email_addr = str(record3[0])

    # Create session and take required data for account information
    s = smtplib.SMTP('smtp.gmail.com', 587)
    s.starttls()
    s.login(email_addr, 'xizcossqyovslmup')

    # Set the title and the content of the E-MAIL
    msg = MIMEMultipart()
    msg['Subject'] = 'Defectives Log File'
    msg.attach(MIMEText('This is a "def_log.txt" file containing defective product information.', 'plain'))

    # Attach the log file to the E-MAIL
    attachment = open('def_log.txt', 'rb')
    part = MIMEBase('application', 'octet-stream')
    part.set_payload((attachment).read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', "attachment; filename= " + 'def_log.txt')
    msg.attach(part)

    # Send the E-MAIL
    s.sendmail(email_addr, email_addr, msg.as_string())
    print("Please check your administrator E-MAIL!")
    
    s.quit()
    connection.close()
    return result

