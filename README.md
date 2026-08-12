# ⚽ FIFA Player Analytics & Scouting Dashboard

An end-to-end **sports analytics and player valuation project** built using the FIFA 21 player dataset containing **18,944 players and 106 attributes**.

The project combines **SQL analytics, statistical analysis, machine learning, and interactive visualization** to investigate player market value, identify player archetypes, compare league economics, and detect potentially under- or overvalued players.

---

## 📌 Project Overview

Football clubs need data-driven approaches to evaluate players, understand market dynamics, and identify potential recruitment opportunities.

This project simulates the work of a **football recruitment analytics team**, using player performance and market data to answer questions such as:

- Which player attributes are most strongly associated with market value?
- Which positions command the highest market value?
- Which leagues pay a premium for similar player quality?
- Can players be grouped into meaningful archetypes based on their attributes?
- Which players appear under- or overvalued relative to their statistical profile?

The project follows a **SQL-first analytics approach**, while Python and Scikit-learn are used where statistical modeling and clustering are required.

---

## 🎯 Business Objectives

The analysis focuses on four major areas:

### 1. Player Valuation

Identify the player attributes most strongly associated with market value.

### 2. Position Economics

Compare player value across positions and determine whether certain positions command a market premium.

### 3. Player Segmentation

Use unsupervised learning to discover natural player archetypes based on performance attributes rather than relying solely on predefined position labels.

### 4. Market Valuation

Build a regression model to estimate expected player value and identify players whose actual market value differs substantially from the model's prediction.

---

## 📊 Dataset

**Source:** FIFA 21 Complete Player Dataset — Kaggle

**Dataset size:**

- **18,944 players**
- **106 attributes**
- FIFA 21 player-level data
- Performance, physical, positional, potential, club, league, and market-value information

### Data Quality Consideration

Goalkeepers do not have the standard outfield attributes such as:

- Pace
- Shooting
- Passing
- Dribbling
- Defending
- Physical

Instead, they have goalkeeper-specific attributes.

Therefore, analyses involving standard outfield attributes explicitly exclude goalkeepers using:

```sql
WHERE pace IS NOT NULL
```

This prevents incompatible player profiles from affecting position and attribute-level comparisons.

---

## 🛠️ Technology Stack

| Area                  | Technology                    |
| --------------------- | ----------------------------- |
| Programming           | Python                        |
| Database & SQL        | DuckDB                        |
| Data Processing       | Pandas                        |
| Statistical Analysis  | SQL / Python                  |
| Clustering            | Scikit-learn KMeans           |
| Regression            | Scikit-learn LinearRegression |
| Feature Scaling       | StandardScaler                |
| Visualization         | Matplotlib, Seaborn           |
| Interactive Dashboard | Streamlit, Plotly             |
| Data Source           | Kaggle                        |

---

## 🏗️ Project Architecture

```text
FIFA 21 Dataset
       │
       ▼
Data Download & Preparation
       │
       ▼
DuckDB
       │
       ├───────────────┐
       │               │
       ▼               ▼
   SQL Analysis    Python Analysis
       │               │
       │        ┌──────┴──────┐
       │        ▼             ▼
       │     K-Means       Regression
       │     Clustering    Valuation Model
       │        │             │
       └────────┴─────────────┘
                    │
                    ▼
          Streamlit Dashboard
```

---

## 🔎 Analytical Approach

### 1. Player Value & Attribute Analysis

SQL correlation analysis is used to measure the relationship between player attributes and market value.

The analysis compares attributes such as:

- Overall rating
- Potential
- Passing
- Dribbling
- Defending
- Physical attributes
- Age

This helps identify which characteristics are most closely associated with player valuation.

---

### 2. Position-Level Analysis

Player positions are analyzed to compare:

- Average market value
- Average overall rating
- Value per overall-rating point
- Number of players by position

Multi-position player records are transformed into individual position categories using SQL string-splitting and unnesting techniques.

This enables comparisons between attacking, midfield, defensive, and other player roles.

---

### 3. League Comparison

Player value is aggregated across leagues to investigate differences in market economics.

The analysis compares player value relative to overall rating to identify leagues where clubs appear to pay substantially more for comparable player quality.

---

## 🤖 Player Archetype Clustering

K-Means clustering is used to identify **natural player archetypes** based on their performance attributes.

### Methodology

1. Select relevant player attributes.
2. Remove incompatible/missing observations.
3. Standardize the features using `StandardScaler`.
4. Evaluate different values of `k`.
5. Use the **Elbow Method** to determine a suitable number of clusters.
6. Apply K-Means clustering.
7. Interpret the resulting player groups.

The analysis identifies **4 meaningful player clusters** based on six standardized performance attributes.

The resulting clusters broadly represent patterns such as:

- Attacking players
- Defensive players
- Balanced/all-round players
- Other specialized player profiles

Importantly, the clustering algorithm is **not given player positions**, allowing the analysis to test whether performance attributes naturally contain positional information.

---

## 📈 Player Valuation Regression

A Linear Regression model is developed to estimate player market value using:

- Overall rating
- Potential
- Age

Because player market values are highly skewed, the model uses:

```text
log(value_eur)
```

as the target variable.

### Model Result

The model achieves approximately:

**R² = 0.971**

This indicates a very strong relationship between the selected features and the transformed market-value target within this dataset.

Residual analysis is then used to identify players whose actual market value differs substantially from their predicted value.

---

## 📊 Key Findings

### 💰 What Drives Player Value?

Overall rating shows the strongest relationship with market value:

