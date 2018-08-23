FROM 	armv7/armhf-ubuntu:16.04
LABEL  description="Python3, tensorflow, OpenCV"

RUN 	apt-get update && \
        # && apt-get upgrade -y \
        apt-get install -y --no-install-recommends build-essential && \
        apt-get install -y --no-install-recommends cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && \
        apt-get install -y --no-install-recommends python3 python3-pip python3-dev python3-setuptools && \
        apt-get install -y --no-install-recommends libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libatlas-base-dev && \
        cd /opt && \
		git clone https://github.com/opencv/opencv_contrib.git && \
		cd opencv_contrib && \
		git checkout 3.4.1 && \
		cd /opt && \
		git clone https://github.com/opencv/opencv.git && \
		cd opencv && \
		git checkout 3.4.1 && \
		mkdir build && \
		cd build && \
		cmake 	-D CMAKE_BUILD_TYPE=RELEASE \
			-D BUILD_NEW_PYTHON_SUPPORT=ON \
			-D CMAKE_INSTALL_PREFIX=/usr/local \
			-D INSTALL_C_EXAMPLES=OFF \
			-D INSTALL_PYTHON_EXAMPLES=OFF \
			-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
			-D PYTHON_EXECUTABLE=/usr/bin/python3.5 \
			-D BUILD_EXAMPLES=OFF /opt/opencv && \
		make -j $(nproc) && \
		make install && \
		ldconfig

RUN pip3 install --upgrade --no-cache-dir pip
RUN pip3 install --no-cache-dir numpy flask && \
    pip3 install --no-cache-dir https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.9.0/tensorflow-1.9.0-cp35-none-linux_armv7l.whl && \
    apt-get purge -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    rm -rf /opt/opencv*

# RUN  	pip install face_recognition boto3 tzlocal imutils

# Define the working directory
WORKDIR   /app

CMD ["/bin/bash"]