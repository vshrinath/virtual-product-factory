#!/usr/bin/env node

'use strict';

const fs = require('fs');
const path = require('path');
const { execSync, spawnSync } = require('child_process');

// ─── Colours ──────────────────────────────────────────────────────────────────
const c = {
  reset: '\x1b[0m',
  blue:  '\x1b[34m',
  green: '\x1b[32m',
  yellow:'\x1b[33m',
  red:   '\x1b[31m',
};

const info    = (msg) => console.log(`${c.blue}[INFO]${c.reset} ${msg}`);
const success = (msg) => console.log(`${c.green}[SUCCESS]${c.reset} ${msg}`);
const warn    = (msg) => console.log(`${c.yellow}[WARNING]${c.reset} ${msg}`);
const error   = (msg) => console.error(`${c.red}[ERROR]${c.reset} ${msg}`);

// ─── Helpers ──────────────────────────────────────────────────────────────────
const REPO_URL = 'https://github.com/vshrinath/virtual-product-factory.git';

/** Directory where this package's files live (works both locally and from npx cache). */
const PKG_DIR = path.resolve(__dirname, '..');

/** Current working directory of the user invoking the CLI. */
const CWD = process.cwd();

function isSourceRepo() {
  const dirs = ['coding', 'product', 'marketing', 'design', 'meta', 'ops'];
  const files = ['INDEX.md', 'AGENTS.md'];
  return (
    dirs.every((d) => fs.existsSync(path.join(CWD, d))) &&
    files.every((f) => fs.existsSync(path.join(CWD, f)))
  );
}

