# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive CI/CD pipeline with GitHub Actions
- Repository-wide dependency management with `cpanfile`
- Automated installation script (`install.sh`)
- Makefile for build automation and testing
- Test framework using Test::More
- Code quality standards with Perl::Critic configuration
- Comprehensive CONTRIBUTING.md guide
- Tools directory for general utility scripts
- Test directory (`t/`) with initial test suite
- Multiple new badges in README
- Quick Start section in README
- Testing & Quality section in README
- Project Roadmap in README
- Enhanced Mermaid diagrams showing new structure
- Tools README for utility documentation

### Changed
- Reorganized repository structure:
  - Created `tools/` directory for utility scripts
  - Created `t/` directory for tests
  - Created `examples/` and `docs/` directories (structure)
- Updated README with improved organization and badges
- Enhanced documentation throughout the repository
- Improved Contributing guidelines

### Consolidated
- File scanner scripts (4 variants → 1 unified `tools/file_scanner.pl`)
- Directory merge scripts (2 variants → 1 unified `tools/merge_directories.pl`)
- Removed versioned script names in favor of single canonical versions

### Removed
- Duplicate file_scanner variants (file_scanner.pl, file_scannerv2.pl, file_scan_recursdir.pl)
- Duplicate merge_dirs scripts (merge_two_directories.pl)
- Old development files in `arxiv_doi_grabber/temp/` directory
- Temporary and backup files

### Fixed
- Inconsistent naming conventions
- Missing .gitignore file
- Lack of centralized dependency management
- Missing test infrastructure

## [0.1.0] - 2024-11-08 (Pre-modernization baseline)

### Initial Repository Structure
- 17+ root-level utility scripts
- 10 specialized module directories
- Basic CI/CD for arxiv_doi_grabber only
- Individual module READMEs
- GPL-3.0 License

### Core Modules
- **arxiv_doi_grabber**: Academic metadata extraction
- **entropy_nlp**: Statistical entropy analysis
- **entropy_cleaner**: File quality assessment
- **jsonl_convertor**: ML pipeline data preparation
- **shellgenie-polyparse**: AI-powered shell automation
- **find_text**: File discovery utilities
- **clean_dupent**: Duplicate removal
- **sshlog_ips**: IP extraction from logs
- **dig**: DNS utilities
- **inference_engine_check**: Language model validation

---

## Release Notes

### Version Numbering Scheme
- **Major version**: Significant architectural changes or breaking changes
- **Minor version**: New features, improvements, or module additions
- **Patch version**: Bug fixes and minor improvements

### How to Contribute to Changelog
When making changes:
1. Add your changes under `[Unreleased]` section
2. Use categories: Added, Changed, Deprecated, Removed, Fixed, Security
3. Keep entries concise but descriptive
4. Include relevant issue/PR numbers when applicable

---

**Repository**: [Perl_GPT](https://github.com/danindiana/Perl_GPT)
**Maintained by**: [danindiana](https://github.com/danindiana)
