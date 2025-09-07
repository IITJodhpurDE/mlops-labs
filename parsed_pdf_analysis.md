# Parsed PDF Content Analysis - MLOps Course Materials

## 📋 Complete Content Summary

Based on the extracted content from all PDF files, here's a comprehensive analysis of the course materials:

---

## 📚 **MLOps Lecture 1 - Course Introduction** (mlops_lec1.txt)

### Course Structure:
- **Evaluation**: Assignment with Viva (50%) + Major Assignment with Viva (50%)
- **Objective**: Cover ML systems, applications, and products with ML algorithms

### Topics Covered:
1. **Machine Learning Systems**: Concepts, stages (data collection to model development), challenges, solutions
2. **ML Data Structure and Processing**
3. **ML Accelerators**: ML Compilers, Virtual Environments, Git, Docker, Containers
4. **Experiment Tracking**: Reproducibility and Reusability
5. **Quantized and Low-precision ML**
6. **Deployment**: Platforms and Infrastructure
7. **ML System Management**: Versioning, Tracking, Testing, Debugging

### Traditional ML Workflow Problems:
**Example**: House Price Prediction
- **Data Collection**: Manual download, no logging
- **Preprocessing**: Jupyter notebooks, scattered code
- **Training**: Manual hyperparameter tuning
- **Saving**: Local .pkl files, no documentation
- **Deployment**: Simple Flask app, no monitoring

### Challenges Identified:
- **Fragile Pipelines**: Manual, ad hoc processes
- **Poor Reproducibility**: Difficult to recreate experiments
- **Slow Iteration**: Lack of automation
- **Scaling Issues**: Models fail with growing data

### Why MLOps Matters:
- Automation of end-to-end ML lifecycle
- Versioning & tracking of datasets, code, models
- CI/CD for ML
- Monitoring & reproducibility
- Infrastructure abstraction (Docker, Cloud-native tools)

---

## 🔧 **MLOps Day 2 - Practical Git and Environment Setup** (ml_ops_day2.txt)

### Core Activities:

#### **Task 1: Digit Classification Setup**
```bash
# Download and run scikit-learn example
wget https://scikit-learn.org/stable/_downloads/1a55101a8e49ab5d3213dadb31332045/plot_digits_classification.py

# Environment setup
conda create -n digit python=3.13
conda activate digit

# Requirements.txt content:
# matplotlib
# scikit-learn  
# pandas
# numpy

# Installation
pip install -r requirements.txt
python plot_digits_classification.py
```

#### **Git Workflow Practice**:
```bash
# Repository setup
git clone "SSH Link"
mv plot_digits_classification.py DigitClassification/
mv requirements.txt DigitClassification/

# Push changes
git add .
git commit -m "Added code and requirements"
git push
```

#### **Task 2: Regression Analysis**
Sample regression.py code provided:
```python
import numpy as np
import statsmodels.api as sm

X = np.array([1, 2, 3, 4, 5, 6, 7, 8])
y = np.array([2, 4, 5, 4, 5, 6, 5, 6])
X = sm.add_constant(X)
model = sm.OLS(y, X).fit()
print(model.summary())
y_pred = model.predict(X)
print("Predictions:", y_pred)
```

### Advanced Git Concepts:

#### **Branching Workflow**:
```bash
# Create and work with branches
git checkout -b branch1
git push -u origin branch1  # Set upstream

# Sync with remote changes
git fetch origin
git merge origin/main

# Handle divergent branches
git pull --no-rebase    # merge (default)
git pull --rebase       # rebase for linear history
git pull --ff-only      # only if fast-forward possible

# Merge back to main
git checkout main
git merge branch1
git push

# Cleanup
git branch -d branch1                    # delete local
git push origin --delete branch1        # delete remote
```

#### **Key Concepts**:
- **origin**: alias for remote repository
- **upstream branch**: remote branch tracking (e.g., origin/main)
- **git push -u**: sets upstream for future push/pull

---

## ⚙️ **MLOps Day 3 - GitHub Actions and Hyperparameters** (mlops_day3.txt)