function isGitRepo() {
  try {
    execSync('git rev-parse --git-dir', { cwd: CWD, stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

function run(cmd, opts = {}) {
  return spawnSync(cmd, { shell: true, cwd: CWD, stdio: 'inherit', ...opts });
}

function copyFile(src, dest) {
  if (!fs.existsSync(src)) return false;
  fs.copyFileSync(src, dest);
  return true;
}

function symlink(target, linkPath) {
  try {
    if (fs.existsSync(linkPath) || fs.lstatSync(linkPath).isSymbolicLink()) {
      fs.unlinkSync(linkPath);
    }
  } catch { /* doesn't exist yet */ }
  try {
    fs.symlinkSync(target, linkPath);
  } catch { /* ignore e.g. Windows without elevated perms */ }
}

// ─── Setup steps ──────────────────────────────────────────────────────────────
function setupSubmodule() {
  const skillsDir = path.join(CWD, 'skills');
  if (fs.existsSync(skillsDir)) {
    warn('skills/ directory already exists. Skipping submodule setup.');
    return;
  }
  info('Adding virtual-product-factory as a git submodule at skills/…');
  const r = run(`git submodule add "${REPO_URL}" skills && git submodule update --init --recursive`);
  if (r.status !== 0) {
    error('git submodule add failed. Try --clone instead.');
    process.exit(1);
  }
  success('Submodule added at skills/');
}

function setupClone() {
  const skillsDir = path.join(CWD, 'skills');
  if (fs.existsSync(skillsDir)) {
    warn('skills/ directory already exists. Skipping clone.');
    return;
  }
  info('Cloning virtual-product-factory into skills/…');
  const r = run(`git clone "${REPO_URL}" skills`);
  if (r.status !== 0) {
    error('git clone failed.');
    process.exit(1);
  }
  // Remove .git so it's a plain copy
  fs.rmSync(path.join(skillsDir, '.git'), { recursive: true, force: true });
  success('Cloned into skills/ (plain copy, no .git)');
}

function setupConfigFiles(sourceDir) {
  info('Copying configuration files…');

  const agentsSrc  = path.join(sourceDir, 'AGENTS.md');
  const agentsDest = path.join(CWD, 'AGENTS.md');
  if (!fs.existsSync(agentsDest)) {
    if (copyFile(agentsSrc, agentsDest)) success('AGENTS.md copied to project root');
  } else {
    warn('AGENTS.md already exists. Skipping.');
  }

  const convSrc  = path.join(sourceDir, 'CONVENTIONS.md');
  const convDest = path.join(CWD, 'CONVENTIONS.md');
  if (!fs.existsSync(convDest)) {
    if (copyFile(convSrc, convDest)) {
      success('CONVENTIONS.md template copied to project root');
      warn('Customize CONVENTIONS.md for your project.');
    }
  } else {
    warn('CONVENTIONS.md already exists. Skipping.');
  }
}

function setupAllTools() {
  info('Setting up AI tool configurations (symlinked to AGENTS.md)…');

  // .cursor/rules.md
  fs.mkdirSync(path.join(CWD, '.cursor'), { recursive: true });
  symlink('../AGENTS.md', path.join(CWD, '.cursor', 'rules.md'));
  symlink('AGENTS.md',   path.join(CWD, '.cursorrules'));

  // GitHub Copilot
  fs.mkdirSync(path.join(CWD, '.github'), { recursive: true });
  symlink('../AGENTS.md', path.join(CWD, '.github', 'copilot-instructions.md'));

  // Windsurf / Claude / Gemini / Antigravity / Codex
  for (const name of ['.windsurfrules', 'claude.md', 'gemini-rules.md', 'antigravity-rules.md', 'codex-rules.md']) {
    symlink('AGENTS.md', path.join(CWD, name));
  }
  for (const name of ['gemini-conventions.md', 'antigravity-conventions.md', 'codex-conventions.md']) {
    symlink('CONVENTIONS.md', path.join(CWD, name));
  }

  success('All AI tools configured (symlinked to AGENTS.md)');
}

function setupKiro(sourceDir) {
  info('Setting up Kiro configuration…');

  fs.mkdirSync(path.join(CWD, '.kiro', 'skills'), { recursive: true });

  if (fs.existsSync(path.join(sourceDir, 'coding'))) {
    // Symlink the entire source dir under .kiro/skills
    const kiroSkills = path.join(CWD, '.kiro', 'skills');
    // Remove existing symlink/dir and replace
    try { fs.rmSync(kiroSkills, { recursive: true, force: true }); } catch {}
    const rel = path.relative(path.join(CWD, '.kiro'), sourceDir);
    symlink(rel, kiroSkills);
    success('Skills symlinked to .kiro/skills/');
  }

  // Brand template
  const brandSrc  = path.join(sourceDir, 'brand', 'brand-template.md');
  const brandDest = path.join(CWD, 'brand', 'brand.md');
  if (!fs.existsSync(brandDest) && fs.existsSync(brandSrc)) {
    fs.mkdirSync(path.join(CWD, 'brand', 'assets'), { recursive: true });
    copyFile(brandSrc, brandDest);
    copyFile(brandSrc, path.join(CWD, 'brand', 'brand-template.md'));
    const brandReadme = path.join(sourceDir, 'brand', 'README.md');
    if (fs.existsSync(brandReadme)) copyFile(brandReadme, path.join(CWD, 'brand', 'README.md'));
    fs.writeFileSync(path.join(CWD, 'brand', 'assets', '.gitkeep'), '');
    success('Brand template copied to brand/brand.md');
  }

  // Kiro steering
  fs.mkdirSync(path.join(CWD, '.kiro', 'steering'), { recursive: true });
  symlink('../../AGENTS.md', path.join(CWD, '.kiro', 'steering', 'agents.md'));

  success('Kiro configuration complete');
}

// ─── Commands ─────────────────────────────────────────────────────────────────
function cmdInit(argv) {
  console.log('\n🤖 Virtual Product Factory — Setup');
  console.log('====================================\n');

  const useClone = argv.includes('--clone');
  const toolsArg = (() => {
    const i = argv.indexOf('--tools');
    return i !== -1 ? argv[i + 1] : 'all';
  })();

  const inSource = isSourceRepo();
  if (inSource) info('Detected virtual-product-factory source repo — skipping submodule/clone step.');

  // 1. Acquire skills
  if (!inSource) {
    if (useClone) {
      setupClone();
    } else {
      if (!isGitRepo()) {
        error('Not inside a git repository. Use --clone for non-git projects.');
        process.exit(1);
      }
      setupSubmodule();
    }
  }

  // Resolve where the skill files live
  const sourceDir = inSource ? PKG_DIR : path.join(CWD, 'skills');

  // 2. Config files
  setupConfigFiles(sourceDir);

  // 3. Tool integrations
  if (toolsArg === 'all') {
    setupAllTools();
    setupKiro(sourceDir);
  } else if (toolsArg === 'kiro') {
    setupKiro(sourceDir);
  } else {
    warn(`Unknown --tools value: ${toolsArg}`);
  }

  console.log('\n' + c.green + 'Setup complete!' + c.reset + '\n');
  console.log('📋 Next steps:');
  console.log('   1. Customize CONVENTIONS.md for your project');
  console.log('   2. Customize brand/brand.md for your brand');
  console.log('   3. Add brand assets to brand/assets/');
  console.log('   4. Commit the changes\n');
  console.log('🔧 All AI tools now read from AGENTS.md as the canonical source.');
  console.log('📚 Available skills: see INDEX.md for the full skill reference.\n');
}

function cmdHelp() {
  console.log(`
Virtual Product Factory — CLI

Usage:
  npx virtual-product-factory [command] [options]
  npx vpf                      [command] [options]

Commands:
  init          Set up the factory in the current project (default)
  help          Show this help message

Options (for init):
  --clone       Clone the skills repo instead of adding a git submodule
  --tools <t>   Which tool integrations to configure: all (default) | kiro

Examples:
  npx virtual-product-factory               # init with defaults (git submodule)
  npx virtual-product-factory init --clone  # use direct clone instead
  npx virtual-product-factory init --tools kiro
`);
}

// ─── Entry point ──────────────────────────────────────────────────────────────
const args = process.argv.slice(2);
const cmd  = args[0];

if (!cmd || cmd === 'init') {
  cmdInit(args.filter((a) => a !== 'init'));
} else if (cmd === 'help' || cmd === '--help' || cmd === '-h') {
  cmdHelp();
} else {
  error(`Unknown command: ${cmd}`);
  cmdHelp();
  process.exit(1);
}
