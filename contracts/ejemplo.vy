# @version ^0.3.7

enum BatchStatus:
    MANUFACTURED
    QUALITY_CHECKED
    PACKED
    SHIPPED
    REJECTED


enum ShipmentStatus:
    SHIPPED
    RECEIVED

owner: address

struct ProductBatch:
    productId: String[36]
    batchNumber: String[10]
    actualStatus: BatchStatus

struct Shipment:
    trackingCode: String[15]
    batch: ProductBatch
    sender: address
    receiver: address
    shipmentDate: uint256
    receivmentDate: uint256
    actualStatus: ShipmentStatus

shipments: HashMap[String[15], Shipment]

@external
def __init__():
    self.owner = msg.sender

@external
def saveNewShipment(shipment: Shipment):
    self.shipments[shipment.trackingCode] = shipment

@external 
def setShipmentAsReceived(tracking: String[15]):
    shipment: Shipment = self.shipments[tracking]
    shipment.actualStatus = ShipmentStatus.RECEIVED
    shipment.receivmentDate = block.timestamp

@view
@external
def viewShipmentData(tracking: String[15]) -> Shipment:
    shipment: Shipment = self.shipments[tracking]
    assert shipment.sender != empty(address), "No se encuentra el envio con el numero de tracking provisto"
    return shipment