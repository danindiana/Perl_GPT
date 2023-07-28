import hashlib

def generate_token(line):
    return hashlib.md5(line.encode()).hexdigest()

def tokenize_data(input_file):
    tokens = {}
    output_data = []

    try:
        with open(input_file, "r") as f:
            for line in f:
                line = line.strip()
                token = generate_token(line)
                output_data.append(token)
    except FileNotFoundError:
        print("Error: The specified file does not exist.")
        return

    return output_data

def main():
    print("Data Tokenization")

    input_file = input("Enter the name of the text file to tokenize: ")

    tokenized_data = tokenize_data(input_file)

    output_file = "tokenized_output.txt"

    with open(output_file, "w") as f:
        f.write("\n".join(tokenized_data))

    print(f"Tokenization completed. The tokenized data has been saved to '{output_file}'.")

if __name__ == "__main__":
    main()
