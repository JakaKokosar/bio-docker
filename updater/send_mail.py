import smtplib
import sys

try:
    s = smtplib.SMTP('212.235.188.18', 25)
    s.sendmail('jaka.kokosar@gmail.com', 'jaka.kokosar@gmail.com', sys.stdin.read())
    s.quit()
except Exception as e:
    print ("Failed to send error report due to:", e)
