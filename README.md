# MLOps Lab - Digit Classification with GitHub Actions

## 🎯 **Project Overview**

A machine learning project that classifies handwritten digits (0-9) using scikit-learn's SVM classifier, integrated with GitHub Actions for continuous integration.

## 📊 **Results**

- **Algorithm**: Support Vector Machine (SVM)
- **Dataset**: 1,797 handwritten digit samples (8x8 pixels)
- **Accuracy**: **96.89%**
- **Features**: Automated testing, visualization generation, CI/CD pipeline

## 🎯 **Learning Objectives**

By completing these labs, you will:
1. ✅ Set up a complete MLOps development environment
2. ✅ Master Git workflows for collaborative development
3. ✅ Implement automated CI/CD pipelines with GitHub Actions
4. ✅ Practice Unix commands for file management
5. ✅ Create reproducible Python environments with Conda

## 📚 Lab Structure

### Lab 1: Foundation Setup (30 minutes)
**Topics**: WSL, Anaconda, Unix commands (cp, mv), Git basics

**Key Activities**:
- Windows WSL2 installation and configuration
- Anaconda environment setup with MLOps packages
- File operations using Unix commands
- Git repository initialization and basic workflow

**Deliverables**:
- Working development environment
- Configured Python environment with MLOps tools
- Basic Git repository structure

### Lab 2: Version Control Mastery (45 minutes)
**Topics**: Advanced Git workflows, branching strategies, remote repositories

**Key Activities**:
- Feature branch development workflow
- Code collaboration using Git
- Remote repository management
- Merge conflict resolution

**Deliverables**:
- Complete Git workflow implementation
- Sample MLOps project with proper version control

### Lab 3: GitHub Actions Implementation (90 minutes) 🎯 **Main Focus**
**Topics**: CI/CD pipelines, automated testing, deployment strategies

**Key Activities**:
- Basic workflow creation and configuration
- Advanced MLOps pipeline with multiple jobs
- Matrix strategy for cross-platform testing
- Conditional deployments and environment management
- Security scanning and monitoring

**Deliverables**:
- Fully functional CI/CD pipeline
- Automated testing and deployment workflows
- Security and monitoring implementations

### Lab 4: Advanced MLOps Features (45 minutes)
**Topics**: Monitoring, alerting, custom actions, advanced patterns

**Key Activities**:
- Scheduled monitoring workflows
- Custom GitHub Actions creation
- Advanced workflow patterns
- Integration with external services

**Deliverables**:
- Production-ready MLOps pipeline
- Comprehensive monitoring and alerting system

## 🛠 Technical Stack

### Core Technologies
- **Windows WSL2**: Development environment
- **Anaconda**: Python environment management
- **Git**: Version control system
- **GitHub Actions**: CI/CD platform
- **Python**: Primary programming language

### MLOps Tools
- **pytest**: Testing framework
- **flake8**: Code linting
- **MLflow**: Experiment tracking (optional)
- **Docker**: Containerization
- **pandas/scikit-learn**: ML libraries

### DevOps Tools
- **GitHub**: Repository hosting and CI/CD
- **Codecov**: Code coverage reporting
- **Bandit/Safety**: Security scanning

## 📁 File Structure

```
labs1-3/
├── lab_activities.md          # Comprehensive lab guide
├── practical_exercises.md     # Step-by-step exercises
├── setup_lab.sh              # Automated setup script
├── README.md                  # This summary document
└── .docs/
    └── days/                  # Reference materials
        ├── ml_ops_day2.pdf
        ├── MLOps day3.docx.pdf
        ├── MLOps Lec 1 - Aug 2025.pdf
        └── MLOps_W1.pdf
```

## 🚀 Quick Start Guide

### Option 1: Automated Setup (Recommended)
```bash
# Clone or download the lab materials
cd labs1-3

# Run the automated setup script
./setup_lab.sh

# Follow the prompts to complete setup
```

### Option 2: Manual Setup
```bash
# Follow the detailed instructions in:
# 1. lab_activities.md (comprehensive guide)
# 2. practical_exercises.md (step-by-step exercises)
```