### Prerequisites Recap:
```bash
# Standard workflow
git clone "ssh repo link"
cd "current directory"
mv ~/Downloads/plot_digits_classification.py ./
nano requirements.txt  # Add: matplotlib, scikit-learn, pandas, numpy
pip install -r requirements.txt
python3 plot_digits_classification.py
git add .
git commit -m "new changes"
git push
```

### GitHub Actions Introduction:

#### **Why GitHub Actions?**
- Manual checking is time-consuming and error-prone
- Automate checking of updates with fixed instructions and tests
- **CI/CD Pipeline**: Series of automated steps for development process
- Combines Continuous Integration (CI) and Continuous Delivery/Deployment (CD)

#### **Core Concepts**:

**Workflows**:
- Configurable automated process running one or more jobs
- Defined by YAML files in `.github/workflows` directory
- Triggered by events, manually, or on schedule
- Can handle: building/testing PRs, deploying releases, labeling issues

**Events**:
- Specific repository activities triggering workflow runs
- Examples: pull requests, issues, commits, schedules, REST API calls

**Jobs**:
- Set of steps executed on same runner
- Steps can be shell scripts or actions
- Executed in order and dependent on each other
- Can share data between steps
- Run in parallel by default (unless dependencies configured)

**Actions**:
- Custom applications for GitHub Actions platform
- Perform complex but frequently repeated tasks
- Reduce repetitive code in workflows
- Can pull Git repo, setup toolchain, setup cloud authentication

**Runners**:
- Servers running workflows when triggered
- Each runner runs single job at a time
- GitHub provides Ubuntu Linux, Windows, macOS runners
- Each run executes in fresh, newly-provisioned VM

### Practical GitHub Actions Implementation:

#### **Step-by-Step Setup**:
```bash
# Create action branch
git checkout -b actionbranch

# Create workflow structure
mkdir -p .github/workflows

# Create workflow file
touch .github/workflows/testing.yml
nano .github/workflows/testing.yml
```

#### **Sample YAML Workflow**:
```yaml
name: GitHub Actions Demo
on: [push]
jobs:
  Explore-GitHub-Actions:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.13.5]
    steps:
      - run: echo "The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v3
      - run: echo "The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: ls -r ${{ github.workspace }}
      - run: echo "This job's status is ${{ job.status }}."
      - name: Install dependencies
        run: pip3 install --no-cache-dir -r requirements.txt
      - name: Run experiment
        run: python plot_digits_classification.py
```

#### **Deployment Process**:
```bash
git add .
git commit -m "anything"
git push -u origin actionbranch
# Then: pull request → merge → confirm
```

### Hyperparameter Optimization:

#### **Concepts**:
- **Hyperparameters**: Chosen before training (learning rate, epochs, batch size)
- **Manual tuning**: Finding best combination through experimentation

#### **Task**:
```bash
# Create hyperparameter branch
git checkout -b hyperparam

# Add optimal hyperparameter selection for:
# - dev_size
# - gamma  
# - C

# Push and verify GitHub Actions trigger
git add .
git commit -m "Add hyperparameter optimization"
git push -u origin hyperparam

# Check GitHub Actions execution
# Merge with main branch
```

---

## 🏗️ **MLOps Week 1 - Environment Setup Guide** (mlops_w1.txt)

### Windows Users - WSL Setup:

#### **Prerequisites**:
- Windows users must set up Linux-like environment using WSL
- **Resources**:
  - How to Install Latest Ubuntu on Windows 11 (WSL)
  - Official guide: https://canonical-ubuntu-wsl.readthedocs-hosted.com/en/latest/guides/install-ubuntu-wsl2/
- **Note**: Linux/macOS users skip WSL setup

### GitHub SSH Setup:

#### **Essential Steps**:
1. **Check existing SSH keys**
2. **Generate new SSH key**
3. **Add SSH key to GitHub account**
4. **Test SSH connection**

