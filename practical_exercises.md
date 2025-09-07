# MLOps Lab Exercises - Practical Implementation

## Quick Reference Guide

This document provides step-by-step practical exercises based on the lab activities, with emphasis on GitHub Actions implementation.

---

## Exercise Set 1: Environment Setup (30 minutes)

### Exercise 1.1: WSL Configuration Check
**Time**: 10 minutes

**Commands to Execute**:
```bash
# Check WSL version
wsl --version

# List installed distributions
wsl --list --verbose

# Check Ubuntu version
lsb_release -a

# Verify file system access
ls -la /mnt/c/Users/
```

**Validation**:
- WSL2 should be running
- Ubuntu distribution should be available
- Can access Windows files from `/mnt/c/`

### Exercise 1.2: Anaconda Environment Test
**Time**: 15 minutes

**Setup Commands**:
```bash
# Test conda installation
conda --version
conda info

# Create test environment
conda create -n test-env python=3.9 -y
conda activate test-env

# Install packages
conda install pandas numpy scikit-learn -y
pip install pytest

# Test installation
python -c "import pandas, numpy, sklearn; print('All packages imported successfully')"
```

**Validation**:
- Conda version 4.10+ should be displayed
- Environment creation should complete without errors
- All packages should import successfully

### Exercise 1.3: Unix Commands Practice
**Time**: 5 minutes

**Practice Scenario**:
```bash
# Create directory structure
mkdir -p project/{data/{raw,processed},src,models,docs}

# Create sample files
echo "# MLOps Project" > project/README.md
echo "pandas==1.5.0" > project/requirements.txt
echo "print('Hello MLOps')" > project/src/main.py

# Practice cp commands
cp project/README.md project/docs/
cp project/src/main.py project/src/backup_main.py
cp -r project/data project/backup_data

# Practice mv commands
mv project/requirements.txt project/requirements_old.txt
mv project/src/backup_main.py project/src/main_backup.py

# Verify results
find project -type f | sort
```

---

## Exercise Set 2: Git Workflow Implementation (45 minutes)

### Exercise 2.1: Repository Initialization
**Time**: 15 minutes

**Step-by-step**:
```bash
# Create new project
mkdir mlops-lab-project
cd mlops-lab-project

# Initialize git repository
git init

# Configure git (replace with your details)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Create initial structure
mkdir -p {src,tests,data,models,notebooks}
echo "# MLOps Lab Project" > README.md
echo "__pycache__/" > .gitignore
echo "*.pyc" >> .gitignore
echo ".env" >> .gitignore

# Initial commit
git add .
git commit -m "Initial commit: Project structure setup"

# Check status
git status
git log --oneline
```

### Exercise 2.2: Feature Branch Workflow
**Time**: 20 minutes

**Scenario**: Add data preprocessing functionality

```bash
# Create feature branch
git checkout -b feature/data-preprocessing

# Create preprocessing module
cat > src/preprocessing.py << 'EOF'
import pandas as pd
from sklearn.preprocessing import StandardScaler

def load_data(filepath):
    """Load data from CSV file."""
    return pd.read_csv(filepath)

def preprocess_data(df):
    """Basic preprocessing steps."""
    # Remove missing values
    df_clean = df.dropna()
    
    # Scale numerical features
    scaler = StandardScaler()
    numerical_cols = df_clean.select_dtypes(include=['float64', 'int64']).columns
    df_clean[numerical_cols] = scaler.fit_transform(df_clean[numerical_cols])
    
    return df_clean
EOF

# Create test file
cat > tests/test_preprocessing.py << 'EOF'
import pytest
import pandas as pd
from src.preprocessing import load_data, preprocess_data

def test_preprocess_data():
    # Create sample data
    data = {'A': [1, 2, 3, None, 5], 'B': [1.1, 2.2, 3.3, 4.4, 5.5]}
    df = pd.DataFrame(data)
    
    # Test preprocessing
    result = preprocess_data(df)
    
    # Assertions
    assert result.isnull().sum().sum() == 0  # No missing values
    assert len(result) == 4  # One row removed due to NaN
EOF

# Commit changes
git add .
git commit -m "Add data preprocessing module with tests"

# Switch back to main and merge
git checkout main
git merge feature/data-preprocessing

# Clean up branch
git branch -d feature/data-preprocessing

# View history
git log --oneline --graph
```

### Exercise 2.3: Remote Repository Setup
**Time**: 10 minutes

**Instructions**:
```bash
# Add remote repository (replace with your GitHub repo)
git remote add origin https://github.com/yourusername/mlops-lab-project.git

# Push to remote
git push -u origin main

# Verify remote connection
git remote -v
```

---

## Exercise Set 3: GitHub Actions Implementation (90 minutes)

### Exercise 3.1: Basic Workflow Creation
**Time**: 30 minutes

