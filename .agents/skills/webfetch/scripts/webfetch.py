#!/usr/bin/env python3
import sys
import trafilatura

def main():
    if len(sys.argv) < 2:
        print("Usage: webfetch <url>", file=sys.stderr)
        sys.exit(1)

    url = sys.argv[1]

    try:
        # Fetch the page
        downloaded = trafilatura.fetch_url(url)
        if downloaded is None:
            print(f"Error: Could not fetch content from {url}", file=sys.stderr)
            sys.exit(1)

        # Metrics: Before
        original_size = len(downloaded.encode('utf-8'))

        # Extract the main content
        # trafilatura.extract returns cleaned text by default
        result = trafilatura.extract(downloaded)

        if result is None:
            print(f"Error: No meaningful content extracted from {url}", file=sys.stderr)
            sys.exit(1)

        # Metrics: After
        extracted_size = len(result.encode('utf-8'))
        reduction = (1 - (extracted_size / original_size)) * 100 if original_size > 0 else 0

        # Output metrics to stderr
        print(f"--- WebFetch Metrics ---", file=sys.stderr)
        print(f"URL: {url}", file=sys.stderr)
        print(f"Original Size: {original_size} bytes", file=sys.stderr)
        print(f"Extracted Size: {extracted_size} bytes", file=sys.stderr)
        print(f"Noise Reduction: {reduction:.2f}%", file=sys.stderr)
        print(f"------------------------", file=sys.stderr)

        # Output content to stdout
        print(result)

    except Exception as e:
        print(f"Critical Error: {str(e)}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
