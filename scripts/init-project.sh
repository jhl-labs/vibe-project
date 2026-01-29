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
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Global variables
PROJECT_NAME=""
ORG_NAME=""
PROJECT_DESC=""
AUTHOR_NAME=""
CURRENT_YEAR=$(date +%Y)
AI_AGENTS=()
SELECTED_EXAMPLE=""
ENABLE_MCP=false

# Functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BOLD}${BLUE}$1${NC}"
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
    echo -e "${CYAN}ℹ $1${NC}"
}

print_step() {
    echo -e "${BOLD}→ $1${NC}"
}

# Progress indicator
show_progress() {
    local duration=$1
    local message=$2
    echo -ne "${CYAN}$message${NC}"
    for ((i=0; i<duration; i++)); do
        echo -n "."
        sleep 0.2
    done
    echo ""
}

# Check if running in a git repository
check_git() {
    if [ ! -d ".git" ]; then
        print_error "Not a git repository. Please run this script from the project root."
        exit 1
    fi
}

# Display welcome message
show_welcome() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║      🚀 Vibe Project Template Initializer                  ║"
    echo "║                                                            ║"
    echo "║      AI-Powered Development Environment Setup              ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# Get project information
get_project_info() {
    print_header "Step 1/5: Project Information"

    # Project name
    while [ -z "$PROJECT_NAME" ]; do
        read -p "$(echo -e ${BOLD}Project name${NC}) (lowercase, no spaces): " PROJECT_NAME
        if [ -z "$PROJECT_NAME" ]; then
            print_error "Project name is required"
        elif [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
            print_error "Project name must be lowercase, start with a letter, and contain only letters, numbers, and hyphens"
            PROJECT_NAME=""
        fi
    done

    # Organization/Owner
    while [ -z "$ORG_NAME" ]; do
        read -p "$(echo -e ${BOLD}GitHub organization or username${NC}): " ORG_NAME
        if [ -z "$ORG_NAME" ]; then
            print_error "Organization name is required"
        fi
    done

    # Description
    read -p "$(echo -e ${BOLD}Project description${NC}): " PROJECT_DESC
    [ -z "$PROJECT_DESC" ] && PROJECT_DESC="A project created with Vibe Project Template"

    # Author
    read -p "$(echo -e ${BOLD}Author name${NC}): " AUTHOR_NAME
    [ -z "$AUTHOR_NAME" ] && AUTHOR_NAME="$ORG_NAME"

    # Summary
    echo ""
    echo -e "${BOLD}Summary:${NC}"
    echo "  Project:      $PROJECT_NAME"
    echo "  Organization: $ORG_NAME"
    echo "  Description:  $PROJECT_DESC"
    echo "  Author:       $AUTHOR_NAME"
    echo ""

    read -p "Is this correct? (Y/n): " CONFIRM
    CONFIRM=${CONFIRM:-Y}
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        print_warning "Cancelled. Please run the script again."
        exit 0
    fi
}

# Select AI agents to configure
select_ai_agents() {
    print_header "Step 2/5: AI Agent Configuration"

    echo "Select the AI agents you plan to use (multiple selection allowed):"
    echo ""
    echo "  1) Claude Code (CLAUDE.md)"
    echo "  2) Cursor AI (.cursor/rules/*.mdc)"
    echo "  3) Roo Code (.roo/rules/*.mdc)"
    echo "  4) All of the above"
    echo "  5) None (I'll configure manually)"
    echo ""

    read -p "Enter your choice(s) separated by spaces (e.g., 1 2): " -a AGENT_CHOICES

    AI_AGENTS=()
    for choice in "${AGENT_CHOICES[@]}"; do
        case $choice in
            1) AI_AGENTS+=("claude") ;;
            2) AI_AGENTS+=("cursor") ;;
            3) AI_AGENTS+=("roo") ;;
            4) AI_AGENTS=("claude" "cursor" "roo"); break ;;
            5) AI_AGENTS=(); break ;;
        esac
    done

    if [ ${#AI_AGENTS[@]} -eq 0 ]; then
        print_info "No AI agents selected. You can configure them manually later."
    else
        print_success "Selected agents: ${AI_AGENTS[*]}"
    fi

    # MCP configuration
    echo ""
    read -p "Enable MCP (Model Context Protocol) configuration? (y/N): " ENABLE_MCP_CHOICE
    if [ "$ENABLE_MCP_CHOICE" = "y" ] || [ "$ENABLE_MCP_CHOICE" = "Y" ]; then
        ENABLE_MCP=true
        print_success "MCP configuration enabled"
    fi
}

# Select example project to initialize
select_example_project() {
    print_header "Step 3/5: Example Project (Optional)"

    echo "Would you like to initialize an example project structure?"
    echo ""
    echo "  1) TypeScript API (Express + Prisma)"
    echo "  2) Python API (FastAPI + SQLAlchemy)"
    echo "  3) None (Start from scratch)"
    echo ""

    read -p "Enter your choice [3]: " EXAMPLE_CHOICE
    EXAMPLE_CHOICE=${EXAMPLE_CHOICE:-3}

    case $EXAMPLE_CHOICE in
        1)
            SELECTED_EXAMPLE="typescript"
            print_success "TypeScript API example selected"
            ;;
        2)
            SELECTED_EXAMPLE="python"
            print_success "Python API example selected"
            ;;
        *)
            SELECTED_EXAMPLE=""
            print_info "No example selected. Starting with a clean structure."
            ;;
    esac
}

