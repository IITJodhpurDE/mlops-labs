# MLOps Lab Activities - Comprehensive Guide

## Overview
This document outlines the lab exercises covering fundamental MLOps concepts and tools, with a focus on GitHub Actions as the primary CI/CD platform.

## Agenda Summary
- **Windows WSL setup** - Environment preparation
- **Anaconda setup** - Python environment management
- **Unix: cp, mv & git** - Basic file operations and version control
- **GitHub Actions** - Main focus on CI/CD automation

---

## Lab 1: Environment Setup and Basic Operations

### Activity 1.1: Windows WSL Setup
**Objective**: Configure Windows Subsystem for Linux for MLOps development

**Prerequisites**: Windows 10/11 machine with administrator privileges

**Steps**:
1. **Enable WSL Feature**
   ```powershell
   # Run in PowerShell as Administrator
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

2. **Install Ubuntu Distribution**
   ```powershell
   # Install from Microsoft Store or use command
   wsl --install -d Ubuntu
   ```

3. **Set WSL Version**
   ```powershell
   wsl --set-default-version 2
   wsl --set-version Ubuntu 2
   ```

4. **Verify Installation**
   ```bash
   wsl --list --verbose
   ```

**Expected Outcome**: Working WSL2 environment with Ubuntu

### Activity 1.2: Anaconda Setup
**Objective**: Install and configure Anaconda for Python environment management

**Steps**:
1. **Download and Install Anaconda**
   ```bash
   # In WSL Ubuntu terminal
   wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
   bash Anaconda3-2024.06-1-Linux-x86_64.sh
   ```

2. **Initialize Conda**
   ```bash
   source ~/.bashrc
   conda --version
   ```

3. **Create MLOps Environment**
   ```bash
   conda create -n mlops python=3.9
   conda activate mlops
   ```

4. **Install Essential Packages**
   ```bash
   conda install pandas numpy scikit-learn matplotlib seaborn
   pip install mlflow dvc
   ```

**Expected Outcome**: Configured conda environment ready for MLOps projects

### Activity 1.3: Unix Commands - File Operations
**Objective**: Master basic Unix commands for file management

**Key Commands Practice**:

1. **Copy Operations (cp)**
   ```bash
   # Create sample files
   echo "Hello MLOps" > sample.txt
   
   # Copy single file
   cp sample.txt backup.txt
   
   # Copy with different name
   cp sample.txt data/processed_sample.txt
   
   # Copy directory recursively
   cp -r src/ backup_src/
   
   # Copy multiple files
   cp *.txt archive/
   ```

2. **Move Operations (mv)**
   ```bash
   # Rename file
   mv old_name.txt new_name.txt
   
   # Move to directory
   mv file.txt data/
   
   # Move and rename
   mv temp.txt data/final_data.txt
   
   # Move multiple files
   mv *.py scripts/
   ```

3. **Advanced Operations**
   ```bash
   # Copy with preserve attributes
   cp -p original.txt copy_with_attributes.txt
   
   # Interactive copy (prompt before overwrite)
   cp -i source.txt destination.txt
   
   # Verbose output
   cp -v file1.txt file2.txt
   ```

**Practice Exercise**:
- Create a directory structure: `project/{data,src,models,notebooks}`
- Copy configuration files to appropriate directories
- Organize Python scripts using mv commands

---

## Lab 2: Git Version Control

### Activity 2.1: Git Fundamentals
**Objective**: Master git commands for version control in MLOps projects

**Setup**:
```bash
# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Initialize repository
mkdir mlops-project
cd mlops-project
git init
```

**Core Git Commands**:

1. **Basic Workflow**
   ```bash
   # Check status
   git status
   
   # Add files to staging
   git add .
   git add specific_file.py
   
   # Commit changes
   git commit -m "Initial commit: Setup project structure"
   
   # View commit history
   git log --oneline
   ```

2. **Branching Strategy**
   ```bash
   # Create and switch to new branch
   git checkout -b feature/data-preprocessing
   
   # List branches
   git branch
   
   # Switch branches
   git checkout main
   git checkout feature/data-preprocessing
   
   # Merge branches
   git checkout main
   git merge feature/data-preprocessing
   ```

3. **Remote Operations**
   ```bash
   # Add remote repository
   git remote add origin https://github.com/username/mlops-project.git
   
   # Push to remote
   git push -u origin main
   
   # Pull from remote
   git pull origin main
   
   # Clone repository
   git clone https://github.com/username/mlops-project.git
   ```

**Practice Exercise**: Create a sample MLOps project with proper git workflow

---

## Lab 3: GitHub Actions - CI/CD for MLOps (Main Focus)

### Activity 3.1: Introduction to GitHub Actions
**Objective**: Understand GitHub Actions concepts and create basic workflows

**Key Concepts**:
- **Workflows**: Automated processes triggered by events
- **Jobs**: Units of work that run on runners
- **Steps**: Individual tasks within jobs
- **Actions**: Reusable units of code
- **Runners**: Servers that execute workflows

**Basic Workflow Structure**:
```yaml
name: MLOps Pipeline
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'
```

### Activity 3.2: Setting Up MLOps Pipeline
**Objective**: Create comprehensive CI/CD pipeline for ML projects

**Create `.github/workflows/mlops-pipeline.yml`**:

```yaml
name: MLOps CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  PYTHON_VERSION: '3.9'

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Cache dependencies
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
        pip install pytest pytest-cov flake8
    
    - name: Run linting
      run: |
        flake8 src/ --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 src/ --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    
    - name: Run tests
      run: |
        pytest tests/ --cov=src --cov-report=xml --cov-report=html
    
    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
        flags: unittests

  data-validation:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Install dependencies
      run: |
        pip install pandas great-expectations
    
    - name: Run data validation
      run: |
        python scripts/validate_data.py
    
    - name: Upload validation results
      uses: actions/upload-artifact@v3
      with:
        name: data-validation-results
        path: validation_results/

  model-training:
    runs-on: ubuntu-latest
    needs: [test, data-validation]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
        pip install mlflow
    
    - name: Train model
      env:
        MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
      run: |
        python src/train_model.py
    
    - name: Upload model artifacts
      uses: actions/upload-artifact@v3
      with:
        name: model-artifacts
        path: models/

  model-evaluation:
    runs-on: ubuntu-latest
    needs: model-training
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Download model artifacts
      uses: actions/download-artifact@v3
      with:
        name: model-artifacts
        path: models/
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ env.PYTHON_VERSION }}
    
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
    
    - name: Evaluate model
      run: |
        python src/evaluate_model.py
    
    - name: Generate evaluation report
      run: |
        python scripts/generate_report.py
    
    - name: Upload evaluation results
      uses: actions/upload-artifact@v3
      with:
        name: evaluation-results
        path: reports/

  deploy:
    runs-on: ubuntu-latest
    needs: [model-evaluation]
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Download model artifacts
      uses: actions/download-artifact@v3
      with:
        name: model-artifacts
        path: models/
    
    - name: Deploy to staging
      run: |
        echo "Deploying model to staging environment"
        # Add deployment commands here
    
    - name: Run integration tests
      run: |
        python tests/integration_tests.py
    
    - name: Deploy to production
      if: success()
      run: |
        echo "Deploying model to production environment"
        # Add production deployment commands here