**Create `.github/workflows/basic-ci.yml`**:
```yaml
name: Basic CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
    
    - name: Set up Python 3.9
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pytest pandas scikit-learn
    
    - name: Run tests
      run: |
        pytest tests/ -v
    
    - name: Run basic script
      run: |
        python -c "from src.preprocessing import preprocess_data; print('Import successful')"
```

**Test the workflow**:
```bash
# Create requirements.txt
echo "pandas==1.5.0" > requirements.txt
echo "scikit-learn==1.3.0" >> requirements.txt
echo "pytest==7.4.0" >> requirements.txt

# Commit and push
git add .
git commit -m "Add basic CI workflow"
git push origin main
```

**Validation**: Check GitHub Actions tab for successful execution

### Exercise 3.2: Advanced MLOps Pipeline
**Time**: 45 minutes

**Create `.github/workflows/mlops-pipeline.yml`**:
```yaml
name: MLOps Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  PYTHON_VERSION: '3.9'

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Cache pip dependencies
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install flake8 pytest-cov
    
    - name: Lint with flake8
      run: |
        # Stop the build if there are Python syntax errors or undefined names
        flake8 src/ --count --select=E9,F63,F7,F82 --show-source --statistics
        # Exit-zero treats all errors as warnings
        flake8 src/ --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    
    - name: Test with pytest
      run: |
        pytest tests/ --cov=src --cov-report=xml --cov-report=html -v
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
        flags: unittests
        name: codecov-umbrella

  build-and-validate:
    needs: lint-and-test
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Create sample dataset
      run: |
        python -c "
import pandas as pd
import numpy as np

# Create sample dataset
np.random.seed(42)
data = {
    'feature1': np.random.normal(0, 1, 1000),
    'feature2': np.random.normal(5, 2, 1000),
    'target': np.random.choice([0, 1], 1000)
}
df = pd.DataFrame(data)
df.to_csv('data/sample_data.csv', index=False)
print('Sample dataset created')
        "
    
    - name: Validate data processing
      run: |
        python -c "
from src.preprocessing import load_data, preprocess_data
import pandas as pd

# Test data loading and preprocessing
df = load_data('data/sample_data.csv')
processed_df = preprocess_data(df)
print(f'Original data shape: {df.shape}')
print(f'Processed data shape: {processed_df.shape}')
print('Data processing validation successful')
        "
    
    - name: Upload processed data
      uses: actions/upload-artifact@v3
      with:
        name: processed-data
        path: data/

  security-scan:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Run Bandit security scan
      run: |
        pip install bandit
        bandit -r src/ || true
    
    - name: Run Safety check
      run: |
        pip install safety
        safety check || true

  docker-build:
    needs: [lint-and-test, build-and-validate]
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Create Dockerfile
      run: |
        cat > Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "-c", "from src.preprocessing import preprocess_data; print('MLOps container ready')"]
EOF
    
    - name: Build Docker image
      run: |
        docker build -t mlops-lab:latest .
    
    - name: Test Docker image
      run: |
        docker run --rm mlops-lab:latest
```

**Additional setup files**:

**Create `src/__init__.py`**:
```python
# Empty file to make src a package
```

**Update `requirements.txt`**:
```
pandas==1.5.0
scikit-learn==1.3.0
pytest==7.4.0
pytest-cov==4.1.0
numpy==1.24.0
```

**Create `.flake8` config**:
```ini
[flake8]
max-line-length = 127
exclude = __pycache__,venv,.git
ignore = E203,W503
```

### Exercise 3.3: Conditional Deployment Workflow
**Time**: 15 minutes

**Create `.github/workflows/deploy.yml`**:
```yaml
name: Deployment Pipeline

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]

jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: staging
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Deploy to staging
      run: |
        echo "🚀 Deploying to staging environment"
        echo "Environment: staging"
        echo "Commit SHA: ${{ github.sha }}"
        echo "Deployment successful!"

  deploy-production:
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Deploy to production
      run: |
        echo "🎯 Deploying to production environment"
        echo "Tag: ${{ github.ref_name }}"
        echo "Production deployment successful!"
```

---

## Exercise Set 4: Advanced Features (45 minutes)

### Exercise 4.1: Matrix Strategy Testing
**Time**: 15 minutes

**Create `.github/workflows/matrix-test.yml`**:
```yaml
name: Matrix Testing

on:
  push:
    branches: [ main ]

jobs:
  test-matrix:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.8', '3.9', '3.10']
        exclude:
          - os: macos-latest
            python-version: '3.8'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pytest pandas scikit-learn
    
    - name: Run compatibility tests
      run: |
        python -c "
import sys
import pandas as pd
import sklearn
print(f'Python: {sys.version}')
print(f'Pandas: {pd.__version__}')
print(f'Sklearn: {sklearn.__version__}')
print('✅ All imports successful')
        "
```

### Exercise 4.2: Scheduled Monitoring Workflow
**Time**: 20 minutes

