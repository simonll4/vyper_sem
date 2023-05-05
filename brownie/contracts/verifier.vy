# @version ^0.3.7

# External Interfaces
interface Manager:
    def rentBook(title: String[36]) -> Book: nonpayable
    def returnBook(book: Book): nonpayable


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

@external
def __init__():
    self.owner = msg.sender

@external
def returnVerification(book: Book,receiverAddress: address):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    assert block.timestamp <= book.returnDate, "Se le debe aplicar sancion al rentador"
    book.bookState = BookStates.AVAILABLE
    book.rentDate = empty(uint256)
    book.returnDate = empty(uint256)
    manager: Manager = Manager(receiverAddress)
    manager.returnBook(book)
    