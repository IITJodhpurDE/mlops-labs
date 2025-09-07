#!/bin/bash

# MLOps Lab Setup Script
# This script helps students quickly set up their environment for the lab exercises

set -e  # Exit on any error

echo "🚀 MLOps Lab Setup Script"
echo "========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in WSL
check_wsl() {
    print_status "Checking WSL environment..."
    if grep -qi microsoft /proc/version; then
        print_success "Running in WSL environment"
    else
        print_warning "Not running in WSL. Some features may not work as expected."
    fi
}

# Check Python installation
check_python() {
    print_status "Checking Python installation..."
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d" " -f2)
        print_success "Python $PYTHON_VERSION found"
    else
        print_error "Python3 not found. Please install Python 3.8 or higher."
        exit 1
    fi
}

# Check Git installation
check_git() {
    print_status "Checking Git installation..."
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | cut -d" " -f3)
        print_success "Git $GIT_VERSION found"
    else
        print_error "Git not found. Please install Git."
        exit 1
    fi
}

# Check Conda installation
check_conda() {
    print_status "Checking Conda installation..."
    if command -v conda &> /dev/null; then
        CONDA_VERSION=$(conda --version | cut -d" " -f2)
        print_success "Conda $CONDA_VERSION found"
        return 0
    else
        print_warning "Conda not found."
        return 1
    fi
}

# Install Anaconda
install_anaconda() {
    print_status "Installing Anaconda..."
    cd /tmp
    wget -q https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    bash Anaconda3-2024.06-1-Linux-x86_64.sh -b -p $HOME/anaconda3
    
    # Add to PATH
    echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/anaconda3/bin:$PATH"
    
    # Initialize conda
    source $HOME/anaconda3/bin/activate
    conda init bash
    
    print_success "Anaconda installed successfully"
}

# Create MLOps environment
create_mlops_env() {
    print_status "Creating MLOps conda environment..."
    
    # Source conda
    source $HOME/anaconda3/bin/activate
    
    # Create environment
    conda create -n mlops python=3.9 -y
    conda activate mlops
    
    # Install packages
    conda install pandas numpy scikit-learn matplotlib seaborn -y
    pip install pytest pytest-cov flake8 mlflow
    
    print_success "MLOps environment created successfully"
}

