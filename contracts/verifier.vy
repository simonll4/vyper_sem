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

owner: address

booksByTitle: HashMap[String[36], String[36]]

@external
def __init__():
    self.owner = msg.sender
