FROM malex984/dockapp:xeyes

MAINTAINER Oleksandr Motsak <malex984@googlemail.com>

# ENV LIBGL_DEBUG=verbose
# ENV XLIB_SKIP_ARGB_VISUALS 1

# set the following if any QT GUI look like an empty rectangular window
# ENV QT_X11_NO_MITSHM 1

RUN update.sh && install.sh --no-install-recommends \
            libqt4-core libqt4-gui libx11-6 \
	    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxmu6 libxt6 libxv1 \
	    libglapi-mesa && \
    clean.sh
## xcompmgr compton 

# g3dviewer gedit
# gtk2.0-examples qt4-qtconfig
# build-essential

RUN git clone https://github.com/IMAGINARY/xfullscreen.git /usr/src/xfullscreen/
RUN ln -s /usr/src/xfullscreen/*fullscreen /usr/local/bin/

# RUN git clone https://github.com/IMAGINARY/qclosebutton.git /usr/src/qclosebutton/
# RUN cd /usr/src/qclosebutton && qmake && make && cp qclosebutton /usr/local/bin/ && make clean
COPY qclosebutton launch.sh x_64x64.png /usr/local/bin/
# NOTE: qclosebutton is a blob for now (building requires more packages... see :appchoo)



