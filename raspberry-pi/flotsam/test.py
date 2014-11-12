import driver
import time

print("initing")
driver.init()

while 1:
    print(driver.read_all())
    time.sleep(0.2)
