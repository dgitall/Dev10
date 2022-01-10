FoodsList = list()
with open('D:\\Documents\\Work\\Dev10\\Files\\M06\\FoodsData\\foods.txt', encoding='utf-8') as text_file:
    FoodsList = text_file.read().split('\n')

HighFiberList = list()
with open('D:\\Documents\\Work\\Dev10\\Files\\M06\\FoodsData\\highfiber.txt', encoding='utf-8') as text_file:
    HighFiberList = text_file.read().split('\n')
    
LowFatList = list()
with open('D:\\Documents\\Work\\Dev10\\Files\\M06\\FoodsData\\lowfat.txt', encoding='utf-8') as text_file:
    LowFatList = text_file.read().split('\n')
    
LowGlycList = list()
with open('D:\\Documents\\Work\\Dev10\\Files\\M06\\FoodsData\\low-glycemic-index.txt', encoding='utf-8') as text_file:
    LowGlycList = text_file.read().split('\n')
    

FoodsDict = dict(iterable=FoodsList)

print(FoodsDict)