**Overall — r = 0.636**

Potential is also strongly associated with value:

**Potential — r = 0.571**

Passing and dribbling show stronger relationships with market value than defending, suggesting that technical and attacking attributes can play an important role in player valuation.

---

### ⚽ Position Economics

Attacking positions such as **CF, LW, and RW** show some of the highest average market values.

They also demonstrate higher value relative to overall rating, suggesting that the market may assign a premium to attacking output beyond a player's general rating.

---

### 🌍 League Market Differences

The analysis indicates that the **English Premier League** has substantially higher player values per overall-rating point compared with leagues such as Spain's Primera División and Italy's Serie A.

This highlights differences in league-level purchasing power and market economics.

---

### 👥 Player Archetypes

K-Means clustering with **k = 4** produces recognizable player groups without using player position as an input.

This provides evidence that the selected performance attributes contain meaningful information about player roles and playing styles.

---

### 📉 Valuation Model

The three-feature regression model achieves an **R² of approximately 0.971**.

However, the model also highlights an important analytical limitation:

**Overall rating and potential are highly correlated.**

Once overall rating is included, the additional contribution of potential becomes very small.

This demonstrates why model interpretation is important even when predictive performance appears strong.

---

## ⚠️ Model Limitations

The valuation model should **not be treated as a real-world player pricing system**.

The model does not include several important factors that influence football transfers, such as:

- Club
- League
- Contract duration
- Player demand
- Transfer market conditions
- Injury history
- Agent influence
- Transfer fees
- Reputation
- Competition between clubs

As a result, players identified as "undervalued" should be interpreted as **statistical anomalies relative to the model**, rather than guaranteed hidden talents.

Recognizing these limitations is an important part of the analysis.

---

## 🧠 SQL Techniques Used

The project demonstrates several practical SQL techniques:

### Correlation Analysis

```sql
CORR()
```

Used to measure relationships between player attributes and market value.

### Multi-valued Column Transformation

```sql
string_split()
UNNEST()
```

Used to transform players with multiple positions into analyzable position-level records.

### Aggregation

```sql
GROUP BY
HAVING
COUNT()
AVG()
```

Used for position and league comparisons.

### Filtering & Data Quality

SQL filtering is used to exclude incompatible player records from specific analyses.

---

## 📊 Dashboard

The project includes an interactive **Streamlit + Plotly scouting dashboard**.

The dashboard provides:

- Player valuation metrics
- Position comparisons
- League comparisons
- Attribute/value relationships
- Player archetype visualization
- Undervalued/overvalued player analysis
- Interactive clustering controls

### Interactive K-Means Analysis

The dashboard includes a **K slider**, allowing users to change the number of clusters and dynamically explore different player segmentation scenarios.

---

## 📁 Project Structure

```text
04-fifa-player-analysis/
│
├── data/
│   └── players_21.csv
│
├── app.py
├── db.py
├── download_data.py
├── queries.sql
├── analysis.ipynb
├── requirements.txt
└── README.md
```

### File Description

| File               | Purpose                                     |
| ------------------ | ------------------------------------------- |
| `download_data.py` | Downloads and prepares the FIFA dataset     |
| `db.py`            | Loads data into DuckDB and executes queries |
| `queries.sql`      | Contains reusable analytical SQL queries    |
| `analysis.ipynb`   | Complete analytical walkthrough             |
| `app.py`           | Interactive Streamlit scouting dashboard    |
| `requirements.txt` | Python dependencies                         |

---

## 🚀 How to Run

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd <repository-name>
```

### 2. Create a virtual environment

```bash
python -m venv .venv
```

### 3. Activate the environment

**macOS / Linux**

```bash
source .venv/bin/activate
```

**Windows**

```bash
.venv\Scripts\activate
```

### 4. Install dependencies

```bash
pip install -r requirements.txt
```

### 5. Download the dataset

```bash
python download_data.py
```

### 6. Explore the analysis

```bash
jupyter notebook analysis.ipynb
```

### 7. Launch the dashboard

```bash
streamlit run app.py
```

---

## 🎯 Skills Demonstrated

- SQL Data Analysis
- Python
- Pandas
- DuckDB
- Data Cleaning
- Exploratory Data Analysis
- Correlation Analysis
- Statistical Analysis
- K-Means Clustering
- Feature Scaling
- Elbow Method
- Linear Regression
- Residual Analysis
- Data Visualization
- Streamlit Dashboard Development
- Plotly
- Business Insight Generation
- Model Interpretation

---

## 💼 Business Value

This project demonstrates how raw sports data can be transformed into actionable insights for a recruitment and scouting team.

The workflow moves from:

**Raw Data → Data Preparation → SQL Analysis → Statistical Modeling → Player Segmentation → Valuation Analysis → Interactive Dashboard → Business Insights**

The resulting analysis can support decisions around **player scouting, market comparison, talent identification, and recruitment strategy**.

---

## 🔮 Future Enhancements

Potential improvements include:

- Incorporating club and league features into the valuation model
- Building a more robust player valuation model using Random Forest or Gradient Boosting
- Creating RFM-style player/team segmentation concepts
- Adding player similarity/recommendation functionality
- Developing a player search and comparison interface
- Adding historical FIFA editions for time-series analysis
- Deploying the Streamlit dashboard online
- Adding automated model evaluation and cross-validation

---

## 📜 Dataset Attribution

**FIFA 21 Complete Player Dataset**

Source: Kaggle

This project is intended for educational, portfolio, and analytical purposes.