```

### Activity 3.3: Advanced GitHub Actions Features
**Objective**: Implement advanced features for robust MLOps pipelines

**1. Matrix Strategy for Multiple Environments**:
```yaml
jobs:
  test-matrix:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.8', '3.9', '3.10']
    
    steps:
    - uses: actions/checkout@v4
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    - name: Run tests
      run: pytest
```

**2. Conditional Deployments**:
```yaml
jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: echo "Deploying to staging"

  deploy-production:
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: echo "Deploying to production"
```

**3. Secrets Management**:
```yaml
steps:
  - name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v2
    with:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      aws-region: us-east-1
```

### Activity 3.4: MLOps-Specific Workflows
**Objective**: Implement specialized workflows for ML projects

**1. Data Drift Detection Workflow**:
```yaml
name: Data Drift Detection

on:
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM
  workflow_dispatch:

jobs:
  drift-detection:
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
        pip install evidently pandas
    
    - name: Check for data drift
      run: |
        python scripts/detect_drift.py
    
    - name: Create issue on drift detection
      if: failure()
      uses: actions/github-script@v6
      with:
        script: |
          github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.repo,
            title: 'Data Drift Detected',
            body: 'Automated drift detection has identified potential data drift. Please investigate.'
          })
```

**2. Model Performance Monitoring**:
```yaml
name: Model Performance Monitoring

