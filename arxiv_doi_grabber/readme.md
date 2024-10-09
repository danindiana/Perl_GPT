### Program Description

This Perl script functions as a metadata extractor for DOI and arXiv links found within text files. It uses regular expressions to detect these links, fetches metadata from the respective websites, and stores the extracted information (such as titles) in separate JSON files. Here’s a step-by-step breakdown of how the program works:

1. **Initialize HTTP User Agent**: The script uses `LWP::UserAgent` to perform HTTP requests to fetch metadata from DOI and arXiv websites.
2. **Directory Scanning**: The program scans a specified directory (or the current directory by default) for text files (`.txt`).
3. **Extract Metadata**: Within each text file, it searches for DOI and arXiv links using regular expressions. For each found link, it:
   - Performs an HTTP GET request to retrieve metadata (e.g., title).
   - Extracts the title and other relevant information from the response.
4. **Store Metadata**: The metadata for each text file is saved to a corresponding JSON file in the same directory as the text file. For example, for `file.txt`, the output will be `file_extracted.json`.
5. **User Input**: After scanning the directory for text files, the script allows the user to select which files they want to process based on a list displayed to the console.
6. **Generate Log**: The program logs all found text files to a file that is named based on the parent directory and a timestamp. This file lists the text files that were found during the scan.
7. **Error Handling**: The script includes basic error handling, such as dealing with invalid HTTP responses and unexpected content types.

### Suggested File Name
A fitting name for this file could be:

```plaintext
metadata_extractor.pl
```

### Suggested `README.md`

```markdown
# Metadata Extractor for DOI and ArXiv Links

`metadata_extractor.pl` is a Perl script designed to extract metadata (such as titles) from DOI and arXiv links present in text files. The metadata is fetched from their respective websites and stored in JSON files for easy reference.

## Features

- Scans a directory for `.txt` files.
- Extracts DOI and arXiv links from the content of the text files.
- Fetches metadata from the respective websites.
- Saves metadata in individual JSON files corresponding to the input text files.
- Logs the list of processed text files for reference.

## Requirements

- Perl (version 5.10 or higher)
- The following Perl modules:
  - `LWP::UserAgent` (for HTTP requests)
  - `JSON` (for JSON parsing and output)
  - `File::Find` (for directory traversal)
  - `Digest::MD5` (for generating hash-based filenames)
  - `Time::HiRes` (for high-resolution time calculations)

Install the required modules using CPAN if needed:

```bash
cpan LWP::UserAgent JSON File::Find Digest::MD5 Time::HiRes
```

## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/metadata_extractor.git
cd metadata_extractor
```

Ensure the script is executable:

```bash
chmod +x metadata_extractor.pl
```

## Usage

### Basic Syntax

```bash
./metadata_extractor.pl --dir=path/to/your/text/files --output=path/to/save/log
```

### Options

- `--dir=DIR`: Directory to scan for text files (default: current directory).
- `--output=DIR`: Directory to save the log file that lists the found text files (default: current directory).

### Example

To scan the `texts` directory for files and store the log file in the `logs` directory:

```bash
./metadata_extractor.pl --dir=./texts --output=./logs
```

After scanning, the script will prompt you to select which files you want to process. You can specify ranges (e.g., `1-3, 5, 7`).

## Output

The script will produce the following types of output:

1. **Metadata JSON Files**: For each processed text file, a corresponding JSON file containing the extracted DOI/arXiv metadata will be created. For example:
   - `example.txt` → `example_extracted.json`
   
2. **Log File**: A log file listing all found text files is generated in the output directory. The filename will follow this format: `<directory_name>_<timestamp>.txt`.

## Error Handling

The script includes error handling for:
- Invalid HTTP responses (e.g., 404 errors).
- Unexpected content types from the DOI and arXiv metadata fetches.
- User input validation for file selection.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your improvements.

```

This `README.md` provides a clear understanding of how the script works, how to install and run it, and what to expect from the output.
