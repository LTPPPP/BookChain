import csv
import requests
import time
from requests.exceptions import ConnectionError, HTTPError, Timeout

# Define API URL template
api_url_template = "https://www.googleapis.com/books/v1/volumes?q=isbn:{}"

# Define file paths
input_csv = "copy.csv"
output_csv = "searching.csv"
count =0

# Read existing CSV data
with open(input_csv, mode="r", encoding="utf-8") as file:
    reader = csv.DictReader(file)
    csv_data = list(reader)

# Collect ISBNs from the CSV file
isbns = [row["ISBN"] for row in csv_data if row.get("ISBN")]

# Function to fetch data from API
def fetch_book_data(isbn):
    api_url = api_url_template.format(isbn)
    for attempt in range(3):  # Retry up to 3 times
        try:
            response = requests.get(api_url, timeout=10)
            response.raise_for_status()
            return response.json()
        except (ConnectionError, HTTPError, Timeout) as e:
            print(f"Attempt {attempt + 1}: Error fetching data for ISBN {isbn} - {e}")
            time.sleep(2)  # Wait before retrying
    print(f"Failed to fetch data for ISBN {isbn} after 3 attempts.")
    return None

# Process new data
for isbn in isbns:
    count +=1
    print(f"Fetching data for ISBN: {isbn} - No. {count}" )
    book_data = fetch_book_data(isbn)
    if book_data:
        items = book_data.get("items", [])
        if items:
            book = items[0]
            volume_info = book.get("volumeInfo", {})
            sale_info = book.get("saleInfo", {})
            access_info = book.get("accessInfo", {})

            # Append new data to the CSV row
            csv_data.append({
                "Id": book.get("id", ""),
                "eTag": book.get("etag", ""),
                "Title": volume_info.get("title", ""),
                "Subtitle": volume_info.get("subtitle", ""),
                "Author": ", ".join(volume_info.get("authors", [])),
                "Publisher": volume_info.get("publisher", ""),
                "Published-Date": volume_info.get("publishedDate", ""),
                "Description": volume_info.get("description", ""),
                "ISBN_10": next((id["identifier"] for id in volume_info.get("industryIdentifiers", []) if id["type"] == "ISBN_10"), ""),
                "ISBN_13": next((id["identifier"] for id in volume_info.get("industryIdentifiers", []) if id["type"] == "ISBN_13"), ""),
                "PageCount": volume_info.get("pageCount", ""),
                "Categories": ", ".join(volume_info.get("categories", [])),
                "Language": volume_info.get("language", ""),
                "Sale_Info": sale_info.get("country", ""),
                "Saleability": sale_info.get("saleability", ""),
                "isEBook": sale_info.get("isEbook", ""),
                "epub": access_info.get("epub", {}).get("isAvailable", ""),
                "pdf": access_info.get("pdf", {}).get("isAvailable", ""),
                "Access_Info": access_info.get("country", ""),
                "Viewability": access_info.get("viewability", ""),
                "PublicDomain": access_info.get("publicDomain", ""),
            })

# Define fieldnames in the desired order
fieldnames = [
    "Id", "eTag", "Title", "Subtitle", "Author", "Publisher", "Published-Date", 
    "Description", "ISBN_10", "ISBN_13", "PageCount", "Categories", "Language", 
    "Sale_Info", "Saleability", "isEBook", "epub", "pdf", "Access_Info", 
    "Viewability", "PublicDomain"
]

# Write updated data to a new CSV
with open(output_csv, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    for row in csv_data:
        writer.writerow({field: row.get(field, "") for field in fieldnames})

print(f"Updated CSV file saved at: {output_csv}")
