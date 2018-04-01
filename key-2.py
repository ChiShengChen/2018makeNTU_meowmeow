
import pyautogui
screenWidth, screenHeight = pyautogui.size()
print(screenWidth,screenHeight)
#pyautogui.moveTo(screenWidth/2, screenHeight/2)
#pyautogui.moveRel(None, 50)  #鼠标向下移动10像素
#pyautogui.alert('即將向前進')
#pyautogui.rightClick(x=screenWidth/2, y=150+screenHeight/2) #I cannot control y
#print(screenWidth/2 + 1)

pyautogui.click(x=screenWidth/2, y=150+screenHeight/2, clicks=2, interval=1, button='left')





