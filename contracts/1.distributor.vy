# @version ^0.3.7

enum BatchStatus:
    MANUFACTURED
    QUALITY_CHECKED
    REJECTED
    PACKED
    SHIPPED

enum ShipmentStatus:
    SHIPPED
    RECEIVED

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
    recievmentDate: uint256
    actualStatus: ShipmentStatus

owner: address

shipments: HashMap[String[15], Shipment]

@external
def __init__():
    self.owner = msg.sender

@external
def saveNewShipment(shipment: Shipment):
    self.shipments[shipment.trackingCode] = shipment

@external
def setShipmentAsReceived(tracking: String[15]):
    assert msg.sender == self.owner, "Esta operacion solo puede ser realizada por el owner"
    shipment: Shipment = self.shipments[tracking]
    assert shipment.sender != empty(address), "No se encuentra el envio indicado."
    shipment.actualStatus = ShipmentStatus.RECEIVED
    shipment.recievmentDate = block.timestamp

@view
@external
def viewShipment(tracking: String[15]) -> Shipment:
    shipment: Shipment = self.shipments[tracking]
    assert shipment.sender != empty(address), "No se encuentra el envio indicado."
    return shipment