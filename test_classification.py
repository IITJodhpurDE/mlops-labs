#!/usr/bin/env python3
"""
Simple test script to verify digit classification is working
"""

import matplotlib
matplotlib.use('Agg')  # Use non-interactive backend
import matplotlib.pyplot as plt
from sklearn import datasets, metrics, svm
from sklearn.model_selection import train_test_split

def main():
    print("🚀 Starting Digit Classification Test...")
    
    # Load dataset
    print("📊 Loading digits dataset...")
    digits = datasets.load_digits()
    print(f"✅ Dataset loaded: {len(digits.images)} samples, shape: {digits.images[0].shape}")
    
    # Prepare data
    n_samples = len(digits.images)
    data = digits.images.reshape((n_samples, -1))
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(
        data, digits.target, test_size=0.5, shuffle=False
    )
    print(f"📈 Data split - Training: {len(X_train)}, Testing: {len(X_test)}")
    
    # Train classifier
    print("🧠 Training SVM classifier...")
    clf = svm.SVC(gamma=0.001)
    clf.fit(X_train, y_train)
    print("✅ Training complete!")
    
    # Make predictions
    print("🔮 Making predictions...")
    predicted = clf.predict(X_test)
    
    # Calculate accuracy
    accuracy = metrics.accuracy_score(y_test, predicted)
    print(f"🎯 Accuracy: {accuracy:.4f} ({accuracy*100:.2f}%)")
    
    # Show some predictions
    print("\n📋 Sample Predictions vs Actual:")
    for i in range(10):
        print(f"   Sample {i+1}: Predicted={predicted[i]}, Actual={y_test[i]} {'✅' if predicted[i]==y_test[i] else '❌'}")
    
    print(f"\n📊 Classification Report:")
    print(metrics.classification_report(y_test, predicted))
    
    print("🎉 Script completed successfully!")
    return True

if __name__ == "__main__":
    main()
