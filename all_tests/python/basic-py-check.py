import numpy as np
import pandas as pd

print (np.sin(1))
print (np.cos(1))

data_dict = {
    'temperatures': [4, 3, 7, 9, 11, 14, 16, 17, 12, 11, 9, 9],
    'months': ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
}

print (data_dict)
data_df = pd.DataFrame(data_dict)
print(data_df)