on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  performance-check:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Monitor model performance
      run: |
        python scripts/monitor_performance.py
    
    - name: Send Slack notification
      if: failure()
      uses: 8398a7/action-slack@v3
      with:
        status: failure
        text: 'Model performance has degraded'
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

## Lab 4: Practical Implementation

### Activity 4.1: Complete MLOps Project Setup
**Objective**: Implement a full MLOps project with all components

**Project Structure**:
```
mlops-project/
├── .github/
│   └── workflows/
│       ├── mlops-pipeline.yml
│       ├── data-drift.yml
│       └── performance-monitoring.yml
├── src/
│   ├── data/
│   │   ├── __init__.py
│   │   ├── ingestion.py
│   │   └── preprocessing.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── train.py
│   │   └── evaluate.py
│   └── utils/
│       ├── __init__.py
│       └── helpers.py
├── tests/
│   ├── test_data.py
│   ├── test_models.py
│   └── integration_tests.py
├── scripts/
│   ├── validate_data.py
│   ├── detect_drift.py
│   └── monitor_performance.py
├── requirements.txt
├── Dockerfile
└── README.md
```

### Activity 4.2: Hands-on Implementation
**Tasks**:

1. **Create Sample ML Project**
   - Implement data preprocessing pipeline
   - Create model training script
   - Write unit tests
   - Setup GitHub Actions workflow

2. **Test CI/CD Pipeline**
   - Push code to trigger workflow
   - Monitor execution in GitHub Actions tab
   - Debug any failures
   - Optimize pipeline performance

3. **Implement Advanced Features**
   - Add environment-specific deployments
   - Setup monitoring and alerting
   - Configure security scanning
   - Add performance benchmarking

**Expected Deliverables**:
- Working MLOps pipeline with GitHub Actions
- Automated testing and deployment
- Monitoring and alerting setup
- Documentation of the complete workflow

---

## Assessment Criteria

### Technical Skills Evaluation:
1. **Environment Setup** (20%)
   - Successful WSL and Anaconda installation
   - Proper environment configuration

2. **Unix Commands** (15%)
   - Proficiency with cp, mv commands
   - File organization and management

3. **Git Version Control** (25%)
   - Repository management
   - Branching strategies
   - Collaboration workflows

4. **GitHub Actions Implementation** (40%)
   - Workflow creation and configuration
   - CI/CD pipeline setup
   - Advanced features implementation
   - Troubleshooting and optimization

### Practical Outcomes:
- Functional development environment
- Organized project structure
- Automated CI/CD pipeline
- Comprehensive testing strategy
- Production-ready deployment process

---

## Additional Resources

### Documentation Links:
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MLOps Best Practices](https://ml-ops.org/)
- [WSL Setup Guide](https://docs.microsoft.com/en-us/windows/wsl/)
- [Anaconda Documentation](https://docs.anaconda.com/)

### Sample Projects:
- [MLOps GitHub Template](https://github.com/microsoft/MLOpsPython)
- [ML Pipeline Examples](https://github.com/Azure/MLOpsPython)

### Tools and Extensions:
- GitHub CLI
- VS Code with Remote-WSL extension
- Docker for containerization
- MLflow for experiment tracking

This comprehensive guide ensures hands-on experience with all the key components of modern MLOps practices, with GitHub Actions as the central automation platform.
