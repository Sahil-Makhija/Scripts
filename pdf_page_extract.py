#!/usr/bin/python3
import sys
import os    

try:
    import PyPDF2
except ModuleNotFoundError:
    installModule = input("Module not found. Install it? (y/n): ")
    if installModule.lower() == "y":
        os.system(f"{sys.executable} -m pip install PyPDF2 --break-system-packages")
        try:
            import PyPDF2
        except ModuleNotFoundError:
            print("Failed to install PyPDF2. Exiting...")
            sys.exit(1)
    else:
        print("Exiting...")
        sys.exit(1)


def extract_pages(input_pdf, output_pdf, start_index, end_index):
    try:
        with open(input_pdf, "rb") as infile:
            reader = PyPDF2.PdfReader(infile)
            writer = PyPDF2.PdfWriter()
            
            for i in range(start_index - 1, end_index):  # PyPDF2 uses 0-based index
                if i < len(reader.pages):
                    writer.add_page(reader.pages[i])
                else:
                    print(f"Warning: Page {i + 1} does not exist in {input_pdf}")
                    break
            
            with open(output_pdf, "wb") as outfile:
                writer.write(outfile)
        print(f"Extracted pages {start_index} to {end_index} into {output_pdf}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python extract_pdf_pages.py <input_pdf> <output_pdf> <start_index> <end_index>")
        sys.exit(1)
    
    input_pdf = sys.argv[1]
    output_pdf = sys.argv[2]
    start_index = int(sys.argv[3])
    end_index = int(sys.argv[4])
    
    extract_pages(input_pdf, output_pdf, start_index, end_index)
