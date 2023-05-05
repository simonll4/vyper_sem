# @version ^0.3.7

interface Distributor:
    def saveNewShipment(shipment: Shipment): nonpayable
    def setShipmentAsReceived(tracking: String[15]): nonpayable
    def viewShipment(tracking: String[15]) -> Shipment: view


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
batches: HashMap[String[10], ProductBatch]

@external
def __init__():
    self.owner = msg.sender

@external
def loadNewBatch(product: String[36], batch: String[10]):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    newBatch: ProductBatch = ProductBatch({productId: product, batchNumber: batch, actualStatus: BatchStatus.MANUFACTURED})
    self.batches[batch] = newBatch

@external
def setQualityChecked(batch: String[10]):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    batchToCheck: ProductBatch = self.batches[batch]
    assert batchToCheck.batchNumber != empty(String[10]), "No se encuentra el lote indicado"
    assert batchToCheck.actualStatus == BatchStatus.MANUFACTURED, "Esta funcion solo se puede ejecutar en el estado MANUFACTURED"
    batchToCheck.actualStatus = BatchStatus.QUALITY_CHECKED
    self.batches[batch] = batchToCheck

@external
def setRejected(batch: String[10]):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    batchToReject: ProductBatch = self.batches[batch]
    assert batchToReject.batchNumber != empty(String[10]), "No se encuentra el lote indicado"
    assert batchToReject.actualStatus == BatchStatus.QUALITY_CHECKED, "Esta funcion solo se puede ejecutar en el estado QUALITY_CHECKED"
    batchToReject.actualStatus = BatchStatus.REJECTED
    self.batches[batch] = batchToReject

@external
def setPacked(batch: String[10]):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    batchToPack: ProductBatch = self.batches[batch]
    assert batchToPack.batchNumber != empty(String[10]), "No se encuentra el lote indicado"
    assert batchToPack.actualStatus == BatchStatus.QUALITY_CHECKED, "Esta funcion solo se puede ejecutar en el estado QUALITY_CHECKED"
    batchToPack.actualStatus = BatchStatus.PACKED
    self.batches[batch] = batchToPack

@external
def setShipped(batch: String[10], shippingCode: String[15], receiverAddress: address):
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    batchToSend: ProductBatch = self.batches[batch]
    assert batchToSend.batchNumber != empty(String[10]), "No se encuentra el lote indicado"
    assert batchToSend.actualStatus == BatchStatus.PACKED, "Esta funcion solo se puede ejecutar en el estado QUALITY_CHECKED"
    batchToSend.actualStatus = BatchStatus.SHIPPED
    self.batches[batch] = batchToSend
    shipment: Shipment = Shipment({trackingCode: shippingCode, batch: batchToSend, sender: self, receiver: receiverAddress, shipmentDate: block.timestamp, recievmentDate: 0, actualStatus: ShipmentStatus.SHIPPED})
    distributor: Distributor = Distributor(receiverAddress)
    distributor.saveNewShipment(shipment)

@view
@external
def viewBatchData(batch: String[10]) -> ProductBatch:
    assert msg.sender == self.owner, "Esta funcion solo puede ser accedida por el owner"
    batchToReturn: ProductBatch = self.batches[batch]
    assert batchToReturn.batchNumber != empty(String[10]), "No se encuentra el lote indicado"
    return batchToReturn