#!/bin/bash

# AI Agent Skills Setup Script
# Sets up skills and configuration files for various AI tools

set -e

REPO_URL="https://github.com/vshrinath/virtual-product-factory.git"
SKILLS_DIR="skills"
IS_SOURCE_REPO=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please run this script from your project root."
        exit 1
    fi
}

# Check if we're in the virtual-product-factory source repo
check_source_repo() {
    if [ -d "coding" ] && [ -d "product" ] && [ -d "marketing" ] && [ -d "design" ] && [ -d "meta" ] && [ -d "ops" ]; then
        if [ -f "INDEX.md" ] && [ -f "AGENTS.md" ]; then
            IS_SOURCE_REPO=true
            print_status "Detected virtual-product-factory source repository"
        fi
    fi
}

# Setup skills as git submodule
setup_skills_submodule() {
    if [ "$IS_SOURCE_REPO" = true ]; then
        print_status "Running in source repo - skipping submodule setup"
        return
    fi
    
    print_status "Setting up AI agent skills as git submodule..."
    
    if [ -d "$SKILLS_DIR" ]; then
        print_warning "Skills directory already exists. Skipping submodule setup."
        return
    fi
    
    git submodule add "$REPO_URL" "$SKILLS_DIR"
    git submodule update --init --recursive
    
    print_success "Skills submodule added successfully"
}

# Setup skills as direct clone (for non-git projects)
setup_skills_clone() {
    if [ "$IS_SOURCE_REPO" = true ]; then
        print_status "Running in source repo - skipping clone"
        return
    fi
    
    print_status "Cloning AI agent skills repository..."
    
    if [ -d "$SKILLS_DIR" ]; then
        print_warning "Skills directory already exists. Skipping clone."
        return
    fi
    
    git clone "$REPO_URL" "$SKILLS_DIR"
    rm -rf "$SKILLS_DIR/.git"  # Remove git history for direct copy
    
    print_success "Skills cloned successfully"
}

# Copy configuration files to project root
setup_config_files() {
    print_status "Setting up configuration files..."
    
    local source_dir="."
    if [ "$IS_SOURCE_REPO" = false ] && [ -d "$SKILLS_DIR" ]; then
        source_dir="$SKILLS_DIR"
    fi
    
    # Copy AGENTS.md if it doesn't exist
    if [ ! -f "AGENTS.md" ] && [ -f "$source_dir/AGENTS.md" ]; then
        cp "$source_dir/AGENTS.md" "AGENTS.md"
        print_success "AGENTS.md copied to project root"
    else
        print_warning "AGENTS.md already exists. Skipping."
    fi
    
    # Copy CONVENTIONS.md template if it doesn't exist
    if [ ! -f "CONVENTIONS.md" ] && [ -f "$source_dir/CONVENTIONS.md" ]; then
        cp "$source_dir/CONVENTIONS.md" "CONVENTIONS.md"
        print_success "CONVENTIONS.md template copied to project root"
        print_warning "Please customize CONVENTIONS.md for your project"
    else
        print_warning "CONVENTIONS.md already exists. Skipping."
    fi
}

# Setup all AI tools with symlinks to AGENTS.md
setup_all_tools() {
    print_status "Setting up AI tool configurations (symlinked to AGENTS.md)..."
    
    # Cursor
    mkdir -p .cursor
    ln -sf ../AGENTS.md .cursor/rules.md 2>/dev/null || true
    ln -sf AGENTS.md .cursorrules 2>/dev/null || true
    
    # GitHub Copilot
    mkdir -p .github
    ln -sf ../AGENTS.md .github/copilot-instructions.md 2>/dev/null || true
    
    # Windsurf
    ln -sf AGENTS.md .windsurfrules 2>/dev/null || true
    
    # Claude
    ln -sf AGENTS.md claude.md 2>/dev/null || true
    
    # Gemini
    ln -sf AGENTS.md gemini-rules.md 2>/dev/null || true
    ln -sf CONVENTIONS.md gemini-conventions.md 2>/dev/null || true
    
    # Antigravity
    ln -sf AGENTS.md antigravity-rules.md 2>/dev/null || true
    ln -sf CONVENTIONS.md antigravity-conventions.md 2>/dev/null || true
    
    # Codex
    ln -sf AGENTS.md codex-rules.md 2>/dev/null || true
    ln -sf CONVENTIONS.md codex-conventions.md 2>/dev/null || true
    
    print_success "All AI tools configured (symlinked to AGENTS.md)"
}

