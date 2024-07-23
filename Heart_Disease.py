import pandas as pd
import numpy as np
import joblib
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix, accuracy_score

# Load the dataset
df = pd.read_csv("Heart_Disease_Prediction.csv")
x = df.iloc[:, 0:13].values
y = df.iloc[:, 13].values

# Encoding the target variable
le = LabelEncoder()
y = le.fit_transform(y)

# Check for missing values
print(df.isnull().sum())

# Splitting the dataset into train and test data
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.25, random_state=0)

# Feature scaling
sc = StandardScaler()
x_train = sc.fit_transform(x_train)
x_test = sc.transform(x_test)

# Train and evaluate the models

# K-Nearest Neighbors
knn = KNeighborsClassifier(weights='distance')
knn.fit(x_train, y_train)
y_pred = knn.predict(x_test)
print("KNN Confusion Matrix:", confusion_matrix(y_test, y_pred))
print("KNN Accuracy Score:", accuracy_score(y_test, y_pred))

# Decision Tree
dc = DecisionTreeClassifier(criterion='entropy', random_state=0)
dc.fit(x_train, y_train)
y_pred = dc.predict(x_test)
print("Decision Tree Confusion Matrix:", confusion_matrix(y_test, y_pred))
print("Decision Tree Accuracy Score:", accuracy_score(y_test, y_pred))

# Random Forest
rc = RandomForestClassifier(n_estimators=40, criterion='entropy', random_state=0)
rc.fit(x_train, y_train)
y_pred = rc.predict(x_test)
print("Random Forest Confusion Matrix:", confusion_matrix(y_test, y_pred))
print("Random Forest Accuracy Score:", accuracy_score(y_test, y_pred))

# Support Vector Machine
sv = SVC(kernel='sigmoid', random_state=0)
sv.fit(x_train, y_train)
y_pred = sv.predict(x_test)
print("SVM Confusion Matrix:", confusion_matrix(y_test, y_pred))
print("SVM Accuracy Score:", accuracy_score(y_test, y_pred))

# Save the best-performing model and scaler
best_model = rc  # Assume Random Forest is the best model based on accuracy
joblib.dump(best_model, 'heart_disease_model.pkl')
joblib.dump(sc, 'scaler.pkl')
