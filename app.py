import human_detector
import numpy as np
import cv2
from flask import Flask, request, jsonify
import time

# model_path = './faster_rcnn_inception_v2_coco_2018_01_28/frozen_inference_graph.pb'
# this one works very fast
# model_path = './ssd_mobilenet_v1_coco_2017_11_17/frozen_inference_graph.pb'
# model_path = './ssd_mobilenet_v2_coco_2018_03_29/frozen_inference_graph.pb'
model_path = './ssdlite_mobilenet_v2_coco_2018_05_09/frozen_inference_graph.pb'
# model_path = './ssd_mobilenet_v1_coco_2018_01_28/frozen_inference_graph.pb'
odapi = human_detector.DetectorAPI(path_to_ckpt=model_path)

#===============================================================================
# REST API SECTION
#===============================================================================
app = Flask(__name__)

@app.route('/', methods=['POST'])
def index():
    """Detect if there any object in the picture"""
    # convert string of image data to uint8
    nparr = np.fromstring(request.data, np.uint8)
    # decode image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    img = cv2.resize(img, (1024, 768))
    
    if odapi.detect_human(img):
        timestr = time.strftime("%Y%m%d-%H%M%S")
        cv2.imwrite('./pics/' + timestr + '.jpg',img)
        resp = jsonify("human detected")
    else:
        # No human detected!
        timestr = time.strftime("%Y%m%d-%H%M%S")
        cv2.imwrite('./pics/' + timestr + '.jpg',img)
        resp = jsonify("not found")
        resp.status_code = 404
    return resp  

if __name__ == '__main__':
    """Run this as an REST API"""
    app.run(host="0.0.0.0", port=9000, debug=False)