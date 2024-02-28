from flask import Flask,render_template,request
import pickle
import numpy as np
from prometheus_client import start_http_server, Summary , Counter,Gauge,generate_latest, CONTENT_TYPE_LATEST

model = pickle.load(open('model_rf.pkl','rb'))
app = Flask(__name__)


@app.route('/healthz')
def healthz():
    return '', 200

REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
#REQUEST_COUNT = Counter('requests_total', 'Total number of requests')

REQUESTS = Counter('http_request_total','Total number of requests')
ACTIVE_USERS = Gauge('active_users', 'Number of active users')

def track_user_activity():
    ACTIVE_USERS.inc()  # Increment active users count for each interaction

@app.route('/')
def index():
    REQUESTS.inc()
    return render_template('index.html')


@app.route('/predict', methods=['GET', 'POST'])



def predict_datapoint():
    
    if request.method == 'GET':
        REQUEST_TIME.time()
        REQUESTS.inc()
        track_user_activity()
        return render_template('form.html')
    else:
        REQUESTS.inc()
        REQUEST_TIME.time()
        # Handling POST request (form submission)
        cgpa = float(request.form.get('cgpa'))
        iq = int(request.form.get('iq'))
        profile_score = int(request.form.get('profile_score'))
        track_user_activity()
       #print(cgpa,iq,profile_score)

        # Example: Making predictions using a model
        # Replace this with your actual prediction logic
        result = model.predict(np.array([cgpa, iq, profile_score]).reshape(1, 3))
        #print(result)
        if result[0]==1:
            result="placed"
        else:
            result="Unplaced"


        return render_template('result.html', result=result)
    

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}


if __name__ == '__main__':
    app.run(host='0.0.0.0',port=8080)
    start_http_server(9000)