# Python Send Email

This is a repost I wrote in 2013

The simple python script below will capture 10 images from a webcam (at a rate of 1 image per second) and then email those images to the specified email address. The script has been tested with Google Gmail. 

Requirements:

* Python 2.7.x
* [VideoCapture](http://videocapture.sourceforge.net/)

```
import os
import smtplib
import datetime
from VideoCapture import Device
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage

toaddr = 'you@gmail.com'
fromaddr = toaddr
subject = 'Intruder Alert'
smtpserver = 'smtp.gmail.com:587'
username = 'yourusername'
password = 'yourpassword'
framedir = 'img'
camid = 1 # which webcam to use (if you only have one webcam, set this to 0)

if not os.path.exists(framedir):
    os.mkdir(framedir)

frames = []
for i in range(10):
    dt = datetime.datetime.now()
    cam = Device(camid)
    #cam.setResolution(1280, 720)
    fname = '{0}/{1}.jpg'.format(framedir, dt.strftime('%Y.%m.%d.%H.%M.%S'))
    cam.saveSnapshot(fname, timestamp=1, boldfont=1, textpos='bl')
    frames.append(fname)
    while datetime.datetime.now() == dt:
        pass

mroot = MIMEMultipart('related')
mroot['Subject'] = subject
mroot['From'] = fromaddr
mroot['To'] = toaddr

for frame_num,frame in enumerate(frames):
    with open(frame, 'rb') as fp:
        mimage = MIMEImage(fp.read())
        mimage.add_header('Content-Disposition', 'attachment; filename="{0}"'.format(frame))
        mroot.attach(mimage)

smtp = smtplib.SMTP()
smtp.connect(smtpserver)
smtp.starttls()
smtp.login(username, password)
smtp.sendmail(fromaddr, toaddr, mroot.as_string())
smtp.quit()
```
