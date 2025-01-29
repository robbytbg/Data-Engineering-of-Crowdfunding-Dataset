# DB Side

1. **Select a Database:** 
  - I've made sure to choose the database from which I wish to import the information. Using the "Navigator" panel, I completed this.

2. Utilizing the Quick Database Diagram, **Open SQL Script from** 
  - I utilized the `CREATE TABLE} commands and foreign key relationships included in the SQL script that Quick Database Diagram created.

![alt text](https://github.com/robbytbg/Data-Engineering-of-Crowdfunding-Dataset/blob/main/Etl.PNG)

3. **Execute SQL Script:** 
  - To build the required tables and relationships in my chosen database, I ran the SQL script in MySQL Workbench.

```
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/NqTsR5
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE `Campaign` (
    `cf_id` INTEGER  NOT NULL ,
    `contact_id` INTEGER  NOT NULL ,
    `company_name` VARCHAR(50)  NOT NULL ,
    `blurb` VARCHAR(255)  NOT NULL ,
    `goal` INTEGER  NOT NULL ,
    `pledged` INTEGER  NOT NULL ,
    `outcome` VARCHAR(50)  NOT NULL ,
    `backers_count` INTEGER  NOT NULL ,
    `country` VARCHAR(50)  NOT NULL ,
    `currency` VARCHAR(50)  NOT NULL ,
    `launched_at` DATE  NOT NULL ,
    `deadline` DATE  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `cf_id`
    )
);

CREATE TABLE `Sub_category` (
    `sub_category` VARCHAR(50)  NOT NULL ,
    `sub_category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `sub_category_id`
    )
);

CREATE TABLE `Category` (
    `category` VARCHAR(50)  NOT NULL ,
    `category_id` INTEGER  NOT NULL ,
    PRIMARY KEY (
        `category_id`
    )
);

CREATE TABLE `Contact` (
    `contact_id` INTEGER  NOT NULL ,
    `email` VARCHAR(100)  NOT NULL ,
    `first_name` VARCHAR(100)  NOT NULL ,
    `last_name` VARCHAR(100)  NOT NULL ,
    PRIMARY KEY (
        `contact_id`
    )
);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_contact_id` FOREIGN KEY(`contact_id`)
REFERENCES `Contact` (`contact_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_category_id` FOREIGN KEY(`category_id`)
REFERENCES `Category` (`category_id`);

ALTER TABLE `Campaign` ADD CONSTRAINT `fk_Campaign_sub_category_id` FOREIGN KEY(`sub_category_id`)
REFERENCES `Sub_category` (`sub_category_id`);


```

4. Click to launch the Table Data Import Wizard: 
  - I navigated to the particular database where I wanted to import the data using the "Navigator" panel.
  - I made a new table or performed a right-click on the table where I wanted to import the data.
  - I went with the "Table Data Import Wizard."

5. **Select CSV File:** 
  - I selected the "Import from File" option in the "Table Data Import Wizard."
  - I choose the data-containing CSV file.

6. **Columns on the Map:**
  - The wizard tried to automatically translate my CSV file's columns to my MySQL table's columns. I checked to make sure the mapping was accurate.

7. **Testing :**

  - Filter Data for Campaigns Launched After a Specific Date:
    
      -Retrieve campaigns launched after January 1, 2023.
    
        ```
        SELECT * FROM porto.campaign WHERE launched_at > '2021-01-01' LIMIT 5;
        ```
    
      ![alt text](https://github.com/robbytbg/Data-Engineering-of-Crowdfunding-Dataset/blob/main/Others/DB_OP.PNG)

  - Aggregate Functions to Get Insights:
    
    - Find the average goal and pledged amounts for all campaigns.
      
        ```
        SELECT
        AVG(goal) AS avg_goal,
        AVG(pledged) AS avg_pledged
        FROM porto.campaign;

        ```

        ![alt text](https://github.com/robbytbg/Data-Engineering-of-Crowdfunding-Dataset/blob/main/Others/DB_OP2.PNG)


  - Join Tables to Retrieve Detailed Information:
    
    - Retrieve campaign information along with associated category and sub-category names.
   
      ```
      SELECT
      c.cf_id,
      c.company_name,
      c.blurb,
      c.goal,
      c.pledged,
      c.outcome,
      c.backers_count,
      c.country,
      c.currency,
      c.launched_at,
      c.deadline,
      ct.category,
      sct.sub_category
      FROM porto.campaign c
      JOIN porto.category ct ON c.category_id = ct.category_id
      JOIN porto.sub_category sct ON c.sub_category_id = sct.sub_category_id
      LIMIT 5;

      ```

      ![alt text](https://github.com/robbytbg/Data-Engineering-of-Crowdfunding-Dataset/blob/main/Others/DB_OP3.PNG)

# Code Side
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

8. Making a New DataFrame for Contacts:

  - From the collected JSON data, a new DataFrame (new_contact) is generated with columns for "contact_id," "name," and "email."

```
new_contact = pd.DataFrame(dict_values, columns=['contact_id', 'name', 'email'])
```

9. dividing a name into its first and last digits:

  - The original 'name' column is dropped and split into 'first_name' and 'last_name'.

```
new_contact[['first_name', 'last_name']] = new_contact['name'].str.split(' ', 1, expand=True)

new_contact = new_contact.drop(columns=['name'])
```
