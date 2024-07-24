import pandas as pd
import numpy as np
import joblib
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, VotingClassifier
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

# Hyperparameter tuning for KNeighborsClassifier
knn_params = {
    'n_neighbors': [3, 5, 7, 9],
    'weights': ['uniform', 'distance'],
    'metric': ['euclidean', 'manhattan']
}
knn = KNeighborsClassifier()
knn_grid = GridSearchCV(knn, knn_params, cv=5, scoring='accuracy')
knn_grid.fit(x_train, y_train)
best_knn = knn_grid.best_estimator_
print(f"Best KNN Parameters: {knn_grid.best_params_}")

# Hyperparameter tuning for DecisionTreeClassifier
dt_params = {
    'criterion': ['gini', 'entropy'],
    'max_depth': [None, 10, 20, 30],
    'min_samples_split': [2, 5, 10]
}
dt = DecisionTreeClassifier(random_state=0)
dt_grid = GridSearchCV(dt, dt_params, cv=5, scoring='accuracy')
dt_grid.fit(x_train, y_train)
best_dt = dt_grid.best_estimator_
print(f"Best Decision Tree Parameters: {dt_grid.best_params_}")

# Hyperparameter tuning for RandomForestClassifier
rf_params = {
    'n_estimators': [50, 100, 150],
    'criterion': ['gini', 'entropy'],
    'max_depth': [None, 10, 20, 30],
    'min_samples_split': [2, 5, 10]
}
rf = RandomForestClassifier(random_state=0)
rf_grid = GridSearchCV(rf, rf_params, cv=5, scoring='accuracy')
rf_grid.fit(x_train, y_train)
best_rf = rf_grid.best_estimator_
print(f"Best Random Forest Parameters: {rf_grid.best_params_}")

# Hyperparameter tuning for SVM
svm_params = {
    'kernel': ['linear', 'rbf', 'sigmoid'],
    'C': [0.1, 1, 10, 100],
    'gamma': ['scale', 'auto'],
    'probability': [True]  # Enable probability estimates
}
svm = SVC(random_state=0)
svm_grid = GridSearchCV(svm, svm_params, cv=5, scoring='accuracy')
svm_grid.fit(x_train, y_train)
best_svm = svm_grid.best_estimator_
print(f"Best SVM Parameters: {svm_grid.best_params_}")

# Voting Classifier for ensemble learning
voting_clf = VotingClassifier(estimators=[
    ('knn', best_knn),
    ('dt', best_dt),
    ('rf', best_rf),
    ('svm', best_svm)
], voting='soft')

voting_clf.fit(x_train, y_train)
y_pred = voting_clf.predict(x_test)

# Evaluate the model
print("Voting Classifier Confusion Matrix:", confusion_matrix(y_test, y_pred))
print("Voting Classifier Accuracy Score:", accuracy_score(y_test, y_pred))

# Save the best-performing model and scaler
joblib.dump(voting_clf, 'heart_disease_model.pkl')
joblib.dump(sc, 'scaler.pkl')
