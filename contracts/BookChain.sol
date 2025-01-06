// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookChain {
    // Struct to store book details
    struct Book {
        string id;
        string eTag;
        string title;
        string subtitle;
        string author;
        string publisher;
        string publishedDate;
        string description;
        string ISBN_10;
        string ISBN_13;
        uint pageCount;
        string[] categories;
        string language;
        string saleInfo;
        string saleability;
        bool isEBook;
        bool epub; // Simplified for demonstration
        bool pdf; // Simplified for demonstration
        string accessInfo;
        string viewability;
        bool publicDomain;
        bool exists; // To check existence in mapping
    }

    // Struct for input parameters to avoid stack too deep
    struct BookInput {
        string id;
        string eTag;
        string title;
        string subtitle;
        string author;
        string publisher;
        string publishedDate;
        string description;
        string ISBN_10;
        string ISBN_13;
        uint pageCount;
        string[] categories;
        string language;
        string saleInfo;
        string saleability;
        bool isEBook;
        bool epub;
        bool pdf;
        string accessInfo;
        string viewability;
        bool publicDomain;
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
    ) public bookDoesNotExist(input.ISBN_13) {
        books[input.ISBN_13] = Book(
            input.id,
            input.eTag,
            input.title,
            input.subtitle,
            input.author,
            input.publisher,
            input.publishedDate,
            input.description,
            input.ISBN_10,
            input.ISBN_13,
            input.pageCount,
            input.categories,
            input.language,
            input.saleInfo,
            input.saleability,
            input.isEBook,
            input.epub,
            input.pdf,
            input.accessInfo,
            input.viewability,
            input.publicDomain,
            true // Mark as exists
        );

        emit BookAdded(input.ISBN_13, input.title, input.author);
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
            BookInput(
                book.id,
                book.eTag,
                book.title,
                book.subtitle,
                book.author,
                book.publisher,
                book.publishedDate,
                book.description,
                book.ISBN_10,
                book.ISBN_13,
                book.pageCount,
                book.categories,
                book.language,
                book.saleInfo,
                book.saleability,
                book.isEBook,
                book.epub,
                book.pdf,
                book.accessInfo,
                book.viewability,
                book.publicDomain
            );
    }
}
