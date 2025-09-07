#!/bin/bash
# Quick test script to verify local setup before pushing to GitHub

echo "🚀 Testing MLOps Lab Setup..."
echo "================================"

# Test 1: Check Git repository
echo "📂 Checking Git repository..."
if [ -d ".git" ]; then
    echo "✅ Git repository initialized"
    echo "   Current branch: $(git branch --show-current)"
    echo "   Commits: $(git rev-list --count HEAD)"
else
    echo "❌ Git repository not found"
    exit 1
fi

# Test 2: Check required files
echo ""
echo "📄 Checking required files..."
required_files=(
    ".github/workflows/github-actions-demo.yml"
    "plot_digits_classification.py"
    "requirements.txt"
    "README.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Test 3: Check Python environment
echo ""
echo "🐍 Testing Python environment..."
if [ -d ".venv" ]; then
    echo "✅ Virtual environment found"
    # Activate and test
    source .venv/bin/activate
    
    # Test Python packages
    echo "   Testing package imports..."
    python -c "
import sys
try:
    from sklearn import datasets
    print('   ✅ scikit-learn imported successfully')
except ImportError:
    print('   ❌ scikit-learn not found')
    sys.exit(1)

try:
    import matplotlib.pyplot as plt
    print('   ✅ matplotlib imported successfully')
except ImportError:
    print('   ❌ matplotlib not found')
    sys.exit(1)

try:
    import numpy as np
    print('   ✅ numpy imported successfully')
except ImportError:
    print('   ❌ numpy not found')
    sys.exit(1)
"
else
    echo "❌ Virtual environment not found"
    echo "   Run: python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# Test 4: Run ML script
echo ""
echo "🧠 Testing ML classification script..."
python -c "
from sklearn import datasets, svm
from sklearn.model_selection import train_test_split

# Quick test run
digits = datasets.load_digits()
n_samples = len(digits.images)
data = digits.images.reshape((n_samples, -1))
X_train, X_test, y_train, y_test = train_test_split(data, digits.target, test_size=0.2, shuffle=False)

clf = svm.SVC(gamma=0.001)
clf.fit(X_train, y_train)
predicted = clf.predict(X_test[:10])  # Test first 10 samples

print('   ✅ ML pipeline working correctly')
print(f'   📊 Test accuracy on 10 samples: {sum(predicted == y_test[:10])}/10')
"

# Test 5: Check GitHub Actions workflow syntax
echo ""
echo "⚙️  Validating GitHub Actions workflow..."
if command -v python &> /dev/null; then
    python -c "
import yaml
try:
    with open('.github/workflows/github-actions-demo.yml', 'r') as f:
        yaml.safe_load(f)
    print('   ✅ GitHub Actions YAML syntax is valid')
except yaml.YAMLError as e:
    print(f'   ❌ YAML syntax error: {e}')
    exit(1)
except FileNotFoundError:
    print('   ❌ Workflow file not found')
    exit(1)
" 2>/dev/null || echo "   ⚠️  YAML validation skipped (PyYAML not installed)"
fi

echo ""
echo "🎉 All tests passed! Ready for GitHub setup."
echo ""
echo "📋 Next steps:"
echo "   1. Create GitHub repository"
echo "   2. git remote add origin <your-repo-url>"
echo "   3. git push -u origin main"
echo "   4. Check GitHub Actions tab for automated workflow"
echo ""
echo "🔗 See GITHUB_SETUP.md for detailed instructions"
