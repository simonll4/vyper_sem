# @version ^0.3.7

enum BookStates:
    AVAILABLE
    RENTED
    MAINTENANCE
    OUT_OF_SERVICE

struct Book:
    bookId: String[36]
    bookTitle: String[36]
    bookState: BookStates
    rentDate: uint256
    returnDate: uint256

owner: address

booksByTitle: HashMap[String[36], Book]

@external
def __init__():
    self.owner = msg.sender

@external
def saveNewBook(book: Book):
    self.booksByTitle[book.bookTitle] = book 

@view
@external
def viewBookData(title: String[36]) -> Book:
    book: Book = self.booksByTitle[title]
    assert book.bookId != empty(String[36])
    return book

@external
def rentBook(title: String[36]) -> Book:
    book : Book = self.booksByTitle[title]  # Buscamos el libro por el titulo que nos dan
    assert book.bookId != empty(String[36]), "No existe un libro con ese titulo" # Verificar si el book existe
    assert book.bookState == BookStates.AVAILABLE, "El libro no esta disponible en este momento" # Verifica si el book esta disponible
    book.bookState = BookStates.RENTED
    book.rentDate = block.timestamp # Obtenemos la fecha de hoy
    book.returnDate = book.rentDate + 604800 # a la fecha de hoy le sumamos 7 dias(en seg) legal?
    return book


