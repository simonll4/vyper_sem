import pytest
import brownie
import uuid
from time import sleep
from brownie import Contract, network

@pytest.fixture
def manager_contract(manager, accounts):
    yield manager.deploy({'from': accounts[0]})  


@pytest.fixture
def verifier_contract(verifier, accounts):
    yield verifier.deploy({'from': accounts[0]}) 


def test_rent_book(manager_contract,verifier_contract):
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
    
    #rentar libro
    book1 = manager_contract.rentBook("libro 1")
    #lo volvemos a rentar para probar la disponibilidad
    book2 = manager_contract.rentBook("libro 2")

    sleep(5)
    book1 = manager_contract.viewBookData("libro 1")
    verifier_contract.returnVerification(book1,manager_contract.address)
    sleep(8)
    book2 = manager_contract.viewBookData("libro 2")
    verifier_contract.returnVerification(book2,manager_contract.address)
    



#def test_return_book(verifier_contract):
    
    
    