# Replace placeholders in files
replace_placeholders() {
    print_header "Step 4/5: Configuring Files"

    print_step "Replacing placeholders..."

    # Find and replace in all relevant files
    local files_to_process=$(find . -type f \( \
        -name "*.md" -o \
        -name "*.yml" -o \
        -name "*.yaml" -o \
        -name "*.json" -o \
        -name "*.ts" -o \
        -name "*.js" -o \
        -name "*.py" -o \
        -name "*.sh" -o \
        -name "*.toml" -o \
        -name "LICENSE" -o \
        -name "CODEOWNERS" -o \
        -name ".cursorrules" -o \
        -name "*.mdc" \
    \) -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./.venv/*" -not -path "./venv/*")

    local count=0
    for file in $files_to_process; do
        if [ -f "$file" ]; then
            # Replace placeholders (macOS/Linux compatible)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' \
                    -e "s/<your-project>/$PROJECT_NAME/g" \
                    -e "s/<your-org>/$ORG_NAME/g" \
                    -e "s/<project-name>/$PROJECT_NAME/g" \
                    -e "s/<your-name-or-organization>/$AUTHOR_NAME/g" \
                    -e "s/<year>/$CURRENT_YEAR/g" \
                    -e "s/<your-domain>/$ORG_NAME/g" \
                    -e "s/<maintainer-email>/$ORG_NAME@users.noreply.github.com/g" \
                    -e "s/<project-description>/$PROJECT_DESC/g" \
                    "$file" 2>/dev/null || true
            else
                sed -i \
                    -e "s/<your-project>/$PROJECT_NAME/g" \
                    -e "s/<your-org>/$ORG_NAME/g" \
                    -e "s/<project-name>/$PROJECT_NAME/g" \
                    -e "s/<your-name-or-organization>/$AUTHOR_NAME/g" \
                    -e "s/<year>/$CURRENT_YEAR/g" \
                    -e "s/<your-domain>/$ORG_NAME/g" \
                    -e "s/<maintainer-email>/$ORG_NAME@users.noreply.github.com/g" \
                    -e "s/<project-description>/$PROJECT_DESC/g" \
                    "$file" 2>/dev/null || true
            fi
            ((count++))
        fi
    done

    print_success "Processed $count files"
}

# Configure AI agents
configure_ai_agents() {
    print_step "Configuring AI agents..."

    # Remove unselected agent configurations
    for agent in claude cursor roo; do
        if [[ ! " ${AI_AGENTS[@]} " =~ " ${agent} " ]]; then
            case $agent in
                claude)
                    # Keep CLAUDE.md but add a note
                    ;;
                cursor)
                    if [ -d ".cursor" ] || [ -f ".cursorrules" ]; then
                        read -p "Remove Cursor AI config (.cursor/, .cursorrules)? (y/N): " REMOVE_CURSOR
                        if [ "$REMOVE_CURSOR" = "y" ]; then
                            rm -rf .cursor .cursorrules
                            print_info "Removed Cursor AI configuration"
                        fi
                    fi
                    ;;
                roo)
                    if [ -d ".roo" ]; then
                        read -p "Remove .roo directory (Roo not selected)? (y/N): " REMOVE_ROO
                        if [ "$REMOVE_ROO" = "y" ]; then
                            rm -rf .roo
                            print_info "Removed .roo directory"
                        fi
                    fi
                    ;;
            esac
        fi
    done

    print_success "AI agent configuration complete"
}

# Setup MCP configuration
setup_mcp() {
    if [ "$ENABLE_MCP" = true ]; then
        print_step "Setting up MCP configuration..."

        if [ -f ".mcp.json.example" ]; then
            cp .mcp.json.example .mcp.json
            print_success "Created .mcp.json from template"
            print_info "Edit .mcp.json to enable/configure MCP servers"
        fi
    fi
}

# Setup example project
setup_example_project() {
    if [ -n "$SELECTED_EXAMPLE" ]; then
        print_step "Setting up example project..."

        local example_dir="examples/${SELECTED_EXAMPLE}-api"

        if [ -d "$example_dir" ]; then
            read -p "Copy example to project root? (y/N): " COPY_EXAMPLE
            if [ "$COPY_EXAMPLE" = "y" ] || [ "$COPY_EXAMPLE" = "Y" ]; then
                # Copy example structure (excluding .git)
                cp -r "$example_dir"/* . 2>/dev/null || true
                print_success "Example project files copied to root"
            else
                print_info "Example project available at: $example_dir"
            fi
        else
            print_warning "Example directory not found: $example_dir"
        fi
    fi
}

# Setup git hooks
setup_hooks() {
    print_step "Setting up Git hooks..."

    # Check if husky is configured
    if [ -d ".husky" ]; then
        # Make hooks executable
        chmod +x .husky/pre-commit 2>/dev/null || true
        chmod +x .husky/commit-msg 2>/dev/null || true

        # Initialize husky (if package.json exists)
        if [ -f "package.json" ]; then
            if command -v npm &> /dev/null; then
                npm pkg set scripts.prepare="husky install" 2>/dev/null || true
            fi
        fi

        print_success "Git hooks configured"
    else
        print_info "No .husky directory found"
    fi
}

# Create .env file
setup_env() {
    print_step "Setting up environment..."

    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env from .env.example"
    elif [ ! -f ".env.example" ]; then
        # Create a basic .env.example
        cat > .env.example << EOF
# Environment Variables
# Copy this file to .env and fill in the values

# Application
NODE_ENV=development
PORT=3000

# Database (if applicable)
# DATABASE_URL=

# API Keys (if applicable)
# ANTHROPIC_API_KEY=
EOF
        cp .env.example .env
        print_success "Created .env and .env.example"
    else
        print_info ".env already exists"
    fi
}

# Remove template-specific files
cleanup_template() {
    print_header "Step 5/5: Cleanup"

    # Remove PROPOSAL.md if it exists
    if [ -f "PROPOSAL.md" ]; then
        read -p "Remove PROPOSAL.md? (Y/n): " REMOVE_PROPOSAL
        REMOVE_PROPOSAL=${REMOVE_PROPOSAL:-Y}
        if [ "$REMOVE_PROPOSAL" = "y" ] || [ "$REMOVE_PROPOSAL" = "Y" ]; then
            rm -f PROPOSAL.md
            print_success "Removed PROPOSAL.md"
        fi
    fi

    # Remove examples directory if example was copied
    if [ -n "$SELECTED_EXAMPLE" ] && [ "$COPY_EXAMPLE" = "y" ]; then
        read -p "Remove examples directory? (y/N): " REMOVE_EXAMPLES
        if [ "$REMOVE_EXAMPLES" = "y" ]; then
            rm -rf examples
            print_success "Removed examples directory"
        fi
    fi

    # Remove this init script from final project
    read -p "Remove init-project.sh? (Y/n): " REMOVE_INIT
    REMOVE_INIT=${REMOVE_INIT:-Y}
    if [ "$REMOVE_INIT" = "y" ] || [ "$REMOVE_INIT" = "Y" ]; then
        rm -f scripts/init-project.sh
        print_success "Removed init-project.sh"
    fi

    print_success "Cleanup complete"
}

# Initialize dependencies
init_dependencies() {
    if [ -f "package.json" ]; then
        if command -v npm &> /dev/null; then
            read -p "Install npm dependencies? (y/N): " INSTALL_DEPS
            if [ "$INSTALL_DEPS" = "y" ] || [ "$INSTALL_DEPS" = "Y" ]; then
                print_step "Installing npm dependencies..."
                npm install
                print_success "npm dependencies installed"
            fi
        fi
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        if command -v pip &> /dev/null; then
            read -p "Install Python dependencies? (y/N): " INSTALL_DEPS
            if [ "$INSTALL_DEPS" = "y" ] || [ "$INSTALL_DEPS" = "Y" ]; then
                print_step "Installing Python dependencies..."
                if [ -f "pyproject.toml" ]; then
                    pip install -e .
                else
                    pip install -r requirements.txt
                fi
                print_success "Python dependencies installed"
            fi
        fi
    fi
}

# Show next steps
show_next_steps() {
    echo ""
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║         🎉 Project Initialization Complete!                ║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${BOLD}📋 Next Steps:${NC}"
    echo ""
    echo "  1. ${BOLD}Review configuration files:${NC}"
    echo "     - README.md"
    echo "     - CLAUDE.md (AI agent instructions)"
    echo "     - .agent/context.md (Project context)"
    echo ""
    echo "  2. ${BOLD}Set up GitHub repository:${NC}"
    echo "     - Add secrets: ANTHROPIC_API_KEY (for Claude)"
    echo "     - Enable GitHub Actions"
    echo "     - Configure branch protection"
    echo "     - See: docs/guides/github-setup-checklist.md"
    echo ""
    echo "  3. ${BOLD}Start developing with AI:${NC}"
    echo "     - Read: docs/guides/getting-started.md"
    echo "     - Prompts: .agent/prompts/"
    if [ "$ENABLE_MCP" = true ]; then
        echo "     - MCP config: .mcp.json"
    fi
    echo ""
    echo "  4. ${BOLD}Commit your changes:${NC}"
    echo "     git add ."
    echo "     git commit -m \"chore: Initialize project from template\""
    echo ""

    if [ ${#AI_AGENTS[@]} -gt 0 ]; then
        echo -e "${CYAN}Selected AI Agents: ${AI_AGENTS[*]}${NC}"
    fi

    echo ""
    echo -e "${BOLD}Happy Vibe Coding! 🚀${NC}"
    echo ""
}

# Main
main() {
    show_welcome
    check_git

    get_project_info
    select_ai_agents
    select_example_project

    replace_placeholders
    configure_ai_agents
    setup_mcp
    setup_example_project
    setup_hooks
    setup_env
    cleanup_template
    init_dependencies

    show_next_steps
}

# Handle arguments
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: ./scripts/init-project.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --non-interactive  Run with defaults (for CI/CD)"
    echo ""
    echo "This script initializes a new project from the Vibe Project Template."
    echo "It will:"
    echo "  - Configure project information"
    echo "  - Set up AI agent configurations"
    echo "  - Initialize MCP (optional)"
    echo "  - Copy example project (optional)"
    echo "  - Set up git hooks and environment"
    exit 0
fi

# Run main function
main
