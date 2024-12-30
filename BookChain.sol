// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookRegistry {
    // Struct to store book details
    struct Book {
        // Thông tin định danh
        string ISBN;
        string title;
        string author;
        string publisher;
        uint256 year;
        // Thông tin bổ sung
        uint256 edition;
        string language;
        string copyright;
        string barcode;
        // Thông tin hình thức và lưu trữ
        string size; // kích thước
        string weight; // trọng lượng
        string coverType; // loại bìa
        uint256 pageCount; // số trang
        // Thông tin số hóa
        string digitalFileLink; // liên kết tệp số hóa
        string doi; // mã DOI
        // Tài liệu liên quan
        string invoiceDetails; // chi tiết hóa đơn
        string publisherConfirmation; // xác nhận từ nhà xuất bản
        string intellectualPropertyRegistration; // đăng ký quyền sở hữu trí tuệ
        bool exists;
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
     * @dev Add a new book to the registry.
     * @param _ISBN The ISBN of the book (unique identifier).
     * @param _title The title of the book.
     * @param _author The author of the book.
     * @param _publisher The publisher of the book.
     * @param _year The year the book was published.
     * @param _edition The edition of the book (e.g., 1 for 1st edition).
     * @param _language The language of the book.
     * @param _copyright The copyright information.
     * @param _barcode The barcode of the book.
     * @param _size The size of the book.
     * @param _weight The weight of the book.
     * @param _coverType The cover type of the book.
     * @param _pageCount The page count of the book.
     * @param _digitalFileLink The digital file link of the book.
     * @param _doi The DOI of the book.
     * @param _invoiceDetails The invoice details of the book.
     * @param _publisherConfirmation The publisher confirmation of the book.
     * @param _intellectualPropertyRegistration The intellectual property registration of the book.
     */
    function addBook(
        string memory _ISBN,
        string memory _title,
        string memory _author,
        string memory _publisher,
        uint256 _year,
        uint256 _edition,
        string memory _language,
        string memory _copyright,
        string memory _barcode,
        string memory _size,
        string memory _weight,
        string memory _coverType,
        uint256 _pageCount,
        string memory _digitalFileLink,
        string memory _doi,
        string memory _invoiceDetails,
        string memory _publisherConfirmation,
        string memory _intellectualPropertyRegistration
    ) public bookDoesNotExist(_ISBN) {
        require(bytes(_ISBN).length > 0, "ISBN cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_author).length > 0, "Author cannot be empty");
        require(bytes(_publisher).length > 0, "Publisher cannot be empty");
        require(_year > 0, "Year must be greater than zero");
        require(_edition > 0, "Edition must be greater than zero");
        require(bytes(_language).length > 0, "Language cannot be empty");
        require(bytes(_copyright).length > 0, "Copyright cannot be empty");
        require(bytes(_barcode).length > 0, "Barcode cannot be empty");
        require(bytes(_size).length > 0, "Size cannot be empty");
        require(bytes(_weight).length > 0, "Weight cannot be empty");
        require(bytes(_coverType).length > 0, "Cover type cannot be empty");
        require(
            bytes(_digitalFileLink).length > 0,
            "Digital file link cannot be empty"
        );
        require(bytes(_doi).length > 0, "DOI cannot be empty");
        require(
            bytes(_invoiceDetails).length > 0,
            "Invoice details cannot be empty"
        );
        require(
            bytes(_publisherConfirmation).length > 0,
            "Publisher confirmation cannot be empty"
        );
        require(
            bytes(_intellectualPropertyRegistration).length > 0,
            "Intellectual property registration cannot be empty"
        );

        books[_ISBN] = Book({
            ISBN: _ISBN,
            title: _title,
            author: _author,
            publisher: _publisher,
            year: _year,
            edition: _edition,
            language: _language,
            copyright: _copyright,
            barcode: _barcode,
            size: _size,
            weight: _weight,
            coverType: _coverType,
            pageCount: _pageCount,
            digitalFileLink: _digitalFileLink,
            doi: _doi,
            invoiceDetails: _invoiceDetails,
            publisherConfirmation: _publisherConfirmation,
            intellectualPropertyRegistration: _intellectualPropertyRegistration,
            exists: true
        });

        emit BookAdded(_ISBN, _title, _author);
    }

    /**
     * @dev Retrieve the details of a book by its ISBN.
     * @param _ISBN The ISBN of the book to retrieve.
     * @return title The title of the book.
     * @return author The author of the book.
     * @return publisher The publisher of the book.
     * @return year The year the book was published.
     * @return edition The edition of the book.
     * @return language The language of the book.
     * @return copyright The copyright information.
     * @return barcode The barcode of the book.
     * @return size The size of the book.
     * @return weight The weight of the book.
     * @return coverType The cover type of the book.
     * @return pageCount The page count of the book.
     * @return digitalFileLink The digital file link of the book.
     * @return doi The DOI of the book.
     * @return invoiceDetails The invoice details of the book.
     * @return publisherConfirmation The publisher confirmation of the book.
     * @return intellectualPropertyRegistration The intellectual property registration of the book.
     */
    function getBook(
        string memory _ISBN
    )
        public
        view
        bookExists(_ISBN)
        returns (
            string memory title,
            string memory author,
            string memory publisher,
            uint256 year,
            uint256 edition,
            string memory language,
            string memory copyright,
            string memory barcode,
            string memory size,
            string memory weight,
            string memory coverType,
            uint256 pageCount,
            string memory digitalFileLink,
            string memory doi,
            string memory invoiceDetails,
            string memory publisherConfirmation,
            string memory intellectualPropertyRegistration
        )
    {
        Book memory book = books[_ISBN];
        return (
            book.title,
            book.author,
            book.publisher,
            book.year,
            book.edition,
            book.language,
            book.copyright,
            book.barcode,
            book.size,
            book.weight,
            book.coverType,
            book.pageCount,
            book.digitalFileLink,
            book.doi,
            book.invoiceDetails,
            book.publisherConfirmation,
            book.intellectualPropertyRegistration
        );
    }
}