**Create `.github/workflows/monitoring.yml`**:
```yaml
name: Model Monitoring

on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
  workflow_dispatch:  # Manual trigger

jobs:
  health-check:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        pip install pandas numpy requests
    
    - name: Run health checks
      run: |
        python -c "
import pandas as pd
import numpy as np
from datetime import datetime

print(f'🏥 Health check started at {datetime.now()}')

# Simulate model health check
model_accuracy = np.random.uniform(0.85, 0.95)
data_quality_score = np.random.uniform(0.90, 1.0)

print(f'📊 Model Accuracy: {model_accuracy:.3f}')
print(f'📈 Data Quality Score: {data_quality_score:.3f}')

if model_accuracy < 0.87:
    print('⚠️  Model accuracy below threshold!')
    exit(1)
    
if data_quality_score < 0.92:
    print('⚠️  Data quality below threshold!')
    exit(1)
    
print('✅ All health checks passed')
        "
    
    - name: Create issue on failure
      if: failure()
      uses: actions/github-script@v6
      with:
        script: |
          github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.repo,
            title: '🚨 Model Health Check Failed',
            body: `
            ## Health Check Failure
            
            The scheduled health check has detected issues with the model.
            
            **Details:**
            - Workflow: ${{ github.workflow }}
            - Run ID: ${{ github.run_id }}
            - Timestamp: ${new Date().toISOString()}
            
            Please investigate immediately.
            `,
            labels: ['bug', 'monitoring', 'urgent']
          })
```

### Exercise 4.3: Custom Action Creation
**Time**: 10 minutes

**Create `.github/actions/setup-mlops/action.yml`**:
```yaml
name: 'Setup MLOps Environment'
description: 'Setup Python environment with MLOps tools'

inputs:
  python-version:
    description: 'Python version to use'
    required: false
    default: '3.9'
  
  install-dev-deps:
    description: 'Install development dependencies'
    required: false
    default: 'false'

runs:
  using: 'composite'
  steps:
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ inputs.python-version }}
    
    - name: Cache pip
      uses: actions/cache@v3
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    
    - name: Install dependencies
      shell: bash
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        
        if [ "${{ inputs.install-dev-deps }}" == "true" ]; then
          pip install pytest flake8 black isort
          echo "Development dependencies installed"
        fi
    
    - name: Verify installation
      shell: bash
      run: |
        python -c "import pandas, sklearn; print('✅ MLOps environment ready')"
```

**Use the custom action**:
```yaml
# In any workflow file
steps:
  - name: Setup MLOps Environment
    uses: ./.github/actions/setup-mlops
    with:
      python-version: '3.9'
      install-dev-deps: 'true'
```

---

## Validation Checklist

### Environment Setup ✓
- [ ] WSL2 is installed and running
- [ ] Anaconda is configured with test environment
- [ ] Unix commands (cp, mv) work correctly
- [ ] Git is configured with user details

### GitHub Actions ✓
- [ ] Basic CI workflow executes successfully
- [ ] Advanced MLOps pipeline completes all jobs
- [ ] Matrix strategy tests run on multiple platforms
- [ ] Scheduled monitoring workflow is configured
- [ ] Custom action is created and functional

### MLOps Pipeline Features ✓
- [ ] Code linting and testing
- [ ] Security scanning
- [ ] Docker containerization
- [ ] Conditional deployments
- [ ] Artifact management
- [ ] Monitoring and alerting

### Best Practices ✓
- [ ] Proper secrets management
- [ ] Environment separation (staging/production)
- [ ] Caching for performance
- [ ] Error handling and notifications
- [ ] Documentation and comments

---

## Troubleshooting Guide

### Common Issues and Solutions

**1. WSL Installation Issues**
```bash
# Check Windows version
winver

# Enable required features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart and try again
```

**2. Conda Command Not Found**
```bash
# Add conda to PATH
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**3. GitHub Actions Failing**
- Check workflow syntax with GitHub Actions syntax checker
- Verify file paths are correct
- Ensure secrets are properly configured
- Check runner logs for detailed error messages

**4. Import Errors in Tests**
```bash
# Add project root to Python path
export PYTHONPATH="${PYTHONPATH}:${PWD}"

# Or modify test files to include:
import sys
import os
sys.path.insert(0, os.path.abspath('.'))
```

---

## Next Steps

After completing these exercises:

1. **Implement Real ML Model**: Replace placeholder code with actual ML model
2. **Add Model Registry**: Integrate with MLflow or similar
3. **Implement A/B Testing**: Setup deployment strategies
4. **Add Monitoring Dashboard**: Create observability stack
5. **Security Hardening**: Implement comprehensive security scanning
6. **Performance Optimization**: Optimize pipeline execution time

This hands-on guide provides practical experience with all components of modern MLOps workflows using GitHub Actions as the central automation platform.
