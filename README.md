# Perl_GPT

> A comprehensive collection of AI-generated Perl utilities for text processing, data analysis, file management, and system automation.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Perl Version](https://img.shields.io/badge/perl-v5.34%2B-blue)](https://www.perl.org/)

## 📋 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Functional Categories](#functional-categories)
- [Key Utilities](#key-utilities)
- [Technology Stack](#technology-stack)
- [Installation & Usage](#installation--usage)
- [Perl Use Cases](#perl-use-cases)
- [Contributing](#contributing)

---

## Overview

**Perl_GPT** is a curated collection of 24+ Perl scripts and utilities, organized into specialized modules for various data processing, file management, and automation tasks. The repository demonstrates Perl's strengths in text processing while incorporating modern workflows for machine learning, NLP, and data science.

### Key Features

- 🔍 **Text Processing & Analysis** - Entropy calculations, duplicate removal, pattern matching
- 📊 **Data Format Conversion** - JSONL conversion for ML pipelines, metadata extraction
- 📁 **File Management** - Directory merging, file scanning, safe deletion utilities
- 🔬 **Academic Tools** - DOI/arXiv metadata extraction
- 🌐 **Network Utilities** - IP extraction, DNS query preparation
- 🤖 **AI Integration** - ShellGenie polymorphic parser with LM support

---

## Repository Structure

```mermaid
graph TB
    Root[Perl_GPT Repository]

    Root --> Utils[Root Utilities<br/>17 Scripts]
    Root --> Dirs[Specialized Directories<br/>12 Modules]

    Dirs --> EC[entropy_cleaner<br/>File Quality]
    Dirs --> EN[entropy_nlp<br/>Statistical Analysis]
    Dirs --> AG[arxiv_doi_grabber<br/>Metadata Extraction]
    Dirs --> JC[jsonl_convertor<br/>Format Conversion]
    Dirs --> FT[find_text<br/>File Discovery]
    Dirs --> CD[clean_dupent<br/>Duplicate Removal]
    Dirs --> SI[sshlog_ips<br/>IP Extraction]
    Dirs --> DG[dig<br/>DNS Utilities]
    Dirs --> IE[inference_engine_check<br/>LM Validation]
    Dirs --> SG[shellgenie-polyparse<br/>Command Parser]

    Utils --> FS[File Scanners<br/>5 variants]
    Utils --> FM[File Management<br/>merge, delete, size]
    Utils --> TP[Text Processing<br/>concat, clean, mutate]

    style Root fill:#e1f5ff
    style Dirs fill:#fff4e1
    style Utils fill:#e8f5e9
    style EC fill:#f3e5f5
    style EN fill:#f3e5f5
    style AG fill:#ffe0b2
    style JC fill:#ffe0b2
    style SG fill:#ffccbc
```

### Directory Organization

```mermaid
graph LR
    A[Perl_GPT] --> B[entropy_cleaner]
    A --> C[entropy_nlp]
    A --> D[arxiv_doi_grabber]
    A --> E[jsonl_convertor]
    A --> F[find_text]
    A --> G[clean_dupent]
    A --> H[sshlog_ips]
    A --> I[dig]
    A --> J[inference_engine_check]
    A --> K[shellgenie-polyparse]

    B --> B1[clean_by_entropy.pl]
    B --> B2[readme.md]

    C --> C1[ShannJensKL_EntropyCalc.pl]
    C --> C2[entrop_calc_deepseekcoder.pl]
    C --> C3[entrop_calc_errchk.pl]

    D --> D1[metadata_extractor.pl]
    D --> D2[readme.md]
    D --> D3[best_practices.md]

    K --> K1[gpt40/]
    K --> K2[gemma9B8q-gpt40/]

    style A fill:#4CAF50,color:#fff
    style B fill:#9C27B0,color:#fff
    style C fill:#9C27B0,color:#fff
    style D fill:#FF9800,color:#fff
    style E fill:#FF9800,color:#fff
    style K fill:#F44336,color:#fff
```

---

## Functional Categories

```mermaid
mindmap
  root((Perl_GPT<br/>Utilities))
    Text Processing
      Entropy Analysis
      Pattern Matching
      Duplicate Removal
      HTML Cleaning
      Whitespace Normalization
    Data Conversion
      JSONL Format
      URL Mutation
      Metadata Extraction
      Tokenization
    File Management
      Directory Merging
      File Scanning
      Safe Deletion
      Size Analysis
      Recursive Search
    Data Science
      Shannon Entropy
      KL Divergence
      JS Divergence
      NLP Utilities
      Dataset Cleaning
    Network & System
      IP Extraction
      DNS Query Prep
      SSH Log Analysis
      Bash History Cleaning
    Academic Research
      DOI Extraction
      arXiv Metadata
      Citation Management
    AI Integration
      LM Engine Check
      ShellGenie Parser
      Command Automation
```

---

## Key Utilities

### Data Quality & Cleaning

```mermaid
flowchart LR
    A[Input Directory] --> B{entropy_cleaner}
    B --> C[Calculate Shannon Entropy]
    C --> D{Entropy < 3.5?}
    D -->|Yes| E[Mark for Deletion]
    D -->|No| F[Keep File]
    E --> G[User Confirmation]
    G -->|Confirm| H[Delete Low-Quality Files]
    G -->|Cancel| I[Abort Operation]
    F --> J[Statistics Report]
    H --> J

    style B fill:#9C27B0,color:#fff
    style C fill:#673AB7,color:#fff
    style H fill:#F44336,color:#fff
    style J fill:#4CAF50,color:#fff
```

**entropy_cleaner** - Removes low-entropy (repetitive/redundant) files using Shannon entropy calculations.

---

### Metadata Extraction Pipeline

```mermaid
sequenceDiagram
    participant U as User
    participant S as metadata_extractor.pl
    participant F as File System
    participant A as arXiv API
    participant D as DOI Service
    participant J as JSON Output

    U->>S: Provide directory path
    S->>F: Scan for .txt files
    F-->>S: Return file list

    loop For each file
        S->>F: Read file content
        S->>S: Extract DOI/arXiv IDs (regex)

        alt Has arXiv ID
            S->>A: Fetch metadata
            A-->>S: Return arXiv data
        end

        alt Has DOI
            S->>D: Fetch metadata
            D-->>S: Return DOI data
        end

        S->>J: Save *_extracted.json
    end

    S->>U: Processing complete + statistics

    style S fill:#FF9800,color:#fff
    style J fill:#4CAF50,color:#fff
```

**arxiv_doi_grabber** - Extracts academic metadata from documents and fetches detailed information from DOI/arXiv APIs.

---

### JSONL Conversion Workflow

```mermaid
flowchart TB
    A[Start: txt_jsonl_convert.pl] --> B[Prompt for directory]
    B --> C{Recursive scan?}
    C -->|Yes| D[Find all .txt recursively]
    C -->|No| E[Find .txt in current dir]
    D --> F[Initialize JSONL output]
    E --> F
    F --> G[Process files sequentially]

    G --> H{File size OK?}
    H -->|Yes| I[Extract metadata]
    H -->|No| J[Skip file]

    I --> K[Create JSONL record]
    K --> L{Output > 2GB?}
    L -->|Yes| M[Rotate to new file]
    L -->|No| N[Append to current]

    M --> O[Continue processing]
    N --> O
    J --> O

    O --> P{More files?}
    P -->|Yes| G
    P -->|No| Q[Report statistics]
    Q --> R[End]

    style A fill:#4CAF50,color:#fff
    style K fill:#FF9800,color:#fff
    style M fill:#F44336,color:#fff
    style Q fill:#2196F3,color:#fff
```

**jsonl_convertor** - Converts text files to JSONL format with metadata for machine learning pipelines.

---

### Entropy Analysis Methods

```mermaid
graph TB
    subgraph "Statistical Measures"
        A[Input Text File] --> B[Character Frequency Analysis]
        B --> C1[Shannon Entropy]
        B --> C2[Kullback-Leibler Divergence]
        B --> C3[Jensen-Shannon Divergence]

        C1 --> D1["H(X) = -Σ p(x) log₂ p(x)"]
        C2 --> D2["KL(P||Q) = Σ P(i) log(P(i)/Q(i))"]
        C3 --> D3["JS(P||Q) = ½[KL(P||M) + KL(Q||M)]"]

        D1 --> E[Entropy Score]
        D2 --> E
        D3 --> E

        E --> F{Threshold Check}
        F -->|High Entropy| G[Quality Content]
        F -->|Low Entropy| H[Repetitive/Junk]
    end

    style C1 fill:#9C27B0,color:#fff
    style C2 fill:#673AB7,color:#fff
    style C3 fill:#512DA8,color:#fff
    style G fill:#4CAF50,color:#fff
    style H fill:#F44336,color:#fff
```

**entropy_nlp** - Advanced statistical analysis using Shannon entropy, KL divergence, and JS divergence for NLP tasks.

---

### ShellGenie Architecture

```mermaid
flowchart LR
    A[User Natural Language Input] --> B[Language Model<br/>GPT-4 / Gemma 9B]
    B --> C[Command Intent Parser]
    C --> D[Polymorphic Perl Parser]
    D --> E{Command Pattern<br/>Registry}

    E --> F1[File Operations]
    E --> F2[System Admin]
    E --> F3[Network Tasks]
    E --> F4[Custom Commands]

    F1 --> G[Parameter Validation]
    F2 --> G
    F3 --> G
    F4 --> G

    G --> H[Bash Execution Engine]
    H --> I[Output Handler]
    I --> J[User Response]

    style B fill:#4CAF50,color:#fff
    style D fill:#FF9800,color:#fff
    style E fill:#2196F3,color:#fff
    style H fill:#F44336,color:#fff
```

**shellgenie-polyparse** - Advanced polymorphic command parser integrating AI language models for natural language shell automation.

---

## Technology Stack

```mermaid
graph TB
    subgraph "Core Language"
        A[Perl 5.34+]
    end

    subgraph "Standard Modules"
        B1[strict/warnings]
        B2[File::Find]
        B3[File::Basename]
        B4[Time::Piece]
        B5[JSON]
        B6[LWP::UserAgent]
        B7[Term::ANSIColor]
        B8[Data::Dumper]
    end

    subgraph "Specialized Modules"
        C1[Math::BaseCalc]
        C2[Data::UUID]
        C3[Digest::MD5]
        C4[List::Util]
    end

    subgraph "External Tools"
        D1[Bash/Shell]
        D2[Docker]
        D3[Python 3.x]
    end

    subgraph "AI/ML Integration"
        E1[GPT-4 API]
        E2[Gemma 9B]
        E3[DeepSeek Coder]
    end

    A --> B1
    A --> B2
    A --> B3
    A --> B4
    A --> B5
    A --> B6
    A --> B7
    A --> B8
    A --> C1
    A --> C2
    A --> C3
    A --> C4

    style A fill:#4CAF50,color:#fff
    style B5 fill:#FF9800,color:#fff
    style E1 fill:#2196F3,color:#fff
    style E2 fill:#2196F3,color:#fff
```

---

## Installation & Usage

### Prerequisites

```bash
# Ensure Perl 5.34+ is installed
perl --version

# Install required CPAN modules
cpan install File::Find JSON LWP::UserAgent Term::ANSIColor Data::UUID
```

### Quick Start

```bash
# Clone the repository
git clone https://github.com/danindiana/Perl_GPT.git
cd Perl_GPT

# Example: Clean directory by entropy
cd entropy_cleaner
perl clean_by_entropy.pl

# Example: Convert text to JSONL
cd jsonl_convertor
perl txt_jsonl_convert.pl

# Example: Extract academic metadata
cd arxiv_doi_grabber
perl metadata_extractor.pl
```

### Common Workflows

```mermaid
flowchart LR
    A[Select Task] --> B{Task Type?}

    B -->|Data Cleaning| C1[entropy_cleaner]
    B -->|Format Conversion| C2[jsonl_convertor]
    B -->|Metadata Extraction| C3[arxiv_doi_grabber]
    B -->|File Management| C4[File Scanners/Merge]
    B -->|Network Analysis| C5[sshlog_ips/dig]

    C1 --> D[Run Script]
    C2 --> D
    C3 --> D
    C4 --> D
    C5 --> D

    D --> E[Review Output]
    E --> F{Successful?}
    F -->|Yes| G[Complete]
    F -->|No| H[Check Logs]

    style A fill:#4CAF50,color:#fff
    style D fill:#FF9800,color:#fff
    style G fill:#2196F3,color:#fff
```

---

## Perl Use Cases

Perl is a versatile programming language that excels in numerous domains:

### Core Strengths

#### 1. Text Processing Excellence

- **Pattern Matching** - Advanced regex support for complex text search
- **Text Parsing** - Extract structured data from logs, configs, and documents
- **Text Transformation** - Format conversion and data normalization
- **String Manipulation** - Comprehensive built-in functions
- **Text Filtering** - Conditional data extraction
- **Report Generation** - Formatted output creation

#### 2. Data Processing & Analysis

- **Data Extraction** - Mining information from large datasets
- **Data Cleaning** - Removing duplicates, fixing formatting
- **Data Validation** - Ensuring data integrity
- **Data Transformation** - Converting between formats
- **Statistical Analysis** - Entropy calculations, frequency analysis

#### 3. System Administration

- **File Operations** - Automated copying, moving, organizing
- **Log Analysis** - Parsing system logs for insights
- **System Monitoring** - Health checks and alerting
- **Configuration Management** - Automated config updates
- **Task Scheduling** - Cron-based automation
- **Backup Management** - Automated backup routines

#### 4. Web & Network Operations

- **Web Scraping** - HTML parsing and data extraction
- **API Integration** - REST/SOAP client implementations
- **Network Utilities** - Socket programming, protocol handling
- **Data Mining** - Extracting insights from web sources

#### 5. Database Operations

- **Database Interactions** - DBI module for SQL operations
- **Data Migration** - Moving data between systems
- **ETL Pipelines** - Extract, Transform, Load workflows

#### 6. Scientific Computing

- **Bioinformatics** - Genomic sequence analysis
- **Natural Language Processing** - Text tokenization, analysis
- **Academic Research** - Metadata extraction, citation management

### Text Processing Capabilities

Perl's regex engine and text handling make it ideal for:

1. **Pattern Matching** - Identify complex patterns in text
2. **Text Parsing** - Extract structured data from unstructured sources
3. **Text Transformation** - Reformat and normalize data
4. **Data Extraction** - Mine specific information from large files
5. **Text Cleaning** - Remove unwanted characters and normalize whitespace
6. **String Manipulation** - Concat, split, trim, case conversion
7. **Text Comparison** - Diff operations and change detection
8. **Text Substitution** - Find-and-replace with regex
9. **Report Generation** - Create formatted output
10. **Log File Analysis** - Extract metrics and statistics
11. **NLP Tasks** - Tokenization, stemming, POS tagging
12. **Text Validation** - Ensure data meets specifications

### Data Scraping Excellence

Perl excels at web and data scraping:

1. **Web Page Scraping** - HTML parsing and extraction
2. **API Scraping** - JSON/XML data retrieval
3. **Social Media** - Trend analysis and user data
4. **E-commerce** - Price monitoring and product data
5. **Academic Sources** - Research paper metadata
6. **Government Data** - Public records and statistics
7. **News Articles** - Content aggregation
8. **Real Estate** - Property listing data
9. **Financial Data** - Stock prices, market data
10. **Weather Data** - Forecasts and historical data

### Automation & Scripting

Perl's concise syntax enables powerful automation:

1. **File & Directory Operations** - Bulk file management
2. **Data Backup & Archiving** - Automated backup workflows
3. **Log Analysis** - Real-time monitoring and alerting
4. **Configuration Management** - Config deployment
5. **Software Deployment** - Package installation automation
6. **Email Automation** - Automated email processing
7. **Network Automation** - Device configuration
8. **Image Processing** - Batch image operations
9. **Data Migration** - System-to-system transfers
10. **Testing Automation** - Unit and integration tests

---

## Project Structure Details

### Root-Level Utilities (17 Files)

| Script | Purpose | Input | Output |
|--------|---------|-------|--------|
| `file_scanner.pl` | Keyword-based file search | Keywords, directory | Matched files list |
| `file_scannerv2.pl` | Enhanced file scanner | Keywords, directory | Improved results |
| `file_scan_recursdir.pl` | Recursive scanning | Directory path | Recursive file list |
| `file_size_scanner.pl` | File size analysis | Directory path | Size statistics |
| `merge_dirs_v2.pl` | Directory merging | Source/dest paths | Merged directory |
| `concat_chunks.pl` | Text concatenation | Directory, chunk size | Chunked files |
| `remove_repeats_html.pl` | HTML duplicate removal | HTML file | Cleaned HTML |
| `remove_whitespace.pl` | Whitespace cleanup | Text file | Normalized text |
| `perl_mutator.pl` | URL to UUID conversion | URL file | UUID output |
| `clean_bash_history.pl` | Bash history sanitization | History file | Cleaned history |
| `file_deletion_tool.pl` | Safe file deletion | File paths | Confirmation + delete |

### Specialized Modules

#### entropy_cleaner/
- **Purpose**: File quality assessment via entropy
- **Key Script**: `clean_by_entropy.pl`
- **Threshold**: 3.5 (configurable)
- **Output**: Deletion confirmation + statistics

#### entropy_nlp/
- **Purpose**: Advanced statistical entropy analysis
- **Methods**: Shannon, KL Divergence, JS Divergence
- **Scripts**:
  - `ShannJensKL_EntropyCalc.pl` - Full suite
  - `entrop_calc_deepseekcoder.pl` - DeepSeek optimized
  - `entrop_calc_errchk.pl` - Error-checked version

#### arxiv_doi_grabber/
- **Purpose**: Academic metadata extraction
- **Key Script**: `metadata_extractor.pl`
- **APIs**: arXiv, DOI resolution services
- **Output**: JSON metadata files

#### jsonl_convertor/
- **Purpose**: ML pipeline data preparation
- **Key Script**: `txt_jsonl_convert.pl`
- **Features**: Auto-rotation at 2GB, metadata inclusion
- **Format**: JSONL (JSON Lines)

#### shellgenie-polyparse/
- **Purpose**: AI-powered shell automation
- **Architecture**: Polymorphic command parser
- **LM Support**: GPT-4, Gemma 9B
- **Deployment**: Docker containerization

---

## Contributing

Contributions are welcome! This repository showcases AI-generated Perl utilities. When contributing:

1. Follow existing naming conventions (`script_name.pl`, versioning with `v2`, `v3`)
2. Include comprehensive documentation in each directory
3. Add error handling and user confirmations for destructive operations
4. Test scripts thoroughly before submitting
5. Update README.md with new utilities

### Code Style

- Use `strict` and `warnings` pragmas
- Include clear comments explaining logic
- Provide usage examples in script headers
- Handle errors gracefully with informative messages

---

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Generated with assistance from GPT-4, DeepSeek Coder, and other AI models
- Built on Perl's robust text processing foundation
- Community CPAN modules for extended functionality

---

## Quick Reference

### Most Used Scripts

```bash
# Clean low-quality files
perl entropy_cleaner/clean_by_entropy.pl

# Convert to JSONL for ML
perl jsonl_convertor/txt_jsonl_convert.pl

# Extract academic metadata
perl arxiv_doi_grabber/metadata_extractor.pl

# Merge directories safely
perl merge_dirs_v2.pl

# Find all text files
perl find_text/find_text_files.pl

# Extract IPs from logs
perl sshlog_ips/ip_extractor.pl
```

### Dependency Installation

```bash
# All required CPAN modules
cpan install File::Find File::Basename File::Spec Time::Piece \
             JSON LWP::UserAgent Term::ANSIColor Data::Dumper \
             List::Util Math::BaseCalc Data::UUID Digest::MD5
```

---

**Maintained by**: [danindiana](https://github.com/danindiana)
**Repository**: [Perl_GPT](https://github.com/danindiana/Perl_GPT)
**Last Updated**: November 2025
