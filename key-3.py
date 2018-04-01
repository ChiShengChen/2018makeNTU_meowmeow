#turn left
import pyautogui
import time

screenWidth, screenHeight = pyautogui.size()
print(screenWidth,screenHeight)

pyautogui.click(x=screenWidth/2, y=150+screenHeight/2, clicks=2, interval=1, button='left')
pyautogui.moveTo(screenWidth, screenHeight)
time.sleep(1)
pyautogui.dragTo(screenWidth/2-400, screenHeight/2, button='left')