## 📋 Prerequisites

### System Requirements
- Windows 10/11 with WSL2 support
- Minimum 8GB RAM
- 5GB free disk space
- Internet connection for package downloads

### Knowledge Prerequisites
- Basic command line familiarity
- Python programming basics
- Understanding of version control concepts
- Basic knowledge of software development lifecycle

### Required Accounts
- GitHub account (free tier sufficient)
- Git configured with user credentials

## 🎯 Assessment Criteria

### Technical Skills (80%)
1. **Environment Setup** (20%)
   - WSL2 and Anaconda configuration
   - Development tools installation

2. **Version Control** (25%)
   - Git workflow implementation
   - Branch management and merging
   - Remote repository operations

3. **GitHub Actions** (40%) - **Primary Focus**
   - Basic workflow creation
   - Advanced pipeline implementation
   - Security and monitoring setup
   - Troubleshooting and optimization

4. **Best Practices** (15%)
   - Code quality and testing
   - Documentation and comments
   - Security considerations

### Practical Implementation (20%)
- Working CI/CD pipeline
- Automated testing and deployment
- Proper project organization
- Real-world applicability

## 🔧 Troubleshooting Resources

### Common Issues
1. **WSL Installation Problems**: Check Windows version and enable required features
2. **Conda Command Not Found**: Verify PATH configuration
3. **GitHub Actions Failures**: Check workflow syntax and secrets
4. **Import Errors**: Ensure proper PYTHONPATH configuration

### Support Resources
- **Lab Materials**: Comprehensive guides with troubleshooting sections
- **Setup Script**: Automated environment configuration
- **Documentation Links**: Official documentation for all tools
- **Community**: GitHub Discussions for collaboration

## 🏆 Learning Outcomes

### Upon Completion, Students Will Have:

**Technical Proficiency**:
- Fully configured MLOps development environment
- Hands-on experience with industry-standard tools
- Working knowledge of CI/CD best practices

**Practical Skills**:
- Ability to set up automated ML pipelines
- Experience with testing and deployment automation
- Understanding of security and monitoring in MLOps

**Portfolio Projects**:
- Complete MLOps project with CI/CD pipeline
- GitHub repository showcasing best practices
- Documented workflows and processes

## 🔄 Continuous Learning Path

### Next Steps After Lab Completion:
1. **Advanced MLOps**: Implement model registry and experiment tracking
2. **Cloud Integration**: Deploy pipelines to AWS/Azure/GCP
3. **Monitoring**: Set up comprehensive observability stack
4. **Security**: Implement advanced security scanning and compliance
5. **Scaling**: Handle enterprise-scale ML operations

### Recommended Follow-up Topics:
- Infrastructure as Code (Terraform/CloudFormation)
- Container orchestration (Kubernetes)
- Advanced monitoring (Prometheus/Grafana)
- MLOps platforms (Kubeflow, MLflow, etc.)

## 📞 Getting Help

### During Lab Execution:
1. **Check Documentation**: Refer to lab_activities.md for detailed explanations
2. **Run Setup Script**: Use setup_lab.sh for automated environment configuration
3. **Review Examples**: practical_exercises.md contains step-by-step examples
4. **Debugging**: Check troubleshooting sections in each guide

### Resources:
- **GitHub Actions Documentation**: https://docs.github.com/en/actions
- **MLOps Community**: https://ml-ops.org/
- **Course Materials**: Reference PDFs in .docs/days/

---

## 🎉 Success Metrics

Students successfully completing this lab series will have:

✅ **Functional Environment**: WSL2 + Anaconda + Git setup  
✅ **Working Pipeline**: Complete CI/CD with GitHub Actions  
✅ **Automated Testing**: Unit tests, linting, security scans  
✅ **Deployment Strategy**: Staging and production workflows  
✅ **Monitoring Setup**: Health checks and alerting  
✅ **Best Practices**: Security, documentation, optimization  

**Ready for Real-World MLOps Implementation! 🚀**

---

*This lab series provides a comprehensive foundation in MLOps practices with GitHub Actions as the centerpiece, preparing students for modern ML engineering roles.*