#### **Repository Workflow**:
```bash
# Fork repository
# Example: https://github.com/IBM-Cloud/get-started-python
# Results in: https://github.com/yourusername/get-started-python

# Clone forked repo
git clone https://github.com/yourusername/get-started-python

# Basic workflow
git add <changed_file>              # Add to staging
git commit -m "meaningful message"  # Commit changes
git push                           # Push to remote
```

#### **Essential Git Commands**:
```bash
git init                                    # Initialize repository
git status                                  # Check status
git branch                                  # See all branches
git branch <new_branch_name>               # Create new branch
git checkout <branch_name>                 # Switch branch
git push origin <branch_name>              # Push branch to remote
git push -u origin <branch_name>           # Push and remember branch
git log                                    # View changes
git log --summary                          # Detailed changes
git log --oneline                          # Short changes
git clone ssh://git@github.com/[user]/[repo].git  # Clone repository
git merge <branch>                         # Merge branch
git pull                                   # Fetch and merge changes
git remote -v                              # List remote repositories
```

**⚠️ Warning**: Use `git push --force` only when necessary (e.g., after rebase) to avoid data loss.

### Conda Environment Management:

#### **Why Use Conda?**
- **Isolation**: Each environment is independent
- **Version Management**: Different Python versions per project
- **Dependency Management**: Prevent package conflicts
- **Reproducibility**: Consistent environments across systems

#### **Miniconda Installation (Linux)**:
```bash
# Update system (optional)
sudo apt update -y
sudo apt upgrade -y

# Install Miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

# Activate and setup
source miniconda3/bin/activate
```

#### **Environment Management Commands**:
```bash
conda create --name <env_name>                    # Create environment
conda create -n <env_name> python=3.5            # Create with specific Python
conda activate <env_name>                        # Activate environment
conda install <package_name>                     # Install package
pip install -r requirements.txt                  # Install from requirements
python hello.py                                  # Run Python file
conda deactivate                                 # Deactivate environment
conda env list                                   # List all environments
```

**Reference**: https://docs.conda.io/en/latest/miniconda.html

---

## 🎯 **Lab Activities Alignment Analysis**

### **Your Original Agenda vs. Parsed Content**:

| **Your Agenda** | **Parsed Content Coverage** | **Status** |
|----------------|----------------------------|------------|
| **Windows WSL setup** | ✅ Comprehensive WSL installation guide in mlops_w1.txt | **Covered** |
| **Anaconda setup** | ✅ Detailed Miniconda/Conda setup and usage in mlops_w1.txt | **Covered** |
| **Unix: cp, mv & git** | ✅ Extensive Git workflow coverage across all files, basic Unix usage | **Covered** |
| **GitHub Actions** | ✅ **Extensive coverage** in mlops_day3.txt with practical examples | **Main Focus ✅** |

### **Additional Content Found**:
- **MLOps Theory**: Course structure, traditional vs. modern ML workflows
- **Practical Coding**: Digit classification, regression analysis
- **Advanced Git**: Branching, merging, upstream concepts
- **Hyperparameter Optimization**: Integration with CI/CD
- **Real Projects**: scikit-learn examples, statsmodels regression

### **Lab Exercise Recommendations**:

Based on the parsed content, the original lab activities I created align well with the course materials, but can be enhanced with:

1. **Specific scikit-learn examples** from the PDFs
2. **Hyperparameter optimization workflows** 
3. **Matrix strategy testing** as shown in the YAML example
4. **SSH-based Git workflows** as emphasized in the materials
5. **Conda environment integration** with the development workflow

The parsed content confirms that **GitHub Actions is indeed the main focus** with extensive practical examples and step-by-step implementation guides.

---

## 📊 **Updated Lab Activities Recommendation**

The lab activities I originally created should be **updated** to include:

1. **Specific project examples** from the PDFs (digit classification, regression)
2. **The exact YAML workflow** provided in the course materials
3. **Hyperparameter optimization tasks** as mentioned in Day 3
4. **SSH setup procedures** as detailed in Week 1 materials
5. **Matrix testing strategies** as shown in the GitHub Actions examples

This will ensure perfect alignment between the lab exercises and the actual course content! 🎯
