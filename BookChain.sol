// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookChain {
    // Struct to store book details
    struct Book {
        // Identification info
        string ISBN;
        string title;
        string author;
        string publisher;
        uint256 year;
        // Additional info
        uint256 edition;
        string language;
        string copyright;
        string barcode;
        // Physical attributes
        string size;
        string weight;
        string coverType;
        uint256 pageCount;
        // Digital info
        string digitalFileLink;
        string doi;
        // Related documents
        string invoiceDetails;
        string publisherConfirmation;
        string intellectualPropertyRegistration;
        bool exists;
    }

    // Struct for input parameters to avoid stack too deep
    struct BookInput {
        string ISBN;
        string title;
        string author;
        string publisher;
        uint256 year;
        uint256 edition;
        string language;
        string copyright;
        string barcode;
        string size;
        string weight;
        string coverType;
        uint256 pageCount;
        string digitalFileLink;
        string doi;
        string invoiceDetails;
        string publisherConfirmation;
        string intellectualPropertyRegistration;
    }

    // Mapping to store books based on ISBN
    mapping(string => Book) private books;

    // Event to notify when a new book is added
    event BookAdded(string ISBN, string title, string author);

    // Modifier to ensure the book does not already exist
    modifier bookDoesNotExist(string memory _ISBN) {
        require(!books[_ISBN].exists, "Book already exists with this ISBN");
        _;
    }

    // Modifier to ensure the book exists
    modifier bookExists(string memory _ISBN) {
        require(books[_ISBN].exists, "Book does not exist");
        _;
    }

    /**
     * @dev Add a new book to the registry using a struct parameter
     * @param input The BookInput struct containing all book details
     */
    function addBook(
        BookInput memory input
    ) public bookDoesNotExist(input.ISBN) {
        // Input validation
        require(bytes(input.ISBN).length > 0, "ISBN cannot be empty");
        require(bytes(input.title).length > 0, "Title cannot be empty");
        require(bytes(input.author).length > 0, "Author cannot be empty");
        require(bytes(input.publisher).length > 0, "Publisher cannot be empty");
        require(input.year > 0, "Year must be greater than zero");
        require(input.edition > 0, "Edition must be greater than zero");
        require(bytes(input.language).length > 0, "Language cannot be empty");
        require(bytes(input.copyright).length > 0, "Copyright cannot be empty");
        require(bytes(input.barcode).length > 0, "Barcode cannot be empty");
        require(bytes(input.size).length > 0, "Size cannot be empty");
        require(bytes(input.weight).length > 0, "Weight cannot be empty");
        require(
            bytes(input.coverType).length > 0,
            "Cover type cannot be empty"
        );
        require(
            bytes(input.digitalFileLink).length > 0,
            "Digital file link cannot be empty"
        );
        require(bytes(input.doi).length > 0, "DOI cannot be empty");
        require(
            bytes(input.invoiceDetails).length > 0,
            "Invoice details cannot be empty"
        );
        require(
            bytes(input.publisherConfirmation).length > 0,
            "Publisher confirmation cannot be empty"
        );
        require(
            bytes(input.intellectualPropertyRegistration).length > 0,
            "Intellectual property registration cannot be empty"
        );

        books[input.ISBN] = Book({
            ISBN: input.ISBN,
            title: input.title,
            author: input.author,
            publisher: input.publisher,
            year: input.year,
            edition: input.edition,
            language: input.language,
            copyright: input.copyright,
            barcode: input.barcode,
            size: input.size,
            weight: input.weight,
            coverType: input.coverType,
            pageCount: input.pageCount,
            digitalFileLink: input.digitalFileLink,
            doi: input.doi,
            invoiceDetails: input.invoiceDetails,
            publisherConfirmation: input.publisherConfirmation,
            intellectualPropertyRegistration: input
                .intellectualPropertyRegistration,
            exists: true
        });

        emit BookAdded(input.ISBN, input.title, input.author);
    }

    /**
     * @dev Retrieve the details of a book by its ISBN
     * @param _ISBN The ISBN of the book to retrieve
     * @return A BookInput struct containing all book details
     */
    function getBook(
        string memory _ISBN
    ) public view bookExists(_ISBN) returns (BookInput memory) {
        Book storage book = books[_ISBN];
        return
            BookInput({
                ISBN: book.ISBN,
                title: book.title,
                author: book.author,
                publisher: book.publisher,
                year: book.year,
                edition: book.edition,
                language: book.language,
                copyright: book.copyright,
                barcode: book.barcode,
                size: book.size,
                weight: book.weight,
                coverType: book.coverType,
                pageCount: book.pageCount,
                digitalFileLink: book.digitalFileLink,
                doi: book.doi,
                invoiceDetails: book.invoiceDetails,
                publisherConfirmation: book.publisherConfirmation,
                intellectualPropertyRegistration: book
                    .intellectualPropertyRegistration
            });
    }
}