# Setup project structure
setup_project() {
    print_status "Setting up project structure..."
    
    PROJECT_DIR="mlops-lab-project"
    
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Project directory already exists. Skipping..."
        return
    fi
    
    mkdir -p $PROJECT_DIR/{src,tests,data,models,notebooks,.github/workflows}
    cd $PROJECT_DIR
    
    # Create basic files
    cat > README.md << 'EOF'
# MLOps Lab Project

This project demonstrates MLOps practices using GitHub Actions.

## Setup

1. Install dependencies: `pip install -r requirements.txt`
2. Run tests: `pytest tests/`
3. Check the GitHub Actions workflows in `.github/workflows/`

## Structure

- `src/`: Source code
- `tests/`: Unit tests
- `data/`: Data files
- `models/`: Model artifacts
- `notebooks/`: Jupyter notebooks
EOF

    cat > requirements.txt << 'EOF'
pandas==1.5.0
scikit-learn==1.3.0
pytest==7.4.0
pytest-cov==4.1.0
numpy==1.24.0
matplotlib==3.6.0
seaborn==0.12.0
EOF

    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Data
*.csv
*.json
*.parquet
!data/sample_*.csv

# Models
models/*.pkl
models/*.joblib
*.h5
*.pb

# Logs
logs/
*.log

# Coverage
htmlcov/
.coverage
.coverage.*
coverage.xml
EOF

    # Create source files
    cat > src/__init__.py << 'EOF'
"""MLOps Lab Project Package"""
__version__ = "0.1.0"
EOF

    cat > src/preprocessing.py << 'EOF'
"""Data preprocessing utilities."""

import pandas as pd
from sklearn.preprocessing import StandardScaler
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def load_data(filepath: str) -> pd.DataFrame:
    """Load data from CSV file.
    
    Args:
        filepath: Path to the CSV file
        
    Returns:
        DataFrame with loaded data
    """
    logger.info(f"Loading data from {filepath}")
    return pd.read_csv(filepath)


def preprocess_data(df: pd.DataFrame) -> pd.DataFrame:
    """Basic preprocessing steps.
    
    Args:
        df: Input DataFrame
        
    Returns:
        Preprocessed DataFrame
    """
    logger.info("Starting data preprocessing")
    
    # Remove missing values
    df_clean = df.dropna()
    logger.info(f"Removed {len(df) - len(df_clean)} rows with missing values")
    
    # Scale numerical features
    numerical_cols = df_clean.select_dtypes(include=['float64', 'int64']).columns
    if len(numerical_cols) > 0:
        scaler = StandardScaler()
        df_clean[numerical_cols] = scaler.fit_transform(df_clean[numerical_cols])
        logger.info(f"Scaled {len(numerical_cols)} numerical columns")
    
    logger.info("Data preprocessing completed")
    return df_clean
EOF

    # Create test files
    cat > tests/__init__.py << 'EOF'
"""Test package"""
EOF

    cat > tests/test_preprocessing.py << 'EOF'
"""Tests for preprocessing module."""

import pytest
import pandas as pd
import numpy as np
from src.preprocessing import load_data, preprocess_data


def test_preprocess_data():
    """Test data preprocessing function."""
    # Create sample data
    data = {
        'feature1': [1, 2, 3, None, 5],
        'feature2': [1.1, 2.2, 3.3, 4.4, 5.5],
        'category': ['A', 'B', 'A', 'C', 'B']
    }
    df = pd.DataFrame(data)
    
    # Test preprocessing
    result = preprocess_data(df)
    
    # Assertions
    assert result.isnull().sum().sum() == 0, "Should have no missing values"
    assert len(result) == 4, "Should have 4 rows after removing NaN"
    assert 'category' in result.columns, "Category column should be preserved"


def test_preprocess_data_empty():
    """Test preprocessing with empty DataFrame."""
    df = pd.DataFrame()
    result = preprocess_data(df)
    assert len(result) == 0, "Empty DataFrame should remain empty"


def test_preprocess_data_no_numerical():
    """Test preprocessing with no numerical columns."""
    data = {'category': ['A', 'B', 'C']}
    df = pd.DataFrame(data)
    result = preprocess_data(df)
    assert len(result) == 3, "Should preserve all rows"
    assert list(result.columns) == ['category'], "Should preserve column"
EOF

    # Create sample data
    python3 -c "
import pandas as pd
import numpy as np

# Create sample dataset
np.random.seed(42)
data = {
    'feature1': np.random.normal(0, 1, 100),
    'feature2': np.random.normal(5, 2, 100),
    'feature3': np.random.uniform(0, 10, 100),
    'target': np.random.choice([0, 1], 100)
}

# Add some missing values
data['feature1'][5] = None
data['feature2'][15] = None

df = pd.DataFrame(data)
df.to_csv('data/sample_data.csv', index=False)
print('Sample dataset created with 100 rows and some missing values')
"

    # Initialize Git repository
    git init
    git add .
    git commit -m "Initial commit: MLOps lab project setup"
    
    print_success "Project structure created successfully"
    cd ..
}

# Configure Git
configure_git() {
    print_status "Configuring Git..."
    
    # Check if git is already configured
    if git config --global user.name &> /dev/null && git config --global user.email &> /dev/null; then
        print_success "Git already configured"
        return
    fi
    
    echo "Please enter your Git configuration details:"
    read -p "Name: " git_name
    read -p "Email: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    print_success "Git configured successfully"
}

# Create GitHub workflows
create_workflows() {
    print_status "Creating GitHub workflows..."
    
    cd mlops-lab-project
    
    # Basic CI workflow
    cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        pytest tests/ -v --cov=src --cov-report=term-missing
    
    - name: Run linting
      run: |
        pip install flake8
        flake8 src/ --max-line-length=88 --ignore=E203,W503
EOF

    git add .github/workflows/ci.yml
    git commit -m "Add CI workflow"
    
    print_success "GitHub workflows created"
    cd ..
}

# Main setup function
main() {
    echo "Starting MLOps lab environment setup..."
    echo "This script will:"
    echo "1. Check system requirements"
    echo "2. Install Anaconda (if needed)"
    echo "3. Create MLOps conda environment"
    echo "4. Setup project structure"
    echo "5. Configure Git"
    echo "6. Create GitHub workflows"
    echo ""
    
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    
    # Run checks
    check_wsl
    check_python
    check_git
    
    # Install Anaconda if needed
    if ! check_conda; then
        read -p "Install Anaconda? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_anaconda
        else
            print_warning "Anaconda not installed. Some features may not work."
        fi
    fi
    
    # Create MLOps environment
    if command -v conda &> /dev/null; then
        create_mlops_env
    fi
    
    # Setup project
    setup_project
    configure_git
    create_workflows
    
    echo ""
    print_success "🎉 MLOps lab environment setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. cd mlops-lab-project"
    echo "2. conda activate mlops (if using conda)"
    echo "3. Create a GitHub repository and push your code"
    echo "4. Follow the lab exercises in lab_activities.md"
    echo ""
    echo "Happy coding! 🚀"
}

# Run main function
main "$@"
