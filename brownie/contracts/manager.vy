# @version ^0.3.7

enum BookStates:
    AVAILABLE
    RENTED

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
def rentBook(title: String[36]) -> Book:
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    book : Book = self.booksByTitle[title]  # Buscamos el libro por el titulo que nos dan
    assert book.bookId != empty(String[36]), "No existe un libro con ese titulo" # Verificar si el book existe
    assert book.bookState == BookStates.AVAILABLE, "El libro no esta disponible en este momento" # Verifica si el book esta disponible
    book.bookState = BookStates.RENTED
    book.rentDate = block.timestamp # Obtenemos fecha de hoy
    book.returnDate = book.rentDate + 10 # Seteamos la fecha de devolucion hoy + 10seg para el test
    self.booksByTitle[book.bookTitle] = book # Guardamos el libro pero en estado rentado
    return book

@external
def returnBook(book: Book):
    assert book.bookState == BookStates.AVAILABLE, "Error en devolucion de libro" # Verifica si el libro recibido del verifier tiene el estado correcto
    self.booksByTitle[book.bookTitle] = book # Guarda el libro en el hashmap


@external
def loadNewBook(id: String[36], title: String[36]):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    book: Book = Book({bookId: id, bookTitle: title, bookState: BookStates.AVAILABLE, rentDate: empty(uint256), returnDate: empty(uint256)})
    assert book.bookTitle != empty(String[36]), "Parametros invalidos: Ingrese un titulo valido" #Verifica titulo != vacio
    assert book.bookId != empty(String[36]), "Parametros invalidos: Ingrese un ID valido" # Verfifica id != vacio
    self.booksByTitle[book.bookTitle] = book # Guarda el libro en el hashmap


@view
@external
def viewBookData(title: String[36]) -> Book:
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner" 
    bookToReturn: Book = self.booksByTitle[title] #Busca el libro pedido
    assert bookToReturn.bookTitle != empty(String[36]), "No se encuentra el libro indicado" 
    return bookToReturn