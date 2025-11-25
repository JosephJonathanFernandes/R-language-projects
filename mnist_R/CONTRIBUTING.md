# Contributing to MNIST Shiny Super-App

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🤝 How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected vs actual behavior**
- **Screenshots** if applicable
- **Environment details**:
  - R version (`R.version.string`)
  - Package versions (`sessionInfo()`)
  - Operating System

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide detailed description** of the proposed functionality
- **Explain why this enhancement would be useful**
- **List any alternative solutions** you've considered

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes**:
   - Follow the code style guidelines below
   - Add comments for complex logic
   - Update documentation as needed
3. **Test your changes**:
   - Ensure the app runs without errors
   - Test all tabs and features
   - Verify models train correctly
4. **Update the README** if you changed functionality
5. **Update CHANGELOG.md** with your changes
6. **Submit a pull request**

## 📝 Code Style Guidelines

### R Code Style

Follow the [tidyverse style guide](https://style.tidyverse.org/):

```r
# Good
calculate_accuracy <- function(predictions, labels) {
  mean(predictions == labels)
}

# Avoid
calculateAccuracy<-function(predictions,labels){mean(predictions==labels)}
```

### Key Conventions

- **Indentation**: 2 spaces (no tabs)
- **Line length**: Maximum 80 characters when possible
- **Naming**:
  - Functions: `snake_case`
  - Variables: `snake_case`
  - Constants: `UPPER_SNAKE_CASE`
- **Comments**: Use `#` for single-line, `###` for section headers

### Shiny Specific

```r
# UI: Organize by tabs
ui <- navbarPage("Title",
  tabPanel("Tab1",
    # Tab content
  ),
  tabPanel("Tab2",
    # Tab content
  )
)

# Server: Group related reactives
server <- function(input, output, session) {
  # Data loading
  # Model training
  # Visualizations
  # Event handlers
}
```

## 🧪 Testing

Before submitting:

1. **Run the app** and test all features:
   ```r
   shiny::runApp("app.R")
   ```

2. **Test all tabs**:
   - MNIST Viewer
   - Train Models
   - Visualization
   - Prediction
   - Model Comparison
   - CNN Insights

3. **Check for errors** in R console

4. **Test with different inputs**:
   - Different image indices
   - Various model training configurations
   - Drawing canvas functionality

## 📚 Documentation

### Code Comments

```r
# Brief description of function purpose
# @param param_name Description of parameter
# @return Description of return value
function_name <- function(param_name) {
  # Implementation
}
```

### README Updates

If you add features:
- Update the Features section
- Add usage instructions
- Update technical details if architecture changes

## 🎯 Priority Areas for Contribution

We especially welcome contributions in:

### High Priority
- 🐛 Bug fixes
- 📊 Additional visualization methods
- 🤖 New ML models (XGBoost, Neural Networks, etc.)
- ♿ Accessibility improvements
- 🎨 UI/UX enhancements

### Medium Priority
- 📈 Performance optimizations
- 🧪 Unit tests
- 📱 Mobile responsiveness
- 🌐 Internationalization (i18n)

### Nice to Have
- 🎨 Themes (dark mode, custom colors)
- 📊 Export functionality (models, plots, results)
- 🔄 Model comparison enhancements
- 📖 Tutorial/walkthrough mode

## 🔍 Code Review Process

All submissions require review. We review pull requests for:

1. **Functionality**: Does it work as intended?
2. **Code quality**: Is it readable and maintainable?
3. **Documentation**: Are changes documented?
4. **Style**: Does it follow style guidelines?
5. **Testing**: Has it been tested?

## 📋 Commit Message Guidelines

Use clear and meaningful commit messages:

```bash
# Good
git commit -m "Add confusion matrix visualization for Random Forest"
git commit -m "Fix canvas drawing on mobile devices"
git commit -m "Update README with new visualization examples"

# Avoid
git commit -m "fixed stuff"
git commit -m "updates"
git commit -m "wip"
```

### Commit Message Format

```
<type>: <short description>

<optional longer description>
<optional issue references>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

## 🏗️ Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/mnist_R.git
   cd mnist_R
   ```

2. **Install dependencies**:
   ```r
   source("install_packages.R")
   ```

3. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make changes and test**

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: add your feature"
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**

## 📞 Questions?

- Open an issue for questions
- Tag issues with `question` label
- Check existing issues first

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in this project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Unacceptable behavior:**
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## 🎉 Recognition

Contributors will be recognized in:
- README.md acknowledgments section
- CHANGELOG.md for specific contributions
- GitHub contributors page

Thank you for contributing! 🙏
