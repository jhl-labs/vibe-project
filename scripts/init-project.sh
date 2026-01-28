#!/bin/bash

# ===========================
# Project Initialization Script
# ===========================
# 이 스크립트는 템플릿에서 새 프로젝트를 초기화합니다.

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running in a git repository
check_git() {
    if [ ! -d ".git" ]; then
        print_error "Not a git repository. Please run this script from the project root."
        exit 1
    fi
}

# Get project information
get_project_info() {
    print_header "Project Information"

    # Project name
    read -p "Project name (lowercase, no spaces): " PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        print_error "Project name is required"
        exit 1
    fi

    # Organization/Owner
    read -p "GitHub organization or username: " ORG_NAME
    if [ -z "$ORG_NAME" ]; then
        print_error "Organization name is required"
        exit 1
    fi

    # Description
    read -p "Project description: " PROJECT_DESC

    # Author
    read -p "Author name: " AUTHOR_NAME

    # Year
    CURRENT_YEAR=$(date +%Y)

    echo ""
    print_info "Project: $PROJECT_NAME"
    print_info "Organization: $ORG_NAME"
    print_info "Description: $PROJECT_DESC"
    print_info "Author: $AUTHOR_NAME"
    echo ""

    read -p "Is this correct? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        print_warning "Cancelled. Please run the script again."
        exit 0
    fi
}

# Replace placeholders in files
replace_placeholders() {
    print_header "Replacing Placeholders"

    # Find and replace in all relevant files
    local files_to_process=$(find . -type f \( \
        -name "*.md" -o \
        -name "*.yml" -o \
        -name "*.yaml" -o \
        -name "*.json" -o \
        -name "*.ts" -o \
        -name "*.js" -o \
        -name "*.sh" -o \
        -name "LICENSE" -o \
        -name "CODEOWNERS" -o \
        -name ".cursorrules" \
    \) -not -path "./.git/*" -not -path "./node_modules/*")

    for file in $files_to_process; do
        if [ -f "$file" ]; then
            # Replace placeholders
            sed -i.bak \
                -e "s/<your-project>/$PROJECT_NAME/g" \
                -e "s/<your-org>/$ORG_NAME/g" \
                -e "s/<project-name>/$PROJECT_NAME/g" \
                -e "s/<your-name-or-organization>/$AUTHOR_NAME/g" \
                -e "s/<year>/$CURRENT_YEAR/g" \
                -e "s/<your-domain>/$ORG_NAME/g" \
                -e "s/<maintainer-email>/$ORG_NAME@users.noreply.github.com/g" \
                "$file"

            # Remove backup files
            rm -f "$file.bak"
        fi
    done

    print_success "Placeholders replaced"
}

# Setup git hooks
setup_hooks() {
    print_header "Setting Up Git Hooks"

    # Check if husky is configured
    if [ -d ".husky" ]; then
        # Make hooks executable
        chmod +x .husky/pre-commit 2>/dev/null || true
        chmod +x .husky/commit-msg 2>/dev/null || true

        # Initialize husky (if package.json exists)
        if [ -f "package.json" ]; then
            if command -v npm &> /dev/null; then
                npm pkg set scripts.prepare="husky install" 2>/dev/null || true
                print_success "Husky hooks configured"
            fi
        fi
    fi

    print_success "Git hooks setup complete"
}

# Create .env file
setup_env() {
    print_header "Setting Up Environment"

    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env from .env.example"
    else
        print_info "No .env.example found or .env already exists"
    fi
}

# Remove template-specific files
cleanup_template() {
    print_header "Cleaning Up Template Files"

    # Remove PROPOSAL.md if it exists
    if [ -f "PROPOSAL.md" ]; then
        read -p "Remove PROPOSAL.md? (y/n): " REMOVE_PROPOSAL
        if [ "$REMOVE_PROPOSAL" = "y" ] || [ "$REMOVE_PROPOSAL" = "Y" ]; then
            rm -f PROPOSAL.md
            print_success "Removed PROPOSAL.md"
        fi
    fi

    print_success "Cleanup complete"
}

# Initialize dependencies
init_dependencies() {
    print_header "Initializing Dependencies"

    if [ -f "package.json" ]; then
        if command -v npm &> /dev/null; then
            read -p "Install npm dependencies? (y/n): " INSTALL_DEPS
            if [ "$INSTALL_DEPS" = "y" ] || [ "$INSTALL_DEPS" = "Y" ]; then
                npm install
                print_success "npm dependencies installed"
            fi
        fi
    elif [ -f "requirements.txt" ]; then
        if command -v pip &> /dev/null; then
            read -p "Install Python dependencies? (y/n): " INSTALL_DEPS
            if [ "$INSTALL_DEPS" = "y" ] || [ "$INSTALL_DEPS" = "Y" ]; then
                pip install -r requirements.txt
                print_success "Python dependencies installed"
            fi
        fi
    else
        print_info "No dependency file found"
    fi
}

# Show next steps
show_next_steps() {
    print_header "Next Steps"

    echo "1. Review and update the following files:"
    echo "   - README.md"
    echo "   - CLAUDE.md"
    echo "   - .agent/context.md"
    echo "   - LICENSE (verify author info)"
    echo ""
    echo "2. Set up your development environment:"
    echo "   - Configure environment variables in .env"
    echo "   - Install dependencies (if not done)"
    echo ""
    echo "3. Configure GitHub repository:"
    echo "   - Add required secrets (ANTHROPIC_API_KEY, etc.)"
    echo "   - Enable GitHub Actions"
    echo "   - Set up branch protection rules"
    echo ""
    echo "4. Start developing:"
    echo "   - Read docs/guides/getting-started.md"
    echo "   - Check docs/guides/development.md"
    echo ""

    print_success "Project initialization complete!"
}

# Main
main() {
    print_header "Vibe Project Template Initializer"

    check_git
    get_project_info
    replace_placeholders
    setup_hooks
    setup_env
    cleanup_template
    init_dependencies
    show_next_steps
}

# Run main function
main
