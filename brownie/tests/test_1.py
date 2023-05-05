import pytest
import brownie
import uuid

@pytest.fixture
def manager_contract(manager, accounts):
    yield manager.deploy({'from': accounts[0]})  

def test_rent_book(manager_contract):
    newIdBook = str(uuid.uuid4())
    newTitleBook = "libro 1"
    manager_contract.loadNewBook(newIdBook, newTitleBook)
    newIdBook = str(uuid.uuid4())
    newTitleBook = "libro 2"
    manager_contract.loadNewBook(newIdBook, newTitleBook) 
    book1 = manager_contract.viewBookData("libro 1")
    assert(book1[1] == "libro 1")
    book2 = manager_contract.viewBookData("libro 2")
    assert(book2[1] == "libro 2")
    
