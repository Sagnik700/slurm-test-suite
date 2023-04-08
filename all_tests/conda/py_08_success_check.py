a = [1,2,3,4,5,6,7,8,9,0,11,12,13,14,15]
# error should be thrown
if (n := len(a)) > 10:
    print(f"List is too long ({n} elements, expected <= 10)")