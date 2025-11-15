# Metadata Extractor for DOI and ArXiv Links

[![CI Status](https://github.com/danindiana/Perl_GPT/actions/workflows/arxiv-doi-grabber-ci.yml/badge.svg)](https://github.com/danindiana/Perl_GPT/actions/workflows/arxiv-doi-grabber-ci.yml)

`metadata_extractor.pl` is a Perl script designed to extract metadata (such as titles) from DOI and arXiv links present in text files. The metadata is fetched from their respective websites and stored in JSON files for easy reference.

## Quick Start

```bash
# Automated installation (recommended)
./install_deps.sh

# Run smoke test
./smoke_test.pl

# Extract metadata
./metadata_extractor.pl --dir=./test/fixtures --output=./temp
```

## Features

- ✓ Scans directories for `.txt` files
- ✓ Extracts DOI and arXiv links from file content
- ✓ Fetches metadata from respective websites
- ✓ Saves metadata in individual JSON files
- ✓ Logs processed files for reference
- ✓ Interactive file selection
- ✓ Comprehensive error handling
- ✓ Automated dependency installation
- ✓ Full CI/CD pipeline with GitHub Actions

## How It Works

1. **Initialize HTTP User Agent**: Uses `LWP::UserAgent` to perform HTTP requests to fetch metadata from DOI and arXiv websites
2. **Directory Scanning**: Scans a specified directory (or current directory by default) for text files (`.txt`)
3. **Extract Metadata**: For each DOI/arXiv link found:
   - Performs an HTTP GET request to retrieve metadata
   - Extracts the title and other relevant information
4. **Store Metadata**: Saves metadata to corresponding JSON files (`file.txt` → `file_extracted.json`)
5. **User Input**: Allows interactive selection of files to process
6. **Generate Log**: Creates a timestamped log file listing all found text files

## Requirements

- **Perl**: Version 5.10 or higher
- **Perl Modules**:
  - `LWP::UserAgent` (for HTTP requests)
  - `LWP::Protocol::https` (for HTTPS support)
  - `JSON` (for JSON parsing and output)
  - `File::Find` (core - for directory traversal)
  - `Digest::MD5` (core - for hash-based filenames)
  - `Time::HiRes` (core - for high-resolution time)

## Installation

### Automated Installation (Recommended)

```bash
# Run the installation script
./install_deps.sh
```

The script will:
1. Check Perl version compatibility
2. Install `cpanm` if needed
3. Install all required dependencies
4. Verify installation
5. Check script syntax

### Manual Installation

```bash
# Install cpanm if not available
curl -L https://cpanmin.us | perl - App::cpanminus

# Install dependencies from cpanfile
cpanm --installdeps .

# Or install manually
cpanm LWP::UserAgent LWP::Protocol::https JSON
```

### System Package Installation

**Debian/Ubuntu:**
```bash
sudo apt-get install libwww-perl libjson-perl
```

**RHEL/CentOS/Fedora:**
```bash
sudo yum install perl-libwww-perl perl-JSON
```

For detailed bare metal setup instructions, see **[BARE_METAL_SETUP.md](BARE_METAL_SETUP.md)**.

## Usage

### Basic Syntax

```bash
./metadata_extractor.pl --dir=<directory> --output=<output_directory>
```

### Options

- `--dir=DIR`: Directory to scan for text files (default: current directory)
- `--output=DIR`: Directory to save the log file (default: current directory)
- `--help`: Display help information

### Examples

**Process test fixtures:**
```bash
./metadata_extractor.pl --dir=./test/fixtures --output=./temp
```

**Process current directory:**
```bash
./metadata_extractor.pl
```

**Automated file selection (first file):**
```bash
echo "0" | ./metadata_extractor.pl --dir=./test/fixtures
```

**View help:**
```bash
./metadata_extractor.pl --help
```

## Output

### Metadata JSON Files

For each processed text file, a JSON file is created:
- Input: `example.txt`
- Output: `example_extracted.json`

**JSON Structure:**
```json
{
  "dois": [
    {
      "doi": "https://dx.doi.org/10.1038/nature12373",
      "title": "Article Title Here"
    }
  ],
  "arxivs": [
    {
      "arxiv": "https://arxiv.org/abs/1706.03762",
      "title": "Paper Title Here"
    }
  ]
}
```

### Log File

A timestamped log file listing all found text files:
- Format: `<directory_name>_<md5_hash>.txt`
- Location: Specified output directory

## Testing

### Run Smoke Tests

```bash
./smoke_test.pl
```

The smoke test validates:
- ✓ Perl version compatibility
- ✓ Required module availability
- ✓ Script syntax validation
- ✓ Basic functionality
- ✓ File discovery
- ✓ Output generation

### Test with Fixtures

Sample test files are provided in `test/fixtures/`:
- `sample_doi.txt` - Contains DOI links
- `sample_arxiv.txt` - Contains arXiv links
- `mixed_links.txt` - Contains both types

```bash
./metadata_extractor.pl --dir=./test/fixtures --output=./temp
```

## CI/CD Pipeline

This project includes a comprehensive GitHub Actions CI/CD pipeline that runs:

- **Smoke Tests**: Across multiple Perl versions (5.30-5.38) and OS (Ubuntu, macOS)
- **Syntax Checks**: Perl syntax validation and linting
- **Bare Metal Simulation**: Tests automated installation process
- **Documentation Validation**: Verifies all required files exist

See **[CI_CD_REVIEW.md](CI_CD_REVIEW.md)** for detailed pipeline documentation.

## Documentation

- **[BARE_METAL_SETUP.md](BARE_METAL_SETUP.md)** - Detailed bare metal installation guide
- **[CI_CD_REVIEW.md](CI_CD_REVIEW.md)** - Comprehensive CI/CD pipeline review and recommendations
- **[best_practices.md](best_practices.md)** - Best practices guide
- **[test/fixtures/README.md](test/fixtures/README.md)** - Test fixtures documentation

## Error Handling

The script includes comprehensive error handling for:
- ✓ Invalid HTTP responses (404, timeouts, etc.)
- ✓ Unexpected content types from DOI/arXiv APIs
- ✓ User input validation for file selection
- ✓ File I/O errors
- ✓ JSON parsing errors

## Project Structure

```
arxiv_doi_grabber/
├── metadata_extractor.pl      # Main script
├── smoke_test.pl              # Smoke test suite
├── install_deps.sh            # Automated dependency installer
├── cpanfile                   # Perl dependency manifest
├── readme.md                  # This file
├── BARE_METAL_SETUP.md        # Bare metal setup guide
├── CI_CD_REVIEW.md            # CI/CD pipeline documentation
├── best_practices.md          # Best practices
├── test/
│   └── fixtures/              # Test data files
│       ├── sample_doi.txt
│       ├── sample_arxiv.txt
│       ├── mixed_links.txt
│       └── README.md
└── temp/                      # Temporary output directory
```

## Troubleshooting

**Issue**: "LWP::UserAgent not found"
```bash
cpanm LWP::UserAgent LWP::Protocol::https
```

**Issue**: "Permission denied" when installing modules
```bash
# Install locally (no root required)
cpanm --local-lib=~/perl5 LWP::UserAgent JSON
echo 'eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)' >> ~/.bashrc
```

**Issue**: SSL certificate errors
```bash
sudo apt-get install ca-certificates  # Debian/Ubuntu
cpanm Mozilla::CA                     # Or install Mozilla CA bundle
```

For more troubleshooting, see **[BARE_METAL_SETUP.md](BARE_METAL_SETUP.md#troubleshooting)**.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run smoke tests (`./smoke_test.pl`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

The CI/CD pipeline will automatically validate your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- DOI metadata from [dx.doi.org](https://dx.doi.org)
- arXiv metadata from [arxiv.org](https://arxiv.org)
- Built with Perl and CPAN modules

## Support

- **Issues**: [GitHub Issues](https://github.com/danindiana/Perl_GPT/issues)
- **Documentation**: See docs listed above
- **CI/CD Status**: Check the badge at the top of this README
