

```
import pandas as pd
import numpy as np
from sklearn.utils import resample
```


```
filename = "transaction_small.csv"
data = pd.read_csv(filename)
```


```
data[:5]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>recipient_unique_id</th>
      <th>transaction_id</th>
      <th>action_date</th>
      <th>last_modified_date</th>
      <th>fiscal_year</th>
      <th>award_id</th>
      <th>generated_pragmatic_obligation</th>
      <th>total_obligation</th>
      <th>total_subsidy_cost</th>
      <th>total_loan_value</th>
      <th>...</th>
      <th>parent_recipient_unique_id</th>
      <th>awarding_toptier_agency_name</th>
      <th>funding_toptier_agency_name</th>
      <th>awarding_subtier_agency_name</th>
      <th>funding_subtier_agency_name</th>
      <th>awarding_toptier_agency_abbreviation</th>
      <th>funding_toptier_agency_abbreviation</th>
      <th>awarding_subtier_agency_abbreviation</th>
      <th>funding_subtier_agency_abbreviation</th>
      <th>business_categories</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.0</td>
      <td>90730483</td>
      <td>2008-11-25</td>
      <td>2008-11-25</td>
      <td>2009</td>
      <td>39313257</td>
      <td>71679.00</td>
      <td>217187.00</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>Corporation for National and Community Service</td>
      <td>NaN</td>
      <td>Corporation for National and Community Service</td>
      <td>NaN</td>
      <td>CNCS</td>
      <td>NaN</td>
      <td>CNCS</td>
      <td>NaN</td>
      <td>local_government government</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.0</td>
      <td>92090107</td>
      <td>2005-09-30</td>
      <td>2005-09-30</td>
      <td>2005</td>
      <td>44040803</td>
      <td>100000.00</td>
      <td>400000.00</td>
      <td>0.0</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>African Development Foundation</td>
      <td>NaN</td>
      <td>African Development Foundation</td>
      <td>NaN</td>
      <td>USADF</td>
      <td>NaN</td>
      <td>USADF</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0</td>
      <td>7689713</td>
      <td>2005-09-10</td>
      <td>2005-10-03</td>
      <td>2005</td>
      <td>28003455</td>
      <td>67030.48</td>
      <td>67030.48</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>0.0</td>
      <td>Department of State</td>
      <td>Department of State</td>
      <td>Department of State</td>
      <td>Department of State</td>
      <td>DOS</td>
      <td>DOS</td>
      <td>DOS</td>
      <td>DOS</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0</td>
      <td>40165724</td>
      <td>2005-07-08</td>
      <td>2010-09-17</td>
      <td>2005</td>
      <td>13475781</td>
      <td>-2000.00</td>
      <td>28000.00</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>0.0</td>
      <td>Department of Commerce</td>
      <td>NaN</td>
      <td>National Oceanic and Atmospheric Administration</td>
      <td>NaN</td>
      <td>DOC</td>
      <td>NaN</td>
      <td>NOAA</td>
      <td>NaN</td>
      <td>other_than_small_business category_business</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.0</td>
      <td>40493005</td>
      <td>2005-02-23</td>
      <td>2013-11-29</td>
      <td>2005</td>
      <td>32138444</td>
      <td>442.88</td>
      <td>608.30</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>0.0</td>
      <td>Department of the Treasury</td>
      <td>Department of Homeland Security</td>
      <td>Bureau of the Fiscal Service</td>
      <td>Office of the Inspector General</td>
      <td>TREAS</td>
      <td>DHS</td>
      <td>NaN</td>
      <td>IG</td>
      <td>other_than_small_business category_business</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 61 columns</p>
</div>




```
def Get1stDig(k):
    return int(str(k)[0])
```


```
mu = np.mean([a for a in data['total_obligation']])
mu
```




    203932.87535353535




```
l = [a for a in data['total_obligation']]
v = [Get1stDig(a) for a in data['total_obligation']]
```


```
v[1:5]
```




    [4, 6, 2, 6]




```
table = pd.Series(v)
table.value_counts()
```




    1    24
    2    19
    4    13
    5     9
    0     9
    3     7
    7     6
    8     5
    6     5
    9     2
    dtype: int64




```
### bootstrap
### "resample" is from sktlearn package, you can consider "np.random.choice" in your case
def onerun(sample):
    mu_star = np.mean(resample(sample,replace = True, n_samples = len(sample)))
    return mu_star
```


```
### set up
B = 100
res = [0]*B
### resample
for i in range(B):
    res[i] = onerun(l)
```


```
### get a 2alpha level confidence interval
alpha = 0.025
np.quantile(res,[alpha,1-alpha])
```




    array([127656.977    , 348513.2652197])




```
np.random.choice(l,size = 3,replace= True)
```




    array([116748., 243024.,  75600.])




```

```
