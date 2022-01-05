
import math 
from functools import reduce

def to_fahrenheit(c
                              import param):
    d = c*param
    return (d * 9/5) + 32

hk_10day_forecast = [24,26,27,27,27,28,28,29,29,29]
print(list(map(lambda c: to_fahrenheit(c, 1), hk_10day_forecast)))
print(list(map(lambda c: (c * 9/5) + 32, hk_10day_forecast)))
print(list(map(lambda c: to_fahrenheit(c, 2), hk_10day_forecast)))
print(list(map(lambda c: to_fahrenheit(c, 3), hk_10day_forecast)))


sum = reduce(lambda t1, t2: t1 + t2, hk_10day_forecast)
min = reduce(lambda t1, t2: t1 if t1 < t2 else t2, hk_10day_forecast)
avg = sum/len(hk_10day_forecast)
print(f"sum = {sum} avg = {avg} min = {min}")

## Calculate the standard deviation of the collection of numbers
numbers = range(1,11)
mean = sum(numbers)/len(numbers)
meandiff = map(lambda x: x - mean, numbers)
sqmeandiff = map(lambda x: pow(x, 2), meandiff)
sumsqrs = reduce(lambda x1, x2: x1+x2, sqmeandiff)
sumsqrs2 = sum(sqmeandiff)
stdev = sqrt(sumsqrs/(len(numbers)-1))
