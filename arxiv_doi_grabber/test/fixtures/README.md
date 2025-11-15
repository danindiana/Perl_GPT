# Test Fixtures

This directory contains test data files for validating the metadata_extractor.pl script.

## Files

### sample_doi.txt
Contains sample DOI (Digital Object Identifier) links for testing DOI metadata extraction.

**Sample DOIs included:**
- 10.1038/nature12373 - Nature publication
- 10.1126/science.1242072 - Science publication
- 10.1093/bioinformatics/bts635 - Bioinformatics publication

### sample_arxiv.txt
Contains sample arXiv links for testing arXiv metadata extraction.

**Sample arXiv papers included:**
- 1706.03762 - "Attention Is All You Need" (Transformer paper)
- 1409.0473 - Neural Machine Translation
- 2103.14030 - Recent research paper

### mixed_links.txt
Contains a mix of both DOI and arXiv links to test the script's ability to handle multiple link types in a single file.

## Usage

To test with these fixtures:

```bash
# From the arxiv_doi_grabber directory
./metadata_extractor.pl --dir=./test/fixtures --output=./temp
```

Or run the smoke test which will automatically use these fixtures:

```bash
./smoke_test.pl
```

## Expected Output

For each .txt file, the script should generate a corresponding `_extracted.json` file containing:
- `dois[]` - Array of DOI metadata objects
- `arxivs[]` - Array of arXiv metadata objects

Each metadata object should include:
- Link/identifier
- Title
- Additional metadata (depending on source)

## Notes

- These are real DOI and arXiv identifiers for testing purposes
- Network connectivity is required to fetch actual metadata
- For offline testing, consider mocking the HTTP responses
- The metadata returned depends on the availability of the external services