# Setup Kiro configuration
setup_kiro() {
    print_status "Setting up Kiro configuration..."
    
    # Kiro expects skills in .kiro/skills/ directory
    mkdir -p .kiro/skills
    
    # Determine source directory for skills
    local source_dir="."
    if [ "$IS_SOURCE_REPO" = false ] && [ -d "$SKILLS_DIR" ]; then
        source_dir="$SKILLS_DIR"
    fi
    
    # Symlink skills from source to Kiro's expected location
    if [ -d "$source_dir/coding" ]; then
        # We need relative paths for symlinks to work correctly
        local rel_source="../../"
        if [ "$IS_SOURCE_REPO" = false ] && [ -d "$SKILLS_DIR" ]; then
            rel_source="../../$SKILLS_DIR/"
        fi
        
        ln -sf "${rel_source}coding" .kiro/skills/coding 2>/dev/null || true
        ln -sf "${rel_source}design" .kiro/skills/design 2>/dev/null || true
        ln -sf "${rel_source}marketing" .kiro/skills/marketing 2>/dev/null || true
        ln -sf "${rel_source}meta" .kiro/skills/meta 2>/dev/null || true
        ln -sf "${rel_source}ops" .kiro/skills/ops 2>/dev/null || true
        ln -sf "${rel_source}product" .kiro/skills/product 2>/dev/null || true
        print_success "Skills symlinked to .kiro/skills/"
    fi
    
    # Copy brand template if brand.md doesn't exist
    if [ ! -f "brand/brand.md" ] && [ -d "$source_dir/brand" ]; then
        mkdir -p brand/assets
        cp "$source_dir/brand/brand-template.md" brand/brand.md
        cp "$source_dir/brand/brand-template.md" brand/brand-template.md
        if [ -f "$source_dir/brand/README.md" ]; then
            cp "$source_dir/brand/README.md" brand/
        fi
        touch brand/assets/.gitkeep
        print_success "Brand template copied to brand/brand.md"
    fi
    
    # Symlink AGENTS.md to Kiro steering
    mkdir -p .kiro/steering
    ln -sf ../../AGENTS.md .kiro/steering/agents.md 2>/dev/null || true
    
    print_success "Kiro configuration complete"
}

# Main setup function
main() {
    echo "🤖 AI Agent Skills Setup"
    echo "======================="
    echo
    
    # Check if we're in the source repo first
    check_source_repo
    
    # Parse command line arguments
    SETUP_TYPE="submodule"
    TOOLS="all"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --clone)
                SETUP_TYPE="clone"
                shift
                ;;
            --submodule)
                SETUP_TYPE="submodule"
                shift
                ;;
            --tools)
                TOOLS="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo
                echo "Options:"
                echo "  --submodule    Setup skills as git submodule (default)"
                echo "  --clone        Setup skills as direct clone"
                echo "  --tools TOOLS  Comma-separated list of tools to configure"
                echo "                 Options: all,kiro"
                echo "  --help         Show this help message"
                echo
                echo "Examples:"
                echo "  $0                                    # Setup with defaults"
                echo "  $0 --clone                            # Clone skills, setup all tools"
                echo "  $0 --tools kiro                       # Setup Kiro only"
                echo
                echo "Note: When run in the virtual-product-factory source repo, submodule/clone is skipped."
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Setup skills (skip if in source repo)
    if [ "$IS_SOURCE_REPO" = false ]; then
        if [ "$SETUP_TYPE" = "submodule" ]; then
            check_git_repo
            setup_skills_submodule
        else
            setup_skills_clone
        fi
    fi
    
    # Setup configuration files
    setup_config_files
    
    # Setup tools
    if [ "$TOOLS" = "all" ]; then
        setup_all_tools
        setup_kiro
    elif [ "$TOOLS" = "kiro" ]; then
        setup_kiro
    else
        print_warning "Unknown tools option: $TOOLS"
    fi
    
    echo
    print_success "Setup complete!"
    echo
    echo "📋 Next steps:"
    echo "1. Customize CONVENTIONS.md for your project"
    echo "2. Customize brand/brand.md for your brand (copy from brand/brand-template.md)"
    echo "3. Add brand assets to brand/assets/"
    echo "4. Commit the changes to your repository"
    echo "5. Note: This library uses nested submodules. Always use 'git submodule update --init --recursive' to keep everything up to date."
    echo
    echo "🔧 All AI tools now read from AGENTS.md as the canonical source"
    echo "   To update instructions, edit AGENTS.md only"
    echo
    echo "📚 Available skills: @pm, @task-decomposition, @decision-framework, @arch, @dev,"
    echo "   @guard, @qa, @self-review, @debugging, @refactoring, @api-design, @data-modeling,"
    echo "   @performance, @frontend-perf, @video-ai, @video, @writer, @seo, @perf, @ux,"
    echo "   @confidence-scoring, @context-strategy, @error-recovery, @memory"
}

# Run main function
main "$@"
