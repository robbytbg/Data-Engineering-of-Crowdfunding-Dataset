1. Adding Data for Crowdfunding:

  - To begin, the application imports the required libraries, including Pandas.
  - It loads data into a Pandas DataFrame called df from an Excel file called "crowdfunding.xlsx."

```
df=pd.read_excel('/content/crowdfunding.xlsx')
```

2. Data division:

  - Using the '/' delimiter, the 'category & sub-category' column is divided into 'category' and'sub_category' columns.
  - Afterwards, the DataFrame's original "category & sub-category" column is removed.

```
df[['category', 'sub_category']] = df['category & sub-category'].str.split('/', expand=True)

df = df.drop(columns=['category & sub-category'])
```

3. Producing Data for Subcategories:

  - Subcategories that are distinct from one another are found and added to a DataFrame called sub_category_data.
  - Every sub-category is given a distinct identification ('sub_category_id').

```
distinct_sub_categories = df['sub_category'].unique()

sub_category_data = pd.DataFrame({'sub_category': distinct_sub_categories})
sub_category_data['sub_category_id'] = range(1, len(distinct_sub_categories) + 1)
```

4. How to Create Category Data?

  - After identifying the unique categories, a DataFrame called category_data is made up of these different categories.
  - Every category has a distinct identification ('category_id') allocated to it.

```
distinct_categories = df['category'].unique()

category_data = pd.DataFrame({'category': distinct_categories})
category_data['category_id'] = range(1, len(distinct_categories) + 1)
```

5. Formatting Dates:

  - The pd.to_datetime function is used to convert the 'launched_at' and 'deadline' columns from Unix timestamp format to a date format that can be read by humans.

```
from datetime import datetime as dt
df["launched_at"] = pd.to_datetime(df["launched_at"],unit='s').dt.strftime('%Y-%m-%d') 
df["deadline"] = pd.to_datetime(df["deadline"],unit='s').dt.strftime('%Y-%m-%d')
```

6. Contact Information Loaded:

  - Next, the application loads contact information into a DataFrame named contact from an Excel file named "contacts.xlsx."

```
contact=pd.read_excel('/content/contacts.xlsx', header=3)
```

7. Taking JSON Data Out:

  - The JSON-formatted data in the 'contact_info' column is extracted using a loop and transformed into a collection of dictionaries.

```
import json
dict_values = []

for i, row in contact.iterrows():
    contact_dict = json.loads(row['contact_info'])
    row_values = [v for k, v in contact_dict.items()]
    dict_values.append(row_values)
```

12. Making a New DataFrame for Contacts:

  - From the collected JSON data, a new DataFrame (new_contact) is generated with columns for "contact_id," "name," and "email."

```
new_contact = pd.DataFrame(dict_values, columns=['contact_id', 'name', 'email'])
```

13. dividing a name into its first and last digits:

  - The original 'name' column is dropped and split into 'first_name' and 'last_name'.

```
new_contact[['first_name', 'last_name']] = new_contact['name'].str.split(' ', 1, expand=True)

new_contact = new_contact.drop(columns=['name'])
```

